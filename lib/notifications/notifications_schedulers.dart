import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/notifications/notifications_utils.dart';
import 'package:mycargenie_2/utils/boxes.dart';

enum NotificationType { insurance, tax, inspection }

bool scheduleInvoiceNotifications(
  AppLocalizations localizations,
  int? vehicleKey,
  DateTime? date,
  NotificationType notificationType,
) {
  if (vehicleKey != null && date != null) {
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

    DateTime effectiveDate = date.add(const Duration(hours: 9));
    scheduleNotification(
      vehicleKey: vehicleKey,
      title: title,
      body: body,
      date: effectiveDate,
      //date: DateTime.now().add(const Duration(seconds: 10)),
      notificationsBox: notificationsBox,
    );
    return true;
  } else {
    log(
      'returning false in scheduleInsuranceNotifications fun because date: $date vehicleKey: $vehicleKey',
    );
    return false;
  }
}
