import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mycargenie_2/refueling/add_refueling.dart';
import 'package:mycargenie_2/refueling/show_refueling.dart';
import 'package:mycargenie_2/settings/currency_settings.dart';
import 'package:mycargenie_2/settings/settings_logics.dart';
import 'package:mycargenie_2/utils/boxes.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/utils/lists.dart';
import 'package:provider/provider.dart';

Widget refuelingEventListTile(
  BuildContext context,
  dynamic item,
  dynamic editKey,
  Function? onEdit,
) {
  final localizations = AppLocalizations.of(context)!;
  final settingsProvider = context.read<SettingsProvider>();

  String parsedPrice = parseShowedPrice(item['price']);
  int? refuelingType = item['refuelingType'];
  String fuelUnit;
  String eventTotalUnits = '';

  String fuelAmount = parseShowedPrice(item['fuelAmount']);
  if (fuelAmount != '0,00') {
    fuelUnit = getFuelUnit(refuelingType);
    eventTotalUnits = localizations.numUnit(fuelAmount, fuelUnit);
  }

  String eventPrice = localizations.numCurrency(
    parsedPrice,
    settingsProvider.currency!,
  );

  String eventDate = localizations.ggMmAaaa(
    item['date'].day,
    item['date'].month,
    item['date'].year,
  );

  return SizedBox(
    child: ListTile(
      onTap: () async {
        await openRefuelingShowScreen(context, editKey);
        if (onEdit != null) onEdit();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      title: Text(eventPrice),
      subtitle: Text(eventDate),
      trailing: Text(eventTotalUnits),
    ),
  );
}

Future<void> deleteEvent(int key) {
  return refuelingBox.delete(key);
}

Future<Object?> openRefuelingShowScreen(
  BuildContext context,
  dynamic editKey,
) async {
  return Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => ShowRefueling(editKey: editKey)));
}

Future<Object?> openRefuelingEditScreen(
  BuildContext context,
  dynamic key,
) async {
  final Map<String, dynamic> refuelingMap = refuelingBox
      .get(key)!
      .cast<String, dynamic>();

  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => AddRefueling(refuelingEvent: refuelingMap, editKey: key),
    ),
  );
}

String getFuelUnit(int? fuelType) {
  switch (fuelType) {
    case null || 6:
      log('type is $fuelType so returning null');
      return '';
    case 4:
      return fuelUnitsList[2]!;
    case 5:
      return fuelUnitsList[3]!;
    default:
      return fuelUnitsList[1]!;
  }
}
