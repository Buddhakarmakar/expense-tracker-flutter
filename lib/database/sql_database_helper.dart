import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/expense_type.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDatabaseHelper {
  static final SqlDatabaseHelper instance = SqlDatabaseHelper._init();

  static Database? _database;
  static List<ExpenseType> expenseTypeList = [];
  static List<Account> accountList = [];
  static int? lastTransactionId;
  SqlDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expense_tracker.db');
    return _database!;
  }

  // Initialize database
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    // Open the database
    final db = await openDatabase(path, version: 1, onCreate: _createDB);

    // ✅ Enable foreign key constraints
    await db.execute('PRAGMA foreign_keys = ON');

    return db;
  }

  // Create tables
  Future _createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE accounts (
          account_id INTEGER PRIMARY KEY AUTOINCREMENT,
          account_name TEXT NOT NULL UNIQUE,
          account_type TEXT NOT NULL CHECK (account_type IN ('CASH', 'ONLINE', 'CARD', 'UPI')),
          account_balance REAL  
        )
      ''');
    await db.execute(
      'INSERT INTO sqlite_sequence (name, seq) VALUES ("accounts", 999)',
    );

    await db.execute('''
      CREATE TABLE expense_types (
        expense_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
        expense_type_name TEXT NOT NULL,
        icon_code_point INTEGER NOT NULL,
        icon_font_family TEXT NOT NULL,
        expense_type_color TEXT
        )
      
    ''');
    await db.execute(
      'INSERT INTO sqlite_sequence (name, seq) VALUES ("expense_types", 199)',
    );
    await db.execute('''
      CREATE TABLE transactions (
        transaction_id INTEGER PRIMARY KEY AUTOINCREMENT,
        transaction_type TEXT NOT NULL CHECK (transaction_type IN ('INCOME', 'EXPENSE')),
        amount REAL NOT NULL,
        payment_method TEXT NOT NULL CHECK (payment_method IN ('CASH', 'ONLINE', 'CARD', 'UPI')),
        debited_from TEXT NOT NULL,
        account_id INTEGER,
        expense_type_id INTEGER,
        description TEXT,
        paid_to TEXT,
        transaction_date TEXT,
        transaction_time TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE SET NULL,
        FOREIGN KEY (expense_type_id) REFERENCES expense_types(expense_type_id) ON DELETE SET NULL

      )
    ''');
    await db.execute(
      'INSERT INTO sqlite_sequence (name, seq) VALUES ("transactions", 1999)',
    );
    await db.execute('''
      CREATE TABLE account_transactions (
        account_transaction_id INTEGER PRIMARY KEY AUTOINCREMENT,
        transaction_id INTEGER NOT NULL,
        account_id INTEGER NOT NULL,
        balance_after_transaction REAL NOT NULL,
        recorded_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON DELETE CASCADE,
        FOREIGN KEY (account_id) REFERENCES accounts(account_id)
      )
    ''');

    await db.execute(
      'INSERT INTO sqlite_sequence (name, seq) VALUES ("account_transactions", 9999)',
    );
  }
}
