import 'package:expense_tracker/services/expense_service_database.dart';
import 'package:expense_tracker/shared/dialogs/add_update_account.dart';
import 'package:expense_tracker/shared/lists/account_list.dart';
import 'package:expense_tracker/shared/bottomsheets/add_expense_category_bottom_sheet.dart';
import 'package:expense_tracker/shared/lists/expense_categories.dart';
import 'package:flutter/material.dart';

class ManageCategories extends StatefulWidget {
  const ManageCategories({super.key});

  @override
  State<ManageCategories> createState() => _ManageCategoriesState();
}

class _ManageCategoriesState extends State<ManageCategories>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late VoidCallback _reloadCategories;
  late VoidCallback _reloadAccounts;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Listen for tab index changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return; // avoids double calls
      debugPrint("Selected Tab------------: ${_tabController.index}");
    });
  }

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
                if (_tabController.index == 0) {
                  final val = await await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // 👈 important
                    isDismissible: false, // ❌ disables tap outside to dismiss
                    enableDrag: false, // ❌ disables swipe to dismiss
                    backgroundColor: Colors.blueGrey[800],
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(
                                context,
                              ).viewInsets.bottom, // 👈 pushes above keyboard
                        ),
                        child: AddExpenseCategoryBottomSheet(
                          isNewCategory: true,
                        ),
                      );
                    },
                  );

                  if (val != null && val > 0) {
                    debugPrint('New category added with id = $val');

                    _reloadCategories(); // reload categories after adding

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Category added successfully'),
                        duration: Duration(microseconds: 200),
                      ),
                    );
                  } else {
                    debugPrint('Failed to add new category');
                    if (!context.mounted) return;

                    if (val != null && val < 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to add category'),
                          duration: Duration(microseconds: 200),
                        ),
                      );
                    }
                  }
                } else {
                  final value = await showAccountDialog(context);
                  debugPrint(
                    "AccountDialog close with value = ${value?.toJson().toString()}",
                  );

                  if (value != null) {
                    final res = await ExpenseServiceDatabase.instance
                        .insertAccount(value);

                    if (res > 0) {
                      debugPrint("Account added with id = $res");
                      _reloadAccounts(); // reload accounts after adding
                    }
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          res > 0
                              ? 'Account added successfully'
                              : 'Failed to add account',
                        ),
                        duration: Duration(microseconds: 200),
                      ),
                    );
                  }
                }
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: [Tab(text: 'Expenses'), Tab(text: 'Accounts')],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
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
              child: AccountList(
                isEditable: true,
                onInit: (reload) => _reloadAccounts = reload,
              ), // Displaying the expense categories
            ),
          ],
        ),
      ),
    );
  }
}
