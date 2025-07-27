import 'package:auto_size_text/auto_size_text.dart';
import 'package:expense_tracker/helper/database_helper.dart';
import 'package:expense_tracker/models/expense_type.dart';
import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/shared/category_picker.dart';
import 'package:expense_tracker/shared/date_picker.dart';
import 'package:expense_tracker/shared/note_taker.dart';
import 'package:expense_tracker/shared/time_picker.dart';
import 'package:expense_tracker/utils/constant.dart';
import 'package:flutter/material.dart';

class CalculatorBottomSheet extends StatefulWidget {
  final ExpenseType expenseType;
  const CalculatorBottomSheet({super.key, required this.expenseType});

  @override
  State<CalculatorBottomSheet> createState() => _CalculatorBottomSheetState();
}

class _CalculatorBottomSheetState extends State<CalculatorBottomSheet> {
  String _input = "0";

  late ExpenseType selectedCategory;
  String? transactionNote;
  String? paidToInput;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.expenseType;
    // Access the expenseType from the widget
  }

  void onPressed(String val) {
    setState(() {
      if (_input == "0") {
        _input = val;
      } else if (val == ".") {
        if (!_input.contains(".")) {
          _input += val;
        }
      } else {
        _input += val;
      }
    });
  }

  void onAdd() async {
    TransactionModel tm = TransactionModel(
      transactionId: DatabaseHelper.lastTransactionId ?? 0 + 1,
      transactionType: "EXPENSE",
      amount: double.parse(_input.trim()),
      paymentMethod: 'CASH',
      accountId: 101,
      expenseTypeId: selectedCategory.expenseTypeId,
      transactionDate: selectedDate,
      transactionTime: selectedTime.toString(),
      description: transactionNote,
      paidTo: paidToInput,
      createdAt: DateTime.now(),
    );

    await DatabaseHelper.instance.insertTransaction(tm);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaction added!'),
        duration: Duration(seconds: 4),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            // Undo logic here
            Future<int> deleteCount =
                DatabaseHelper.instance.deleteLastTransactcion();
            deleteCount.then((value) {
              if (value == 1) {
                print("Delete Complete");
              } else {
                print("Delete failed");
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      color: Colors.blueGrey[800],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    _input,
                    maxLines: 1,
                    minFontSize: 18,
                    style: const TextStyle(fontSize: 48, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 10),
              if (_input != '0')
                IconButton.outlined(
                  onPressed: () {
                    setState(() {
                      _input = _input.substring(0, _input.length - 1);
                      if (_input.isEmpty) {
                        _input = '0';
                      }
                    });
                  },
                  icon: Icon(Icons.delete),
                ),
            ],
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => _openCategoryPicker(context),
                child: Row(
                  children: [
                    Image.asset(
                      expenseIconList[selectedCategory.expenseTypeName]!,
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(width: 5),
                    Text(selectedCategory.expenseTypeName),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),

                onPressed: () {
                  showNoteDialog(
                    context: context,
                    onNoteSaved: (note) {
                      // print(transactionNote);
                      transactionNote = note; // store or display it as needed
                      // print(transactionNote);
                    },
                    onPaidToSaved: (paidTo) {
                      paidToInput = paidTo;
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.white),

                onPressed: () {
                  pickStylishDate(
                    context: context,
                    onDatePick: (sd) {
                      // print("Sd" + sd.toString());

                      selectedDate = sd;
                    },
                  );
                },
              ),
              IconButton(
                onPressed: () {
                  pickStyledTime(
                    context: context,
                    onTimePick: (time) {
                      selectedTime = time;
                    },
                  );
                },
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
              ].map((val) => CalculatorButton(val, onPressed, onAdd)),
            ],
          ),
        ],
      ),
    );
  }

  void _openCategoryPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CategoryPicker(
          categories: DatabaseHelper.expenseTypeList,
          onCategorySelected: (selected) {
            setState(() {
              selectedCategory = selected;
            });
          },
        );
      },
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String value;
  final Function(String) onTap;
  final Function onAdd;

  const CalculatorButton(this.value, this.onTap, this.onAdd, {super.key});

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
            onPressed: () {
              onAdd();
              Navigator.pop(context);
            },
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
