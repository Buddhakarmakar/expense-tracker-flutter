import 'dart:convert';
import 'dart:io';
import 'package:expense_tracker/models/transaction_with_type.dart';
import 'package:path_provider/path_provider.dart';

Future<void> exportTransactionsToJsonFile(
  List<TransactionWithType> transactions,
) async {
  try {
    final jsonString = jsonEncode(transactions);
    final directory = await getApplicationDocumentsDirectory();
    // final file = File('${directory.path}/transactions_export.json');
    final file = File('${directory.path}/transactions_export.json');

    await file.writeAsString(jsonString);
    print('Transactions exported to: ${file.path}');
  } catch (e) {
    print('Error exporting: $e');
  }
}
