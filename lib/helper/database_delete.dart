import 'package:sqflite/sqflite.dart';

Future<void> deleteDatabaseFile() async {
  String dbPath = await getDatabasesPath();
  String path =
      '$dbPath/expense_tracker.db'; // Replace with your actual DB name

  await deleteDatabase(path); // This deletes the .db file
  print("Database deleted successfully");
}
