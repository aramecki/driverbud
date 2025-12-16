import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mycargenie_2/invoices/edit_insurance.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/settings/currency_settings.dart';
import 'package:mycargenie_2/settings/settings.dart';
import 'package:mycargenie_2/settings/settings_logics.dart';
import 'package:mycargenie_2/theme/colors.dart';
import 'package:mycargenie_2/theme/icons.dart';
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
                  if (_insurer.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            localizations.insuranceAgency,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),

                  if (_insurer.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            _insurer,
                            style: TextStyle(
                              fontSize: 22,
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
                          child: containerWithTextAndIcon(
                            startDateString!,
                            startCalendarIcon,
                          ),
                        ),

                        SizedBox(width: 8),

                        Expanded(
                          child: containerWithTextAndIcon(
                            endDateString!,
                            stopCalendarIcon,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_totalPrice != '0.00')
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            totalPriceString,
                            style: TextStyle(fontSize: 20),
                          ),

                          if (duesInt > 1)
                            Text(
                              '${localizations.spaceInSpace}${localizations.duesCount(duesInt)}',
                            ),
                        ],
                      ),
                    ),

                  if (duesInt > 1 && _personalizeDues)
                    for (var i = 0; i < duesInt; i++)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 52,
                          vertical: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('${localizations.dueSpace}${i + 1} '),
                            SizedBox(width: 16),
                            Text(
                              duesDateList[i].toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: lightGrey,
                              ),
                            ),

                            SizedBox(width: 16),

                            Text(
                              duesPriceList[i],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                  if (_note.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [Expanded(child: Text(_note))],
                      ),
                    ),

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
                            onPressed: () => navigateToPage(
                              context,
                              EditInsurance(editKey: key),
                            ),
                            text: localizations.editInsuranceDetails,
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
