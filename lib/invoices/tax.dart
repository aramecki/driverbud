import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mycargenie_2/invoices/edit_tax.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/settings/currency_settings.dart';
import 'package:mycargenie_2/settings/settings.dart';
import 'package:mycargenie_2/settings/settings_logics.dart';
import 'package:provider/provider.dart';
import '../utils/puzzle.dart';
import '../utils/boxes.dart';

class Tax extends StatefulWidget {
  final int vehicleKey;

  const Tax({super.key, required this.vehicleKey});

  @override
  State<Tax> createState() => _TaxState();
}

class _TaxState extends State<Tax> {
  int? key;

  String _note = '';
  String? _totalPrice;
  DateTime? _endDate;

  final now = DateTime.now();
  DateTime get today => DateTime(now.year, now.month, now.day);

  @override
  void initState() {
    super.initState();

    log('taxBox contains: ${taxBox.toMap().toString()}');

    List<dynamic> details = taxBox.keys.where((key) {
      final value = taxBox.get(key);
      return value != null && value['vehicleKey'] == widget.vehicleKey;
    }).toList();

    log('details are: $details');

    if (details.isNotEmpty) {
      key = details.first;
      log('key is $key');
    } else {
      log('navigating to creation page in initState');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => EditTax(editKey: null)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final settingsProvider = context.read<SettingsProvider>();
    final currencySymbol = settingsProvider.currency;

    String totalPriceString = '';
    String? endDateString;

    final content = key == null
        ? SizedBox()
        : ValueListenableBuilder(
            valueListenable: taxBox.listenable(keys: [key]),
            builder: (context, box, _) {
              final e = box.get(key);

              if (e == null) {
                return Center(child: CircularProgressIndicator());
              }

              _note = e['note'] ?? '';
              _totalPrice = e['totalPrice']?.toString() ?? '';
              _endDate = e['endDate'] as DateTime;

              totalPriceString = localizations.numCurrency(
                parseShowedPrice(_totalPrice!),
                currencySymbol!,
              );

              endDateString = localizations.ggMmAaaa(
                _endDate!.day,
                _endDate!.month,
                _endDate!.year,
              );

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // End date row
                  if (endDateString != null && endDateString != '')
                    ...tileRow(localizations.endDateUpper, endDateString!),

                  // Total price row
                  if (_totalPrice != null && _totalPrice != '0.00')
                    ...tileRow(localizations.priceToPay, totalPriceString),

                  // Notes row
                  if (_note.isNotEmpty) ...notesTileRow(context, _note),

                  // Save or update button section
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
                                navigateToPage(context, EditTax(editKey: key)),
                            text: localizations.editInvoiceDetails(
                              localizations.taxLower,
                            ),
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
        title: Text(localizations.tax),
        leading: customBackButton(context),
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

Widget containerWithTextAndIcon(String text, HugeIcon icon) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.deepOrange, width: 2),
      borderRadius: BorderRadius.circular(50),
    ),
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [icon, SizedBox(width: 10), Text(text)],
    ),
  );
}
