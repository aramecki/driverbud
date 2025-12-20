import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:mycargenie_2/utils/boxes.dart';
import 'package:timezone/timezone.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  tz.initializeTimeZones();

  String timeZoneName;
  try {
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();

    timeZoneName = timezoneInfo.identifier;

    log('Timezone set to: $timeZoneName');
  } catch (e) {
    log('Could not get local timezone: $e, setting \'Europe/Rome\'');
    timeZoneName = 'UTC';
  }

  tz.setLocalLocation(tz.getLocation(timeZoneName));

  const androidSettings = AndroidInitializationSettings(
    '@drawable/notification_icon',
  );
  const darwinSettings = DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidSettings,
    iOS: darwinSettings,
  );

  await notificationsPlugin.initialize(initializationSettings);

  //await requestPermissions(); // put permissions request when scheduling a notificatiojn
}

Future<void> showInstantNotification({
  required int id,
  required String title,
  required String body,
}) async {
  await notificationsPlugin.show(
    id,
    title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'instant_channel',
        'Instant Notifications',
        channelDescription: 'Instant notifications channel.',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),
  );
}

Future<void> scheduleNotification({
  required int vehicleKey,
  required String title,
  String? body,
  required DateTime date,
}) async {
  TZDateTime scheduledDate = tz.TZDateTime.from(date, tz.local);

  int id = createUniqueId(date);

  await notificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    scheduledDate,
    //payload: id.toString(),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'invoices',
        'Invoices',
        channelDescription: 'Invoices notifications.',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    //matchDateTimeComponents: DateTimeComponents
    //  .dayOfWeekAndTime, // Repeat every day of the week at the same time
  );

  final insuranceNotificationsMap = <String, dynamic>{
    'vehicleKey': vehicleKey,
    'date': date,
  };

  insuranceNotificationsBox.put(id, insuranceNotificationsMap);

  log('scheduled notification for: $scheduledDate with id $id');
  log('added to hive box: ${insuranceNotificationsMap.toString()}');
}

int createUniqueId(DateTime date) {
  return date.millisecondsSinceEpoch & 0x7FFFFFFF;
}

Future<void> deleteAllNotificationsInCategory(
  Box<dynamic> box,
  int vehicleKey,
) async {
  log('starting iterating in $box');

  for (var entry in box.toMap().entries) {
    final key = entry.key;
    final value = entry.value;
    log('value is: $value');

    if (value['vehicleKey'] == vehicleKey) {
      log('found corrisponding key, deleting notification');
      await notificationsPlugin.cancel(key);

      await box.delete(key);
    }
  }

  log('now box contains ${box.toMap().toString()}');
}

Future<void> cleanupDeliveredNotifications(Box<dynamic> box) async {
  final List<PendingNotificationRequest> pendingRequests =
      await notificationsPlugin.pendingNotificationRequests();

  final Set<int> osPendingIds = pendingRequests.map((req) => req.id).toSet();

  final List<dynamic> boxKeys = box.keys.toList();

  for (final key in boxKeys) {
    final int? notificationId = int.tryParse(key.toString());

    if (notificationId != null) {
      if (!osPendingIds.contains(notificationId)) {
        await box.delete(key);
        log('Deleted delivered notification with ID $key from ${box.name}.');
      }
    }
  }
}
