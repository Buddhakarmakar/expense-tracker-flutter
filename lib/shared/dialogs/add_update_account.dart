import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<Account?> showAccountDialog(
  BuildContext context, {
  Account? initial,
  bool? isNew = true,
}) {
  final nameCtrl = TextEditingController(text: initial?.accountName ?? "");
  final balCtrl = TextEditingController(
    text: initial?.accountBalance.toStringAsFixed(2) ?? "",
  );
  var accountType = AccountTypeX.fromName(
    initial?.accountName ?? 'cash',
  ); // ✅ AccountType.online

  final formKey = GlobalKey<FormState>();

  return showDialog<Account?>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: Colors.blueGrey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(initial == null ? "Add Account" : "Edit Account"),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 340, // nice width for desktop too
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Account Name
                TextFormField(
                  controller: nameCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "Account Name",
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (v) =>
                          (v == null || v.trim().isEmpty) ? "Required" : null,
                ),
                const SizedBox(height: 12),

                // Balance
                TextFormField(
                  controller: balCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: "Account Balance",
                    prefixText: "₹ ",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Required";
                    final parsed = double.tryParse(v);
                    if (parsed == null) return "Enter a valid number";
                    if (parsed < 0) return "Cannot be negative";
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Account Type
                DropdownButtonFormField<AccountType>(
                  borderRadius: BorderRadius.circular(20),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  value: accountType,
                  items:
                      AccountType.values.map((t) {
                        return DropdownMenuItem(
                          value: t,
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: Color(
                                    int.parse(
                                      t.color.replaceFirst('#', '0xff'),
                                    ),
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(t.accountName),
                            ],
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    debugPrint("Selected ${value?.accountName}");
                    accountType = value!;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() != true) return;
              final acc = Account(
                accountName: nameCtrl.text.trim(),
                accountBalance: double.parse(balCtrl.text),
                accountType: accountType.accountName,
              );

              if (!isNew) {
                acc.accountId = initial?.accountId; // Update existing account
              }
              Navigator.of(ctx).pop(acc);
            },
            child: Text(isNew! ? "Add" : "Update"),
          ),
        ],
      );
    },
  );
}
