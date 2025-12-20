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

  /// Cancel text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Stay text
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// Discard text
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

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
  /// **'On this page you will find all the {eventType} events.'**
  String youWillFindEvents(String eventType);

  /// Create your first vehicle to add one. text shown when saving a vehicle without the brand or model required fields
  ///
  /// In en, this message translates to:
  /// **'Create your first vehicle to add one.'**
  String get createYourFirstVehicle;

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

  /// num currency/unit Ex. 5€/l
  ///
  /// In en, this message translates to:
  /// **'{num}{currency}/{unit}'**
  String numCurrencyOnUnits(String num, String currency, String unit);

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

  /// Export backup text
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get exportBackup;

  /// Restore backup text
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get restoreBackup;

  /// Backup and bestore text
  ///
  /// In en, this message translates to:
  /// **'Backup and restore'**
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

  /// The backup file won't include custom images. text
  ///
  /// In en, this message translates to:
  /// **'The backup file won\'t include custom images.'**
  String get backupFileWontContainImage;

  /// Checkout my  text
  ///
  /// In en, this message translates to:
  /// **'Checkout my '**
  String get checkoutMy;

  /// beloved  text
  ///
  /// In en, this message translates to:
  /// **'beloved '**
  String get beloved;

  /// with  text
  ///
  /// In en, this message translates to:
  /// **'with '**
  String get withSpace;

  /// powered by  text
  ///
  /// In en, this message translates to:
  /// **'powered by {energy} '**
  String poweredby(String energy);

  /// with standard  text
  ///
  /// In en, this message translates to:
  /// **'with standard {ecology}.'**
  String withStandard(String ecology);

  /// On  text
  ///
  /// In en, this message translates to:
  /// **'On '**
  String get onDate;

  /// I performed  text
  ///
  /// In en, this message translates to:
  /// **'I performed '**
  String get iPerformed;

  /// on my  text
  ///
  /// In en, this message translates to:
  /// **'on my '**
  String get onMy;

  /// with  text
  ///
  /// In en, this message translates to:
  /// **'with '**
  String get withKm;

  /// at  text
  ///
  /// In en, this message translates to:
  /// **'at '**
  String get at;

  /// paying  text
  ///
  /// In en, this message translates to:
  /// **'paying '**
  String get paying;

  /// Language text
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Country text
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// Currency text
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// Theme text
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Got a feedback? text
  ///
  /// In en, this message translates to:
  /// **'Got a feedback?'**
  String get gotAFeedback;

  /// About text
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Language settings text
  ///
  /// In en, this message translates to:
  /// **'Language settings'**
  String get languageSettings;

  /// Theme settings text
  ///
  /// In en, this message translates to:
  /// **'Theme settings'**
  String get themeSettings;

  /// Currency settings text
  ///
  /// In en, this message translates to:
  /// **'Currency settings'**
  String get currencySettings;

  /// Follow system theme text
  ///
  /// In en, this message translates to:
  /// **'Follow system theme'**
  String get followSystemTheme;

  /// Dark mode text
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// The latest events of the selected vehicle will be shown on this page. text
  ///
  /// In en, this message translates to:
  /// **'The latest events of the selected vehicle will be shown on this page.'**
  String get homeNoEventsMessage;

  /// Third party insurance text
  ///
  /// In en, this message translates to:
  /// **'Third party insurance'**
  String get thirdPartyInsurance;

  /// Car tax text
  ///
  /// In en, this message translates to:
  /// **'Car tax'**
  String get carTax;

  /// Car inspection text
  ///
  /// In en, this message translates to:
  /// **'Car inspection'**
  String get carInspection;

  /// Expiring: text
  ///
  /// In en, this message translates to:
  /// **'Expiring:'**
  String get expiring;

  /// Edit insurance details text
  ///
  /// In en, this message translates to:
  /// **'Edit insurance details'**
  String get editInsuranceDetails;

  /// insurance text
  ///
  /// In en, this message translates to:
  /// **'insurance'**
  String get insurance;

  /// Insurance agency text
  ///
  /// In en, this message translates to:
  /// **'Insurance agency'**
  String get insuranceAgency;

  /// Notes text
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// Total amount text
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get totalAmount;

  /// Customize dues text
  ///
  /// In en, this message translates to:
  /// **'Customize dues'**
  String get customizeDues;

  /// Due  text
  ///
  /// In en, this message translates to:
  /// **'Due '**
  String get dueSpace;

  /// No description provided for @duesCount.
  ///
  /// In en, this message translates to:
  /// **'{duesNumber,plural, =1{1 due} other{{duesNumber} dues}}'**
  String duesCount(int duesNumber);

  ///  in  text
  ///
  /// In en, this message translates to:
  /// **' in '**
  String get spaceInSpace;

  /// Notifications text
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Permissions required text
  ///
  /// In en, this message translates to:
  /// **'Permissions required'**
  String get permissionsRequired;

  /// To be informed about deadlines and events, you need to allow notifications in the app settings. text
  ///
  /// In en, this message translates to:
  /// **'To be informed about deadlines and events, you need to allow notifications in the app settings.'**
  String get permissionsRequiredAlertBody;

  /// Your vehicle insurance is expiring! text
  ///
  /// In en, this message translates to:
  /// **'Your vehicle insurance is expiring!'**
  String get insuranceNotificationsTitle;

  /// The insurance of your {vehicleName} is expiring on  text
  ///
  /// In en, this message translates to:
  /// **'The insurance of your {vehicleName} is expiring on '**
  String insuranceNotificationsBody(String vehicleName);

  /// Are you sure? text
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// Data not saved will be lost. text
  ///
  /// In en, this message translates to:
  /// **'Data not saved will be lost.'**
  String get dataNotSavedWillBeLost;

  /// This action cannot be undone. text
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get actionCantBeUndone;

  /// Delete text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// You've reached the vehicle limit in your garage. text
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the vehicle limit in your garage.'**
  String get reachedMaxEntry;
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
