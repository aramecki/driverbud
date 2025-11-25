import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mycargenie_2/boxes.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/maintenance/add_maintenance.dart';
import 'package:mycargenie_2/maintenance/maintenance_misc.dart';
import 'package:mycargenie_2/maintenance/maintenance_search_list.dart';
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
  bool isSearching = false;

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
                  if (!isSearching)
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
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                // vertical: 30.0,
                              ),
                              child: customSortingPanel(context, (
                                selectedSort,
                              ) {
                                setState(() {
                                  currentSort = selectedSort;
                                  isDecrementing = !isDecrementing;
                                });
                              }, isDecrementing),
                            )
                          : const SizedBox.shrink(key: ValueKey('hidden')),
                    ),

                  Flexible(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 1000),
                      child: isSearching
                          ? MaintenanceSearchList(key: const ValueKey('search'))
                          : SlidableAutoCloseBehavior(
                              key: const ValueKey('notsearch'),
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
                                            onPressed: (_) => deleteEvent(key),
                                            icon: deleteIcon(),
                                          ),
                                          slideableIcon(
                                            context,
                                            onPressed: (_) =>
                                                openEventEditScreen(
                                                  context,
                                                  key,
                                                ),
                                            icon: editIcon,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      child: maintenanceEventListTile(
                                        context,
                                        item,
                                        key,
                                        null,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ),

                  if (!isSearching)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: 8.0,
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
            actions: isEmpty
                ? null
                : <Widget>[
                    IconButton(
                      padding: EdgeInsets.all(0),
                      icon: searchIcon,
                      onPressed: () {
                        setState(() {
                          if (isSorting == true) isSorting = false;
                          isSearching = !isSearching;
                        });
                      },
                    ),
                    if (!isSearching)
                      IconButton(
                        icon: filterIcon,
                        onPressed: () {
                          setState(() {
                            isSorting = !isSorting;
                          });
                        },
                      ),
                  ],
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: content,
          ),
          // body: content,
        );
      },
    );
  }
}

// TODO: Move delete and openedit to external file
