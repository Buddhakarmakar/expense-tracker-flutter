import 'package:expense_tracker/shared/account_list.dart';
import 'package:expense_tracker/shared/add_expense_category_bottom_sheet.dart';
import 'package:expense_tracker/shared/expense_categories.dart';
import 'package:flutter/material.dart';

class ManageCategories extends StatefulWidget {
  const ManageCategories({super.key});

  @override
  State<ManageCategories> createState() => _ManageCategoriesState();
}

class _ManageCategoriesState extends State<ManageCategories> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Categories'),
          backgroundColor: Colors.blueGrey[900],
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              color: Colors.white,
              onPressed: () {
                // Logic to add a new category can be implemented here
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.blueGrey[800],
                  builder: (context) {
                    return AddExpenseCategoryBottomSheet(isNewCategory: true);
                  },
                ).then((value) {
                  debugPrint('New category added $value');
                  if (!mounted) return;
                  if (value > 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Category added successfully'),
                      ),
                    );
                  } else {
                    debugPrint('Failed to add new category');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add category')),
                    );
                  }
                });
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [Tab(text: 'Expenses'), Tab(text: 'Accounts')],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: ExpenseCategories(
                isEditable: true,
              ), // Displaying the expense categories
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: AccountList(), // Displaying the expense categories
            ),
          ],
        ),
      ),
    );
  }
}
