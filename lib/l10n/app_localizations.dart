import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// Main Home text shown when the app starts
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Favorite text
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// Brand text
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brandUpper;

  /// Model text
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get modelUpper;

  /// Configuration text
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get configurationUpper;

  /// Capacity cc text
  ///
  /// In en, this message translates to:
  /// **'Capacity cc'**
  String get capacityCcUpper;

  /// Power kw text
  ///
  /// In en, this message translates to:
  /// **'Power kw'**
  String get powerKwUpper;

  /// HorsePower cv text
  ///
  /// In en, this message translates to:
  /// **'HorsePower cv'**
  String get horsePowerCvUpper;

  /// Main Maintenance uppercase text shown in navigation bar and in maintenance section
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenanceUpper;

  /// maintenance lower text
  ///
  /// In en, this message translates to:
  /// **'maintenance'**
  String get maintenanceLower;

  /// Vehicle uppercase text
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicleUpper;

  /// vehicle lowercase text
  ///
  /// In en, this message translates to:
  /// **'vehicle'**
  String get vehicleLower;

  /// Main Refueling Uppercase text shown in navigation bar and in refueling section
  ///
  /// In en, this message translates to:
  /// **'Refueling'**
  String get refuelingUpper;

  /// refueling lowercase text
  ///
  /// In en, this message translates to:
  /// **'refueling'**
  String get refuelingLower;

  /// Main Invoices text shown in navigation bar and in invoices section
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get invoices;

  /// Settings text
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// My garage text
  ///
  /// In en, this message translates to:
  /// **'My garage'**
  String get myGarage;

  /// Title is a required field. text shown when saving an event without the title required field
  ///
  /// In en, this message translates to:
  /// **'Title is a required field.'**
  String get titleRequiredField;

  /// Brand and model are required fields. text shown when saving a vehicle without the brand or model required fields
  ///
  /// In en, this message translates to:
  /// **'Brand and model are required fields.'**
  String get brandModelRequiredField;

  /// On this page you will find all the added maintenance/refueling events. text shown when user has not maintenance event saved for the selected vehicle
  ///
  /// In en, this message translates to:
  /// **'On this page you will find all the created {eventType} events.'**
  String youWillFindEvents(String eventType);

  /// On this page you will find all the saved vehicles. text shown when user has not vehicles saved
  ///
  /// In en, this message translates to:
  /// **'On this page you will find all the saved vehicles.'**
  String get youWillFindVehicles;

  /// Title text
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleUpper;

  /// Title* text shown in title field
  ///
  /// In en, this message translates to:
  /// **'Title*'**
  String get asteriskTitle;

  /// Type text shown in type field
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeUpper;

  /// Place text shown in place field
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get placeUpper;

  /// Kilometers text shown in kilometers field
  ///
  /// In en, this message translates to:
  /// **'Kilometers'**
  String get kilometersUpper;

  /// Description text shown in description field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionUpper;

  /// Price text shown in price field
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceUpper;

  /// Year text
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearUpper;

  /// Select Year text
  ///
  /// In en, this message translates to:
  /// **'Select Year'**
  String get selectYear;

  /// Category text
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryUpper;

  /// Energy text
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energyUpper;

  /// Ecology text
  ///
  /// In en, this message translates to:
  /// **'Ecology'**
  String get ecologyUpper;

  /// Update text shown as save button when editing an event
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateUpper;

  /// Save text shown as save button when creating an event
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveUpper;

  /// Edit text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editUpper;

  /// Can't find your vehicle brand? text
  ///
  /// In en, this message translates to:
  /// **'Can\'t find your vehicle brand?'**
  String get cantFindYourVehicleBrand;

  /// Fields marked with * are required. text shown under event creation or editing screen
  ///
  /// In en, this message translates to:
  /// **'Fields marked with * are required.'**
  String get asteriskRequiredFields;

  /// Add Maintenance/Refueling/Vehicle text shown as title when creating
  ///
  /// In en, this message translates to:
  /// **'Add {value}'**
  String addValue(String value);

  /// Edit Maintenance/Refueling/Vehicle text shown as title when editing
  ///
  /// In en, this message translates to:
  /// **'Edit {value}'**
  String editValue(String value);

  /// Search Maintenance/refueling events text
  ///
  /// In en, this message translates to:
  /// **'Search in {eventType} events'**
  String searchInEvents(String eventType);

  /// Date text
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// dd/mm/aaaa date form DateTime
  ///
  /// In en, this message translates to:
  /// **'{day}/{month}/{year}'**
  String ggMmAaaa(int day, int month, int year);

  /// num km Ex. 10km
  ///
  /// In en, this message translates to:
  /// **'{num}km'**
  String numKm(int num);

  /// num cc Ex. 10cc
  ///
  /// In en, this message translates to:
  /// **'{num}cc'**
  String numCc(int num);

  /// num kW Ex. 10kW
  ///
  /// In en, this message translates to:
  /// **'{num}kW'**
  String numKw(int num);

  /// num CV Ex. 10CV
  ///
  /// In en, this message translates to:
  /// **'{num}CV'**
  String numCv(int num);

  /// num currency Ex. 5€
  ///
  /// In en, this message translates to:
  /// **'{num}{currency}'**
  String numCurrency(String num, String currency);

  /// Latest Events: text shown in home screen
  ///
  /// In en, this message translates to:
  /// **'Latest events:'**
  String get latestEvents;

  /// No vehicles text shown in screens when there are no registered vehicles
  ///
  /// In en, this message translates to:
  /// **'No vehicles'**
  String get noVehicles;

  /// Other text
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Sedan vehicle text
  ///
  /// In en, this message translates to:
  /// **'Sedan'**
  String get sedan;

  /// Coupé vehicle text
  ///
  /// In en, this message translates to:
  /// **'Coupé'**
  String get coupe;

  /// Sports Car vehicle text
  ///
  /// In en, this message translates to:
  /// **'Sports Car'**
  String get sportsCar;

  /// SUV Car vehicle text
  ///
  /// In en, this message translates to:
  /// **'SUV'**
  String get suv;

  /// Station Wagon vehicle text
  ///
  /// In en, this message translates to:
  /// **'Station Wagon'**
  String get stationWagon;

  /// Minivan Car vehicle text
  ///
  /// In en, this message translates to:
  /// **'Minivan'**
  String get minivan;

  /// Supercar Car vehicle text
  ///
  /// In en, this message translates to:
  /// **'Supercar'**
  String get supercar;

  /// Petrol text
  ///
  /// In en, this message translates to:
  /// **'Petrol'**
  String get petrol;

  /// Diesel text
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get diesel;

  /// LPG text
  ///
  /// In en, this message translates to:
  /// **'LPG'**
  String get lpg;

  /// CNG text
  ///
  /// In en, this message translates to:
  /// **'CNG'**
  String get cng;

  /// Electric text
  ///
  /// In en, this message translates to:
  /// **'Electric'**
  String get electric;

  /// Mechanic text
  ///
  /// In en, this message translates to:
  /// **'Mechanic'**
  String get mechanic;

  /// Electrician text
  ///
  /// In en, this message translates to:
  /// **'Electrician'**
  String get electrician;

  /// Body Shop text
  ///
  /// In en, this message translates to:
  /// **'Body Shop'**
  String get bodyShop;

  /// Backup text
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backupUpper;

  /// Restoration text
  ///
  /// In en, this message translates to:
  /// **'Restoration'**
  String get restorationUpper;

  /// Export Backup text
  ///
  /// In en, this message translates to:
  /// **'Export Backup'**
  String get exportBackup;

  /// Restore Backup text
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get restoreBackup;

  /// Backup and Restore text
  ///
  /// In en, this message translates to:
  /// **'Backup and Restore'**
  String get backupAndRestore;

  /// Creating backup file... text
  ///
  /// In en, this message translates to:
  /// **'Creating backup file...'**
  String get creatingBackupFile;

  /// Restoring file... text
  ///
  /// In en, this message translates to:
  /// **'Restoring file...'**
  String get restoringFile;

  /// Backup completed. text
  ///
  /// In en, this message translates to:
  /// **'Backup completed.'**
  String get backupCompleted;

  /// Restored successfully. text
  ///
  /// In en, this message translates to:
  /// **'Restored successfully.'**
  String get restoredSuccessfully;

  /// Backup/Restoration not completed. text
  ///
  /// In en, this message translates to:
  /// **'{process} not completed.'**
  String processNotCompleted(String process);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
