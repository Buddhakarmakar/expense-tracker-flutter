import 'package:flutter/material.dart';

void main() {
  runApp(const ExpenseCalculatorApp());
}

class ExpenseCalculatorApp extends StatelessWidget {
  const ExpenseCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const ExpenseCalculatorScreen(),
    );
  }
}

class ExpenseCalculatorScreen extends StatelessWidget {
  const ExpenseCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12202F),
      appBar: AppBar(
        title: const Text("Just Expenses"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Expense Categories
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Expense",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              categoryCard(Icons.shopping_basket, 'Groceries'),
              categoryCard(Icons.restaurant, 'Restaurants'),
              categoryCard(Icons.school, 'Education'),
              categoryCard(Icons.set_meal, 'Fish'),
              categoryCard(Icons.directions_bike, 'Travel'),
              categoryCard(Icons.receipt, 'Bills'),
            ],
          ),
          const Spacer(),
          // Calculator View
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF204060),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const Text("0", style: TextStyle(fontSize: 50)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Chip(
                      label: Text('Gifts'),
                      avatar: Icon(Icons.card_giftcard),
                    ),
                    Icon(Icons.menu),
                    Icon(Icons.calendar_today),
                    Icon(Icons.access_time),
                  ],
                ),
                const SizedBox(height: 10),
                // Keypad Rows
                buildKeyRow(['7', '8', '9', '÷']),
                buildKeyRow(['4', '5', '6', '×']),
                buildKeyRow(['1', '2', '3', '−']),
                buildKeyRow(['.', '0', '✓', '+']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget categoryCard(IconData icon, String label) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF1C2C3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: Colors.white),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget buildKeyRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            keys.map((key) {
              final isOperator = ['÷', '×', '−', '+'].contains(key);
              final isSubmit = key == '✓';

              final bool isFilled =
                  isOperator ||
                  isSubmit; // fill background for all operators + ✓
              final bgColor = isFilled ? Colors.white : Colors.transparent;
              final textColor = isFilled ? Colors.black : Colors.white;

              return Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white54),
                ),
                child: Center(
                  child: Text(
                    key,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
