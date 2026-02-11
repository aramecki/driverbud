import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mycargenie_2/invoices/edit_insurance.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/settings/currency_settings.dart';
import 'package:mycargenie_2/settings/settings.dart';
import 'package:mycargenie_2/settings/settings_logics.dart';
import 'package:provider/provider.dart';
import '../utils/puzzle.dart';
import '../utils/boxes.dart';

class Insurance extends StatefulWidget {
  final int vehicleKey;

  const Insurance({super.key, required this.vehicleKey});

  @override
  State<Insurance> createState() => _InsuranceState();
}

class _InsuranceState extends State<Insurance> {
  int? key;

  String _insurer = '';
  String _note = '';
  String? _totalPrice;
  DateTime? _startDate;
  DateTime? _endDate;
  String _dues = '1';
  bool _personalizeDues = false;

  final now = DateTime.now();
  DateTime get today => DateTime(now.year, now.month, now.day);

  @override
  void initState() {
    super.initState();

    log('insuranceBox contains: ${insuranceBox.toMap().toString()}');

    List<dynamic> details = insuranceBox.keys.where((key) {
      final value = insuranceBox.get(key);
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
          MaterialPageRoute(builder: (context) => EditInsurance(editKey: null)),
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
    String? startDateString;
    String? endDateString;

    final content = key == null
        ? SizedBox()
        : ValueListenableBuilder(
            valueListenable: insuranceBox.listenable(keys: [key]),
            builder: (context, box, _) {
              final e = box.get(key);

              if (e == null) {
                return Center(child: CircularProgressIndicator());
              }

              _insurer = e['insurer'] ?? '';
              _note = e['note'] ?? '';
              _totalPrice = e['totalPrice']?.toString() ?? '';
              _startDate = e['startDate'] as DateTime;
              _endDate = e['endDate'] as DateTime;
              _dues = e['dues'];
              _personalizeDues = e['personalizeDues'];

              List<String> duesPriceList = [];
              List<String> duesDateList = [];

              int duesInt = int.parse(_dues);

              if (duesInt > 1) {
                for (var i = 0; i < duesInt; i++) {
                  duesPriceList.add(
                    localizations.numCurrency(
                      parseShowedPrice(e['due$i']),
                      currencySymbol!,
                    ),
                  );

                  DateTime dueDate = e['dueDate$i'];
                  duesDateList.add(
                    localizations.ggMmAaaa(
                      dueDate.day,
                      dueDate.month,
                      dueDate.year,
                    ),
                  );
                }
              }

              totalPriceString = localizations.numCurrency(
                parseShowedPrice(_totalPrice!),
                currencySymbol!,
              );

              startDateString = localizations.ggMmAaaa(
                _startDate!.day,
                _startDate!.month,
                _startDate!.year,
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
                  // TODO: Check ellipsis on small screens
                  // Insurance Agency row
                  if (_insurer.isNotEmpty)
                    ...tileRow(localizations.insuranceAgency, _insurer),

                  // Start date row
                  if (startDateString != null && startDateString != '')
                    ...tileRow(localizations.startDateUpper, startDateString!),

                  // End date row
                  if (endDateString != null && endDateString != '')
                    ...tileRow(localizations.endDateUpper, endDateString!),

                  // Total price row
                  if (_totalPrice != null && _totalPrice != '0.00')
                    ...tileRow(localizations.totalPrice, totalPriceString),

                  // Dues number row
                  if (duesInt > 1)
                    ...tileRow(localizations.duesCount, duesInt.toString()),

                  // Singular due rows
                  if (duesInt > 1 && _personalizeDues)
                    for (var i = 0; i < duesInt; i++)
                      ...tileRow(
                        '${localizations.dueSpace}${i + 1}',
                        duesPriceList[i],
                        centralColumn: true,
                        centerContent: duesDateList[i].toString(),
                      ),

                  // Notes row
                  if (_note.isNotEmpty) ...notesTileRow(context, _note),

                  // Save or update button section
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 12,
                      bottom: 44,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: buildAddButton(
                            context,
                            onPressed: () => navigateToPage(
                              context,
                              EditInsurance(editKey: key),
                            ),
                            text: localizations.editInvoiceDetails(
                              localizations.insurance,
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
        title: Text(localizations.thirdPartyInsurance),
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
