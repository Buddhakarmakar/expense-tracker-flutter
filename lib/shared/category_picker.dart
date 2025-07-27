// import 'package:expense_tracker/helper/database_helper.dart';
// import 'package:expense_tracker/models/expense_type.dart';
// import 'package:expense_tracker/utils/constant.dart';
// import 'package:flutter/material.dart';

// class CategoryPickerDialogExample extends StatefulWidget {
//   const CategoryPickerDialogExample();

//   @override
//   // ignore: library_private_types_in_public_api
//   _CategoryPickerDialogExampleState createState() =>
//       _CategoryPickerDialogExampleState();
// }

// class _CategoryPickerDialogExampleState
//     extends State<CategoryPickerDialogExample> {
//   String selectedCategory = 'Food';
//   final List<ExpenseType> categories = DatabaseHelper.expenseTypeList;

//   void _openCategoryDialog() {
//     print(categories.toString());
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             backgroundColor: Colors.blueGrey[800],
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             title: Text(
//               'Choose Category',
//               style: TextStyle(color: Colors.white),
//             ),
//             content: SizedBox(
//               width: double.maxFinite,
//               child: ListView(
//                 shrinkWrap: true,
//                 children:
//                     categories.map((category) {
//                       return ListTile(
//                         leading: Image.asset(
//                           // ignore: collection_methods_unrelated_type
//                           expenseIconList[category.expenseTypeName] ??
//                               'assets/expense_trcker_icons/other.png',
//                           height: 20,
//                           width: 20,
//                         ),
//                         title: Text(
//                           category.expenseTypeName,
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         onTap: () {
//                           setState(() {
//                             selectedCategory = category.expenseTypeName;
//                           });
//                           Navigator.of(context).pop();
//                         },
//                       );
//                     }).toList(),
//               ),
//             ),
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.indigo,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//         onPressed: () {
//           _openCategoryDialog();
//         },
//         child: Row(
//           children: [
//             Image.asset(
//               expenseIconList[selectedCategory]!,
//               height: 20,
//               width: 20,
//             ),
//             SizedBox(width: 5),
//             Text(selectedCategory),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
                  leading: Image.asset(
                    // ignore: collection_methods_unrelated_type
                    expenseIconList[category.expenseTypeName] ??
                        'assets/expense_trcker_icons/other.png',
                    height: 20,
                    width: 20,
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
