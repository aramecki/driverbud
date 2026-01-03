import 'package:hive_flutter/hive_flutter.dart';

final vehicleBox = Hive.box('vehicle');

final maintenanceBox = Hive.box('maintenance');

final maintenanceNotificationsBox = Hive.box('maintenanceNotifications');

final refuelingBox = Hive.box('refueling');

final insuranceBox = Hive.box('insurance');

final insuranceNotificationsBox = Hive.box('insuranceNotifications');

final taxBox = Hive.box('tax');

final taxNotificationsBox = Hive.box('taxNotifications');

final inspectionBox = Hive.box('inspection');

final inspectionNotificationsBox = Hive.box('inspectionNotifications');
