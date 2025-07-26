class TransactionModel {
  final int transactionId;
  final String transactionType; // Use an enum if needed
  final double amount;
  final String paymentMethod;
  final int accountId;
  final int expenseTypeId;
  final String? description;
  final String? paidTo;
  final DateTime transactionDate;
  final String transactionTime; // You can also use Duration or TimeOfDay
  DateTime? createdAt = DateTime.now();

  TransactionModel({
    required this.transactionId,
    required this.transactionType,
    required this.amount,
    required this.paymentMethod,
    required this.accountId,
    required this.expenseTypeId,
    this.description,
    this.paidTo,
    required this.transactionDate,
    required this.transactionTime,
    this.createdAt,
  });

  // Factory constructor for JSON deserialization
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json['transaction_id'],
      transactionType: json['transaction_type'],
      amount: json['amount'].toDouble(),
      paymentMethod: json['payment_method'],
      accountId: json['account_id'],
      expenseTypeId: json['expense_type_id'],
      description: json['description'],
      paidTo: json['paid_to'],
      transactionDate: DateTime.parse(json['transaction_date']),
      transactionTime: json['transaction_time'], // Or parse as needed
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'transaction_type': transactionType,
      'amount': amount,
      'payment_method': paymentMethod,
      'account_id': accountId,
      'expense_type_id': expenseTypeId,
      'description': description,
      'paid_to': paidTo,
      'transaction_date': transactionDate.toIso8601String().split('T')[0],
      'transaction_time': transactionTime,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'transaction_type': transactionType,
      'amount': amount,
      'payment_method': paymentMethod,
      'account_id': accountId,
      'expense_type_id': expenseTypeId,
      'description': description,
      'paid_to': paidTo,
      'transaction_date':
          transactionDate.toIso8601String().split('T')[0], // YYYY-MM-DD
      'transaction_time': transactionTime, // e.g., '06:10:29'
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      transactionId: map['transaction_id'],
      transactionType: map['transaction_type'],
      amount: map['amount'],
      paymentMethod: map['payment_method'],
      accountId: map['account_id'],
      expenseTypeId: map['expense_type_id'],
      description: map['description'],
      paidTo: map['paid_to'],
      transactionDate: DateTime.parse(map['transaction_date']),
      transactionTime: map['transaction_time'],
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}

enum TransactionType { income, expense }
