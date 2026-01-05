import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mycargenie_2/notifications/notifications_utils.dart';
import 'package:mycargenie_2/settings/settings_logics.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/theme/theme.dart';
import 'package:provider/provider.dart';
import 'vehicle/vehicles.dart';
import 'home.dart';
import 'maintenance/maintenance.dart';
import 'refueling/refueling.dart';
import 'invoices/invoices.dart';
import 'utils/boxes.dart';
import 'startup_image_loader_debug.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

  await initNotifications();

  await Hive.initFlutter();

  await Hive.openBox('vehicle');
  await Hive.openBox('maintenance');
  await Hive.openBox('maintenanceNotifications');
  await Hive.openBox('refueling');
  await Hive.openBox('insurance');
  await Hive.openBox('insuranceNotifications');
  await Hive.openBox('tax');
  await Hive.openBox('taxNotifications');
  await Hive.openBox('inspection');
  await Hive.openBox('inspectionNotifications');

  await cleanDeliveredNotificationFromBoxes();

  if (vehicleBox.isEmpty) {
    await startupImageLoader();

    await vehicleBox.add({
      'category': 1,
      'brand': 'Toyota',
      'model': 'Corolla',
      'config': 'B-Turbo',
      'year': 2020,
      'capacity': 1400,
      'power': 100,
      'horse': 140,
      'plate': 'AF345TG',
      'type': 3,
      'energy': 2,
      'ecology': 4,
      'favorite': false,
      'assetImage': imageOne,
    });
    await vehicleBox.add({
      'category': 1,
      'brand': 'Ford',
      'model': 'Focus',
      'config': null,
      'year': 2019,
      'capacity': 1400,
      'power': 100,
      'horse': 140,
      'plate': 'EF345GH',
      'type': 1,
      'energy': 3,
      'ecology': 2,
      'favorite': false,
      'assetImage': imageTwo,
    });
    await vehicleBox.add({
      'category': 1,
      'brand': 'Audi',
      'model': 'TT',
      'config': 'Quattro',
      'year': 2016,
      'capacity': 2000,
      'power': 100,
      'horse': 190,
      'plate': 'AB123CD',
      'type': 3,
      'energy': 1,
      'ecology': 3,
      'favorite': true,
      'assetImage': imageThree,
    });
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider(systemLocale)),
      ],
      child: DriverBud(),
    ),
  );
}

class DriverBud extends StatelessWidget {
  const DriverBud({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    if (settingsProvider.settings == null) {
      return const MaterialApp(
        home: Center(child: CircularProgressIndicator()),
      );
    }

    return MaterialApp(
      //title: 'DriverBud',
      themeMode: settingsProvider.themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const DriverBudMain(),
      locale: settingsProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: const [Locale('en'), Locale('it')],
    );
  }
}

// MainMaterialPage
class DriverBudMain extends StatefulWidget {
  const DriverBudMain({super.key});

  @override
  State<DriverBudMain> createState() => _DriverBudMainState();
}

class _DriverBudMainState extends State<DriverBudMain> {
  // Variables to track navigation
  int _currentIndex = 0;
  int _latestIndex = 0;

  final List<Widget> pages = const [
    Home(key: ValueKey<int>(0)),
    Maintenance(key: ValueKey<int>(1)),
    Refueling(key: ValueKey<int>(2)),
    Invoices(key: ValueKey<int>(3)),
    Garage(key: ValueKey<int>(4)),
  ];

  // TODO: Add double back to close on main pages
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      //extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          final bool incoming =
              (child.key as ValueKey<int>).value == _currentIndex;
          final Offset begin = incoming
              ? _latestIndex < _currentIndex
                    ? const Offset(0.2, 0)
                    : const Offset(-0.2, 0)
              : _latestIndex < _currentIndex
              ? const Offset(-0.2, 0)
              : const Offset(0.2, 0);
          final Tween<Offset> tween = Tween(begin: begin, end: Offset.zero);
          final Animation<Offset> offset = tween.animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOut),
          );
          return SlideTransition(position: offset, child: child);
        },
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 2, bottom: 8, left: 16, right: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              height: 60,
              child: NavigationBar(
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _latestIndex = _currentIndex;
                    _currentIndex = index;
                  });
                },
                destinations: [
                  NavigationDestination(
                    icon: homeIcon,
                    label: localizations.home,
                  ),
                  NavigationDestination(
                    icon: toolsIcon,
                    label: localizations.maintenanceUpper,
                  ),
                  NavigationDestination(
                    icon: refuelingIcon,
                    label: localizations.refuelingUpper,
                  ),
                  NavigationDestination(
                    icon: invoicesIcon,
                    label: localizations.invoices,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
