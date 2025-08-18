// import 'dart:convert';
// import 'dart:io';
// import 'package:expense_tracker/models/transaction_with_type.dart';
// import 'package:path_provider/path_provider.dart';

// Future<void> exportTransactionsToJsonFile(
//   List<TransactionWithType> transactions,
// ) async {
//   try {
//     final jsonString = jsonEncode(transactions);
//     final directory = await getApplicationDocumentsDirectory();
//     // final file = File('${directory.path}/transactions_export.json');
//     final file = File('${directory.path}/transactions_export.json');

//     await file.writeAsString(jsonString);
//     print('Transactions exported to: ${file.path}');
//   } catch (e) {
//     print('Error exporting: $e');
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:expense_tracker/models/transaction_with_type.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> exportTransactionsToJsonFile(
  List<TransactionWithType> transactions,
) async {
  try {
    // Ask storage permission
    if (await Permission.manageExternalStorage.request().isDenied) {
      debugPrint("❌ Manage external storage permission denied");
      return;
    }

    // Create a folder "expenses" in external storage
    final directory = Directory('/storage/emulated/0/expenses');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // Convert transactions to JSON
    final jsonString = jsonEncode(transactions);

    // Create file path
    final file = File('${directory.path}/transactions_export.json');

    // Write to file
    await file.writeAsString(jsonString);

    debugPrint('✅ Transactions exported to: ${file.path}');
  } catch (e) {
    debugPrint('❌ Error exporting: $e');
  }
}
