import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mycargenie_2/theme/theme.dart';
import 'package:provider/provider.dart';
import 'vehicle/vehicles.dart';
import 'home.dart';
import 'maintenance/maintenance.dart';
import 'refueling.dart';
import 'invoices.dart';
import 'boxes.dart';
import 'startup_image_loader_debug.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('vehicle');
  await Hive.openBox('maintenance');

  if (vehicleBox.isEmpty) {
    await startupImageLoader();

    await vehicleBox.add({
      'brand': 'Toyota',
      'model': 'Corolla',
      'config': 'B-Turbo',
      'year': 2020,
      'capacity': 1400,
      'power': 100,
      'horse': 140,
      'category': 'Sport',
      'energy': 'Benzina',
      'ecology': 'Euro 4',
      'favourite': false,
      'assetImage': imageOne,
    });
    await vehicleBox.add({
      'brand': 'Ford',
      'model': 'Focus',
      'config': null,
      'year': 2019,
      'capacity': 1400,
      'power': 100,
      'horse': 140,
      'category': 'Berlina',
      'energy': 'Benzina',
      'ecology': 'Euro 6',
      'favourite': false,
      'assetImage': imageTwo,
    });
    await vehicleBox.add({
      'brand': 'Audi',
      'model': 'TT',
      'config': 'Quattro',
      'year': 2016,
      'capacity': 2000,
      'power': 100,
      'horse': 190,
      'category': 'Sport',
      'energy': 'Benzina',
      'ecology': 'Euro 3',
      'favourite': true,
      'assetImage': imageThree,
    });
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => VehicleProvider(),
      child: MyCarGenie(),
    ),
  );
}

class MyCarGenie extends StatelessWidget {
  const MyCarGenie({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'MyCarGenie2',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const MyCarGenieMain(),
    );
  }
}

// MainMaterialPage
class MyCarGenieMain extends StatefulWidget {
  const MyCarGenieMain({super.key});

  @override
  State<MyCarGenieMain> createState() => _MyCarGenieMainState();
}

class _MyCarGenieMainState extends State<MyCarGenieMain> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBody: true,
      // appBar: AppBar(
      //   title: const Text('MyCarGenie'),
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      // ),
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
          padding: EdgeInsets.only(top: 2.0, left: 16.0, right: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
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
                destinations: const [
                  NavigationDestination(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedHome07,
                      size: 30,
                      strokeWidth: 1,
                    ),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedTools,
                      size: 30,
                      strokeWidth: 1,
                    ),
                    label: 'Maintenance',
                  ),
                  NavigationDestination(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedFuel,
                      size: 30,
                      strokeWidth: 1,
                    ),
                    label: 'Refueling',
                  ),
                  NavigationDestination(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedInvoice,
                      size: 30,
                      strokeWidth: 1,
                    ),
                    label: 'Invoices',
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
