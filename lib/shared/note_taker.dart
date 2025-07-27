import 'package:flutter/material.dart';

Future<void> showNoteDialog({
  required BuildContext context,
  required Function(String note) onNoteSaved,
  required Function(String note) onPaidToSaved,
  String initialNote = '',
}) async {
  // ignore: no_leading_underscores_for_local_identifiers
  final TextEditingController _noteController = TextEditingController(
    text: initialNote,
  );
  // ignore: no_leading_underscores_for_local_identifiers
  final TextEditingController _paidToController = TextEditingController(
    text: initialNote,
  );

  await showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Add Note'),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              TextField(
                controller: _noteController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.blueGrey[700],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _paidToController,
                decoration: InputDecoration(
                  labelText: 'Paid To..',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.blueGrey[700],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final note = _noteController.text.trim();
                final paidTo = _paidToController.text.trim();
                Navigator.pop(context);
                onNoteSaved(note);
                onPaidToSaved(paidTo);
              },
              child: const Text('Done'),
            ),
          ],
        ),
  );
}
