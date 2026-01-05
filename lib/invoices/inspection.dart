import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mycargenie_2/invoices/edit_inspection.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/settings/settings.dart';
import 'package:mycargenie_2/theme/icons.dart';
import '../utils/puzzle.dart';
import '../utils/boxes.dart';

class Inspection extends StatefulWidget {
  final int vehicleKey;

  const Inspection({super.key, required this.vehicleKey});

  @override
  State<Inspection> createState() => _InspectionState();
}

class _InspectionState extends State<Inspection> {
  int? key;

  String _inspector = '';
  String _note = '';
  DateTime? _startDate;
  DateTime? _endDate;

  final now = DateTime.now();
  DateTime get today => DateTime(now.year, now.month, now.day);

  @override
  void initState() {
    super.initState();

    log('inspectionBox contains: ${inspectionBox.toMap().toString()}');

    List<dynamic> details = inspectionBox.keys.where((key) {
      final value = inspectionBox.get(key);
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
          MaterialPageRoute(
            builder: (context) => EditInspection(editKey: null),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    String? startDateString;
    String? endDateString;

    final content = key == null
        ? SizedBox()
        : ValueListenableBuilder(
            valueListenable: inspectionBox.listenable(keys: [key]),
            builder: (context, box, _) {
              final e = box.get(key);

              if (e == null) {
                return Center(child: CircularProgressIndicator());
              }

              _inspector = e['inspector'] ?? '';
              _note = e['note'] ?? '';
              _startDate = e['startDate'] as DateTime;
              _endDate = e['endDate'] as DateTime;

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
                  if (_inspector.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            localizations.performedAt,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),

                  if (_inspector.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            _inspector,
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
                              EditInspection(editKey: key),
                            ),
                            text: localizations.editInvoiceDetails(
                              localizations.inspectionLower,
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
        title: Text(localizations.inspection),
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
