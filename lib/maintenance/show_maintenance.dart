import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mycargenie_2/boxes.dart';
import 'package:mycargenie_2/maintenance/maintenance_misc.dart';
import 'package:mycargenie_2/theme/icons.dart';
import '../utils/puzzle.dart';

class ShowMaintenance extends StatefulWidget {
  final dynamic editKey;

  const ShowMaintenance({super.key, this.editKey});

  @override
  State<ShowMaintenance> createState() => _ShowMaintenanceState();
}

class _ShowMaintenanceState extends State<ShowMaintenance> {
  // TODO: Stylize
  @override
  Widget build(BuildContext context) {
    final content = ValueListenableBuilder(
      valueListenable: maintenanceBox.listenable(keys: [widget.editKey]),
      builder: (context, box, _) {
        final e = box.get(widget.editKey);

        if (e == null) return SizedBox();

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Text(
                '${e['title']}',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: 26,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (e['maintenanceType'] != null)
                    Text(e['maintenanceType'], style: TextStyle(fontSize: 18)),
                  if (e['place'] != null)
                    Text(e['place'].toString(), style: TextStyle(fontSize: 18)),
                ],
              ),
            ),

            if (e['description'] != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${e['description']}',
                  style: TextStyle(fontSize: 17),
                ),
              ),

            SizedBox(height: 44),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (e['date'] != null)
                    Text(
                      '${e['date'].day}/${e['date'].month}/${e['date'].year}',
                      style: TextStyle(fontSize: 18),
                    ),
                  if (e['kilometers'] != null)
                    Text(
                      '${e['kilometers'].toString()}km',
                      style: TextStyle(fontSize: 18),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // TODO: Set currency symbol to set one
                  if (e['price'] != '0.00')
                    Text(
                      '${e['price']}€',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                          openEventEditScreen(context, widget.editKey),
                      text: 'Modifica',
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
              deleteEvent(widget.editKey);
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
