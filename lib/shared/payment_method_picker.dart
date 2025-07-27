import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/utils/constant.dart';
import 'package:flutter/material.dart';

class PaymentMethodPicker extends StatelessWidget {
  final List<Account> paymentMethods;
  final void Function(String selectedCategory) onPaymentMethodSelected;

  const PaymentMethodPicker({
    super.key,
    required this.paymentMethods,
    required this.onPaymentMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Choose Category', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children:
              paymentMethods.map((paymentMethod) {
                return ListTile(
                  leading: Image.asset(
                    // ignore: collection_methods_unrelated_type
                    accountIcons[paymentMethod.accountName] ??
                        'assets/expense_trcker_icons/other.png',
                    height: 20,
                    width: 20,
                  ),
                  title: Text(
                    paymentMethod.accountName,
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    onPaymentMethodSelected(paymentMethod.accountName);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
        ),
      ),
    );
  }
}
