import 'package:auto_size_text/auto_size_text.dart';
import 'package:expense_tracker/shared/category_picker.dart';
import 'package:flutter/material.dart';

class CalculatorBottomSheet extends StatefulWidget {
  const CalculatorBottomSheet({super.key});

  @override
  State<CalculatorBottomSheet> createState() => _CalculatorBottomSheetState();
}

class _CalculatorBottomSheetState extends State<CalculatorBottomSheet> {
  String _input = "0";

  void onPressed(String val) {
    print("Insaide ontap");
    setState(() {
      if (_input == "0") {
        _input = val;
      } else {
        _input += val;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      color: Colors.blueGrey[800],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            _input,
            maxLines: 1,
            minFontSize: 18,
            style: const TextStyle(fontSize: 48, color: Colors.white),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // ElevatedButton.icon(
              //   icon: const Icon(Icons.card_giftcard),
              //   label: const Text("Gifts"),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.indigo,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //   ),
              //   onPressed: () {
              //     CategoryPickerDialogExample();
              //   },
              // ),
              CategoryPickerDialogExample(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.calendar_today, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.access_time, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ...[
                '7',
                '8',
                '9',
                // '÷',
                '4',
                '5',
                '6',
                // '×',
                '1',
                '2',
                '3',
                // '−',
                '.',
                '0',
                'add',
                // '+',
              ].map((val) => CalculatorButton(val, onPressed)),
            ],
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String value;
  final Function(String) onTap;

  const CalculatorButton(this.value, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    if (value == "add") {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white54),
          ),
          child: IconButton(
            onPressed: () => onTap,
            icon: Icon(Icons.done),
            color: Colors.white,
          ),
        ),
      );
    }
    return Center(
      child: TextButton(
        onPressed: () => onTap(value),
        child: Text(
          value,
          style: TextStyle(fontSize: 24, color: Colors.grey[200]),
        ),
      ),
    );
  }
}
