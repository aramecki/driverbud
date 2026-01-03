import 'dart:developer';
import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/notifications/notifications_schedulers.dart';
import 'package:mycargenie_2/notifications/notifications_utils.dart';
import 'package:mycargenie_2/notifications/permissions.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/custom_currency_text_field_controller.dart';
import 'package:mycargenie_2/utils/date_picker.dart';
import 'package:provider/provider.dart';
import '../utils/puzzle.dart';
import '../utils/boxes.dart';

class EditTax extends StatefulWidget {
  final dynamic editKey;

  const EditTax({super.key, this.editKey});

  @override
  State<EditTax> createState() => _EditTaxState();
}

class _EditTaxState extends State<EditTax> {
  final TextEditingController _noteCtrl = TextEditingController();

  CurrencyTextFieldController? _totalPriceCtrl;

  DateTime? _endDate;
  bool _notifications = false;

  String? _bkNote;
  DateTime? _bkEndDate;
  String? _bkTotalPrice;
  bool? _bkNotifications;

  final now = DateTime.now();
  DateTime get today => DateTime(now.year, now.month, now.day);

  @override
  void initState() {
    super.initState();

    final details = taxBox.get(widget.editKey);

    log('details are: $details');

    _totalPriceCtrl = customCurrencyTextFieldController(context);

    if (details != null) {
      if (details['endDate'] is DateTime) {
        _endDate = details['endDate'];
        _bkEndDate = _endDate;
        log('loading endDate: ${_endDate.toString()}');
      }

      _noteCtrl.text = details['note'] ?? '';
      _bkNote = _noteCtrl.text;
      log('loading note: ${_noteCtrl.text}');

      _totalPriceCtrl!.text = details['totalPrice']?.toString() ?? '';
      _bkTotalPrice = _totalPriceCtrl!.text;
      log('loading totPrice: ${_totalPriceCtrl!.text.toString()}');

      _notifications = details['notifications'] ?? false;
      _bkNotifications = _notifications;
    } else {
      _endDate = today.add(const Duration(days: 365));
    }
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    _totalPriceCtrl!.dispose();
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

    final taxMap = <String, dynamic>{
      'endDate': _endDate,
      'note': _noteCtrl.text.trim(),
      'totalPrice': totalPriceDoubleValue.toStringAsFixed(2),
      'notifications': _endDate != null && _endDate!.isAfter(today)
          ? _notifications
          : false,
      'vehicleKey': vehicleKey,
    };

    if (_notifications == true) {
      log('Notifications is true, scheduling...');
      if (_bkEndDate == null) {
        log('_bkEndDate is null, new entry just scheduling');

        scheduleInvoiceNotifications(
          localizations,
          vehicleKey,
          _endDate,
          NotificationType.tax,
        );
      } else if (_isSomethingChanged()) {
        log('_bkEndDate and _endDate are different, updating notifications');

        deleteAllNotificationsInCategory(taxNotificationsBox, vehicleKey!);
        scheduleInvoiceNotifications(
          localizations,
          vehicleKey,
          _endDate,
          NotificationType.tax,
        );
      } else {
        log('_bkEndDate and _endDate are the same, nothing to do');
      }
    } else {
      deleteAllNotificationsInCategory(taxNotificationsBox, vehicleKey!);
    }

    if (widget.editKey == null) {
      taxBox.add(taxMap);
      log('Saved: $taxMap');
    } else {
      taxBox.put(widget.editKey, taxMap);
      log('Updated: $taxMap at ${widget.editKey}');
    }

    Navigator.of(context).pop();
  }

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
              DatePickerWidget(
                pickerIcon: stopCalendarIcon,
                editDate: isEdit ? _endDate : null,
                preSelectedDate: _endDate,
                onSelected: (value) {
                  setState(() => _endDate = value);
                },
              ),

              SizedBox(width: 8),

              Expanded(
                child: TextField(
                  controller: _totalPriceCtrl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: localizations.totalAmount,
                  ),
                ),
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

        final hasChanges = _isSomethingChanged();

        if (!hasChanges) {
          if (context.mounted) Navigator.of(context).pop();
          return;
        }

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
                ? localizations.editValue(localizations.taxLower)
                : localizations.addValue(localizations.taxLower),
          ),
          leading: customBackButton(
            context,
            confirmation: true,
            checkChanges: _isSomethingChanged,
          ),
          actions: <Widget>[
            if (widget.editKey != null)
              IconButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    deleteAllNotificationsInCategory(
                      taxNotificationsBox,
                      widget.editKey,
                    );
                    taxBox.delete(widget.editKey);
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

  bool _isSomethingChanged() {
    return _endDate != _bkEndDate ||
        _noteCtrl.text != _bkNote ||
        _totalPriceCtrl!.text != _bkTotalPrice ||
        _notifications != _bkNotifications;
  }
}
