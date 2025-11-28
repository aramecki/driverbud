// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get favorite => 'Favorite';

  @override
  String get brandUpper => 'Brand';

  @override
  String get modelUpper => 'Model';

  @override
  String get configurationUpper => 'Configuration';

  @override
  String get capacityCcUpper => 'Capacity cc';

  @override
  String get powerKwUpper => 'Power kw';

  @override
  String get horsePowerCvUpper => 'HorsePower cv';

  @override
  String get maintenanceUpper => 'Maintenance';

  @override
  String get maintenanceLower => 'maintenance';

  @override
  String get vehicleUpper => 'Vehicle';

  @override
  String get vehicleLower => 'vehicle';

  @override
  String get refuelingUpper => 'Refueling';

  @override
  String get refuelingLower => 'refueling';

  @override
  String get invoices => 'Invoices';

  @override
  String get settings => 'Settings';

  @override
  String get myGarage => 'My garage';

  @override
  String get titleRequiredField => 'Title is a required field.';

  @override
  String get brandModelRequiredField => 'Brand and model are required fields.';

  @override
  String youWillFindEvents(String eventType) {
    return 'On this page you will find all the created $eventType events.';
  }

  @override
  String get youWillFindVehicles =>
      'On this page you will find all the saved vehicles.';

  @override
  String get titleUpper => 'Title';

  @override
  String get asteriskTitle => 'Title*';

  @override
  String get typeUpper => 'Type';

  @override
  String get placeUpper => 'Place';

  @override
  String get kilometersUpper => 'Kilometers';

  @override
  String get descriptionUpper => 'Description';

  @override
  String get priceUpper => 'Price';

  @override
  String get yearUpper => 'Year';

  @override
  String get selectYear => 'Select Year';

  @override
  String get categoryUpper => 'Category';

  @override
  String get energyUpper => 'Energy';

  @override
  String get ecologyUpper => 'Ecology';

  @override
  String get updateUpper => 'Update';

  @override
  String get saveUpper => 'Save';

  @override
  String get editUpper => 'Edit';

  @override
  String get cantFindYourVehicleBrand => 'Can\'t find your vehicle brand?';

  @override
  String get asteriskRequiredFields => 'Fields marked with * are required.';

  @override
  String addValue(String value) {
    return 'Add $value';
  }

  @override
  String editValue(String value) {
    return 'Edit $value';
  }

  @override
  String searchInEvents(String eventType) {
    return 'Search in $eventType events';
  }

  @override
  String get date => 'Date';

  @override
  String ggMmAaaa(int day, int month, int year) {
    return '$day/$month/$year';
  }

  @override
  String numKm(int num) {
    return '${num}km';
  }

  @override
  String numCc(int num) {
    return '${num}cc';
  }

  @override
  String numKw(int num) {
    return '${num}kW';
  }

  @override
  String numCv(int num) {
    return '${num}CV';
  }

  @override
  String numCurrency(String num, String currency) {
    return '$num$currency';
  }

  @override
  String get latestEvents => 'Latest events:';

  @override
  String get noVehicles => 'No vehicles';

  @override
  String get other => 'Other';

  @override
  String get sedan => 'Sedan';

  @override
  String get coupe => 'Coupé';

  @override
  String get sportsCar => 'Sports Car';

  @override
  String get suv => 'SUV';

  @override
  String get stationWagon => 'Station Wagon';

  @override
  String get minivan => 'Minivan';

  @override
  String get supercar => 'Supercar';

  @override
  String get petrol => 'Petrol';

  @override
  String get diesel => 'Diesel';

  @override
  String get lpg => 'LPG';

  @override
  String get cng => 'CNG';

  @override
  String get electric => 'Electric';

  @override
  String get mechanic => 'Mechanic';

  @override
  String get electrician => 'Electrician';

  @override
  String get bodyShop => 'Body Shop';

  @override
  String get backupUpper => 'Backup';

  @override
  String get restorationUpper => 'Restoration';

  @override
  String get exportBackup => 'Export Backup';

  @override
  String get restoreBackup => 'Restore Backup';

  @override
  String get backupAndRestore => 'Backup and Restore';

  @override
  String get creatingBackupFile => 'Creating backup file...';

  @override
  String get restoringFile => 'Restoring file...';

  @override
  String get backupCompleted => 'Backup completed.';

  @override
  String get restoredSuccessfully => 'Restored successfully.';

  @override
  String processNotCompleted(String process) {
    return '$process not completed.';
  }
}
