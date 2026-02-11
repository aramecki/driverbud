import 'dart:developer';
import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mycargenie_2/get_next_events.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/settings/settings.dart';
import 'package:mycargenie_2/theme/colors.dart';
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

    return ValueListenableBuilder(
      valueListenable: vehicleBox.listenable(),
      builder: (context, Box box, _) {
        return ValueListenableBuilder(
          valueListenable: maintenanceBox.listenable(),
          builder: (context, _, _) {
            return ValueListenableBuilder(
              valueListenable: refuelingBox.listenable(),
              builder: (context, _, _) {
                // Latest and next events logics
                final List<Widget> latestAndNextEventsList = [];

                Map<dynamic, dynamic>? nextMaintenance = getNextOrLatestEvent(
                  true,
                  false,
                  vehicleProvider.vehicleToLoad,
                );

                Map<dynamic, dynamic>? latestMaintenance = getNextOrLatestEvent(
                  true,
                  true,
                  vehicleProvider.vehicleToLoad,
                );

                Map<dynamic, dynamic>? nextRefueling = getNextOrLatestEvent(
                  false,
                  false,
                  vehicleProvider.vehicleToLoad,
                );

                Map<dynamic, dynamic>? latestRefueling = getNextOrLatestEvent(
                  false,
                  true,
                  vehicleProvider.vehicleToLoad,
                );

                if (nextRefueling != null || nextMaintenance != null) {
                  Widget nextRefuelingAndLatestMaintenanceBox = Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsGeometry.only(left: 16),
                            child: Text(localizations.nextEvents),
                          ),
                        ],
                      ),

                      nextMaintenance != null
                          ? homeRowBox(
                              context,
                              event: nextMaintenance,
                              isRefueling: false,
                            )
                          : SizedBox(),

                      nextRefueling != null
                          ? homeRowBox(
                              context,
                              event: nextRefueling,
                              isRefueling: true,
                            )
                          : SizedBox(),
                    ],
                  );

                  latestAndNextEventsList.add(
                    nextRefuelingAndLatestMaintenanceBox,
                  );
                }

                if (latestRefueling != null || latestMaintenance != null) {
                  Widget latestRefuelingAndLatestMaintenanceBox = Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsGeometry.only(left: 16),
                            child: Text(localizations.latestEvents),
                          ),
                        ],
                      ),

                      latestMaintenance != null
                          ? homeRowBox(
                              context,
                              event: latestMaintenance,
                              isRefueling: false,
                            )
                          : SizedBox(),

                      latestRefueling != null
                          ? homeRowBox(
                              context,
                              event: latestRefueling,
                              isRefueling: true,
                            )
                          : SizedBox(),
                    ],
                  );

                  latestAndNextEventsList.add(
                    latestRefuelingAndLatestMaintenanceBox,
                  );
                }

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
                                      right: 8,
                                      left: 8,
                                    ),
                                    child: CircleAvatar(
                                      radius: 60,
                                      foregroundImage: imageProvider,
                                      child: (imageProvider == null)
                                          ? carIcon
                                          : null,
                                    ),
                                  );
                                },
                              ),

                              // Car selection dropdown container
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 20,
                                    left: 8,
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

                          if (latestAndNextEventsList.isEmpty)
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

                          if (latestAndNextEventsList.isNotEmpty)
                            Flexible(
                              child: SizedBox(
                                height:
                                    230, // TODO: Check after home completition - Fixed height seems the best option for every screen dimension for now
                                child: latestAndNextEventsSwiper(
                                  latestAndNextEventsList,
                                  context,
                                ),
                              ),
                            ),

                          // TODO: Add invoices expiration notifications
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
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const Settings()),
                      ),
                      icon: settingsIcon,
                    ),
                    actions: <Widget>[
                      IconButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const Garage()),
                        ),
                        icon: garageIcon,
                      ),
                      // ),
                    ],
                  ),
                  body: vehicleProvider._isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(child: content),
                );
              },
            );
          },
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

Widget latestAndNextEventsSwiper(
  List<Widget> eventsWidgetList,
  BuildContext context,
) {
  return Swiper(
    itemBuilder: (BuildContext context, int index) {
      return eventsWidgetList[index];
    },
    loop: eventsWidgetList.length > 1 ? true : false,
    autoplayDelay: 5000,
    itemCount: eventsWidgetList.length,
    //viewportFraction: 1,
    scale: 1,
    autoplay: eventsWidgetList.length > 1 ? true : false,
    pagination: SwiperPagination(
      alignment: Alignment.bottomCenter,
      builder: DotSwiperPaginationBuilder(
        activeColor: eventsWidgetList.length > 1
            ? Theme.of(context).colorScheme.onSurface
            : Colors.transparent,
        activeSize: 12,
        color: darkGrey,
        size: 8,
      ),
    ),
  );
}
