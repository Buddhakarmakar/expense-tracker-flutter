import 'package:expense_tracker/models/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionWithType {
  final int? transactionId;
  final String transactionType;
  final double amount;
  final String paymentMethod;
  final String debitedFrom;
  final int accountId;
  final String accountName;
  final String accountType;
  final int expenseTypeId;
  final String expenseTypeName;
  final int iconCodePoint; // Use int for code point
  String? iconFontFaily; // Use string for font family
  final String expenseTypeColor; // Optional color field
  final String? description;
  final String? paidTo;
  final String transactionDate;
  final String transactionTime;

  TransactionWithType({
    this.transactionId,
    required this.transactionType,
    required this.amount,
    required this.paymentMethod,
    required this.debitedFrom,
    required this.accountId,
    required this.accountName,
    required this.accountType,
    required this.expenseTypeId,
    required this.expenseTypeName,
    required this.iconCodePoint,
    this.iconFontFaily = 'MaterialIcons',
    required this.expenseTypeColor,
    this.description,
    this.paidTo,
    required this.transactionDate,
    required this.transactionTime,
  });

  factory TransactionWithType.fromJson(Map<String, dynamic> json) {
    return TransactionWithType(
      transactionId: json['transaction_id'],
      transactionType: json['transaction_type'],
      amount: json['amount'],
      paymentMethod: json['payment_method'],
      debitedFrom: json['debited_from'],
      accountId: json['account_id'],
      accountName: json['account_name'] ?? 'CASH',
      accountType: json['account_type'] ?? 'CASH',
      expenseTypeId: json['expense_type_id'],
      expenseTypeName: json['expense_type_name'],
      iconCodePoint: json['icon_code_point'],
      iconFontFaily: json['icon_font_family'] ?? 'MaterialIcons',
      expenseTypeColor: json['expense_type_color'],
      description: json['description'],
      paidTo: json['paid_to'],
      transactionDate: json['transaction_date'],
      transactionTime: json['transaction_time'],
    );
  }
  TransactionModel toTransactionModel() {
    return TransactionModel(
      transactionType: transactionType,
      amount: amount,
      paymentMethod: paymentMethod,
      debitedFrom: debitedFrom,
      accountId: accountId,
      expenseTypeId: expenseTypeId,
      transactionDate: DateTime.parse(transactionDate),
      transactionTime: transactionTime,
      description: description,
      paidTo: paidTo,
    );
  }

  factory TransactionWithType.withDefaults({
    int transactionId = 0,
    String transactionType = 'EXPENSE',
    String expenseTypeName = "",
    double amount = 0.0,
    String paymentMethod = 'Cash',
    int accountId = 0,
    int expenseTypeId = 0,
    String? description,
    String? paidTo,
    DateTime? transactionDate,
    String? transactionTime,
  }) {
    return TransactionWithType(
      transactionId: transactionId,
      transactionType: transactionType,
      amount: amount,
      paymentMethod: paymentMethod,
      debitedFrom: 'CASH',
      accountId: accountId,
      accountName: 'CASH',
      accountType: 'CASH',
      expenseTypeId: expenseTypeId,
      expenseTypeName: expenseTypeName,
      iconCodePoint: Icons.money.codePoint,
      iconFontFaily: Icons.money.fontFamily ?? 'MaterialIcons',
      expenseTypeColor: '#FF7043', // Default color, can be changed later
      description: description ?? '',
      paidTo: paidTo ?? '',
      transactionDate: transactionDate.toString(),
      transactionTime: transactionTime ?? TimeOfDay.now().toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'transaction_type': transactionType,
      'amount': amount,
      'payment_method': paymentMethod,
      'account_id': accountId,
      'expense_type_id': expenseTypeId,
      'expense_type_name': expenseTypeName,
      'description': description,
      'paid_to': paidTo,
      'transaction_date': transactionDate, // for consistency
      'transaction_time':
          transactionTime, // assuming it's already in string format
    };
  }
}
