import 'package:flutter/material.dart';
import 'package:mycargenie_2/settings/currency_settings.dart';
import 'package:mycargenie_2/settings/settings_logics.dart';
import 'package:mycargenie_2/utils/boxes.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/maintenance/add_maintenance.dart';
import 'package:mycargenie_2/maintenance/show_maintenance.dart';
import 'package:provider/provider.dart';

Widget maintenanceEventListTile(
  BuildContext context,
  dynamic item,
  dynamic editKey,
  Function? onEdit,
) {
  final localizations = AppLocalizations.of(context)!;
  final settingsProvider = context.read<SettingsProvider>();

  String parsedPrice = parseShowedPrice(item['price']);

  String eventPrice = localizations.numCurrency(
    parsedPrice,
    settingsProvider.currency!,
  );
  String eventTitle = item['title'];
  String eventDate = localizations.ggMmAaaa(
    item['date'].day,
    item['date'].month,
    item['date'].year,
  );

  return SizedBox(
    child: ListTile(
      onTap: () async {
        await openEventShowScreen(context, editKey);
        if (onEdit != null) onEdit();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      title: Text(eventTitle),
      subtitle: Text(eventDate),
      trailing: Text(eventPrice),
    ),
  );
}

Future<void> deleteEvent(dynamic key) {
  return maintenanceBox.delete(key);
}

Future<Object?> openEventShowScreen(
  BuildContext context,
  dynamic editKey,
) async {
  return Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => ShowMaintenance(editKey: editKey)));
}

Future<Object?> openEventEditScreen(BuildContext context, dynamic key) async {
  final Map<String, dynamic> maintenanceMap = maintenanceBox
      .get(key)!
      .cast<String, dynamic>();

  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) =>
          AddMaintenance(maintenanceEvent: maintenanceMap, editKey: key),
    ),
  );
}
