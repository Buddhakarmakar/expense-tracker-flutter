import 'package:expense_tracker/models/expense_type.dart';
import 'package:expense_tracker/services/expense_service_database.dart';
import 'package:expense_tracker/shared/bottomsheets/color_picker_bottom_sheet.dart';
import 'package:expense_tracker/shared/bottomsheets/icon_picker_bottom_sheet.dart';
import 'package:expense_tracker/utils/constant.dart';
import 'package:flutter/material.dart';

class AddExpenseCategoryBottomSheet extends StatefulWidget {
  final bool? isNewCategory;
  final ExpenseType? expenseType;
  const AddExpenseCategoryBottomSheet({
    super.key,
    this.isNewCategory = false,
    this.expenseType,
  });

  @override
  State<AddExpenseCategoryBottomSheet> createState() =>
      _AddExpenseCategoryBottomSheetState();
}

class _AddExpenseCategoryBottomSheetState
    extends State<AddExpenseCategoryBottomSheet> {
  Color? selectedColor = Colors.blueGrey[700];
  IconData? selectedIcon = Icons.category;

  TextEditingController titleController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    if (!widget.isNewCategory!) {
      selectedColor = colorFromHex(widget.expenseType!.expenseTypeColor);
      selectedIcon = iconFromDB(
        widget.expenseType!.iconCodePoint,
        widget.expenseType!.iconFontFaily ?? 'MaterialIcons',
      );
      titleController.text = widget.expenseType?.expenseTypeName ?? 'Untitled';
    } else {
      selectedColor =
          widget.expenseType?.expenseTypeColor != null
              ? colorFromHex(widget.expenseType!.expenseTypeColor)
              : Colors.blueGrey[700];
      selectedIcon =
          widget.expenseType?.iconCodePoint != null
              ? iconFromDB(
                widget.expenseType!.iconCodePoint,
                widget.expenseType!.iconFontFaily ?? 'MaterialIcons',
              )
              : Icons.category;
      titleController.text = widget.expenseType?.expenseTypeName ?? 'Untitled';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),

      child: Column(
        mainAxisSize: MainAxisSize.min,

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
                  widget.isNewCategory!
                      ? 'New Category'
                      : widget.expenseType!.expenseTypeName,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Logic to save the new category can be implemented here
                      final iconData = iconToDB(selectedIcon!);
                      final fontFamily =
                          iconData['fontFamily'] ?? 'MaterialIcons';

                      final newExpenseType = ExpenseType(
                        expenseTypeName:
                            titleController.text.trim() == ""
                                ? 'Untitled'
                                : titleController.text.trim(),
                        expenseTypeColor: colorToHex(selectedColor!),
                        iconCodePoint: iconData['codePoint'],
                        iconFontFaily: fontFamily,
                      );
                      debugPrint(newExpenseType.toMap().toString());
                      if (widget.isNewCategory!) {
                        // Create a new ExpenseType object

                        final value = await ExpenseServiceDatabase.instance
                            .insertExpenseType(newExpenseType);

                        debugPrint('New category added with id = $value');
                        if (!context.mounted) return;
                        //
                        Navigator.of(context).pop(value);

                        //
                      } else {
                        final expneseType = ExpenseType(
                          expenseTypeId: widget.expenseType!.expenseTypeId,
                          expenseTypeName:
                              titleController.text.trim() == ""
                                  ? 'Untitled'
                                  : titleController.text.trim(),
                          expenseTypeColor: colorToHex(selectedColor!),
                          iconCodePoint: iconData['codePoint'],
                          iconFontFaily: fontFamily,
                        );
                        final value = await ExpenseServiceDatabase.instance
                            .updateExpenseType(expneseType);
                        debugPrint('Updated category  with id = $value');
                        if (!context.mounted) return;
                        Navigator.of(context).pop(value);
                      }
                    },
                    child: Text(widget.isNewCategory! ? 'Add' : 'Update'),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: Colors.blueGrey),

          ListTile(
            title: Text('Title '),
            leading: Icon(Icons.title),
            trailing: SizedBox(
              width: 200,
              child: TextField(
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Untitled',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            onTap: () async {
              debugPrint('Title tapped');
              Navigator.pop(context);
            },
          ),
          // SizedBox(height: 12),
          Container(height: 1, color: Colors.blueGrey),
          ListTile(
            title: Text('Color '),
            leading: Icon(Icons.color_lens_outlined),
            trailing: Container(
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.circular(20.0),
              ),

              width: 30,
              height: 30,
            ),
            onTap: () async {
              debugPrint('Color tapped');
              showColorPickerBottomSheet(context).then((selectedColor) {
                if (selectedColor != null) {
                  // Handle the selected color
                  debugPrint('Selected color: $selectedColor');
                  setState(() {
                    this.selectedColor = selectedColor;
                  });
                }
              });
            },
          ),
          Container(height: 1, color: Colors.blueGrey),

          ListTile(
            title: Text('Icon '),
            leading: Icon(Icons.image_rounded),
            trailing: Icon(
              selectedIcon ?? Icons.category,
              color: Colors.white,
              size: 30,
            ),
            onTap: () async {
              debugPrint('Icon tapped');
              showIconPickerBottomSheet(context).then((selectedIcon) {
                if (selectedIcon != null) {
                  // Handle the selected icon
                  debugPrint('Selected icon: $selectedIcon');
                  setState(() {
                    this.selectedIcon = selectedIcon;
                  });
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
