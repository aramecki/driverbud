// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'DriverBud';

  @override
  String get backAgainToExit => 'Back again to exit';

  @override
  String get cancel => 'Cancel';

  @override
  String get stay => 'Stay';

  @override
  String get discard => 'Discard';

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
  String get capacityUpper => 'Capacity';

  @override
  String get powerUpper => 'Power';

  @override
  String get horsePowerUpper => 'HorsePower';

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
  String get priceRequiredField => 'Total price is a required field.';

  @override
  String get brandModelRequiredField =>
      'Category, brand and model are required fields.';

  @override
  String youWillFindEvents(String eventType) {
    return 'On this page you will find all the $eventType events.';
  }

  @override
  String get youWillFindInvoices =>
      'On this page you will find all the invoices.';

  @override
  String get createYourFirstVehicle => 'Create your first vehicle to add one.';

  @override
  String get createYourFirstVehicleToVisualize =>
      'Add your first vehicle to see details.';

  @override
  String get youWillFindVehicles =>
      'On this page you will find all the saved vehicles.';

  @override
  String get titleUpper => 'Title';

  @override
  String get titleLower => 'title';

  @override
  String get asteriskTitle => 'Title*';

  @override
  String get typeUpper => 'Type';

  @override
  String get placeUpper => 'Place';

  @override
  String get placeLower => 'place';

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
  String get plateUpper => 'Plate';

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
  String searchInEvents(String eventType, String field) {
    return 'Search $eventType by $field';
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
  String numUnit(String numAsString, String unit) {
    return '$numAsString$unit';
  }

  @override
  String numCurrency(String num, String currency) {
    return '$num$currency';
  }

  @override
  String numCurrencyOnUnits(String num, String currency, String unit) {
    return '$num$currency/$unit';
  }

  @override
  String get nextEvents => 'Next events:';

  @override
  String get latestEvents => 'Latest events:';

  @override
  String get noVehicles => 'No vehicles';

  @override
  String get other => 'Other';

  @override
  String get cars => 'Cars';

  @override
  String get motorcycles => 'Motorcycles';

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
  String get exportBackup => 'Export backup';

  @override
  String get restoreBackup => 'Restore backup';

  @override
  String get backupAndRestore => 'Backup and restore';

  @override
  String get creatingBackupFile => 'Creating backup file...';

  @override
  String get restoringFile => 'Waiting for file...';

  @override
  String get backupCompleted => 'Backup completed.';

  @override
  String get restoredSuccessfully => 'Restored successfully.';

  @override
  String processNotCompleted(String process) {
    return '$process not completed.';
  }

  @override
  String get backupFileWontContainImage =>
      'The backup file won\'t include custom images.';

  @override
  String get checkoutMy => 'Checkout my ';

  @override
  String get beloved => 'beloved ';

  @override
  String get withSpace => 'with ';

  @override
  String poweredby(String energy) {
    return 'powered by $energy ';
  }

  @override
  String withStandard(String ecology) {
    return 'with standard $ecology.';
  }

  @override
  String get onDateUpper => 'On ';

  @override
  String get onDateArticleLower => 'on ';

  @override
  String get iPerformed => 'I performed ';

  @override
  String get iRefueled => 'I refueled ';

  @override
  String get onMy => 'on my ';

  @override
  String get forMy => 'for my ';

  @override
  String get withKm => 'with ';

  @override
  String get at => 'at ';

  @override
  String get atPlace => 'at ';

  @override
  String get paying => 'paying ';

  @override
  String get forATotalOf => 'for a total of ';

  @override
  String get language => 'Language';

  @override
  String get country => 'Country';

  @override
  String get currency => 'Currency';

  @override
  String get theme => 'Theme';

  @override
  String get gotAFeedback => 'Got a feedback?';

  @override
  String get about => 'About';

  @override
  String get languageSettings => 'Language settings';

  @override
  String get themeSettings => 'Theme settings';

  @override
  String get currencySettings => 'Currency settings';

  @override
  String get followSystemTheme => 'Follow system theme';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get homeNoEventsMessage =>
      'The latest events of the selected vehicle will be shown on this page.';

  @override
  String get thirdPartyInsurance => 'Third party insurance';

  @override
  String get tax => 'Tax';

  @override
  String get taxLower => 'tax';

  @override
  String get inspection => 'Technical inspection';

  @override
  String get inspectionLower => 'technical inspection';

  @override
  String get inspector => 'Inspector';

  @override
  String get performedAt => 'Performed at:';

  @override
  String get expiring => 'Expiring:';

  @override
  String editInvoiceDetails(String invoice) {
    return 'Edit $invoice details';
  }

  @override
  String get insurance => 'insurance';

  @override
  String get insuranceAgency => 'Insurance agency';

  @override
  String get notes => 'Notes';

  @override
  String get totalAmount => 'Total amount';

  @override
  String get customizeDues => 'Customize dues';

  @override
  String get dueSpace => 'Due ';

  @override
  String duesCount(int duesNumber) {
    String _temp0 = intl.Intl.pluralLogic(
      duesNumber,
      locale: localeName,
      other: '$duesNumber dues',
      one: '1 due',
    );
    return '$_temp0';
  }

  @override
  String get spaceInSpace => ' in ';

  @override
  String get notifications => 'Notifications';

  @override
  String get permissionsRequired => 'Permissions required';

  @override
  String get permissionsRequiredAlertBody =>
      'To be informed about deadlines and events, you need to allow notifications in the app settings.';

  @override
  String maintenanceNotificationsTitle(String vehicleName) {
    return 'Reminder: $vehicleName maintenance.';
  }

  @override
  String get insuranceNotificationsTitle =>
      'Your vehicle insurance is expiring!';

  @override
  String get taxNotificationsTitle => 'Time to renew your vehicle tax!';

  @override
  String get inspectionNotificationsTitle =>
      'Time to renew your vehicle technical inspection!';

  @override
  String maintenanceNotificationsBody(String date, String type, String event) {
    return '$event on $date at $type.';
  }

  @override
  String insuranceNotificationsBody(String vehicleName, String date) {
    return 'The insurance of your $vehicleName is expiring on $date.';
  }

  @override
  String taxNotificationsBody(String vehicleName, String date) {
    return 'The vehicle tax for your $vehicleName is due by $date.';
  }

  @override
  String inspectionNotificationsBody(String vehicleName, String date) {
    return 'It’s time for your $vehicleName’s technical inspection. Book your appointment by $date to stay road-legal.';
  }

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get dataNotSavedWillBeLost => 'Data not saved will be lost.';

  @override
  String get actionCantBeUndone => 'This action cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String get reachedMaxEntry =>
      'You\'ve reached the vehicle limit in your garage.';

  @override
  String get aSoloProject => 'A solo project by aramecki';

  @override
  String get getMoreInfoOn => 'Get more info on:';

  @override
  String get cantFindBrandSub => 'DriverBud - Report: Unable to find a brand.';

  @override
  String get feedbackSub => 'DriverBud - Feedback';

  @override
  String get fuelUppercase => 'Fuel';

  @override
  String get fuelAmount => 'Fuel amount';

  @override
  String get totalPrice => 'Total price';

  @override
  String get pricePerUnit => 'Price per unit';

  @override
  String get automatic => 'Automatic';

  @override
  String get autoFuelCalculationMessage =>
      'Enter the total and unit price values for automatic calculation.';
}
