import 'package:expense_tracker/services/expense_service_database.dart';
import 'package:expense_tracker/utils/util_functions.dart';
import 'package:flutter/material.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Statistics",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Add your statistics widgets here
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final val = await exportTransactionsToJsonFile(
                    ExpenseServiceDatabase.transactionList,
                  );
                  if (!context.mounted) return;
                  if (val == -1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error exporting transactions')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$val transactions exported successfully',
                        ),
                      ),
                    );
                  }
                },
                child: Text('Export Transactions'),
              ),
            ),
            SizedBox(height: 16),

            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await ExpenseServiceDatabase.instance
                      .fetchAccountTransactions();
                  final val = await exportAccountTransactionsToJsonFile(
                    ExpenseServiceDatabase.accountTransactionList,
                  );
                  if (!context.mounted) return;
                  if (val == -1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error exporting account transactions'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$val Account transactions exported successfully',
                        ),
                      ),
                    );
                  }
                },
                child: Text('Export Account Transactions'),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
