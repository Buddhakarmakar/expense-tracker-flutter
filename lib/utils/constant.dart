import 'package:flutter/material.dart';

final path = 'assets/expense_trcker_icons/';

// final Map<String, String> expenseIconList = {
//   'Food': '${path}curry.png',
//   'Rent': '${path}rent.png',
//   'Groceries': '${path}grocery-cart.png',
//   'Restaurants': '${path}dinner-table.png',
//   'Education': '${path}education.png',
//   'Subscriptions': '${path}membership.png',
//   'Bills': '${path}bill.png',
//   'Gifts': '${path}gift.png',
//   'Maintenance': '${path}estate.png',
//   'Bike Expenses': '${path}utility.png',
//   'Others': '${path}other.png',
//   'Transport': '${path}bus.png',
//   'Vacations': '${path}beach.png',
// };

final Map<String, String> accountIcons = {
  'CASH': '${path}money.png',
  'UPI': '${path}icons8-bhim-48.png',
  'Online': '${path}cashless-payment.png',
  'CARD': '${path}contactless.png',
};

enum AccountType {
  cash("CASH", "#FF7043"),
  upi("UPI", "#42A5F5"),
  online("ONLINE", "#66BB6A"),
  card("CARD", "#AB47BC");

  final String accountName;
  final String color;

  const AccountType(this.accountName, this.color);
}

extension AccountTypeX on AccountType {
  static AccountType fromName(String name) {
    return AccountType.values.firstWhere(
      (e) => e.accountName.toLowerCase() == name.toLowerCase(),
      orElse: () => AccountType.cash,
    );
  }
}

IconData iconFromDB(int codePoint, String fontFamily) {
  return IconData(codePoint, fontFamily: fontFamily);
}

Color colorFromHex(String hex) {
  return Color(int.parse(hex.substring(1), radix: 16) + 0xFF000000);
}

Map<String, dynamic> iconToDB(IconData icon) {
  return {'codePoint': icon.codePoint, 'fontFamily': icon.fontFamily};
}

String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
}
