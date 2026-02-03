import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mycargenie_2/maintenance/maintenance_misc.dart';
import 'package:mycargenie_2/refueling/refueling_misc.dart';
import 'package:mycargenie_2/settings/settings_logics.dart';
import 'package:mycargenie_2/utils/boxes.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/maintenance/add_maintenance.dart';
import 'package:mycargenie_2/refueling/add_refueling.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/sorting_funs.dart';
import 'package:provider/provider.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showCustomToast(
  BuildContext context, {
  required String message,
  Duration duration = const Duration(seconds: 3),
  Color backgroundColor = Colors.deepOrangeAccent,
  VoidCallback? onUndo,
  double? topMargin,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
      backgroundColor: backgroundColor,
      elevation: 6.0,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      margin: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
    ),
  );
}

// Adaptive button
Widget buildAddButton(
  BuildContext context, {
  required VoidCallback onPressed,
  required String text,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(50),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    ),
    child: Text(text, style: TextStyle(fontSize: 20)),
  );
}

// Custom switch
class CustomSwitch extends StatelessWidget {
  final bool isSelected;
  final ValueChanged<bool> onChanged;
  final String? text;

  const CustomSwitch({
    super.key,
    required this.isSelected,
    required this.onChanged,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Switch(value: isSelected, onChanged: onChanged),
        const SizedBox(width: 4),

        Text(
          text ?? localizations.favorite,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// CustomSlideableAction custom icon
Widget slideableIcon(
  BuildContext context, {
  required SlidableActionCallback? onPressed,
  required HugeIcon icon,
  Color color = Colors.deepOrange,
}) {
  return CustomSlidableAction(
    onPressed: onPressed,
    autoClose: true,
    backgroundColor: Colors.transparent,
    padding: EdgeInsets.symmetric(horizontal: 3),
    child: SizedBox.expand(
      child: Container(
        width: 28,
        height: 28,
        padding: const EdgeInsets.all(2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: icon,
      ),
    ),
  );
}

// Box containing latest events for selected vehicle in home screen

Widget homeRowBox(
  BuildContext context, {
  required Map<dynamic, dynamic> event,
  required bool isRefueling,
}) {
  final settingsProvider = context.read<SettingsProvider>();

  final localizations = AppLocalizations.of(context)!;
  TextStyle textStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);

  // Shared
  int eventKey = event['key'];
  DateTime date = event['value']['date'];
  String? place = event['value']['place'];
  String price = event['value']['price'];

  // Maintenance events proper
  String? title = isRefueling ? null : event['value']['title'];

  // Refueling events proper
  int? refuelingType = isRefueling ? event['value']['refuelingType'] : null;
  String? fuelUnit = isRefueling ? getFuelUnit(refuelingType) : null;
  String? pricePerUnit = isRefueling ? event['value']['pricePerUnit'] : null;

  return Padding(
    padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 8),
    child: GestureDetector(
      onTap: () {
        isRefueling
            ? openRefuelingShowScreen(context, eventKey)
            : openMaintenanceShowScreen(context, eventKey);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepOrange, width: 2),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: isRefueling
                  ? [
                      Text(
                        localizations.ggMmAaaa(date.day, date.month, date.year),
                        style: textStyle,
                      ),
                      if (price != '0.00')
                        Text(
                          localizations.numCurrency(
                            price,
                            settingsProvider.currency!,
                          ),
                          style: textStyle,
                        ),
                    ]
                  : [Text(title!, style: textStyle)],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: isRefueling
                  ? [
                      if (place != null) Text(place, style: textStyle),
                      if (pricePerUnit != null && fuelUnit != null)
                        Text(
                          localizations.numCurrencyOnUnits(
                            pricePerUnit,
                            settingsProvider.currency!,
                            fuelUnit,
                          ),
                          style: textStyle,
                        ),
                    ]
                  : [
                      if (place != null) Text(place, style: textStyle),
                      Text(
                        localizations.ggMmAaaa(date.day, date.month, date.year),
                        style: textStyle,
                      ),
                    ],
            ),
          ],
        ),
      ),
    ),
  );
}

// Custom back button for appbar
Widget customBackButton(
  BuildContext context, {
  bool confirmation = false,
  bool Function()? checkChanges,
}) {
  return IconButton(
    icon: backIcon,
    onPressed: () {
      bool actuallyChanged = checkChanges?.call() ?? false;
      log('changed: $actuallyChanged');
      if (confirmation && actuallyChanged) {
        discardConfirmOnBack(context);
        return;
      } else {
        Navigator.of(context).pop();
      }
    },
  );
}

Widget customSortingPanel(
  BuildContext context,
  void Function(String sortType) onSort,
  bool isDecrementing, {
  bool isMaintenance = false,
}) {
  final localizations = AppLocalizations.of(context)!;

  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    spacing: 12,
    children: [
      HugeIcon(
        icon: isDecrementing
            ? HugeIcons.strokeRoundedSorting01
            : HugeIcons.strokeRoundedSorting02,
      ),
      if (isMaintenance)
        OutlinedButton(
          onPressed: () {
            onSort('name');
          },
          child: Text(textAlign: TextAlign.center, localizations.titleUpper),
        ),

      if (!isMaintenance)
        OutlinedButton(
          onPressed: () {
            onSort('fuelAmount');
          },
          child: Text(textAlign: TextAlign.center, localizations.fuelUppercase),
        ),

      OutlinedButton(
        onPressed: () {
          onSort('price');
        },
        child: Text(textAlign: TextAlign.center, localizations.priceUpper),
      ),
      OutlinedButton(
        onPressed: () {
          onSort('date');
        },
        child: Text(textAlign: TextAlign.center, localizations.date),
      ),
    ],
  );
}

Widget customSearchingPanel(
  BuildContext context,
  void Function(String, List<Map<String, dynamic>>) onChange, {
  bool isMaintenance = true,
}) {
  final localizations = AppLocalizations.of(context)!;

  String eventTypeString = localizations.maintenanceLower;
  String searchFieldString = localizations.titleLower;
  Box box = maintenanceBox;

  if (!isMaintenance) {
    eventTypeString = localizations.refuelingLower;
    searchFieldString = localizations.placeLower;
    box = refuelingBox;
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    spacing: 12,
    children: [
      Expanded(
        child: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: localizations.searchInEvents(
              eventTypeString,
              searchFieldString,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            counterText: '',
          ),
          keyboardType: TextInputType.text,
          maxLength: 20,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          onChanged: (value) {
            if (value.isEmpty) {
              onChange('', []);
              return;
            }

            List<Map<String, dynamic>> result = searchByText(
              box, // Make dynamic
              value,
              isMaintenance: isMaintenance,
            );
            log(result.toString());
            onChange(value, result);
          },
        ),
      ),
    ],
  );
}

// Add maintenance/refueling button shown at the bottom of the main events list page
Widget addEventButton(BuildContext context, bool isMaintenance) {
  final localizations = AppLocalizations.of(context)!;
  final eventTypeString = isMaintenance
      ? localizations.maintenanceLower
      : localizations.refuelingLower;

  return Padding(
    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
    child: buildAddButton(
      context,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                isMaintenance ? const AddMaintenance() : AddRefueling(),
          ),
        );
      },
      text: localizations.addValue(eventTypeString),
    ),
  );
}

Future<bool?> discardConfirmOnBack(
  BuildContext context, {
  bool popScope = false,
}) {
  final localizations = AppLocalizations.of(context)!;

  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(localizations.areYouSure),
        content: Text(localizations.dataNotSavedWillBeLost),
        actions: <Widget>[
          TextButton(
            child: Text(localizations.discard),
            onPressed: () {
              Navigator.of(context).pop(true);
              if (!popScope) Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(localizations.stay),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}

Future<void> deletionConfirmAlert(BuildContext context, Function onDelete) {
  final localizations = AppLocalizations.of(context)!;

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(localizations.areYouSure),
        content: Text(localizations.actionCantBeUndone),
        actions: <Widget>[
          TextButton(
            child: Text(localizations.discard),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(localizations.delete),
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
          ),
        ],
      );
    },
  );
}

Widget containerWithTextAndIcon(String text, HugeIcon icon) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.deepOrange, width: 2),
      borderRadius: BorderRadius.circular(50),
    ),
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [icon, SizedBox(width: 10), Text(text)],
    ),
  );
}

// Row simulating a tile
List<Widget> tileRow(String title, String content) {
  return [
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            content,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    ),
    Divider(height: 22),
  ];
}
