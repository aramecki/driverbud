import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/theme/misc.dart';
import 'package:mycargenie_2/utils/support_fun.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'add_vehicle.dart';
import '../boxes.dart';
import '../utils/puzzle.dart';
import '../home.dart';

class Garage extends StatefulWidget {
  const Garage({super.key});

  @override
  State<Garage> createState() => _GarageState();
}

class _GarageState extends State<Garage> {
  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);

    return ValueListenableBuilder(
      valueListenable: vehicleBox.listenable(),
      builder: (context, Box box, _) {
        final isEmpty = box.isEmpty;

        final content = isEmpty
            ? Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 35),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 18),
                    child: Text(
                      'In questa pagina troverai tutti i veicoli aggiunti.',
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
                          MaterialPageRoute(builder: (_) => const AddVehicle()),
                        );
                      },
                      text: 'Aggiungi il tuo primo veicolo',
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Expanded(
                    child: SlidableAutoCloseBehavior(
                      child: ListView.builder(
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          final item = box.getAt(index) as Map;
                          final key = box.keyAt(index);

                          return SizedBox(
                            child: Slidable(
                              key: ValueKey(key),
                              endActionPane: ActionPane(
                                extentRatio: 0.25,
                                motion: const ScrollMotion(),
                                children: [
                                  slideableIcon(
                                    context,
                                    onPressed: (_) => deleteVehicle(
                                      vehicleProvider,
                                      context,
                                      key,
                                    ),
                                    icon: deleteIcon(),
                                  ),
                                  slideableIcon(
                                    context,
                                    onPressed: (_) =>
                                        openVehicleEditScreen(context, key),
                                    icon: editIcon,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              child: SizedBox(
                                child: ListTile(
                                  enabled: true,
                                  //selected: _selected,
                                  onTap: () => openShowVehicle(context, key),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  title: Text(
                                    '${item['brand']} ${item['model']}',
                                    style: titleTextStyle,
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        item['power'] != null
                                            ? '${item['power']}kW '
                                            : '',
                                        style: subtitleTextStyle,
                                      ),
                                      Text(
                                        item['horse'] != null
                                            ? '${item['horse']}CV '
                                            : '',
                                        style: subtitleTextStyle,
                                      ),
                                      Text(
                                        item['capacity'] != null
                                            ? '${item['capacity']}CC '
                                            : '',
                                        style: subtitleTextStyle,
                                      ),
                                    ],
                                  ),
                                  selectedColor: Colors.blue,
                                  trailing: favouriteIconButton(
                                    isEnabled(
                                      key,
                                      vehicleProvider.favouriteKey,
                                    ),
                                    () {
                                      setState(() {
                                        changeFavourite(key);
                                        vehicleProvider.favouriteKey = key;
                                      });
                                    },
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
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 28.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: buildAddButton(
                            context,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const AddVehicle(),
                                ),
                              );
                            },
                            text: 'Add vehicle',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );

        return Scaffold(
          appBar: AppBar(
            title: const Text('My garage'),
            forceMaterialTransparency: true,
            leading: customBackButton(context),
            actions: <Widget>[
              IconButton(
                icon: helpIcon,
                onPressed: () {
                  // Navigator.of(
                  //   context,
                  // ).push(MaterialPageRoute(builder: (_) => const Garage()));
                  showCustomToast(context, message: 'Info opened');
                },
              ),
            ],
          ),
          body: content,
        );
      },
    );
  }

  Widget? favouriteIconButton(bool? isEnabled, VoidCallback onChanged) {
    return IconButton(
      icon: isEnabled == true ? activeStarIcon : emptyStarIcon,
      onPressed: isEnabled == true ? null : onChanged,
      tooltip: isEnabled == true ? null : 'Mark as favourite',
    );
  }

  bool isEnabled(int itemId, int? favouriteItemId) {
    if (itemId == favouriteItemId) {
      return true;
    }
    return false;
  }
}
