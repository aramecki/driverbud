import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mycargenie_2/utils/lists.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mycargenie_2/utils/boxes.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/support_fun.dart';
import 'package:provider/provider.dart';
import '../utils/puzzle.dart';

class ShowVehicle extends StatefulWidget {
  final dynamic editKey;

  const ShowVehicle({super.key, this.editKey});

  @override
  State<ShowVehicle> createState() => _ShowVehicleState();
}

class _ShowVehicleState extends State<ShowVehicle> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final vehicleProvider = Provider.of<VehicleProvider>(context);

    final content = ValueListenableBuilder(
      valueListenable: vehicleBox.listenable(keys: [widget.editKey]),
      builder: (context, box, _) {
        final v = box.get(widget.editKey);

        if (v == null) return SizedBox();

        String? brandModel = v['brand'] != null && v['model'] != null
            ? '${v['brand']} ${v['model']}'
            : null;
        String? config = v['config'];
        String? plate = v['plate'];
        String? year = v['year']?.toString();
        String? capacity = v['capacity'] != null
            ? localizations.numCc(v['capacity'])
            : null;
        String? power = v['power'] != null
            ? localizations.numKw(v['power'])
            : null;
        String? horse = v['horse'] != null
            ? localizations.numCv(v['horse'])
            : null;
        String? type = getVehicleTypeList(context)[v['type']];
        String? energy = getVehicleEnergyList(context)[v['energy']];
        String? ecology = getVehicleEcologyList(context)[v['ecology']];

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child:
                  // Vehicle image container
                  FutureBuilder<ImageProvider<Object>?>(
                    future: getVehicleImageAsync(widget.editKey),
                    builder: (context, snapshot) {
                      ImageProvider<Object>? imageProvider;

                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        imageProvider = snapshot.data;
                      }

                      return CircleAvatar(
                        radius: 100,
                        foregroundImage: imageProvider,
                        child: (imageProvider == null) ? carIcon : null,
                      );
                    },
                  ),
            ),

            if (brandModel != null)
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      brandModel,
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            // Config
            if (config != null && config != '')
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [Text(config, style: TextStyle(fontSize: 19))],
                ),
              ),

            // Plate row
            if (plate != null && plate != '')
              ...tileRow(localizations.plateUpper, plate),

            // Year row
            if (year != null) ...tileRow(localizations.yearUpper, year),

            // Capacity row
            if (capacity != null)
              ...tileRow(localizations.capacityUpper, capacity),

            // Power row
            if (power != null) ...tileRow(localizations.powerUpper, power),

            // Horse row
            if (horse != null) ...tileRow(localizations.horsePowerUpper, horse),

            // Type row
            if (type != null) ...tileRow(localizations.typeUpper, type),

            // Energy row
            if (energy != null) ...tileRow(localizations.energyUpper, energy),

            // Ecology row
            if (ecology != null)
              ...tileRow(localizations.ecologyUpper, ecology),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: buildAddButton(
                      context,
                      onPressed: () =>
                          openVehicleEditScreen(context, widget.editKey),
                      text: localizations.editUpper,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: customBackButton(context),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              deleteVehicle(vehicleProvider, context, widget.editKey);
              Navigator.of(context).pop();
            },
            icon: deleteIcon(iconSize: 30),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: shareIcon,
        onPressed: () => _shareVehicle(context, localizations, widget.editKey),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(child: content),
      ),
    );
  }
}

void _shareVehicle(
  BuildContext context,
  AppLocalizations localizations,
  vehicleKey,
) async {
  final v = vehicleBox.get(vehicleKey);

  final Directory docsDir = await getApplicationDocumentsDirectory();

  final String fullPath = p.join(docsDir.path, 'images', v['assetImage']);

  final List<XFile> files = [XFile(fullPath)];

  String text = localizations.checkoutMy;

  if (v['favorite']) {
    text += localizations.beloved;
  }

  text += '${v['brand']} ${v['model']} ';

  if (v['config'] != null) {
    text += '${v['config']} ';
  }

  if (v['year'] != null) {
    text += '${v['year'].toString()} ';
  }

  if (v['capacity'] != null || v['power'] != null || v['horse'] != null) {
    text += localizations.withSpace;
    if (v['capacity'] != null) {
      text += '${localizations.numCc(v['capacity'])} ';
    }
    if (v['power'] != null) {
      text += '${localizations.numKw(v['power'])} ';
    }
    if (v['horse'] != null) {
      text += '${localizations.numCv(v['horse'])} ';
    }
  }

  if (v['energy'] != null && v['energy'] != localizations.other) {
    text += localizations.poweredby(v['energy']);
  }

  if (v['ecology'] != null && v['ecology'] != localizations.other) {
    text += localizations.withStandard(v['ecology']);
  }

  await SharePlus.instance.share(ShareParams(text: text, files: files));
}
