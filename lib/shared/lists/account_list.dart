import 'dart:math';

import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/services/expense_service_database.dart';
import 'package:expense_tracker/shared/bottomsheets/accounts_ontap_bottomsheet.dart';
import 'package:expense_tracker/utils/constant.dart';
import 'package:flutter/material.dart';

class AccountList extends StatefulWidget {
  final bool? isEditable;
  final void Function(VoidCallback reload)? onInit;
  const AccountList({super.key, this.isEditable = false, this.onInit});

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  final Random _random = Random();
  Future<List<Account>>? _accounts;

  @override
  void initState() {
    super.initState();
    _accounts = ExpenseServiceDatabase.instance.fetchAllAccounts();
    widget.onInit?.call(reload);
  }

  void reload() {
    setState(() {
      _accounts = ExpenseServiceDatabase.instance.fetchAllAccounts();
    });
  }

  // Generate a random color
  Color _getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _accounts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          ); // Loading indicator
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Accounts found.'));
        }
        final accounts = snapshot.data!;
        final accountType =
            AccountType.cash; // Default account type, can be changed as needed
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(), // disable GridView scroll
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1.0,
          ),
          itemCount: accounts.length,
          itemBuilder: (BuildContext context, int index) {
            return Material(
              color: Colors.transparent,
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.blueGrey[700],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () async {
                    if (widget.isEditable!) {
                      final value = await showModalBottomSheet(
                        context: context,
                        builder:
                            (context) => accountsOnTapBottomSheet(
                              accounts[index],
                              context,
                            ),
                      );
                      if (value != null && value > 0) {
                        setState(() {
                          reload();
                        });
                      }
                    }
                  },

                  borderRadius: BorderRadius.circular(
                    12,
                  ), // match Ink's borderRadius
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 32,
                        ),

                        SizedBox(height: 8),
                        Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorFromHex(accountType.color),
                                _getRandomColor(),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          accounts[index].accountName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
