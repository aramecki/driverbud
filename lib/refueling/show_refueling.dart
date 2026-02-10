import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mycargenie_2/settings/currency_settings.dart';
import 'package:mycargenie_2/settings/settings_logics.dart';
import 'package:mycargenie_2/utils/boxes.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/refueling/refueling_misc.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/lists.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/puzzle.dart';

// Used for sharing
Map<String, dynamic> refuelingInfo = {
  'price': null,
  'pricePerUnit': null,
  'fuelAmount': null,
  'place': null,
  'vehicleKey': null,
  'date': null,
};

class ShowRefueling extends StatefulWidget {
  final dynamic editKey;

  const ShowRefueling({super.key, this.editKey});

  @override
  State<ShowRefueling> createState() => _ShowRefuelingState();
}

class _ShowRefuelingState extends State<ShowRefueling> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final settingsProvider = context.read<SettingsProvider>();

    final content = ValueListenableBuilder(
      valueListenable: refuelingBox.listenable(keys: [widget.editKey]),
      builder: (context, box, _) {
        final e = box.get(widget.editKey);

        if (e == null) return SizedBox();

        String parsedTotalPrice = parseShowedPrice(e['price']);
        String parsedPricePerUnit = parseShowedPrice(e['pricePerUnit']);
        String parsedFuelAmount = parseShowedPrice(e['fuelAmount']);

        String? refuelingType = getVehicleEnergyList(
          context,
        )[e['refuelingType']];

        String? fuelUnit = getFuelUnit(e['refuelingType']);

        String? place = e['place'];
        String? notes = e['notes'];
        String? date = localizations.ggMmAaaa(
          e['date'].day,
          e['date'].month,
          e['date'].year,
        );
        String? kilometers = e['kilometers'] != null
            ? localizations.numKm(e['kilometers'])
            : null;

        String? fuelAmount = parsedFuelAmount != '0,00'
            ? localizations.numUnit(parsedFuelAmount, fuelUnit)
            : null;

        String? pricePerUnit = parsedPricePerUnit != '0,00'
            ? localizations.numCurrencyOnUnits(
                parsedPricePerUnit,
                settingsProvider.currency!,
                fuelUnit,
              )
            : null;

        String? totalPrice = parsedTotalPrice != '0,00'
            ? localizations.numCurrency(
                parsedTotalPrice,
                settingsProvider.currency!,
              )
            : null;

        refuelingInfo['price'] = totalPrice;
        refuelingInfo['pricePerUnit'] = pricePerUnit;
        refuelingInfo['fuelAmount'] = fuelAmount;
        refuelingInfo['place'] = place;
        refuelingInfo['vehicleKey'] = e['vehicleKey'];
        refuelingInfo['date'] = date;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Notes row
            if (notes != null && notes != '')
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizations.notes,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            notes,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const Divider(height: 22),

            // Type row
            if (refuelingType != null && refuelingType != '')
              ...tileRow(localizations.typeUpper, refuelingType),

            // Place row
            if (place != null && place != '')
              ...tileRow(localizations.placeUpper, place),

            // Date row
            if (date != '') ...tileRow(localizations.date, date),

            // Kilometers row
            if (kilometers != null && kilometers != '')
              ...tileRow(localizations.kilometersUpper, kilometers),

            // Price per unit row
            if (pricePerUnit != null)
              ...tileRow(localizations.pricePerUnit, pricePerUnit),

            // Total units row
            if (fuelAmount != null && fuelAmount != '')
              ...tileRow(localizations.fuelAmount, fuelAmount),

            // Total price row
            if (totalPrice != null)
              ...tileRow(localizations.totalPrice, totalPrice),

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
                          openRefuelingEditScreen(context, widget.editKey),
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
        onPressed: () => _shareRefueling(
          context,
          localizations,
          refuelingInfo,
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

void _shareRefueling(
  BuildContext context,
  AppLocalizations localizations,
  Map<String, dynamic> refuelingInfo,
  refuelingKey,
) async {
  final vehicle = await vehicleBox.get(refuelingInfo['vehicleKey']);
  final vehicleBrand = vehicle['brand'];
  final vehicleModel = vehicle['model'];

  String text = '${localizations.iRefueled}${refuelingInfo['price']} ';

  if (refuelingInfo['pricePerUnit'] != null) {
    text += '${localizations.at}${refuelingInfo['pricePerUnit']} ';
  }

  if (refuelingInfo['fuelAmount'] != null) {
    text += '${localizations.forATotalOf}${refuelingInfo['fuelAmount']} ';
  }

  if (refuelingInfo['place'] != null && refuelingInfo['place'] != '') {
    text += '${localizations.atPlace}${refuelingInfo['place']} ';
  }

  if (refuelingInfo['date'] != null) {
    text += '${localizations.onDateArticleLower}${refuelingInfo['date']} ';
  }

  text += '${localizations.forMy}$vehicleBrand $vehicleModel.';

  await SharePlus.instance.share(ShareParams(text: text));
}
