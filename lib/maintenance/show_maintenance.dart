import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mycargenie_2/settings/currency_settings.dart';
import 'package:mycargenie_2/settings/settings_logics.dart';
import 'package:mycargenie_2/utils/boxes.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/maintenance/maintenance_misc.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/lists.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/puzzle.dart';

Map<String, dynamic> maintenanceInfo = {
  'vehicleKey': null,
  'title': null,
  'date': null,
  'place': null,
  'price': null,
  'kilometers': null,
  'description': null,
};

class ShowMaintenance extends StatefulWidget {
  final dynamic editKey;

  const ShowMaintenance({super.key, this.editKey});

  @override
  State<ShowMaintenance> createState() => _ShowMaintenanceState();
}

class _ShowMaintenanceState extends State<ShowMaintenance> {
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

        String? maintenanceType = getMaintenanceTypeList(
          context,
        )[e['maintenanceType']];
        String? place = e['place'];
        String? description = e['description'];
        String? date = localizations.ggMmAaaa(
          e['date'].day,
          e['date'].month,
          e['date'].year,
        );
        String? kilometers = e['kilometers'] != null
            ? localizations.numKm(e['kilometers'])
            : null;
        String? amount = parsedPrice != '0,00'
            ? localizations.numCurrency(parsedPrice, settingsProvider.currency!)
            : null;

        maintenanceInfo['vehicleKey'] = e['vehicleKey'];
        maintenanceInfo['title'] = e['title'];
        maintenanceInfo['date'] = date;
        maintenanceInfo['place'] = place;
        maintenanceInfo['price'] = amount;
        maintenanceInfo['kilometers'] = kilometers;
        maintenanceInfo['description'] = description;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                '${e['title']}',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Description row
            if (description != null && description != '')
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${localizations.descriptionUpper}:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            description,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Divider(height: 22),

            // Type row
            if (maintenanceType != null && maintenanceType != '')
              ...tileRow(localizations.typeUpper, maintenanceType),

            // Plate row
            if (place != null && place != '')
              ...tileRow(localizations.placeUpper, place),

            // Date row
            if (date != '') ...tileRow(localizations.date, date),

            // Kilometers row
            if (kilometers != null && kilometers != '')
              ...tileRow(localizations.kilometersUpper, kilometers),

            // Amount row
            if (amount != null) ...tileRow(localizations.totalAmount, amount),

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
              deleteEvent(
                maintenanceBox.get(widget.editKey)['vehicleKey'],
                widget.editKey,
              );
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
          maintenanceInfo,
          widget.editKey,
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
  Map<String, dynamic> maintenanceInfo,
  maintenanceKey,
) async {
  final vehicle = await vehicleBox.get(maintenanceInfo['vehicleKey']);
  final vehicleBrand = vehicle['brand'];
  final vehicleModel = vehicle['model'];

  String text =
      '${localizations.onDate}${maintenanceInfo['date']} ${localizations.iPerformed}"${maintenanceInfo['title']}" ${localizations.onMy}$vehicleBrand $vehicleModel ';

  if (maintenanceInfo['kilometers'] != null) {
    text += '${localizations.withKm}${maintenanceInfo['kilometers']} ';
  }

  if (maintenanceInfo['place'] != null && maintenanceInfo['place'] != '') {
    text += '${localizations.at}${maintenanceInfo['place']} ';
  }

  if (maintenanceInfo['price'] != null) {
    text += '${localizations.paying}${maintenanceInfo['price']} ';
  }

  if (maintenanceInfo['description'] != '') {
    text += '"${maintenanceInfo['description']}"';
  }

  await SharePlus.instance.share(ShareParams(text: text));
}
