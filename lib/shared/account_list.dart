import 'dart:math';

import 'package:expense_tracker/services/expense_service_database.dart';
import 'package:expense_tracker/utils/constant.dart';
import 'package:flutter/material.dart';

class AccountList extends StatelessWidget {
  AccountList({super.key});
  final Random _random = Random();

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
      future: ExpenseServiceDatabase.instance.fetchAllAccounts(),
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
                  onTap: () {},

                  borderRadius: BorderRadius.circular(
                    12,
                  ), // match Ink's borderRadius
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          accountIcons[accounts[index].accountName] ??
                              'assets/expense_trcker_icons/other.png',
                          height: 48,
                          width: 48,
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [_getRandomColor(), _getRandomColor()],
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
