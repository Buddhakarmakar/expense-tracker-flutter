import 'package:expense_tracker/pages/manage_categories.dart';
import 'package:expense_tracker/shared/account_list.dart';
import 'package:expense_tracker/shared/expense_categories.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VoidCallback _reloadCategories;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    "Expense Tracker",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () async {
                      final res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageCategories(),
                        ),
                      );

                      debugPrint('Manage Categories returned: $res');
                      if (res != null && res is bool && res) {
                        _reloadCategories(); // reload categories if needed
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            Text(
              "Expenses",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ExpenseCategories(onInit: (reload) => _reloadCategories = reload),
            SizedBox(height: 24),
            Text(
              "Accounts",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Displaying the account list
            AccountList(),
          ],
        ),
      ),
    );
  }
}
