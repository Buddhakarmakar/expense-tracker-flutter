import 'package:expense_tracker/models/expense_type.dart';
import 'package:flutter/material.dart';

SizedBox expenseCategoriesBottomSheet(
  ExpenseType expenseType,
  BuildContext context,
) {
  return SizedBox(
    height: 20,
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
                style: TextStyle(color: Colors.white, fontSize: 18),
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
            Navigator.pop(context);
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
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
