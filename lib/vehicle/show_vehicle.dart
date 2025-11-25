import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mycargenie_2/boxes.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/support_fun.dart';
import 'package:provider/provider.dart';
import 'dart:io';
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
              child: CircleAvatar(
                radius: 120,
                backgroundColor: Colors.deepOrange,
                backgroundImage: v['assetImage'] != null
                    ? FileImage(File(v['assetImage']))
                    : null,
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
                  if (v['capacity'] != null) Text('${v['capacity']}CC'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (v['power'] != null) Text('${v['power']}kW'),
                  const SizedBox(width: 8),
                  if (v['horse'] != null) Text('${v['horse']}CV'),
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
                      text: 'Edit',
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
        onPressed: () => showCustomToast(context, message: 'Share opened'),
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
