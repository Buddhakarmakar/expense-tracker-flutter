import 'package:expense_tracker/models/account.dart';
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
                    color: Colors.white,
                    size: 32,
                  ),
                  title: Text(
                    account.accountName,
                    style: TextStyle(color: Colors.white),
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
