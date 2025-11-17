import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mycargenie_2/boxes.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/maintenance/add_maintenance.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/sorting_funs.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../utils/puzzle.dart';

class Maintenance extends StatefulWidget {
  const Maintenance({super.key});

  @override
  State<Maintenance> createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  String currentSort = 'date';
  bool isDecrementing = true;
  bool isSorting = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: maintenanceBox.listenable(),
      builder: (context, Box box, _) {
        final vehicleKey = Provider.of<VehicleProvider>(
          context,
          listen: false,
        ).vehicleToLoad;

        List<dynamic> items = sortByDate(
          maintenanceBox.keys
              .map((key) {
                final value = box.get(key);
                return {'key': key, 'value': value};
              })
              .where((m) => m['value']['vehicleKey'] == vehicleKey)
              .toList(),
          true,
        );

        final isEmpty = items.isEmpty;

        switch (currentSort) {
          case 'name':
            items = sortByName(items, isDecrementing);
            break;
          case 'price':
            items = sortByPrice(items, isDecrementing);
            break;
          default:
            items = sortByDate(items, isDecrementing);
        }

        final content = isEmpty
            ? Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 35),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 18),
                    child: Text(
                      'In questa pagina troverai tutti gli eventi di manutenzione aggiunti.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 30.0,
                    ),
                    child: buildAddButton(
                      context,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AddMaintenance(),
                          ),
                        );
                      },
                      text: 'Aggiungi prima manutenzione',
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  // if (isSorting == true)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return SizeTransition(
                            sizeFactor: animation,
                            axisAlignment: -1.0,
                            child: child,
                          );
                        },
                    child: isSorting
                        ? customSortingPanel(context, (selectedSort) {
                            setState(() {
                              currentSort = selectedSort;
                              isDecrementing = !isDecrementing;
                            });
                          }, isDecrementing)
                        : const SizedBox.shrink(key: ValueKey('hidden')),
                  ),

                  Expanded(
                    child: SlidableAutoCloseBehavior(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final entry = items[index];
                          final key = entry['key'];
                          final item = entry['value'];

                          return SizedBox(
                            child: Slidable(
                              key: ValueKey(key),
                              endActionPane: ActionPane(
                                extentRatio: 0.25,
                                motion: const ScrollMotion(),
                                children: [
                                  slideableIcon(
                                    context,
                                    onPressed: (_) => _deleteMaintenance(key),
                                    icon: deleteIcon,
                                  ),
                                  slideableIcon(
                                    context,
                                    onPressed: (_) =>
                                        _openEditScreen(context, key),
                                    icon: editIcon,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              child: SizedBox(
                                child: ListTile(
                                  // enabled: true,
                                  // onTap: () => _openShowVehicle(context, key),
                                  // contentPadding: const EdgeInsets.symmetric(
                                  //   horizontal: 16.0,
                                  // ),
                                  title: Text('${item['title']}'),
                                  subtitle: Text(
                                    'Data: ${item['date'].day}/${item['date'].month}/${item['date'].year} Key: ${item['vehicleKey']}',
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 30.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: buildAddButton(
                            context,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const AddMaintenance(),
                                ),
                              );
                            },
                            text: 'Aggiungi manutenzione',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Maintenance'),
            actions: <Widget>[
              IconButton(
                padding: EdgeInsets.all(0),
                icon: helpIcon,
                onPressed: () {
                  showCustomToast(context, message: 'Info opened');
                },
              ),
              ?isEmpty
                  ? null
                  : IconButton(
                      icon: filterIcon,
                      onPressed: () {
                        setState(() {
                          isSorting = !isSorting;
                        });
                      },
                    ),
            ],
          ),
          body: content,
        );
      },
    );
  }

  void _deleteMaintenance(dynamic key) {
    maintenanceBox.delete(key);
  }

  void _openEditScreen(BuildContext context, dynamic key) {
    final Map<String, dynamic> maintenanceMap = maintenanceBox
        .get(key)!
        .cast<String, dynamic>();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            AddMaintenance(maintenanceEvent: maintenanceMap, editKey: key),
      ),
    );
  }
}
