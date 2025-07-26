class ExpenseType {
  final int expenseTypeId;
  final String expenseTypeName;

  ExpenseType({required this.expenseTypeId, required this.expenseTypeName});

  factory ExpenseType.fromJson(Map<String, dynamic> json) {
    return ExpenseType(
      expenseTypeId: json['expense_type_id'],
      expenseTypeName: json['expense_type_name'],
    );
  }

  factory ExpenseType.fromMap(Map<String, dynamic> json) {
    return ExpenseType(
      expenseTypeId: json['expense_type_id'],
      expenseTypeName: json['expense_type_name'],
    );
  }
  Map<String, dynamic> toMap() {
    final map = {
      'expense_type_name': expenseTypeName,
      "expense_type_id": expenseTypeId,
    };

    // if (expenseTypeId != null) {
    //   map['expense_type_id'] = expenseTypeId;
    // }

    return map;
  }
}
