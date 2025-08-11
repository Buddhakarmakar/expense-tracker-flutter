import 'package:auto_size_text/auto_size_text.dart';
import 'package:expense_tracker/models/expense_type.dart';
import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/models/transaction_with_type.dart';
import 'package:expense_tracker/services/expense_service_database.dart';
import 'package:expense_tracker/shared/category_picker.dart';
import 'package:expense_tracker/shared/date_picker.dart';
import 'package:expense_tracker/shared/note_taker.dart';
import 'package:expense_tracker/shared/payment_method_picker.dart';
import 'package:expense_tracker/shared/time_picker.dart';
import 'package:expense_tracker/utils/constant.dart';
import 'package:flutter/material.dart';

class CalculatorBottomSheet extends StatefulWidget {
  final int expenseTypeId;
  final bool newTransaction;
  final TransactionWithType? transactionModel;
  const CalculatorBottomSheet({
    super.key,
    required this.expenseTypeId,
    this.newTransaction = true,
    this.transactionModel,
  });

  @override
  State<CalculatorBottomSheet> createState() => _CalculatorBottomSheetState();
}

class _CalculatorBottomSheetState extends State<CalculatorBottomSheet> {
  String _input = "0";

  ExpenseType? selectedCategory;
  String? transactionNote;
  String? paidToInput;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  String paymentMethod = 'CASH';
  late TransactionWithType _model;

  @override
  void initState() {
    super.initState();
    ExpenseServiceDatabase.instance
        .fetchExpenseTypeById(widget.expenseTypeId)
        .then((expenseType) {
          if (expenseType != null) {
            setState(() {
              selectedCategory = expenseType;
            });
          }
        });
    if (!widget.newTransaction) {
      // ExpenseServiceDatabase.
      _model = widget.transactionModel ?? TransactionWithType.withDefaults();
      debugPrint("Transaction Model: ${_model.paymentMethod}");
      setModelValues(_model);
    }
  }

  void setModelValues(TransactionWithType model) {
    _input = model.amount.toString();

    transactionNote = model.description;
    paidToInput = model.paidTo;
    selectedDate = DateTime.parse(model.transactionDate);
    selectedTime = parseTimeOfDay(model.transactionTime);
    paymentMethod = model.paymentMethod;
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
      transactionType: "EXPENSE",
      amount: double.parse(_input.trim()),
      paymentMethod: paymentMethod,
      debitedFrom: 'Default Account',
      accountId: 101,
      expenseTypeId: widget.expenseTypeId,
      transactionDate: selectedDate,
      transactionTime: formatTransactionTime(selectedTime),
      description: transactionNote,
      paidTo: paidToInput,
      createdAt: DateTime.now(),
    );

    print("Insaide on add");
    if (!widget.newTransaction) {
      tm.setTransactionId(_model.transactionId!);
      debugPrint("Updating Transaction: ${tm.toJson()}");
      await ExpenseServiceDatabase.instance.updateTransaction(tm);
      setState(() {
        ExpenseServiceDatabase.instance.fetchTransactionsWithExpenseType();
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaction Updated!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue[800],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      await ExpenseServiceDatabase.instance.insertTransaction(tm);
      debugPrint("new Transaction: ${tm.toJson()}");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaction added!'),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: 'UNDO',
            textColor: Colors.white,
            onPressed: () {
              // Undo logic here
              Future<int> deleteCount =
                  ExpenseServiceDatabase.instance.deleteLastTransactcion();
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        color: Colors.blueGrey[800],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Left button
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => _openpaymentMethodPicker(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        accountIcons[paymentMethod] ??
                            'assets/expense_trcker_icons/money.png',
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(width: 5),
                      Text(paymentMethod),
                    ],
                  ),
                ),
              ),

              // Center text (takes available space)
              Expanded(
                child: Center(
                  child: AutoSizeText(
                    _input,
                    maxLines: 1,
                    minFontSize: 14,
                    style: const TextStyle(fontSize: 48, color: Colors.white),
                  ),
                ),
              ),

              // Right button
              if (_input != '0')
                IconButton(
                  icon: const Icon(Icons.backspace, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      if (_input.length > 1) {
                        _input = _input.substring(0, _input.length - 1);
                      } else {
                        _input = "0";
                      }
                    });
                  },
                ),
              if (_input == '0')
                //space
                const SizedBox(width: 48), // Placeholder for alignment
            ],
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorFromHex(
                    selectedCategory?.expenseTypeColor ?? '#FFFFFF',
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => _openCategoryPicker(context),
                child: Row(
                  children: [
                    Icon(
                      iconFromDB(
                        selectedCategory?.iconCodePoint ??
                            Icons.shopping_cart.codePoint,
                        selectedCategory?.iconFontFaily ?? 'MaterialIcons',
                      ),
                      color: colorFromHex('#FFFFFF'),
                      size: 20,
                    ),
                    SizedBox(width: 5),
                    Text(
                      selectedCategory?.expenseTypeName ?? 'Select Category',
                    ),
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
                    initialNote: transactionNote ?? '',
                    initialPaidTo: paidToInput ?? '',
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.white),

                onPressed: () {
                  pickStylishDate(
                    context: context,
                    initialDate: selectedDate,
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
                    selectedTime: selectedTime,
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
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _buildRow(['7', '8', '9']),
              _buildRow(['4', '5', '6']),
              _buildRow(['1', '2', '3']),
              _buildRow(['.', '0', 'add']),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildRow(List<String> values) {
    return TableRow(
      children:
          values.map((val) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: CalculatorButton(val, onPressed, onAdd),
            );
          }).toList(),
    );
  }

  void _openCategoryPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CategoryPicker(
          categories: ExpenseServiceDatabase.expenseTypeList,
          onCategorySelected: (selected) {
            setState(() {
              selectedCategory = selected;
            });
          },
        );
      },
    );
  }

  void _openpaymentMethodPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return PaymentMethodPicker(
          paymentMethods: ExpenseServiceDatabase.accountList,
          onPaymentMethodSelected: (selected) {
            setState(() {
              paymentMethod = selected;
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

TimeOfDay parseTimeOfDay(String timeString) {
  print("parseTimeOfDay ----------$timeString");
  final parts = timeString.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}

String formatTransactionTime(TimeOfDay timeOfDay) {
  final now = DateTime.now();
  final fullDateTime = DateTime(
    now.year,
    now.month,
    now.day,
    timeOfDay.hour,
    timeOfDay.minute,
    0, // default second
    97, // hundredths of a second as milliseconds (97 ms)
  );
  return "${fullDateTime.hour.toString().padLeft(2, '0')}:"
      "${fullDateTime.minute.toString().padLeft(2, '0')}:"
      "${fullDateTime.second.toString().padLeft(2, '0')}"
      "${(fullDateTime.millisecond).toString().padLeft(2, '0')}";
}
