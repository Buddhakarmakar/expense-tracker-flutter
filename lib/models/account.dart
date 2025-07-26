class Account {
  final int? accountId; // Nullable because it's auto-incremented
  final String accountName;
  final double accountBalance;

  Account({
    this.accountId,
    required this.accountName,
    required this.accountBalance,
  });

  // Create Account object from DB row (Map)
  factory Account.fromMap(Map<String, dynamic> json) {
    return Account(
      accountId: json['account_id'],
      accountName: json['account_name'],
      accountBalance: json['account_balance'].toDouble(),
    );
  }

  // Convert Account object to Map for insert/update
  Map<String, dynamic> toMap() {
    final map = {
      'account_name': accountName,
      'account_balance': accountBalance,
    };

    // account_id only added if it's not null (for updates)
    if (accountId != null) {
      map['account_id'] = accountId!;
    }

    return map;
  }
}
