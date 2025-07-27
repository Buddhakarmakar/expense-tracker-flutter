import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/expense_type.dart';
import 'package:expense_tracker/models/transaction_with_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:expense_tracker/models/transaction_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;
  static List<ExpenseType> expenseTypeList = [];
  static List<Account> accountList = [];
  static int? lastTransactionId;
  DatabaseHelper._init();

  // Get database instance
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
          account_balance REAL
        )
      ''');

    await db.execute('''
      CREATE TABLE expense_types (
        expense_type_id INTEGER PRIMARY KEY,
        expense_type_name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        transaction_id INTEGER PRIMARY KEY AUTOINCREMENT,
        transaction_type TEXT NOT NULL CHECK (transaction_type IN ('INCOME', 'EXPENSE')),
        amount REAL NOT NULL,
        payment_method TEXT NOT NULL CHECK (payment_method IN ('CASH', 'ONLINE', 'CARD', 'UPI')),
        account_id INTEGER,
        expense_type_id INTEGER,
        description TEXT,
        paid_to TEXT,
        transaction_date TEXT,
        transaction_time TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (account_id) REFERENCES accounts(account_id),
        FOREIGN KEY (expense_type_id) REFERENCES expense_types(expense_type_id)
      )
    ''');

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
  }

  Future<void> insertDefaultAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('isAccountsInserted') ?? true;

    if (isFirstRun) {
      final db = await database;
      List<Account> types = [
        Account(accountId: 101, accountName: "CASH", accountBalance: 1000.0),
        Account(accountId: 102, accountName: "Online", accountBalance: 1000.0),
        Account(accountId: 103, accountName: "UPI", accountBalance: 1000.0),
        Account(accountId: 104, accountName: "CARD", accountBalance: 1000.0),
      ];

      for (var type in types) {
        await db.insert(
          'accounts',
          type.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    }
    // Mark setup as complete
    await prefs.setBool('isAccountsInserted', false);
  }

  Future<List<Account>> fetchAllAccounts() async {
    final db = await instance.database;
    final maps = await db.query('accounts');
    print("Accouts ->  $maps <-");
    final res = maps.map((map) => Account.fromMap(map)).toList();
    accountList = res;
    return res;
  }

  // Optional: Preload expense types
  Future<void> insertDefaultExpenseTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('isExpenseTypeInserted') ?? true;

    if (isFirstRun) {
      final db = await database;
      List<Map<String, dynamic>> types = [
        {'expense_type_id': 201, 'expense_type_name': 'Food'},
        {'expense_type_id': 202, 'expense_type_name': 'Rent'},
        {'expense_type_id': 203, 'expense_type_name': 'Transport'},
        {'expense_type_id': 204, 'expense_type_name': 'Groceries'},
        {'expense_type_id': 205, 'expense_type_name': 'Restaurants'},
        {'expense_type_id': 206, 'expense_type_name': 'Education'},
        {'expense_type_id': 207, 'expense_type_name': 'Subscriptions'},
        {'expense_type_id': 208, 'expense_type_name': 'Bills'},
        {'expense_type_id': 209, 'expense_type_name': 'Gifts'},
        {'expense_type_id': 210, 'expense_type_name': 'Vacations'},
        {'expense_type_id': 211, 'expense_type_name': 'Maintenance'},
        {'expense_type_id': 212, 'expense_type_name': 'Bike Expenses'},
        {'expense_type_id': 213, 'expense_type_name': 'Others'},
      ];

      for (var type in types) {
        await db.insert(
          'expense_types',
          type,
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    }
    // Mark setup as complete
    await prefs.setBool('isExpenseTypeInserted', false);
  }

  Future<int> insertExpenseType(String expenseTypeName) async {
    final db = await instance.database;
    Map<String, Object> row = {'expenseTypeName': expenseTypeName};
    return await db.insert('expense_types', row);
  }

  Future<List<ExpenseType>> fetchAllExpenses() async {
    final db = await instance.database;
    final maps = await db.query('expense_types');

    expenseTypeList = maps.map((map) => ExpenseType.fromMap(map)).toList();

    print("fetchAllExpenses" + expenseTypeList[0].expenseTypeId.toString());
    return expenseTypeList;
  }

  Future<int> updateExpenseType(Map<String, dynamic> row) async {
    final db = await instance.database;
    int id = row['id'];
    return await db.update(
      'expense_types',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await instance.database;
    return await db.delete('expense_types', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertDefaultTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('isTransactionsInserted') ?? true;

    if (isFirstRun) {
      final db = await database;
      final List<TransactionModel> transactions = [
        TransactionModel(
          transactionId: 1001,
          transactionType: 'EXPENSE',
          amount: 50.0,
          paymentMethod: 'ONLINE',
          accountId: 101,
          expenseTypeId: 204,
          description: 'For chicken',
          paidTo: 'Blue Lohar',
          transactionDate: DateTime.parse('2025-07-20'),
          transactionTime: '06:10:29',
        ),
        TransactionModel(
          transactionId: 1002,
          transactionType: 'EXPENSE',
          amount: 25.0,
          paymentMethod: 'CASH',
          accountId: 101,
          expenseTypeId: 201,
          description: 'For Fuchka and Ghugni',
          paidTo: 'Tapas Mahanta',
          transactionDate: DateTime.parse('2025-07-20'),
          transactionTime: '06:10:29',
        ),
        TransactionModel(
          transactionId: 1003,
          transactionType: 'EXPENSE',
          amount: 25.0,
          paymentMethod: 'CASH',
          accountId: 101,
          expenseTypeId: 201,
          description: 'For Fuchka and Ghugni',
          paidTo: 'Tapas Mahanta',
          transactionDate: DateTime.parse('2025-07-21'),
          transactionTime: '06:10:29',
        ),
        TransactionModel(
          transactionId: 1004,
          transactionType: 'EXPENSE',
          amount: 90.00,
          paymentMethod: 'CASH',
          accountId: 101,
          expenseTypeId: 213,
          description: 'Lottery Ketechialm',
          paidTo: 'Bishnupur Lottary wala',
          transactionDate: DateTime.parse('2025-07-22'),
          transactionTime: '11:00:00',
        ),
        TransactionModel(
          transactionId: 1005,
          transactionType: 'EXPENSE',
          amount: 40,
          paymentMethod: 'UPI',
          accountId: 103,
          expenseTypeId: 201,
          description: 'Kolakond Misti',
          paidTo: 'Bisnupur Mishti Dokan',
          transactionDate: DateTime.parse('2025-07-22'),
          transactionTime: '11:10:29',
        ),
        TransactionModel(
          transactionId: 1006,
          transactionType: 'EXPENSE',
          amount: 50.00,
          paymentMethod: 'CASH',
          accountId: 101,
          expenseTypeId: 204,
          description: 'Chicken 50 takar',
          paidTo: 'Shyamnagar theke asar somoi',
          transactionDate: DateTime.parse('2025-07-21'),
          transactionTime: '18:10:29',
        ),
        TransactionModel(
          transactionId: 1007,
          transactionType: 'EXPENSE',
          amount: 10.0,
          paymentMethod: 'CASH',
          accountId: 101,
          expenseTypeId: 201,
          description: 'For Fuchka and Ghugni',
          paidTo: 'Shyamnagar',
          transactionDate: DateTime.parse('2025-07-22'),
          transactionTime: '06:10:29',
        ),
        TransactionModel(
          transactionId: 1008,
          transactionType: 'EXPENSE',
          amount: 50.0,
          paymentMethod: 'CASH',
          accountId: 101,
          expenseTypeId: 201,
          description: 'For Fuchka and Ghugni',
          paidTo: 'Tapas Mahanta',
          transactionDate: DateTime.parse('2025-07-23'),
          transactionTime: '18:10:29',
        ),
        TransactionModel(
          transactionId: 1009,
          transactionType: 'EXPENSE',
          amount: 150.0,
          paymentMethod: 'CASH',
          accountId: 101,
          expenseTypeId: 204,
          description: 'Mobarokpur hat er sabji',
          paidTo: 'Hat',
          transactionDate: DateTime.parse('2025-07-24'),
          transactionTime: '10:00:29',
        ),
        TransactionModel(
          transactionId: 1010,
          transactionType: 'EXPENSE',
          amount: 60.0,
          paymentMethod: 'ONLINE',
          accountId: 101,
          expenseTypeId: 204,
          description: 'For chicken',
          paidTo: 'Blue Lohar',
          transactionDate: DateTime.parse('2025-07-25'),
          transactionTime: '10:10:29',
        ),
        TransactionModel(
          transactionId: 1011,
          transactionType: 'EXPENSE',
          amount: 60.00,
          paymentMethod: 'CASH',
          accountId: 101,
          expenseTypeId: 213,
          description: 'Lottery Ketechialm',
          paidTo: 'Gossainpur Lottary wala Bapi Roy',
          transactionDate: DateTime.parse('2025-07-25'),
          transactionTime: '10:00:00',
        ),
        // TransactionModel(
        //   transactionId: 1002,

        //   transactionType: 'EXPENSE',
        //   amount: 120.0,
        //   paymentMethod: 'CASH',
        //   accountId: 102,
        //   expenseTypeId: 205,
        //   description: 'Monthly broadband bill',
        //   paidTo: 'ACT Fibernet',
        //   transactionDate: DateTime.parse('2025-07-18'),
        //   transactionTime: '10:15:00',
        // ),
        // TransactionModel(
        //   transactionId: 1003,

        //   transactionType: 'EXPENSE',
        //   amount: 200.5,
        //   paymentMethod: 'CARD',
        //   accountId: 101,
        //   expenseTypeId: 202,
        //   description: 'Grocery purchase',
        //   paidTo: 'Spencers',
        //   transactionDate: DateTime.parse('2025-07-19'),
        //   transactionTime: '16:30:45',
        // ),
        // TransactionModel(
        //   transactionId: 1004,

        //   transactionType: 'EXPENSE',
        //   amount: 600.0,
        //   paymentMethod: 'UPI',
        //   accountId: 103,
        //   expenseTypeId: 203,
        //   description: 'Electricity bill',
        //   paidTo: 'WBSEDCL',
        //   transactionDate: DateTime.parse('2025-07-15'),
        //   transactionTime: '14:20:12',
        // ),
        // TransactionModel(
        //   transactionId: 1005,

        //   transactionType: 'EXPENSE',
        //   amount: 89.0,
        //   paymentMethod: 'ONLINE',
        //   accountId: 101,
        //   expenseTypeId: 201,
        //   description: 'Auto fare to station',
        //   paidTo: 'Local Driver',
        //   transactionDate: DateTime.parse('2025-07-21'),
        //   transactionTime: '08:40:00',
        // ),
        // TransactionModel(
        //   transactionId: 1006,

        //   transactionType: 'EXPENSE',
        //   amount: 999.99,
        //   paymentMethod: 'CARD',
        //   accountId: 104,
        //   expenseTypeId: 206,
        //   description: 'New headphones',
        //   paidTo: 'Amazon',
        //   transactionDate: DateTime.parse('2025-07-16'),
        //   transactionTime: '20:10:55',
        // ),
        // TransactionModel(
        //   transactionId: 1007,

        //   transactionType: 'EXPENSE',
        //   amount: 35.0,
        //   paymentMethod: 'CASH',
        //   accountId: 101,
        //   expenseTypeId: 207,
        //   description: 'Evening snacks',
        //   paidTo: 'Food stall',
        //   transactionDate: DateTime.parse('2025-07-20'),
        //   transactionTime: '18:30:00',
        // ),
        // TransactionModel(
        //   transactionId: 1008,

        //   transactionType: 'EXPENSE',
        //   amount: 150.0,
        //   paymentMethod: 'UPI',
        //   accountId: 102,
        //   expenseTypeId: 208,
        //   description: 'Train ticket',
        //   paidTo: 'IRCTC',
        //   transactionDate: DateTime.parse('2025-07-22'),
        //   transactionTime: '07:50:10',
        // ),
        // TransactionModel(
        //   transactionId: 1009,

        //   transactionType: 'EXPENSE',
        //   amount: 480.0,
        //   paymentMethod: 'ONLINE',
        //   accountId: 103,
        //   expenseTypeId: 209,
        //   description: 'Fuel refill',
        //   paidTo: 'Indian Oil',
        //   transactionDate: DateTime.parse('2025-07-17'),
        //   transactionTime: '11:25:35',
        // ),
        // TransactionModel(
        //   transactionId: 1010,

        //   transactionType: 'EXPENSE',
        //   amount: 210.75,
        //   paymentMethod: 'CARD',
        //   accountId: 104,
        //   expenseTypeId: 210,
        //   description: 'Dinner outing',
        //   paidTo: 'Cafe Coffee Day',
        //   transactionDate: DateTime.parse('2025-07-20'),
        //   transactionTime: '21:05:44',
        // ),
      ];

      for (var transaction in transactions) {
        await db.insert(
          'transactions',
          transaction.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      prefs.setBool('isTransactionsInserted', false);
    }
  }

  Future<void> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    try {
      await db.insert(
        'transactions',
        transaction.toMap(),
        // conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      print("Transaction Added successfully");
    } catch (e) {
      print(e);
    }
  }

  Future<int> deleteLastTransactcion() async {
    final db = await database;
    try {
      int deleteCount = await db.rawDelete('''
      DELETE FROM transactions
      WHERE transaction_id = (
        SELECT transaction_id FROM transactions
        ORDER BY transaction_id DESC
        LIMIT 1)
      ''');
      return deleteCount;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<int> deleteTransaction(int transactionId) async {
    final db = await database;
    try {
      int deleteCount = await db.rawDelete(
        '''
      DELETE FROM transactions
      WHERE transaction_id =?
      ''',
        [transactionId],
      );
      return deleteCount;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<int> updateTransaction(TransactionModel transactionData) async {
    final db = await database;
    try {
      print("Update transaction---------");
      print(transactionData.toJson().toString());
      final count = await db.update(
        'transactions',
        transactionData.toMap(),
        where: 'transaction_id= ?',
        whereArgs: [transactionData.transactionId],
      );
      return count;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<List<TransactionWithType>> fetchTransactionsWithExpenseType() async {
    final db = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT 
      t.transaction_id,
      t.transaction_type,
      t.amount,
      t.payment_method,
      t.account_id,
      t.expense_type_id,
      e.expense_type_name,
      t.description,
      t.paid_to,
      t.transaction_date,
      t.transaction_time
    FROM transactions t
    JOIN expense_types e ON t.expense_type_id = e.expense_type_id ORDER BY t.transaction_date desc, TIME(t.transaction_time) asc
  ''');

    // await db.delete('transactions');

    List<TransactionWithType> res =
        result.map((json) => TransactionWithType.fromJson(json)).toList();

    lastTransactionId = res[0].transactionId;
    res.forEach((item) {
      print(
        item.transactionDate +
            ' ' +
            item.transactionTime +
            item.transactionId.toString(),
      );
    });
    return res;
  }
}
