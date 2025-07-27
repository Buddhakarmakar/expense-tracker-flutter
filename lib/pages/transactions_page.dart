import 'package:expense_tracker/helper/database_helper.dart';
import 'package:expense_tracker/models/expense_type.dart';
import 'package:expense_tracker/models/transaction_with_type.dart';
import 'package:expense_tracker/shared/calcutaor.dart';
import 'package:expense_tracker/utils/constant.dart';
import 'package:flutter/material.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final TextEditingController _controller = TextEditingController();

  late Future<List<TransactionWithType>> _transactions;
  @override
  void initState() {
    super.initState();
    _transactions = DatabaseHelper.instance.fetchTransactionsWithExpenseType();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _textBox(_controller),
            SizedBox(height: 16),
            FutureBuilder<List<TransactionWithType>>(
              future: _transactions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No transactions found.'));
                }

                final transactions = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: transactions.length, // Example item count
                  itemBuilder: (context, index) {
                    return Material(
                      color: Colors.transparent,
                      child: Ink(
                        // decoration: BoxDecoration(
                        //   color: Colors.blueGrey[700],
                        //   borderRadius: BorderRadius.circular(12),
                        // ),
                        child: InkWell(
                          onTap: () {
                            print('InkWell tapped!');
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(24),
                                ),
                              ),
                              backgroundColor: Colors.blueGrey[800],
                              builder:
                                  (context) => Container(
                                    height: 200,
                                    child: ListView(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.pinkAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      expenseIconList[transactions[index]
                                                          .expenseTypeName]!,
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      transactions[index]
                                                          .expenseTypeName,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                transactions[index].amount
                                                    .toString(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Container(
                                          height: 1,
                                          color: Colors.blueGrey,
                                        ),

                                        ListTile(
                                          title: Text('Update '),
                                          leading: Icon(Icons.edit_outlined),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            24,
                                                          ),
                                                        ),
                                                  ),
                                              builder:
                                                  (
                                                    context,
                                                  ) => CalculatorBottomSheet(
                                                    expenseType: ExpenseType(
                                                      expenseTypeId:
                                                          transactions[index]
                                                              .expenseTypeId,
                                                      expenseTypeName:
                                                          transactions[index]
                                                              .expenseTypeName,
                                                    ),
                                                    newTransaction: false,
                                                    transactionModel:
                                                        transactions[index],
                                                  ),
                                            );
                                          },
                                        ),
                                        SizedBox(height: 12),
                                        Container(
                                          height: 1,
                                          color: Colors.blueGrey,
                                        ),
                                        ListTile(
                                          title: Text('Delete '),
                                          leading: Icon(Icons.delete),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            await DatabaseHelper.instance
                                                .deleteTransaction(
                                                  transactions[index]
                                                      .transactionId,
                                                );
                                            setState(() {
                                              _transactions =
                                                  DatabaseHelper.instance
                                                      .fetchTransactionsWithExpenseType();
                                            });
                                            if (!mounted) return;
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Transaction Deleted!',
                                                ),
                                                duration: Duration(seconds: 4),
                                                backgroundColor:
                                                    Colors.redAccent,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                            );
                          },

                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[800],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.pinkAccent,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            transactions[index].expenseTypeName
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      transactions[index].amount.toString(),
                                      style: TextStyle(
                                        color: Colors.pinkAccent,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      transactions[index].description ??
                                          'No description',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      transactions[index].paymentMethod,
                                      style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${transactions[index].transactionDate.toString().split(' ')[0]}  ${transactions[index].transactionTime} ", // Format date
                                      // 'Date: ${DateTime.now().subtract(Duration(days: index)).toLocal()}',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
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
          ],
        ),
      ),
    );
  }
}

Widget _textBox(TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      hintText: 'Search Transactions', // 👈 stays inside the field
      hintStyle: TextStyle(color: Colors.white54),
      prefixIcon: Icon(Icons.search, color: Colors.white),
      suffixIcon: Icon(Icons.filter_list, color: Colors.white),
      filled: true,
      fillColor: Colors.blueGrey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
    ),
    style: TextStyle(color: Colors.white),
  );
}
