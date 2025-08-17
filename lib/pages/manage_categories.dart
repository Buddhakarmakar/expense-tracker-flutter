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
  late VoidCallback _reloadCategories;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Categories'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true); // ✅ send back signal
            },
          ),
          backgroundColor: Colors.blueGrey[900],
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              color: Colors.white,
              onPressed: () async {
                // Logic to add a new category can be implemented here
                final val = await showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.blueGrey[800],
                  builder: (context) {
                    return AddExpenseCategoryBottomSheet(isNewCategory: true);
                  },
                );

                if (val != null && val > 0) {
                  debugPrint('New category added with id = $val');

                  _reloadCategories(); // reload categories after adding

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Category added successfully'),
                    ),
                  );
                } else {
                  debugPrint('Failed to add new category');
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to add category')),
                  );
                }
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
                onInit: (reload) {
                  _reloadCategories = reload;
                },
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
