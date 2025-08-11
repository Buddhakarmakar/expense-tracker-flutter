import 'dart:convert';

import 'package:expense_tracker/models/expense_type.dart';
import 'package:expense_tracker/models/transaction_model.dart';
import 'package:http/http.dart' as http;

class ExpenseService {
  // Example method to fetch expenses
  Future<List<ExpenseType>> fetchExpenses() async {
    // Simulate a network call or database query
    await Future.delayed(Duration(seconds: 1));
    final url = 'http://10.0.2.2:8000/api/expense_types/';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load expenses');
    }

    // Assuming the response body is a JSON array of expense types
    // You would typically parse the JSON here
    // For demonstration, returning a static list
    List<ExpenseType> expenses = [];
    jsonDecode(response.body).forEach((expense) {
      expenses.add(ExpenseType.fromJson(expense));
    });

    return expenses;
    //   return [
    //     ExpenseType(expenseTypeId: 1, expenseTypeName: 'Food'),
    //     ExpenseType(expenseTypeId: 2, expenseTypeName: 'Transport'),
    //     ExpenseType(expenseTypeId: 3, expenseTypeName: 'Entertainment'),
    //     ExpenseType(expenseTypeId: 4, expenseTypeName: 'Utilities'),
    //   ];
    // }
  }

  Future<List<TransactionModel>> fetchTransactions() async {
    // Simulate a network call or database query
    await Future.delayed(Duration(seconds: 1));
    final url = 'http://10.0.2.2:8000/api/transactions/';

    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load transactions');
    }

    // Assuming the response body is a JSON array of transactions
    List<TransactionModel> transactions = [];

    jsonDecode(response.body).forEach((transaction) {
      transactions.add(TransactionModel.fromJson(transaction));
    });
    return transactions;
  }
}
