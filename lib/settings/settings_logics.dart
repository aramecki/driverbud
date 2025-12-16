import 'package:flutter/material.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Class to hold user settings
class SettingsModel {
  Locale locale;
  String currency;
  bool followsSystemTheme;
  ThemeMode themeMode;
  String documentsPath;

  SettingsModel({
    required this.locale,
    required this.currency,
    required this.followsSystemTheme,
    required this.themeMode,
    required this.documentsPath,
  });

  factory SettingsModel.initial() {
    return SettingsModel(
      locale: const Locale('en'),
      currency: '€',
      followsSystemTheme: true,
      themeMode: ThemeMode.system,
      documentsPath: '',
    );
  }
}

// To read from and write to SharedPreferences.
class SettingsService {
  static const String _localeKey = 'user_locale_code';
  static const String _currencyKey = 'user_currency_symbol';
  static const String _themeKey = 'user_theme_mode';
  static const String _followsSystemThemeKey = 'follows_system_theme';
  static const String _documentsPathKey = 'documents_path';

  Future<SettingsModel> loadSettings(Locale systemLocale) async {
    final prefs = await SharedPreferences.getInstance();

    // Load locale
    final String languageCode =
        prefs.getString(_localeKey) ?? systemLocale.languageCode;

    final Locale savedLocale;
    if (AppLocalizations.supportedLocales.any(
      (l) => l.languageCode == languageCode,
    )) {
      savedLocale = Locale(languageCode);
    } else {
      savedLocale = const Locale('en');
    }

    final String currencySymbol = prefs.getString(_currencyKey) ?? '€';

    // Load theme
    final int themeIndex = prefs.getInt(_themeKey) ?? ThemeMode.system.index;
    final ThemeMode savedThemeMode = ThemeMode.values[themeIndex];
    final followsSystemTheme = prefs.getBool(_followsSystemThemeKey) ?? true;
    final String documentsPath = prefs.getString(_documentsPathKey) ?? '';

    return SettingsModel(
      locale: savedLocale,
      currency: currencySymbol,
      themeMode: savedThemeMode,
      followsSystemTheme: followsSystemTheme,
      documentsPath: documentsPath,
    );
  }

  // Save locale key
  Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  // Save currency symbol
  Future<void> saveCurrency(String currencySymbol) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currencySymbol);
  }

  // Save theme index
  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  Future<void> setFollowSystemTheme(bool followsSystem) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_followsSystemThemeKey, followsSystem);

    await prefs.setInt(
      _themeKey,
      followsSystem ? ThemeMode.system.index : ThemeMode.light.index,
    );
  }

  Future<void> saveDocumentsPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_documentsPathKey, path);
  }
}

// Settings provider
class SettingsProvider with ChangeNotifier {
  final SettingsService _service = SettingsService();
  final Locale _systemLocale;
  SettingsModel? _settings = SettingsModel.initial();

  SettingsModel? get settings => _settings;
  Locale? get locale => _settings?.locale;
  String? get currency => _settings?.currency;
  ThemeMode? get themeMode => _settings?.themeMode ?? ThemeMode.system;
  bool get followsSystemTheme => _settings?.followsSystemTheme ?? true;
  String get documentsPath => _settings?.documentsPath ?? '';

  SettingsProvider(this._systemLocale) {
    _loadInitialSettings();
  }

  Future<void> _loadInitialSettings() async {
    _settings = await _service.loadSettings(_systemLocale);

    if (_settings!.documentsPath.isEmpty) {
      await _initializeAndSaveDocumentsPath();
    }
    notifyListeners();
  }

  // Set locale
  Future<void> setLocale(Locale newLocale) async {
    if (_settings == null ||
        newLocale.languageCode == _settings!.locale.languageCode) {
      return;
    }

    await _service.saveLocale(newLocale);

    _settings = SettingsModel(
      locale: newLocale,
      currency: _settings!.currency,
      followsSystemTheme: _settings!.followsSystemTheme,
      themeMode: _settings!.themeMode,
      documentsPath: settings!.documentsPath,
    );

    notifyListeners();
  }

  // Set locale
  Future<void> setCurrency(String currencySymbol) async {
    if (_settings == null || currencySymbol == _settings!.currency) {
      return;
    }

    await _service.saveCurrency(currencySymbol);

    _settings = SettingsModel(
      locale: _settings!.locale,
      currency: currencySymbol,
      followsSystemTheme: _settings!.followsSystemTheme,
      themeMode: _settings!.themeMode,
      documentsPath: settings!.documentsPath,
    );

    notifyListeners();
  }

  // Set theme to follow system
  Future<void> setFollowSystemTheme(bool followsSystem) async {
    if (_settings == null) return;

    ThemeMode systemTheme = _settings!.themeMode;

    if (!followsSystem) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      systemTheme = brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light;

      await _service.saveThemeMode(systemTheme);
    }

    await _service.setFollowSystemTheme(followsSystem);

    _settings = SettingsModel(
      locale: _settings!.locale,
      currency: _settings!.currency,
      followsSystemTheme: followsSystem,
      themeMode: followsSystem ? ThemeMode.system : systemTheme,
      documentsPath: _settings!.documentsPath,
    );

    notifyListeners();
  }

  // Set dark or light theme
  Future<void> setThemeMode(ThemeMode newMode) async {
    if (_settings == null || newMode == _settings!.themeMode) return;

    await _service.saveThemeMode(newMode);

    _settings = SettingsModel(
      locale: _settings!.locale,
      currency: _settings!.currency,
      followsSystemTheme: _settings!.followsSystemTheme,
      themeMode: newMode,
      documentsPath: settings!.documentsPath,
    );

    notifyListeners();
  }

  Future<void> _initializeAndSaveDocumentsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;

    await _service.saveDocumentsPath(path);

    _settings = SettingsModel(
      locale: _settings!.locale,
      currency: _settings!.currency,
      followsSystemTheme: _settings!.followsSystemTheme,
      themeMode: _settings!.themeMode,
      documentsPath: path,
    );
  }
}
