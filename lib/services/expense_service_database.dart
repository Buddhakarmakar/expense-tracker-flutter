import 'package:expense_tracker/database/sql_database_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/expense_type.dart';
import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/models/transaction_with_type.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseServiceDatabase {
  static final ExpenseServiceDatabase instance = ExpenseServiceDatabase._init();
  ExpenseServiceDatabase._init();
  final SqlDatabaseHelper _dbHelper = SqlDatabaseHelper.instance;

  static List<ExpenseType> expenseTypeList = [];
  static List<Account> accountList = [];
  static List<TransactionWithType> transactionList = [];

  // Optional: Preload accounts
  Future<void> insertDefaultAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('isAccountsInserted') ?? true;

    if (!isFirstRun) {
      final db = await _dbHelper.database;
      List<Account> types = [
        Account(
          accountId: 101,
          accountName: "CASH",
          accountBalance: 1000.0,
          accountType: 'CASH',
        ),
        // Account(accountId: 102, accountName: "Online", accountBalance: 1000.0),
        // Account(accountId: 103, accountName: "UPI", accountBalance: 1000.0),
        // Account(accountId: 104, accountName: "CARD", accountBalance: 1000.0),
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

  // Insert an account into the database

  Future<int> insertAccount(Account account) async {
    final db = await _dbHelper.database;
    try {
      return await db.insert('accounts', account.toMap());
    } catch (e) {
      debugPrint("Error inserting account: $e");
      return -1; // Indicate failure
    }
  }

  // Update an account in the database
  Future<int> updateAccount(Account account) async {
    final db = await _dbHelper.database;
    try {
      debugPrint("Updating  account  : ${account.toJson().toString()}");
      return await db.update(
        'accounts',
        account.toMap(),
        where: 'account_id = ?',
        whereArgs: [account.accountId],
      );
    } catch (e) {
      debugPrint("Error updating account: $e");
      return -1; // Indicate failure
    }
  }

  Future<int> deleteAccount(int id) async {
    try {
      debugPrint("Deleting   account  with id : $id");
      final db = await _dbHelper.database;
      return await db.delete(
        'accounts',
        where: 'account_id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint("-------------Error deleting account : $e");
      return -1; // Indicate failure
    }
  }

  Future<List<Account>> fetchAllAccounts() async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query('accounts');

      accountList = maps.map((map) => Account.fromMap(map)).toList();

      debugPrint("Accounts fetched successfully: ${accountList.length}");
    } catch (e) {
      debugPrint("Error fetching accounts: $e");
    }
    return accountList;
  }

  // Optional: Preload expense types
  Future<void> insertDefaultExpenseTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('isExpenseTypeInserted') ?? true;

    if (!isFirstRun) {
      final db = await _dbHelper.database;
      final defaultExpenseTypes = [
        {
          'expense_type_name': 'Shopping',
          'icon_code_point': Icons.shopping_cart.codePoint,
          'icon_font_family': Icons.shopping_cart.fontFamily,
          'expense_type_color': '#FF7043',
        },
      ];
      for (var type in defaultExpenseTypes) {
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

  Future<int> insertExpenseType(ExpenseType expenseType) async {
    print("Inside insertExpenseType");
    try {
      final db = await _dbHelper.database;
      final row = expenseType.toMap();
      debugPrint("Inserting expense type: ${row.toString()}");
      return await db.insert('expense_types', row);
    } catch (e) {
      debugPrint("Error inserting expense type: $e");
      return -1; // Indicate failure
    }
  }

  // == Fetch all expense types from the database
  Future<List<ExpenseType>> fetchAllExpenses() async {
    debugPrint("Fetching all expense types from the database");
    try {
      final db = await _dbHelper.database;
      final maps = await db.query('expense_types');

      expenseTypeList = maps.map((map) => ExpenseType.fromJson(map)).toList();

      debugPrint(
        "Expense types fetched successfully: ${expenseTypeList.length}",
      );
    } catch (e) {
      debugPrint("Error fetching expense types: $e");
    }
    return expenseTypeList;
  }

  // == Update an expense type in the database

  Future<int> updateExpenseType(ExpenseType expenseType) async {
    try {
      final db = await _dbHelper.database;
      debugPrint("Updating  expense type : ${expenseType.toJson().toString()}");
      return await db.update(
        'expense_types',
        expenseType.toMap(),
        where: 'expense_type_id = ?',
        whereArgs: [expenseType.expenseTypeId],
      );
    } catch (e) {
      debugPrint("Error fetching expense types: $e");
      return -1;
    }
  }

  // == Delete an expense type from the database
  Future<int> deleteExpenseType(int id) async {
    try {
      final db = await _dbHelper.database;
      return await db.delete(
        'expense_types',
        where: 'expense_type_id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint("Error deleting expense type: $e");
      return -1; // Indicate failure
    }
  }

  // Fetch an expense type by ID
  Future<ExpenseType?> fetchExpenseTypeById(int id) async {
    debugPrint("Fetching expense type with ID: $id");
    final db = await _dbHelper.database;
    final maps = await db.query(
      'expense_types',
      where: 'expense_type_id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ExpenseType.fromJson(maps.first);
    } else {
      return null; // No expense type found with the given ID
    }
  }

  Future<void> insertDefaultTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('isTransactionsInserted') ?? true;

    if (!isFirstRun) {
      final db = await _dbHelper.database;
      final List<TransactionModel> transactions = [];

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
    final db = await _dbHelper.database;
    try {
      debugPrint("Inserting transaction: ${transaction.toJson().toString()}");
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
    final db = await _dbHelper.database;
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
      debugPrint(e.toString());
      return 0;
    }
  }

  Future<int> deleteTransaction(int transactionId) async {
    final db = await _dbHelper.database;
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
    final db = await _dbHelper.database;
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
    final db = await _dbHelper.database;

    //  t.transaction_id,
    //       t.transaction_type,
    //       t.amount,
    //       t.payment_method,
    //       t.debited_from,
    //       t.account_id,
    //       t.expense_type_id,
    //       e.expense_type_name,
    //       e.icon_code_point,
    //       e.icon_font_family,
    //       e.expense_type_color,
    //       t.description,
    //       t.paid_to,
    //       t.transaction_date,
    //       t.transaction_time
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT 
     t.*,
     e.*,
      a.*
    FROM transactions t
    JOIN expense_types e ON t.expense_type_id = e.expense_type_id 
    JOIN accounts a ON t.account_id = a.account_id
     ORDER BY t.transaction_date desc, TIME(t.transaction_time) asc
  ''');

    // await db.delete('transactions');

    List<TransactionWithType> res =
        result.map((json) => TransactionWithType.fromJson(json)).toList();

    for (var item in res) {
      debugPrint(
        ' Transaction Date --->${item.transactionDate}. Name-> ${item.accountName} --- Accounttype-->${item.accountType}----Time --->${item.transactionTime}.... Id---> ${item.transactionId}',
      );
    }
    transactionList = res;
    return res;
  }
}
