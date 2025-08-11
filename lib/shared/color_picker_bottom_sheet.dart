import 'package:flutter/material.dart';

/// Shows a modal bottom sheet with a 40-color palette.
/// Returns the selected Color or null if cancelled.
Future<Color?> showColorPickerBottomSheet(
  BuildContext context, {
  Color? initialColor,
}) {
  return showModalBottomSheet<Color?>(
    context: context,
    isScrollControlled: false,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => _ColorPickerSheet(initialColor: initialColor),
  );
}

class _ColorPickerSheet extends StatefulWidget {
  final Color? initialColor;
  const _ColorPickerSheet({this.initialColor});

  @override
  State<_ColorPickerSheet> createState() => _ColorPickerSheetState();
}

class _ColorPickerSheetState extends State<_ColorPickerSheet> {
  // 40-color fixed palette (feel free to tweak)
  static final List<Color> _palette = [
    Colors.red,
    Colors.redAccent,
    Colors.pink,
    Colors.pinkAccent,
    Colors.purple,
    Colors.deepPurple,
    Colors.deepPurpleAccent,
    Colors.indigo,
    Colors.indigoAccent,
    Colors.blue,
    Colors.blueAccent,
    Colors.lightBlue,
    Colors.cyan,
    Colors.cyanAccent,
    Colors.teal,
    Colors.tealAccent,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.indigo.shade200,
    Colors.purpleAccent,
    Colors.greenAccent,
    Colors.lightBlueAccent,
    Colors.orangeAccent,
    Colors.deepOrangeAccent,
    Color(0xFF8E44AD),
    Color(0xFF1ABC9C),
    Color(0xFF2ECC71),
    Color(0xFFF39C12),
    Color(0xFF34495E),
    Color(0xFF7F8C8D),
    Color(0xFF95A5A6),
    Color(0xFF273746),
  ];

  Color? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialColor;
    // If initialColor not in palette, _selected will be that color (still shown)
  }

  @override
  Widget build(BuildContext context) {
    final radius = 20.0;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // handle + title row
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 4),
                const Expanded(
                  child: Text(
                    'Pick a color',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(null),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // preview row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Selected: '),
                const SizedBox(width: 8),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _selected ?? Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white24),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // palette grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _palette.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8, // 8 columns x 5 rows = 40
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final color = _palette[index];
                final isSelected =
                    _selected != null && _areColorsEqual(_selected!, color);

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(radius),
                    onTap: () {
                      setState(() => _selected = color);
                      // short delay so ripple shows nicely, then return
                      // Future.delayed(const Duration(milliseconds: 120), () {
                      //   Navigator.of(context).pop(color);
                      // });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(radius),
                        border:
                            isSelected
                                ? Border.all(color: Colors.white, width: 2)
                                : null,
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 100),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ]
                                : null,
                      ),
                      child:
                          isSelected
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(_selected),
                    child: const Text('Choose'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  static bool _areColorsEqual(Color a, Color b) => a.value == b.value;
}
