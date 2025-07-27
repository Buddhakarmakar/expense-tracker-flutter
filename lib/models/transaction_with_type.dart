import 'package:expense_tracker/models/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionWithType {
  final int transactionId;
  final String transactionType;
  final double amount;
  final String paymentMethod;
  final int accountId;
  final int expenseTypeId;
  final String expenseTypeName;
  final String? description;
  final String? paidTo;
  final String transactionDate;
  final String transactionTime;

  TransactionWithType({
    required this.transactionId,
    required this.transactionType,
    required this.amount,
    required this.paymentMethod,
    required this.accountId,
    required this.expenseTypeId,
    required this.expenseTypeName,
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
      accountId: json['account_id'],
      expenseTypeId: json['expense_type_id'],
      expenseTypeName: json['expense_type_name'],
      description: json['description'],
      paidTo: json['paid_to'],
      transactionDate: json['transaction_date'],
      transactionTime: json['transaction_time'],
    );
  }
  TransactionModel toTransactionModel() {
    return TransactionModel(
      transactionId: transactionId,
      transactionType: transactionType,
      amount: amount,
      paymentMethod: paymentMethod,
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
      accountId: accountId,
      expenseTypeId: expenseTypeId,
      expenseTypeName: expenseTypeName,
      description: description ?? '',
      paidTo: paidTo ?? '',
      transactionDate: transactionDate.toString(),
      transactionTime: transactionTime ?? TimeOfDay.now().toString(),
    );
  }
}
