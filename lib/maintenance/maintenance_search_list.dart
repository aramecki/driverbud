import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mycargenie_2/utils/boxes.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/maintenance/maintenance_misc.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/puzzle.dart';
import 'package:mycargenie_2/utils/sorting_funs.dart';
import 'package:provider/provider.dart';

class MaintenanceSearchList extends StatefulWidget {
  const MaintenanceSearchList({super.key});

  @override
  State<MaintenanceSearchList> createState() => _MaintenanceSearchListState();
}

class _MaintenanceSearchListState extends State<MaintenanceSearchList> {
  String currentSort = 'date';
  bool isDecrementing = true;
  bool isSorting = false;
  String searchText = '';

  ValueNotifier<List<Map<String, dynamic>>> searchResult = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    final vehicleKey = Provider.of<VehicleProvider>(
      context,
      listen: false,
    ).vehicleToLoad;

    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: searchResult,
      builder: (context, list, _) {
        // log('list = $list');

        List<dynamic> items = sortByDate(
          list.where((m) => m['value']['vehicleKey'] == vehicleKey).toList(),
          true,
        );

        log('items = $items');

        // final isEmpty = items.isEmpty;

        // log('searchResult= $searchResult');

        switch (currentSort) {
          case 'name':
            items = sortByName(items, isDecrementing);
            // log('items sorted by name: $items');
            break;
          case 'price':
            items = sortByPrice(items, isDecrementing);
            // log('items sorted by price: $items');
            break;
          default:
            items = sortByDate(items, isDecrementing);
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: customSearchingPanel(context, (value, result) {
                      searchText = value;
                      searchResult.value = result;
                    }),
                  ),

                  IconButton(
                    icon: filterIcon,
                    color: Colors.deepOrange,
                    onPressed: () {
                      setState(() {
                        isSorting = !isSorting;
                      });
                    },
                  ),
                ],
              ),
            ),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1.0,
                  child: child,
                );
              },
              child: isSorting
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: customSortingPanel(context, (selectedSort) {
                        setState(() {
                          currentSort = selectedSort;
                          isDecrementing = !isDecrementing;
                        });
                      }, isDecrementing),
                    )
                  : const SizedBox.shrink(key: ValueKey('hidden')),
            ),

            Flexible(
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
                              onPressed: (_) async {
                                await deleteEvent(key);
                                searchResult.value = searchByText(
                                  maintenanceBox,
                                  searchText,
                                );
                              },
                              icon: deleteIcon(),
                            ),
                            slideableIcon(
                              context,
                              onPressed: (_) async {
                                await openEventEditScreen(context, key);
                                searchResult.value = searchByText(
                                  maintenanceBox,
                                  searchText,
                                );
                                // log('ho aggiornato');
                              },
                              icon: editIcon,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        child: maintenanceEventListTile(
                          context,
                          item,
                          key,
                          () => searchResult.value = searchByText(
                            maintenanceBox,
                            searchText,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
