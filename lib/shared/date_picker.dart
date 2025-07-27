import 'package:flutter/material.dart';

Future<void> pickStylishDate({
  required BuildContext context,
  required Function(DateTime) onDatePick,
}) async {
  final DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          primaryColor: Colors.purple,
          colorScheme: ColorScheme.dark(
            primary: Colors.purpleAccent,
            onPrimary: Colors.white,
            surface: Colors.grey[850]!,
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      );
    },
  );

  if (selectedDate != null) {
    print("Selected date: $selectedDate");
    onDatePick(selectedDate);
  }
}
