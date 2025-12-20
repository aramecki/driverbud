import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mycargenie_2/get_latest_events.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/settings/settings.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/puzzle.dart';
import 'package:mycargenie_2/utils/support_fun.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'utils/vehicles_dropdown.dart';
import 'vehicle/vehicles.dart';
import 'package:provider/provider.dart';
import 'utils/boxes.dart';

class VehicleProvider with ChangeNotifier {
  int? vehicleToLoad;
  int? year;
  int? favoriteKey;
  bool _isLoading = false;

  //bool get isLoading => _isLoading;

  void loadInitialData() {
    if (vehicleToLoad == null && vehicleBox.isNotEmpty) {
      _isLoading = true;
      notifyListeners();

      Future.microtask(() {
        vehicleToLoad = getFavoriteKey();
        // log('loading: $vehicleToLoad');
        favoriteKey = vehicleToLoad;
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
    final localizations = AppLocalizations.of(context)!;

    final vehicleProvider = context.watch<VehicleProvider>();

    log('Starting loading: ${vehicleBox.get(vehicleProvider.vehicleToLoad)} ');

    Map<dynamic, dynamic>? latestMaintenance = getLatestEvent(
      true,
      vehicleProvider.vehicleToLoad,
    );

    // Map<dynamic, dynamic>? latestRefueling = getLatestEvent(
    //   false,
    //   vehicleProvider.vehicleToLoad,
    // );

    log('Latest maintenance is $latestMaintenance');

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Vehicle image container
                      FutureBuilder<ImageProvider<Object>?>(
                        future: getVehicleImageAsync(
                          vehicleProvider.vehicleToLoad,
                        ),
                        builder: (context, snapshot) {
                          ImageProvider<Object>? imageProvider;

                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            imageProvider = snapshot.data;
                          }

                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              bottom: 16,
                              //left: 8,
                              right: 8,
                            ),
                            child: CircleAvatar(
                              radius: 80,
                              foregroundImage: imageProvider,
                              child: (imageProvider == null) ? carIcon : null,
                            ),
                          );
                        },
                      ),

                      //Expanded(child: SizedBox()),

                      // Car selection dropdown container
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            bottom: 20,
                            left: 8,
                            //right: 8,
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

                  if (latestMaintenance == null
                  // && latestRefueling == null
                  )
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        vertical: 32,
                        horizontal: 16,
                      ),
                      child: Text(
                        localizations.homeNoEventsMessage,
                        textAlign: TextAlign.center,
                      ),
                    ),

                  //   ],
                  // ),
                  if (latestMaintenance != null
                  // || latestRefueling != null
                  )
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.only(left: 16),
                          child: Text(localizations.latestEvents),
                        ),
                      ],
                    ),

                  if (latestMaintenance != null)
                    homeRowBox(
                      context,
                      eventKey: latestMaintenance['key'],
                      isRefueling: false,
                      title: latestMaintenance['value']['title'],
                      date: latestMaintenance['value']['date'],
                      place: latestMaintenance['value']['place'],
                    ),
                  // if (latestRefueling != null)
                  //   homeRowBox(
                  //     context,
                  //     eventKey: latestRefueling['key'],
                  //     isRefueling: false,
                  //     date: latestRefueling['value']['date'],
                  //     place: latestRefueling['value']['place'],
                  //     price: latestRefueling['value']['price'],
                  //     priceForUnit: latestRefueling['value']['priceForUnit'],
                  //   ),
                  // homeRowBox(
                  //   context,
                  //   isRefueling: true,
                  //   date: '11/22/1963',
                  //   place: 'Eni Giugliano',
                  //   price: '20€',
                  //   priceForUnit: '1,78€/l',
                  // ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(localizations.noVehicles)],
              );

        return Scaffold(
          appBar: AppBar(
            title: Text(localizations.home),
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

Future<ImageProvider?> getVehicleImageAsync(int? vehicleKey) async {
  if (vehicleKey == null) return null;

  final dynamic raw = vehicleBox.get(vehicleKey);
  if (raw == null) return null;

  final map = Map<String, dynamic>.from(raw);
  String? fileName = map['assetImage'] as String?;

  if (fileName == null || fileName.isEmpty) return null;

  final Directory docsDir = await getApplicationDocumentsDirectory();

  final String fullPath = p.join(docsDir.path, 'images', fileName);
  final File file = File(fullPath);

  if (await file.exists()) {
    return FileImage(file);
  }

  return null;
}
