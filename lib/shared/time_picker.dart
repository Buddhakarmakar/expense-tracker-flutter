import 'package:flutter/material.dart';

Future<void> pickStyledTime({
  required BuildContext context,
  required Function(TimeOfDay) onTimePick,
}) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (context, child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          timePickerTheme: TimePickerThemeData(
            backgroundColor: Colors.black87,
            hourMinuteTextColor: Colors.white,
            dialHandColor: Colors.purpleAccent,
            entryModeIconColor: Colors.amber,
          ),
          colorScheme: ColorScheme.dark(
            primary: Colors.deepPurple,
            onPrimary: Colors.white,
            surface: Colors.black,
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    onTimePick(picked);
    print("Picked Time: ${picked.format(context)}");
  }
}
