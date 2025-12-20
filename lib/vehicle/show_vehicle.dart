import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
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
  // TODO: Stylize because it's very very very ugly
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final vehicleProvider = Provider.of<VehicleProvider>(context);

    final content = ValueListenableBuilder(
      valueListenable: vehicleBox.listenable(keys: [widget.editKey]),
      builder: (context, box, _) {
        final v = box.get(widget.editKey);

        if (v == null) return SizedBox();

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 4),
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
                        radius: 120,
                        foregroundImage: imageProvider,
                        child: (imageProvider == null) ? carIcon : null,
                      );
                    },
                  ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    '${v['brand']} ${v['model']}',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (v['config'] != null)
                    Text(v['config'], style: TextStyle(fontSize: 19)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (v['year'] != null)
                    Text(v['year'].toString(), style: TextStyle(fontSize: 17)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (v['capacity'] != null)
                    Text(localizations.numCc(v['capacity'])),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (v['power'] != null) Text(localizations.numKw(v['power'])),
                  const SizedBox(width: 8),
                  if (v['horse'] != null) Text(localizations.numCv(v['horse'])),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [if (v['category'] != null) Text(v['category'])],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (v['energy'] != null) Text(v['energy']),
                  const SizedBox(width: 8),
                  if (v['ecology'] != null) Text(v['ecology']),
                ],
              ),
            ),
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
        // title: Text('$_brand $_model'),
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
        // showCustomToast(
        //   context,
        //   message: 'Share opened',
        // ), // TODO: Remove, for debugging
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

  final List<XFile> files = [XFile(v['assetImage'])];

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
