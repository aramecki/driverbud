import 'package:flutter/material.dart';
import 'package:mycargenie_2/boxes.dart';
import 'package:mycargenie_2/maintenance/add_maintenance.dart';
import 'package:mycargenie_2/maintenance/show_maintenance.dart';

Widget maintenanceEventListTile(
  BuildContext context,
  dynamic item,
  dynamic editKey,
  Function? onEdit,
) {
  return SizedBox(
    child: ListTile(
      // enabled: true,
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ShowMaintenance(editKey: editKey)),
        );
        if (onEdit != null) onEdit();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      // TODO: Set currency symbol to set one
      trailing: Text('${item['price']}€'),
      leadingAndTrailingTextStyle: TextStyle(fontSize: 16, color: Colors.grey),
      title: Text('${item['title']}'),
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      subtitle: Text(
        '${item['date'].day}/${item['date'].month}/${item['date'].year}',
      ),
      subtitleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.grey,
      ),
    ),
  );
}

Future<void> deleteEvent(dynamic key) {
  return maintenanceBox.delete(key);
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
