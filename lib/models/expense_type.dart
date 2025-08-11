class ExpenseType {
  final int? expenseTypeId;
  final String expenseTypeName;
  final int iconCodePoint; // Use int for code point
  String? iconFontFaily; // Use string for font family
  final String expenseTypeColor; // Optional color field

  ExpenseType({
    this.expenseTypeId,
    required this.expenseTypeName,
    required this.iconCodePoint,
    this.iconFontFaily = 'MaterialIcons',
    required this.expenseTypeColor,
  });

  factory ExpenseType.fromJson(Map<String, dynamic> json) {
    return ExpenseType(
      expenseTypeId: json['expense_type_id'],
      expenseTypeName: json['expense_type_name'],
      expenseTypeColor: json['expense_type_color'],
      iconCodePoint: json['icon_code_point'],
      iconFontFaily: json['icon_font_family'] ?? 'MaterialIcons',
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'expense_type_name': expenseTypeName,
      // "expense_type_id": expenseTypeId,
      'expense_type_color': expenseTypeColor,
      'icon_code_point': iconCodePoint,
      'icon_font_family': iconFontFaily ?? 'MaterialIcons',
    };

    if (expenseTypeId != null) {
      map['expense_type_id'] = expenseTypeId!;
    }

    return map;
  }

  Map<String, dynamic> toJson() {
    return {
      'expenseTypeId': expenseTypeId,
      'expenseTypeName': expenseTypeName,
      'iconCodePoint': iconCodePoint,
      'iconFontFaily': iconFontFaily,
      'expenseTypeColor': expenseTypeColor,
    };
  }
}
