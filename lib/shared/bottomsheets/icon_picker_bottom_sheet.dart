import 'package:flutter/material.dart';

Future<IconData?> showIconPickerBottomSheet(
  BuildContext context, {
  IconData? initialIcon,
}) {
  return showModalBottomSheet<IconData?>(
    context: context,
    isScrollControlled: false,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => _IconPickerSheet(initialIcon: initialIcon),
  );
}

class _IconPickerSheet extends StatefulWidget {
  final IconData? initialIcon;
  const _IconPickerSheet({this.initialIcon});

  @override
  State<_IconPickerSheet> createState() => _IconPickerSheetState();
}

class _IconPickerSheetState extends State<_IconPickerSheet> {
  // Replace/add icons as per your categories & accounts
  static final List<IconData> _icons = [
    Icons.shopping_cart,
    Icons.fastfood,
    Icons.directions_car,
    Icons.home,
    Icons.phone_android,
    Icons.laptop,
    Icons.tv,
    Icons.watch,
    Icons.sports_soccer,
    Icons.sports_basketball,
    Icons.sports_tennis,
    Icons.fitness_center,
    Icons.local_florist,
    Icons.pets,
    Icons.school,
    Icons.work,
    Icons.account_balance,
    Icons.credit_card,
    Icons.savings,
    Icons.attach_money,
    Icons.flight,
    Icons.train,
    Icons.directions_boat,
    Icons.hotel,
    Icons.movie,
    Icons.music_note,
    Icons.camera_alt,
    Icons.palette,
    Icons.book,
    Icons.menu_book,
    Icons.brush,
    Icons.color_lens,
    Icons.cake,
    Icons.icecream,
    Icons.local_cafe,
    Icons.local_bar,
    Icons.local_gas_station,
    Icons.medical_services,
    Icons.healing,
    Icons.local_pharmacy,
    Icons.cleaning_services,
    Icons.hardware,
    Icons.construction,
    Icons.build,
    Icons.wifi,
    Icons.lightbulb,
    Icons.bolt,
    Icons.battery_full,
    Icons.security,
    Icons.key,
    Icons.lock,
    Icons.vpn_key,
    Icons.child_care,
    Icons.family_restroom,
    Icons.emoji_events,
    Icons.star,
    Icons.favorite,
    Icons.favorite_border,
    Icons.thumb_up,
    Icons.thumb_down,
    Icons.call,
    Icons.email,
    Icons.message,
    Icons.chat,
    Icons.map,
    Icons.navigation,
    Icons.location_on,
    Icons.place,
    Icons.alarm,
    Icons.access_time,
    Icons.date_range,
    Icons.calendar_today,
    Icons.print,
    Icons.scanner,
    Icons.copy,
    Icons.paste,
    Icons.recycling,
    Icons.delete,
    Icons.delete_forever,
    Icons.restore,
    Icons.folder,
    Icons.insert_drive_file,
    Icons.note,
    Icons.description,
    Icons.save,
    Icons.cloud,
    Icons.cloud_download,
    Icons.cloud_upload,
    Icons.account_circle,
    Icons.group,
    Icons.person,
    Icons.person_outline,
    Icons.settings,
    Icons.tune,
    Icons.dashboard,
    Icons.view_list,
    Icons.bike_scooter,
    Icons.directions_walk,
    Icons.local_shipping,
    Icons.emoji_transportation,
    Icons.light_mode,
    Icons.dark_mode,
    Icons.park,
    Icons.terrain,
  ];

  IconData? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                  color: Colors.white,
                ),
              ),
              Text(
                "Icons",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(_selected);
                  },
                  child: Text('Save'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ✅ Expanded is fine here, because it's inside a Column
          Expanded(
            child: GridView.builder(
              itemCount: _icons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final icon = _icons[index];
                final isSelected = _selected == icon;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _selected = icon),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.2)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            isSelected
                                ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                )
                                : null,
                      ),
                      child: Icon(
                        icon,
                        color:
                            isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white70,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
