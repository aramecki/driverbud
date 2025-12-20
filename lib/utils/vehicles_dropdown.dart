import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'boxes.dart';

typedef MenuEntry = DropdownMenuEntry<int>;

/* NOTE: Due to his workflow VehiclesDropdown still uses DropdownMenu widget, so it accepts text input via keyboard,
 this doesn't seems to affect the mobile app in his UX, but has to be edited if it will be ever released for other platforms */

class VehiclesDropdown extends StatefulWidget {
  final ValueChanged<int>? onChanged;
  final int? defaultId;

  const VehiclesDropdown({super.key, this.onChanged, this.defaultId});

  @override
  State<VehiclesDropdown> createState() => _VehiclesDropdownState();
}

class _VehiclesDropdownState extends State<VehiclesDropdown> {
  int? dropdownKey;

  @override
  void initState() {
    super.initState();
    dropdownKey = widget.defaultId;
  }

  @override
  void didUpdateWidget(covariant VehiclesDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.defaultId != oldWidget.defaultId) {
      setState(() {
        dropdownKey = widget.defaultId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: vehicleBox.listenable(),
      builder: (context, Box box, _) {
        final keys = box.keys.cast<int>().toList();
        final values = box.values.toList();

        final labels = values.map((value) {
          if (value is Map) {
            final brand = value['brand']?.toString() ?? '';
            final model = value['model']?.toString() ?? '';
            return '$brand $model';
          } else {
            return value.toString();
          }
        }).toList();

        final menuEntries = List<MenuEntry>.generate(
          keys.length,
          (i) => MenuEntry(value: keys[i], label: labels[i]),
        );

        return DropdownMenu<int>(
          //width: MediaQuery.of(context).size.width / 1.5,
          textAlign: TextAlign.start,
          //textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          initialSelection: dropdownKey,
          trailingIcon: arrowDownIcon(),
          selectedTrailingIcon: arrowUpIcon(),
          dropdownMenuEntries: menuEntries,
          onSelected: (int? key) {
            if (key == null) return;
            setState(() {
              dropdownKey = key;
            });
            widget.onChanged?.call(key);
          },
        );
      },
    );
  }
}
