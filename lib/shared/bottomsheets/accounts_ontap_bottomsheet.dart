import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/services/expense_service_database.dart';
import 'package:expense_tracker/shared/dialogs/add_update_account.dart';
import 'package:expense_tracker/utils/constant.dart';
import 'package:flutter/material.dart';

SizedBox accountsOnTapBottomSheet(Account account, BuildContext context) {
  AccountType accountType = AccountTypeX.fromName(account.accountType);
  return SizedBox(
    height: 200,
    child: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                  color: Colors.white,
                ),
              ),

              Text(
                account.accountName,
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18,
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: colorFromHex(accountType.color),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(height: 1, color: Colors.blueGrey),

        ListTile(
          title: Text('Update '),
          leading: Icon(Icons.edit_outlined),
          onTap: () async {
            debugPrint(
              'Update tapped for ${account.accountName}  id : ${account.accountId}',
            );

            final value = await showAccountDialog(
              context,
              isNew: false,
              initial: account,
            );
            debugPrint(
              "AccountDialog close with value = ${value?.toJson().toString()}",
            );

            if (value != null) {
              final res = await ExpenseServiceDatabase.instance.updateAccount(
                value,
              );

              if (res > 0) {
                debugPrint("Account added with id = $res");
                // reload();
              }
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    res > 0
                        ? 'Account added successfully'
                        : 'Failed to add account',
                  ),
                ),
              );
            }

            if (!context.mounted) return;
            Navigator.pop(context, value);
          },
        ),
        // SizedBox(height: 12),
        Container(height: 1, color: Colors.blueGrey),
        ListTile(
          title: Text('Delete '),
          leading: Icon(Icons.delete),
          onTap: () async {
            debugPrint(
              'Delete tapped for ${account.accountName} Id : ${account.accountId}',
            );
            //Delete expense type logic here
            final value = await ExpenseServiceDatabase.instance.deleteAccount(
              account.accountId!,
            );
            if (!context.mounted) return;

            if (value > 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Account ${account.accountName} with id ${account.accountId} deleted successfully',
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Failed to delete expense type ${account.accountName}',
                  ),
                ),
              );
            }
            Navigator.pop(context, value);
          },
        ),
      ],
    ),
  );
}
