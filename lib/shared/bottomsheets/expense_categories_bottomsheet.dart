import 'package:expense_tracker/models/expense_type.dart';
import 'package:expense_tracker/services/expense_service_database.dart';
import 'package:expense_tracker/shared/bottomsheets/add_expense_category_bottom_sheet.dart';
import 'package:expense_tracker/utils/constant.dart';
import 'package:flutter/material.dart';

SizedBox expenseCategoriesBottomSheet(
  ExpenseType expenseType,
  BuildContext context,
) {
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
                expenseType.expenseTypeName,
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
                    color: colorFromHex(expenseType.expenseTypeColor),
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
              'Update tapped for ${expenseType.expenseTypeName} ${expenseType.expenseTypeId}',
            );

            final val = await showModalBottomSheet(
              context: context,
              backgroundColor: Colors.blueGrey[800],
              builder: (context) {
                return AddExpenseCategoryBottomSheet(
                  isNewCategory: false,
                  expenseType: expenseType,
                );
              },
            );
            if (!context.mounted) return;
            Navigator.pop(context, val);
          },
        ),
        // SizedBox(height: 12),
        Container(height: 1, color: Colors.blueGrey),
        ListTile(
          title: Text('Delete '),
          leading: Icon(Icons.delete),
          onTap: () async {
            debugPrint(
              'Delete tapped for ${expenseType.expenseTypeName} ${expenseType.expenseTypeId}',
            );
            //Delete expense type logic here
            final value = await ExpenseServiceDatabase.instance
                .deleteExpenseType(expenseType.expenseTypeId!);
            if (!context.mounted) return;

            if (value > 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Expense type ${expenseType.expenseTypeName} deleted successfully',
                  ),
                  duration: Duration(microseconds: 200),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Failed to delete expense type ${expenseType.expenseTypeName}',
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
