import 'dart:developer';
import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/notifications/notifications_utils.dart';
import 'package:mycargenie_2/notifications/permissions.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/custom_currency_text_field_controller.dart';
import 'package:mycargenie_2/utils/date_picker.dart';
import 'package:mycargenie_2/utils/incrementable_digits_field.dart';
import 'package:mycargenie_2/utils/reusable_textfield.dart';
import 'package:provider/provider.dart';
import '../utils/puzzle.dart';
import '../utils/boxes.dart';

class EditInsurance extends StatefulWidget {
  final Map<String, dynamic>? insuranceDetails;
  final dynamic editKey;

  const EditInsurance({super.key, this.insuranceDetails, this.editKey});

  @override
  State<EditInsurance> createState() => _EditInsuranceState();
}

class _EditInsuranceState extends State<EditInsurance> {
  bool isCalculating = false;

  final TextEditingController _insurerCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();
  final TextEditingController _duesCtrl = TextEditingController();
  final List<CurrencyTextFieldController> _duesPersonalizationControllers = [];
  final List<DateTime> _duesPersonalizationDates = [];

  CurrencyTextFieldController? _totalPriceCtrl;

  final MenuController menuController = MenuController();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _personalizeDues = false;
  bool _notifications = false;

  DateTime? _bkEndDate;

  final now = DateTime.now();
  DateTime get today => DateTime(now.year, now.month, now.day);

  List<String> numbersAsString = List<String>.generate(
    12,
    (i) => (i + 1).toString(),
  );

  @override
  void initState() {
    super.initState();

    final details = insuranceBox.get(widget.editKey);

    log('details are: $details');

    _totalPriceCtrl = customCurrencyTextFieldController(context);

    if (details != null) {
      _insurerCtrl.text = details['insurer'] ?? '';
      log('loading insurer: ${_insurerCtrl.text}');

      if (details['startDate'] is DateTime) {
        _startDate = details['startDate'];
        log('loading startDate: ${_startDate.toString()}');
      }

      if (details['endDate'] is DateTime) {
        _endDate = details['endDate'];
        _bkEndDate = _endDate;
        log('loading endDate: ${_endDate.toString()}');
      }

      _noteCtrl.text = details['note'] ?? '';
      log('loading note: ${_noteCtrl.text}');

      _totalPriceCtrl!.text = details['totalPrice']?.toString() ?? '';
      log('loading totPrice: ${_totalPriceCtrl!.text.toString()}');

      _duesCtrl.text = details['dues'] ?? '1';

      _personalizeDues = details['personalizeDues'] ?? false;
      _notifications = details['notifications'] ?? false;

      final int? duesNumber = int.tryParse(_duesCtrl.text);

      if (duesNumber != null && duesNumber > 1) {
        for (int i = 0; i < duesNumber; i++) {
          log('loading controller $i');
          _duesPersonalizationControllers.add(
            customCurrencyTextFieldController(context),
          );

          _duesPersonalizationControllers[i].text =
              details['due$i']?.toString() ?? '';

          _duesPersonalizationDates.add(details['dueDate$i'] as DateTime);
        }
      }
    } else {
      _startDate = today;
      _endDate = today.add(const Duration(days: 356));
      _duesCtrl.text = '1';
    }
  }

  @override
  void dispose() {
    _insurerCtrl.dispose();
    _noteCtrl.dispose();
    _totalPriceCtrl!.dispose();
    for (var controller in _duesPersonalizationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _onSavePressed() async {
    final localizations = AppLocalizations.of(context)!;

    final vehicleKey = Provider.of<VehicleProvider>(
      context,
      listen: false,
    ).vehicleToLoad;

    if (!mounted) return;

    final double totalPriceDoubleValue = _totalPriceCtrl != null
        ? _totalPriceCtrl!.doubleValue
        : 0.00;

    final duesMap = {
      for (int i = 0; i < _duesPersonalizationControllers.length; i++)
        'due$i': _duesPersonalizationControllers[i].doubleValue.toStringAsFixed(
          2,
        ),
    };

    final duesDatesMap = {
      for (int i = 0; i < _duesPersonalizationDates.length; i++)
        'dueDate$i': _duesPersonalizationDates[i],
      // TODO: Calculate automatically dues when no personalization or inform user of only informing him of expiration
    };

    final insuranceMap = <String, dynamic>{
      'insurer': _insurerCtrl.text.trim(),
      'startDate': _startDate,
      'endDate': _endDate,
      'note': _noteCtrl.text.trim(),
      'totalPrice': totalPriceDoubleValue.toStringAsFixed(2),
      'dues': _duesCtrl.text.trim() == '' ? '1' : _duesCtrl.text.trim(),
      'personalizeDues': _personalizeDues,
      'notifications': _notifications,
      ...duesMap,
      ...duesDatesMap,
      'vehicleKey': vehicleKey,
    };

    if (_notifications == true) {
      log('Notifications is true, scheduling...');
      if (_bkEndDate == null) {
        log('_bkEndDate is null, new entry just scheduling');

        scheduleInsuranceNotifications(localizations, vehicleKey, _endDate);
      } else if (_bkEndDate != _endDate) {
        log('_bkEndDate and _endDate are different, updating notifications');

        deleteAllNotificationsInCategory(
          insuranceNotificationsBox,
          vehicleKey!,
        );
        scheduleInsuranceNotifications(localizations, vehicleKey, _endDate);
      } else {
        log('_bkEndDate and _endDate are the same, nothing to do');
      }
    } else {
      deleteAllNotificationsInCategory(insuranceNotificationsBox, vehicleKey!);
    }

    if (_notifications == true && _duesPersonalizationDates.length > 1) {
      for (int i = 0; i < _duesPersonalizationDates.length; i++) {
        scheduleInsuranceNotifications(
          localizations,
          vehicleKey,
          _duesPersonalizationDates[i],
        );
      }
    }

    if (widget.editKey == null) {
      insuranceBox.add(insuranceMap);
      log('Saved: $insuranceMap');
    } else {
      insuranceBox.put(widget.editKey, insuranceMap);
      log('Updated: $insuranceMap at ${widget.editKey}');
    }

    Navigator.of(context).pop();
  }

  //TODO: Manage when there are no vehicles

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final isEdit = widget.editKey != null;

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              customTextField(
                context,
                hintText: localizations.insuranceAgency,
                maxLength: 35,
                action: TextInputAction.next,
                controller: _insurerCtrl,
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
              DatePickerWidget(
                pickerIcon: startCalendarIcon,
                editDate: isEdit ? _startDate : null,
                onSelected: (value) {
                  setState(() => _startDate = value);
                },
              ),

              const SizedBox(width: 8),
              DatePickerWidget(
                pickerIcon: stopCalendarIcon,
                editDate: isEdit ? _endDate : null,
                preSelectedDate: _endDate,
                onSelected: (value) {
                  setState(() => _endDate = value);
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: TextField(
                  controller: _noteCtrl,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  maxLines: 12,
                  maxLength: 500,
                  decoration: InputDecoration(hintText: localizations.notes),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: TextField(
                  controller: _totalPriceCtrl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: localizations.totalAmount,
                  ),
                  style: TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(width: 12),

              IncrementableTextField(
                controller: _duesCtrl,
                onChanged: (text) {
                  log('text: $text _duesCtrl.text: ${_duesCtrl.text}');
                  int duesPersonalizationControllerLenght =
                      _duesPersonalizationControllers.length;
                  int duesNumber = _duesCtrl.text == '' || _duesCtrl.text == '0'
                      ? 1
                      : int.parse(_duesCtrl.text);
                  if (duesNumber == 1) {
                    setState(() {
                      _personalizeDues = false;
                    });
                  }
                  editDuesControllers(
                    duesPersonalizationControllerLenght,
                    duesNumber,
                  );
                },
              ),
            ],
          ),
        ),

        if (int.parse(_duesCtrl.text) > 1)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomSwitch(
                  text: localizations.customizeDues,
                  isSelected: _personalizeDues,
                  onChanged: (v) async {
                    setState(() {
                      log('changing v state to $v');
                      _personalizeDues = v;
                      if (v == true) {
                        isCalculating = true;
                      }
                    });
                    if (v == true) {
                      refreshDues();
                    }
                    setState(() {
                      isCalculating = false;
                    });
                  },
                ),

                Expanded(child: const SizedBox()),

                if (int.parse(_duesCtrl.text) > 1 &&
                    _personalizeDues &&
                    !isCalculating)
                  IconButton(
                    onPressed: () async {
                      refreshDues();
                    },
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedRefresh,
                      strokeWidth: 2,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),

        if (isCalculating)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CircularProgressIndicator(),
          ),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SizeTransition(
              sizeFactor: animation,
              axisAlignment: -1.0,
              child: child,
            );
          },
          child:
              int.parse(_duesCtrl.text) > 1 &&
                  _personalizeDues &&
                  !isCalculating
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._duesPersonalizationControllers.asMap().entries.map((
                        entry,
                      ) {
                        final n = entry.key;
                        final controller = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              DatePickerWidget(
                                editDate: isEdit
                                    ? _duesPersonalizationDates[n]
                                    : null,
                                onSelected: (value) {
                                  setState(
                                    () => _duesPersonalizationDates[n] = value,
                                  );
                                },
                              ),

                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: controller,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText:
                                        '${localizations.dueSpace}${n + 1}',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('hidden')),
        ),

        if (_endDate != null && _endDate!.isAfter(today))
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomSwitch(
                  text: localizations.notifications,
                  isSelected: _notifications,
                  onChanged: (v) async {
                    bool hasPermissions = await checkAndRequestPermissions(
                      context,
                    );

                    if (hasPermissions) {
                      setState(() {
                        log('changing notifications state to $v');
                        _notifications = v;
                      });
                    } else {
                      _notifications = false;
                    }
                  },
                ),
              ],
            ),
          ),

        // Save  button section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: buildAddButton(
                  context,
                  onPressed: () => _onSavePressed(),
                  text: isEdit
                      ? localizations.updateUpper
                      : localizations.saveUpper,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final bool? shouldPop = await discardConfirmOnBack(
          context,
          popScope: true,
        );

        if (shouldPop == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEdit
                ? localizations.editValue(localizations.insurance)
                : localizations.addValue(localizations.insurance),
          ),
          leading: customBackButton(context, confirmation: true),
          actions: <Widget>[
            if (widget.editKey != null)
              IconButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    insuranceBox.delete(widget.editKey);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                },
                icon: deleteIcon(iconSize: 30),
              ),
          ],
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(child: content),
        ),
      ),
    );
  }

  Future<void> assignPriceToDues(double duePrice) async {
    final String duePriceString = duePrice.toStringAsFixed(2);

    for (var controller in _duesPersonalizationControllers) {
      controller.text = duePriceString;
    }
  }

  void editDuesControllers(int duesControllerLenght, int newDues) {
    setState(() {
      if (duesControllerLenght < newDues) {
        int controllersToAdd = newDues - duesControllerLenght;
        for (int i = 0; i < controllersToAdd; i++) {
          _duesPersonalizationControllers.add(
            customCurrencyTextFieldController(context),
          );
          _duesPersonalizationDates.add(DateTime.now());
        }
      } else if (duesControllerLenght > newDues) {
        int controllersToRemove = duesControllerLenght - newDues;
        for (int i = 0; i < controllersToRemove; i++) {
          final controllerToRemove = _duesPersonalizationControllers
              .removeLast();
          _duesPersonalizationDates.removeLast();
          controllerToRemove.dispose();
        }
      }
    });
  }

  Future<void> refreshDues() async {
    double? duePrice = await calculateDues(
      _totalPriceCtrl?.doubleValue,
      int.parse(_duesCtrl.text),
    );
    if (duePrice != null) {
      await assignPriceToDues(duePrice);
    }
  }
}

Future<double?> calculateDues(double? totalPrice, int dues) async {
  if (totalPrice != null) {
    return totalPrice / dues;
  } else {
    return null;
  }
}

bool scheduleInsuranceNotifications(
  AppLocalizations localizations,
  int? vehicleKey,
  DateTime? date,
) {
  if (vehicleKey != null && date != null) {
    final vehicle = vehicleBox.get(vehicleKey);
    String vehicleName = '${vehicle['brand']} ${vehicle['model']}';
    DateTime effectiveDate = date.add(const Duration(hours: 9));
    scheduleNotification(
      vehicleKey: vehicleKey,
      title: localizations.insuranceNotificationsTitle,
      body:
          '${localizations.insuranceNotificationsBody(vehicleName)}${localizations.ggMmAaaa(date.day, date.month, date.year)}.',
      date: effectiveDate,
      //date: DateTime.now().add(const Duration(seconds: 10)),
    );
    return true;
  } else {
    log(
      'returning false in scheduleInsuranceNotifications fun because date: $date vehicleKey: $vehicleKey',
    );
    return false;
  }
}
