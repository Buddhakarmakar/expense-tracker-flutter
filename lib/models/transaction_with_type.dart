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
}
