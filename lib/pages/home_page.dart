import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:expense_tracker/helper/database_helper.dart';
import 'package:expense_tracker/models/expense_type.dart';
import 'package:expense_tracker/shared/calculator_new.dart';
import 'package:expense_tracker/shared/calcutaor.dart';
import 'package:expense_tracker/utils/constant.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, String> _accountIcons = {
    'CASH': 'assets/expense_trcker_icons/money.png',
    'UPI': 'assets/expense_trcker_icons/icons8-bhim-48.png',
    'Online': 'assets/expense_trcker_icons/cashless-payment.png',
    'CARD': 'assets/expense_trcker_icons/contactless.png',
  };

  final Random _random = Random();

  // Generate a random color
  Color _getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }

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
                    onPressed: () {},
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
            FutureBuilder<List<ExpenseType>>(
              future:
                  DatabaseHelper.instance
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
                  physics:
                      NeverScrollableScrollPhysics(), // disable GridView scroll
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
                            print('InkWell tapped!');
                            // showModalBottomSheet(
                            //   context: context,
                            //   isScrollControlled: true,
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.vertical(
                            //       top: Radius.circular(24),
                            //     ),
                            //   ),
                            //   backgroundColor: Colors.blueGrey[800],
                            //   builder: (context) => _buildBottomSheet(context),
                            // );
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
                                    expenseType: expenses[index],
                                  ),
                            );
                          },
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // match Ink's borderRadius
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  expenseIconList[expense.expenseTypeName] ??
                                      'assets/expense_trcker_icons/other.png',
                                  height: 48,
                                  width: 48,
                                ),
                                SizedBox(height: 8),
                                Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        _getRandomColor(),
                                        _getRandomColor(),
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
            ),
            SizedBox(height: 24),
            Text(
              "Incomes",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            FutureBuilder(
              future: DatabaseHelper.instance.fetchAllAccounts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  ); // Loading indicator
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No Accounts found.'));
                }
                final accounts = snapshot.data!;
                return GridView.builder(
                  shrinkWrap: true,
                  physics:
                      NeverScrollableScrollPhysics(), // disable GridView scroll
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: accounts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[700],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            _accountIcons[accounts[index].accountName]!,
                            height: 48,
                            width: 48,
                          ),
                          SizedBox(height: 8),
                          Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.purple, Colors.pink],
                              ),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            accounts[index].accountName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget _buildBottomSheet(BuildContext context) {
//   return Container(
//     padding: EdgeInsets.all(20),
//     height: 500,
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Center(
//         //   child: Container(
//         //     width: 40,
//         //     height: 4,
//         //     decoration: BoxDecoration(
//         //       color: Colors.grey[600],
//         //       borderRadius: BorderRadius.circular(2),
//         //     ),
//         //   ),
//         // ),
//         SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AutoSizeText(
//               '1,000',
//               style: TextStyle(fontSize: 40, color: Colors.white),
//               maxLines: 1,
//               minFontSize: 14,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),

//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Text(
//               '',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 12),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           decoration: BoxDecoration(
//             color: Colors.pinkAccent,
//             borderRadius: BorderRadius.circular(18),
//           ),
//           child: Text(
//             "Resturants",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         SizedBox(height: 12),

//         Text(
//           'You can add any widgets here: buttons, forms, lists, etc.',
//           style: TextStyle(color: Colors.white70),
//         ),
//         Spacer(),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
//           onPressed: () => Navigator.pop(context),
//           child: Center(child: Text('Close')),
//         ),
//       ],
//     ),
//   );
// }
