import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/utils/constant.dart';
import 'package:flutter/material.dart';

class AccountPicker extends StatelessWidget {
  final List<Account> accountList;
  final void Function(String accountName, String accountType, int accountId)
  onAccountSelected;

  const AccountPicker({
    super.key,
    required this.accountList,
    required this.onAccountSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Select Account', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children:
              accountList.map((account) {
                return ListTile(
                  leading: Icon(
                    Icons.account_balance_wallet,
                    color: colorFromHex(
                      AccountTypeX.fromName(account.accountType).color,
                    ),
                    size: 24,
                  ),
                  title: Text(
                    account.accountName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    onAccountSelected(
                      account.accountName,
                      account.accountType,
                      account.accountId!,
                    );
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
        ),
      ),
    );
  }
}
