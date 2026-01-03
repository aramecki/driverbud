import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/notifications/notifications_schedulers.dart';
import 'package:mycargenie_2/notifications/notifications_utils.dart';
import 'package:mycargenie_2/notifications/permissions.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/date_picker.dart';
import 'package:mycargenie_2/utils/reusable_textfield.dart';
import 'package:provider/provider.dart';
import '../utils/puzzle.dart';
import '../utils/boxes.dart';

class EditInspection extends StatefulWidget {
  final dynamic editKey;

  const EditInspection({super.key, this.editKey});

  @override
  State<EditInspection> createState() => _EditInspectionState();
}

class _EditInspectionState extends State<EditInspection> {
  bool isCalculating = false;

  final TextEditingController _inspectorCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _notifications = false;

  String? _bkInspector;
  String? _bkNote;
  DateTime? _bkStartDate;
  DateTime? _bkEndDate;
  bool? _bkNotifications;

  final now = DateTime.now();
  DateTime get today => DateTime(now.year, now.month, now.day);

  @override
  void initState() {
    super.initState();

    final details = inspectionBox.get(widget.editKey);

    log('details are: $details');

    if (details != null) {
      _inspectorCtrl.text = details['inspector'] ?? '';
      _bkInspector = _inspectorCtrl.text;
      log('loading inspector: ${_inspectorCtrl.text}');

      if (details['startDate'] is DateTime) {
        _startDate = details['startDate'];
        _bkStartDate = _startDate;
        log('loading startDate: ${_startDate.toString()}');
      }

      if (details['endDate'] is DateTime) {
        _endDate = details['endDate'];
        _bkEndDate = _endDate;
        log('loading endDate: ${_endDate.toString()}');
      }

      _noteCtrl.text = details['note'] ?? '';
      _bkNote = _noteCtrl.text;

      _notifications = details['notifications'] ?? false;
      _bkNotifications = _notifications;

      //log('loading note: ${_noteCtrl.text}');
    } else {
      _startDate = today;
      _endDate = today.add(const Duration(days: 365));
    }
  }

  @override
  void dispose() {
    _inspectorCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSavePressed() async {
    final localizations = AppLocalizations.of(context)!;

    final vehicleKey = Provider.of<VehicleProvider>(
      context,
      listen: false,
    ).vehicleToLoad;

    if (!mounted) return;

    final inspectionMap = <String, dynamic>{
      'inspector': _inspectorCtrl.text.trim(),
      'startDate': _startDate,
      'endDate': _endDate,
      'note': _noteCtrl.text.trim(),
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
          NotificationType.inspection,
        );
      } else if (_isSomethingChanged()) {
        log('_bkEndDate and _endDate are different, updating notifications');

        deleteAllNotificationsInCategory(
          inspectionNotificationsBox,
          vehicleKey!,
        );
        scheduleInvoiceNotifications(
          localizations,
          vehicleKey,
          _endDate,
          NotificationType.inspection,
        );
      } else {
        log('_bkEndDate and _endDate are the same, nothing to do');
      }
    } else {
      deleteAllNotificationsInCategory(inspectionNotificationsBox, vehicleKey!);
    }

    if (widget.editKey == null) {
      inspectionBox.add(inspectionMap);
      log('Saved: $inspectionMap');
    } else {
      inspectionBox.put(widget.editKey, inspectionMap);
      log('Updated: $inspectionMap at ${widget.editKey}');
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
              customTextField(
                context,
                hintText: localizations.inspector,
                maxLength: 25,
                action: TextInputAction.next,
                controller: _inspectorCtrl,
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
                ? localizations.editValue(localizations.inspectionLower)
                : localizations.addValue(localizations.inspectionLower),
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
                      inspectionNotificationsBox,
                      widget.editKey,
                    );
                    inspectionBox.delete(widget.editKey);
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
    return _inspectorCtrl.text != _bkInspector ||
        _startDate != _bkStartDate ||
        _endDate != _bkEndDate ||
        _noteCtrl.text != _bkNote ||
        _notifications != _bkNotifications;
  }
}
