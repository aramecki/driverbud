import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mycargenie_2/utils/boxes.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/refueling/refueling_misc.dart';
import 'package:mycargenie_2/refueling/refueling_search_list.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/sorting_funs.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../utils/puzzle.dart';

class Refueling extends StatefulWidget {
  const Refueling({super.key});

  @override
  State<Refueling> createState() => _RefuelingState();
}

class _RefuelingState extends State<Refueling> {
  String currentSort = 'date';
  bool isDecrementing = true;
  bool isSorting = false;
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    log(refuelingBox.toMap().toString());

    return ValueListenableBuilder(
      valueListenable: refuelingBox.listenable(),
      builder: (context, Box box, _) {
        final vehicleKey = Provider.of<VehicleProvider>(
          context,
          listen: false,
        ).vehicleToLoad;

        log('vehicleKey is: $vehicleKey');

        List<dynamic> items = sortByDate(
          refuelingBox.keys
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
          case 'fuelAmount':
            items = sortByDouble(items, isDecrementing, isPrice: false);
            break;
          case 'price':
            items = sortByDouble(items, isDecrementing);
            break;
          default:
            items = sortByDate(items, isDecrementing);
        }

        final content = isEmpty
            ? Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: vehicleKey != null
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                    child: Text(
                      localizations.youWillFindEvents(
                        localizations.refuelingLower,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (vehicleKey == null)
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 18),
                      child: Text(
                        localizations.createYourFirstVehicle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (vehicleKey != null) addEventButton(context, false),
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
                          ? RefuelingSearchList(key: const ValueKey('search'))
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
                                            onPressed: (_) =>
                                                deletionConfirmAlert(
                                                  context,
                                                  () => deleteEvent(key),
                                                ),
                                            icon: deleteIcon(),
                                          ),
                                          slideableIcon(
                                            context,
                                            onPressed: (_) =>
                                                openRefuelingEditScreen(
                                                  context,
                                                  key,
                                                ),
                                            icon: editIcon,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      child: refuelingEventListTile(
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

                  if (!isSearching) addEventButton(context, false),
                ],
              );

        return Scaffold(
          appBar: AppBar(
            title: Text(localizations.refuelingUpper),
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
        );
      },
    );
  }
}
