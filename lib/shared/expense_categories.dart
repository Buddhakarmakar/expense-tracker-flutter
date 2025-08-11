import 'package:expense_tracker/models/expense_type.dart';
import 'package:expense_tracker/services/expense_service_database.dart';
import 'package:expense_tracker/shared/calculator.dart';
import 'package:expense_tracker/shared/expense_categories_bottomsheet.dart';
import 'package:expense_tracker/utils/constant.dart';
import 'package:flutter/material.dart';

class ExpenseCategories extends StatelessWidget {
  final bool? isReorderable;
  final bool? isEditable;
  const ExpenseCategories({
    super.key,
    this.isReorderable = false,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExpenseType>>(
      future:
          ExpenseServiceDatabase.instance
              .fetchAllExpenses(), // Your async function
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          ); // Loading indicator
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No expenses found.'));
        }

        final expenses = snapshot.data!;

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(), // disable GridView scroll
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1.0,
          ),
          itemCount: expenses.length,
          itemBuilder: (BuildContext context, int index) {
            final expense = expenses[index];

            return Material(
              color: Colors.transparent,
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.blueGrey[700],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    if (isEditable!) {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.blueGrey[800],
                        builder: (context) {
                          return expenseCategoriesBottomSheet(expense, context);
                        },
                      );
                    } else {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        builder:
                            (context) => CalculatorBottomSheet(
                              expenseTypeId: expenses[index].expenseTypeId!,
                            ),
                      );
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
                          iconFromDB(
                            expense.iconCodePoint,
                            expense.iconFontFaily ?? 'MaterialIcons',
                          ),
                          color: Colors.white60,
                          size: 36,
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue,
                                colorFromHex(expense.expenseTypeColor),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          expense.expenseTypeName,
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
