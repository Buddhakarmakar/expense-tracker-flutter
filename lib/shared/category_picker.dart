import 'package:expense_tracker/models/expense_type.dart';
import 'package:expense_tracker/utils/constant.dart';
import 'package:flutter/material.dart';

class CategoryPicker extends StatelessWidget {
  final List<ExpenseType> categories;
  final void Function(ExpenseType selectedCategory) onCategorySelected;

  const CategoryPicker({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Choose Category', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children:
              categories.map((category) {
                return ListTile(
                  leading: Icon(
                    iconFromDB(
                      category.iconCodePoint,
                      category.iconFontFaily ?? 'MaterialIcons',
                    ),
                    color: colorFromHex(category.expenseTypeColor),
                    size: 20,
                  ),
                  title: Text(
                    category.expenseTypeName,
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    onCategorySelected(category);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
        ),
      ),
    );
  }
}
