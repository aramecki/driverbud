import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mycargenie_2/settings.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/puzzle.dart';
import 'package:mycargenie_2/utils/support_fun.dart';
import 'utils/vehicles_dropdown.dart';
import 'vehicle/vehicles.dart';
import 'package:provider/provider.dart';
import 'boxes.dart';

class VehicleProvider with ChangeNotifier {
  int? vehicleToLoad;
  int? year;
  int? favouriteKey;
  bool _isLoading = false;

  //bool get isLoading => _isLoading;

  void loadInitialData() {
    if (vehicleToLoad == null && vehicleBox.isNotEmpty) {
      _isLoading = true;
      notifyListeners();

      Future.microtask(() {
        vehicleToLoad = getFavouriteKey();
        log('loading: $vehicleToLoad');
        favouriteKey = vehicleToLoad;
        year = getYear(vehicleToLoad!);
        _isLoading = false;
        notifyListeners();
      });
    }
  }

  void updateVehicle(int? newId) {
    vehicleToLoad = newId;
    year = getYear(vehicleToLoad!);
    notifyListeners();
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  @override
  void initState() {
    super.initState();

    if (vehicleBox.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<VehicleProvider>(context, listen: false).loadInitialData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = context.watch<VehicleProvider>();

    return ValueListenableBuilder(
      valueListenable: vehicleBox.listenable(),
      builder: (context, Box box, _) {
        final content = vehicleBox.isNotEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Vehicle image container
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          bottom: 16,
                          left: 8,
                          right: 4,
                        ),
                        child: CircleAvatar(
                          radius: 80,
                          foregroundImage: getVehicleImage(
                            vehicleProvider.vehicleToLoad,
                          ),
                          backgroundImage: NetworkImage(
                            'https://s3.us-west-2.amazonaws.com/portoftacoma.com.if-us-west-2-or/s3fs-public/styles/image_text_paragraph/public/2023-11/otters12.jpg',
                          ),
                        ),
                      ),

                      // Car selection dropdown container
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            bottom: 20,
                            left: 4,
                            right: 8,
                          ),
                          child: VehiclesDropdown(
                            defaultId: vehicleProvider.vehicleToLoad,
                            onChanged: (value) {
                              setState(() {
                                vehicleProvider.updateVehicle(value);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.only(left: 16),
                        child: Text('Ultimi eventi:'),
                      ),
                    ],
                  ),

                  homeRowBox(
                    context,
                    isRefueling: false,
                    title: 'Sostituzione pasticche freni',
                    date: '23/01/2025',
                    place: 'Officine Galli',
                  ),
                  homeRowBox(
                    context,
                    isRefueling: true,
                    date: '11/22/1963',
                    place: 'Eni Giugliano',
                    price: '20€',
                    priceForUnit: '1,78€/l',
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('No vehicles')],
              );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            leading: IconButton(
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const Settings())),
              icon: settingsIcon,
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const Garage())),
                icon: garageIcon,
              ),
              // ),
            ],
          ),
          body: vehicleProvider._isLoading
              ? const Center(child: CircularProgressIndicator())
              : content,
        );
      },
    );
  }
}

int? getYear(int vehicleId) {
  final dynamic raw = vehicleBox.get(vehicleId);
  if (raw == null) return null;
  final map = Map<String, dynamic>.from(raw);
  return map['year'] as int?;
}

ImageProvider<Object>? getVehicleImage(int? vehicleKey) {
  log('vehicleKey: $vehicleKey in getVehicleImage()');
  if (vehicleKey == null) return null;

  final dynamic raw = vehicleBox.get(vehicleKey);

  log('Get vehicle raw: $raw in getVehicleImage()');

  if (raw == null) return null;

  final map = Map<String, dynamic>.from(raw);
  String? storedImagePath = map['assetImage'] as String?;

  log('storedImagePath: $storedImagePath');

  if (storedImagePath == null) return null;

  final File possibleFile = File(storedImagePath);
  if (possibleFile.existsSync()) {
    log('possibleFile: $possibleFile  in getVehicleImage()');
    return FileImage(possibleFile);
  }

  log('returning null code ended  in getVehicleImage()');
  return null;
}
