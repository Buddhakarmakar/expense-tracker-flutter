import 'package:expense_tracker/helper/database_delete.dart';
import 'package:expense_tracker/models/transaction_with_type.dart';
import 'package:expense_tracker/services/expense_service_database.dart';
import 'package:expense_tracker/shared/bottomsheets/calculator_bottomsheet.dart';
import 'package:expense_tracker/utils/constant.dart';
import 'package:expense_tracker/utils/util_functions.dart';
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

    _transactions =
        ExpenseServiceDatabase.instance.fetchTransactionsWithExpenseType();
    // deleteDatabaseFile();
    debugPrint("Transactions Page Initialized");
    // debugPrint("Transactions: ${_transactions.toJson()}");
    _transactions.then((value) {
      debugPrint("Fetched Transactions: ${value.length}");
      // debugPrint("Transactions: ${value[0].toJson()}");
    });
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
                                  (context) => showTransactionBottomSheet(
                                    transactions,
                                    index,
                                    context,
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
                                            color: colorFromHex(
                                              transactions[index]
                                                  .expenseTypeColor,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                iconFromDB(
                                                  transactions[index]
                                                      .iconCodePoint,
                                                  transactions[index]
                                                      .iconFontFaily!,
                                                ),
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                transactions[index]
                                                    .expenseTypeName
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
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
                                      transactions[index].debitedFrom,
                                      style: TextStyle(
                                        color: colorFromHex(
                                          AccountTypeX.fromName(
                                            transactions[index].accountType,
                                          ).color,
                                        ),
                                        fontSize: 16,
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
                                    Text(
                                      transactions[index].paymentMethod,
                                      style: TextStyle(
                                        color: Colors.white,
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

  SizedBox showTransactionBottomSheet(
    List<TransactionWithType> transactions,
    int index,
    BuildContext context,
  ) {
    return SizedBox(
      height: 200,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorFromHex(transactions[index].expenseTypeColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        iconFromDB(
                          transactions[index].iconCodePoint,
                          transactions[index].iconFontFaily ?? 'MaterialIcons',
                        ),
                        color: Colors.white,
                        size: 20,
                      ),

                      SizedBox(width: 5),
                      Text(
                        transactions[index].expenseTypeName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Text(
                    transactions[index].amount.toString(),
                    style: TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Container(height: 1, color: Colors.blueGrey),

          ListTile(
            title: Text('Update '),
            leading: Icon(Icons.edit_outlined),
            onTap: () async {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder:
                    (context) => CalculatorBottomSheet(
                      expenseTypeId: transactions[index].expenseTypeId,
                      newTransaction: false,
                      transactionModel: transactions[index],
                    ),
              );
            },
          ),
          SizedBox(height: 12),
          Container(height: 1, color: Colors.blueGrey),
          ListTile(
            title: Text('Delete '),
            leading: Icon(Icons.delete),
            onTap: () async {
              Navigator.pop(context);
              await ExpenseServiceDatabase.instance.deleteTransaction(
                transactions[index].transactionId ?? 0,
              );
              setState(() {
                _transactions =
                    ExpenseServiceDatabase.instance
                        .fetchTransactionsWithExpenseType();
              });
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Transaction Deleted!'),
                  duration: Duration(seconds: 1),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ],
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
