class AccountTransaction {
  final int? accountTransactionId; // nullable because AUTOINCREMENT
  final int transactionId;
  final int accountId;
  final double balance;
  final double balanceAfterTransaction;
  final String? recordedAt; // nullable, DB auto generates if not given

  AccountTransaction({
    this.accountTransactionId,
    required this.transactionId,
    required this.accountId,
    required this.balance,
    required this.balanceAfterTransaction,
    this.recordedAt,
  });

  /// Convert a DB row (Map) into a Dart object
  factory AccountTransaction.fromMap(Map<String, dynamic> map) {
    return AccountTransaction(
      accountTransactionId: map['account_transaction_id'] as int?,
      transactionId: map['transaction_id'] as int,
      accountId: map['account_id'] as int,
      balance: (map['balance'] as num).toDouble(),
      balanceAfterTransaction:
          (map['balance_after_transaction'] as num).toDouble(),
      recordedAt: map['recorded_at'] as String?,
    );
  }

  /// Convert a Dart object into a Map (for SQLite insert/update)
  Map<String, dynamic> toMap() {
    return {
      'account_transaction_id': accountTransactionId,
      'transaction_id': transactionId,
      'account_id': accountId,
      'balance': balance,
      'balance_after_transaction': balanceAfterTransaction,
      'recorded_at': recordedAt,
    };
  }

  /// From JSON (e.g., API response)
  factory AccountTransaction.fromJson(Map<String, dynamic> json) {
    return AccountTransaction.fromMap(json);
  }

  /// To JSON (for API or storage)
  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() {
    return 'AccountTransaction('
        'accountTransactionId: $accountTransactionId, '
        'transactionId: $transactionId, '
        'accountId: $accountId, '
        'balance: $balance, '
        'balanceAfterTransaction: $balanceAfterTransaction, '
        'recordedAt: $recordedAt'
        ')';
  }
}
