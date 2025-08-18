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
            ElevatedButton(
              onPressed: () {
                exportTransactionsToJsonFile(
                  ExpenseServiceDatabase.transactionList,
                );
              },
              child: Text('Export'),
            ),
          ],
        ),
      ),
    );
  }
}
