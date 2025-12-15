import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mycargenie_2/notifications/notifications_utils.dart';

Future<bool> checkAndRequestPermissions(BuildContext context) async {
  var notificationsStatus = await Permission.notification.status;

  if (!context.mounted) return false;

  if (notificationsStatus.isGranted) {
    //log('User gave notifications permissions');
    return true;
  }

  if (notificationsStatus.isPermanentlyDenied) {
    //log('Notifications permissions denied showing alert');
    await _showSettingsDialog(context);
    return false;
  }

  bool grantedPermissions = false;

  if (Platform.isIOS || Platform.isMacOS) {
    final iosImpl = notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (iosImpl != null) {
      grantedPermissions =
          await iosImpl.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
  } else if (Platform.isAndroid) {
    final androidImpl = notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImpl != null) {
      grantedPermissions =
          await androidImpl.requestNotificationsPermission() ?? false;
    }
  }

  if (grantedPermissions) {
    //log('Permissions given instantly');
    return true;
  }

  notificationsStatus = await Permission.notification.status;

  if (notificationsStatus.isPermanentlyDenied && context.mounted) {
    //log('Permissions permanently denied, showing alert');
    await _showSettingsDialog(context);
  }

  return grantedPermissions;
}

Future<void> _showSettingsDialog(BuildContext context) async {
  final localizations = AppLocalizations.of(context)!;

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(localizations.permissionsRequired),
        content: Text(localizations.permissionsRequiredAlertBody),
        actions: <Widget>[
          TextButton(
            child: Text(localizations.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(localizations.settings),
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
          ),
        ],
      );
    },
  );
}
