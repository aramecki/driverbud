import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mycargenie_2/settings/currency_settings.dart';
import 'package:mycargenie_2/settings/settings_logics.dart';
import 'package:mycargenie_2/utils/boxes.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/maintenance/maintenance_misc.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
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
    final localizations = AppLocalizations.of(context)!;
    final settingsProvider = context.read<SettingsProvider>();

    final content = ValueListenableBuilder(
      valueListenable: maintenanceBox.listenable(keys: [widget.editKey]),
      builder: (context, box, _) {
        final e = box.get(widget.editKey);

        if (e == null) return SizedBox();

        String parsedPrice = parseShowedPrice(e['price']);

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
                  if (e['maintenanceType'] != '')
                    Text(e['maintenanceType'], style: TextStyle(fontSize: 18)),
                  if (e['place'] != null)
                    Text(e['place'].toString(), style: TextStyle(fontSize: 18)),
                ],
              ),
            ),

            if (e['description'] != '')
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${e['description']}',
                  style: TextStyle(fontSize: 17),
                ),
              ),

            if (e['description'] != '') SizedBox(height: 44),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (e['date'] != null)
                    Text(
                      localizations.ggMmAaaa(
                        e['date'].day,
                        e['date'].month,
                        e['date'].year,
                      ),
                      style: TextStyle(fontSize: 18),
                    ),
                  if (e['kilometers'] != null)
                    Text(
                      localizations.numKm(e['kilometers']),
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
                  if (e['price'] != '0.00')
                    Text(
                      localizations.numCurrency(
                        parsedPrice,
                        settingsProvider.currency!,
                      ),
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
        onPressed: () => _shareMaintenance(
          context,
          localizations,
          widget.editKey,
          settingsProvider.currency!,
        ),
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

void _shareMaintenance(
  BuildContext context,
  AppLocalizations localizations,
  maintenanceKey,
  String currency,
) async {
  final v = maintenanceBox.get(maintenanceKey);
  final vehicle = vehicleBox.get(v['vehicleKey']);
  final vehicleBrand = vehicle['brand'];
  final vehicleModel = vehicle['model'];

  String text =
      '${localizations.onDate}${localizations.ggMmAaaa(v['date'].day, v['date'].month, v['date'].year)} ${localizations.iPerformed}"${v['title']}" ${localizations.onMy}$vehicleBrand $vehicleModel ';

  if (v['kilometers'] != null) {
    text += '${localizations.withKm}${localizations.numKm(v['kilometers'])} ';
  }

  if (v['place'] != null) {
    text += '${localizations.at}${v['place']} ';
  }

  if (v['price'] != null) {
    text +=
        '${localizations.paying}${localizations.numCurrency(v['price'], currency)} ';
  }

  if (v['description'] != '') {
    text += '"${v['description']}"';
  }

  await SharePlus.instance.share(ShareParams(text: text));
}
