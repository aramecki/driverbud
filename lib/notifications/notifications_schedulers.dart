import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/notifications/notifications_utils.dart';
import 'package:mycargenie_2/utils/boxes.dart';

enum NotificationType { insurance, tax, inspection, maintenance }

bool scheduleInvoiceNotifications(
  AppLocalizations localizations,
  int? vehicleKey,
  DateTime? date,
  NotificationType notificationType, {
  int? id,
  bool isRestoring = false,
}) {
  if (vehicleKey != null && date != null) {
    DateTime effectiveDate;

    final vehicle = vehicleBox.get(vehicleKey);
    String vehicleName = '${vehicle['brand']} ${vehicle['model']}';

    String title = '';
    String body = '';

    Box notificationsBox;

    if (notificationType == NotificationType.insurance) {
      title = localizations.insuranceNotificationsTitle;
      body = localizations.insuranceNotificationsBody(
        vehicleName,
        localizations.ggMmAaaa(date.day, date.month, date.year),
      );
      notificationsBox = insuranceNotificationsBox;
    } else if (notificationType == NotificationType.tax) {
      title = localizations.taxNotificationsTitle;
      body = localizations.taxNotificationsBody(
        vehicleName,
        localizations.ggMmAaaa(date.day, date.month, date.year),
      );
      notificationsBox = taxNotificationsBox;
    } else {
      title = localizations.inspectionNotificationsTitle;
      body = localizations.inspectionNotificationsBody(
        vehicleName,
        localizations.ggMmAaaa(date.day, date.month, date.year),
      );
      notificationsBox = inspectionNotificationsBox;
    }

    if (!isRestoring) {
      effectiveDate = date.add(const Duration(hours: 9));
    } else {
      effectiveDate = date;
    }

    scheduleNotification(
      vehicleKey: vehicleKey,
      title: title,
      body: body,
      date: effectiveDate,
      //date: DateTime.now().add(const Duration(seconds: 10)),
      notificationsBox: notificationsBox,
      id: id,
      isRestoring: isRestoring,
    );
    return true;
  } else {
    log(
      'returning false in scheduleInsuranceNotifications fun because date: $date vehicleKey: $vehicleKey',
    );
    return false;
  }
}

bool scheduleEventNotifications(
  AppLocalizations localizations,
  int? vehicleKey,
  int eventKey,
  DateTime? date,
  String? type,
  String event, {
  int? id,
  bool isRestoring = false,
}) {
  if (vehicleKey != null && date != null && type != null) {
    DateTime effectiveDate;

    final vehicle = vehicleBox.get(vehicleKey);
    String vehicleName = '${vehicle['brand']} ${vehicle['model']}';

    String title = localizations.maintenanceNotificationsTitle(vehicleName);
    String body = localizations.maintenanceNotificationsBody(
      localizations.ggMmAaaa(date.day, date.month, date.year),
      type,
      event,
    );

    if (!isRestoring) {
      effectiveDate = date.add(const Duration(hours: 9));
    } else {
      effectiveDate = date;
    }

    scheduleNotification(
      vehicleKey: vehicleKey,
      eventKey: eventKey,
      title: title,
      body: body,
      eventTitle: event,
      maintenanceType: type,
      date: effectiveDate,
      //date: DateTime.now().add(const Duration(minutes: 5)),
      notificationsBox: maintenanceNotificationsBox,
      id: id,
      isRestoring: isRestoring,
      isMaintenance: true,
    );
    return true;
  } else {
    log(
      'returning false in scheduleEventNotifications fun because date: $date vehicleKey: $vehicleKey',
    );
    return false;
  }
}
