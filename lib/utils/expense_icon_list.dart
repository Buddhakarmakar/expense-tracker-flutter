import 'package:flutter/material.dart';

class ExpenseCategory {
  static const path = 'assets/expense_trcker_icons/';

  /// Expense type → icon path
  static const Map<String, String> expenseIconList = {
    'Food': '${path}curry.png',
    'Rent': '${path}rent.png',
    'Groceries': '${path}grocery-cart.png',
    'Restaurants': '${path}dinner-table.png',
    'Education': '${path}education.png',
    'Subscriptions': '${path}membership.png',
    'Bills': '${path}bill.png',
    'Gifts': '${path}gift.png',
    'Maintenance': '${path}estate.png',
    'Bike Expenses': '${path}utility.png',
    'Others': '${path}other.png',
    'Transport': '${path}bus.png',
    'Vacations': '${path}beach.png',
  };

  /// Expense type → fixed background color
  static const Map<String, Color> expenseColors = {
    'Food': Colors.orange,
    'Rent': Colors.blueGrey,
    'Groceries': Colors.green,
    'Restaurants': Colors.redAccent,
    'Education': Colors.indigo,
    'Subscriptions': Colors.purple,
    'Bills': Colors.blue,
    'Gifts': Colors.pink,
    'Maintenance': Colors.teal,
    'Bike Expenses': Colors.brown,
    'Others': Colors.grey,
    'Transport': Colors.amber,
    'Vacations': Colors.cyan,
  };
}
