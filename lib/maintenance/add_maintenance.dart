import 'dart:developer';

import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/notifications/notifications_schedulers.dart';
import 'package:mycargenie_2/notifications/notifications_utils.dart';
import 'package:mycargenie_2/notifications/permissions.dart';
import 'package:mycargenie_2/settings/settings_logics.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/theme/text_styles.dart';
import 'package:mycargenie_2/utils/date_picker.dart';
import 'package:mycargenie_2/utils/reusable_textfield.dart';
import 'package:provider/provider.dart';
import '../utils/lists.dart';
import '../utils/puzzle.dart';
import '../utils/boxes.dart';

class AddMaintenance extends StatefulWidget {
  final Map<String, dynamic>? maintenanceEvent;
  final dynamic editKey;

  const AddMaintenance({super.key, this.maintenanceEvent, this.editKey});

  @override
  State<AddMaintenance> createState() => _AddMaintenanceState();
}

class _AddMaintenanceState extends State<AddMaintenance> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _placeCtrl = TextEditingController();
  final TextEditingController _kilometersCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();

  CurrencyTextFieldController? _priceCtrl;

  final MenuController menuController = MenuController();

  DateTime? _date;
  int? _maintenanceType;
  bool _notifications = false;

  String? _bkTitle;
  String? _bkPlace;
  String? _bkKilometers;
  String? _bkDescription;
  String? _bkPrice;
  DateTime? _bkDate;
  int? _bkType;
  bool? _bkNotifications;

  final now = DateTime.now();
  DateTime get today => DateTime(now.year, now.month, now.day);

  @override
  void initState() {
    super.initState();

    final settingsProvider = context.read<SettingsProvider>();
    final currencySymbol = settingsProvider.currency;

    _priceCtrl = CurrencyTextFieldController(
      currencySymbol: currencySymbol!,
      decimalSymbol: ',',
      thousandSymbol: ' ',
      maxDigits: 8,
      enableNegative: false,
    );

    final eventToEdit = widget.maintenanceEvent;

    if (eventToEdit != null) {
      _titleCtrl.text = eventToEdit['title'] ?? '';
      _bkTitle = _titleCtrl.text;

      _placeCtrl.text = eventToEdit['place'] ?? '';
      _bkPlace = _placeCtrl.text;

      _kilometersCtrl.text = eventToEdit['kilometers']?.toString() ?? '';
      _bkKilometers = _kilometersCtrl.text;

      _descriptionCtrl.text = eventToEdit['description'] ?? '';
      _bkDescription = _descriptionCtrl.text;

      _priceCtrl!.text = eventToEdit['price']?.toString() ?? '';
      _bkPrice = _priceCtrl!.text;

      _date = eventToEdit['date'] as DateTime;
      _bkDate = _date;

      _maintenanceType = eventToEdit['maintenanceType'] as int?;
      _bkType = _maintenanceType;

      _notifications = eventToEdit['notifications'] ?? false;
      _bkNotifications = _notifications;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _placeCtrl.dispose();
    _kilometersCtrl.dispose();
    _descriptionCtrl.dispose();
    _priceCtrl!.dispose();
    super.dispose();
  }

  Future<void> _onSavePressed(dynamic maintenanceTypeList) async {
    final localizations = AppLocalizations.of(context)!;

    final vehicleKey = Provider.of<VehicleProvider>(
      context,
      listen: false,
    ).vehicleToLoad;

    if (!mounted) return;

    final double priceDoubleValue = _priceCtrl!.doubleValue;

    final maintenanceMap = <String, dynamic>{
      'title': _titleCtrl.text.trim(),
      'maintenanceType': _maintenanceType ?? 1,
      'place': _placeCtrl.text.trim(),
      'date': _date ?? today,
      'kilometers': int.tryParse(_kilometersCtrl.text),
      'description': _descriptionCtrl.text.trim(),
      'price': priceDoubleValue.toStringAsFixed(2),
      'notifications': _date != null && _date!.isAfter(today)
          ? _notifications
          : false,
      'vehicleKey': vehicleKey,
    };

    if (maintenanceMap['title'].isEmpty) {
      showCustomToast(context, message: localizations.titleRequiredField);
      return;
    }

    int? key = widget.editKey;

    if (widget.editKey == null) {
      key = await maintenanceBox.add(maintenanceMap);
    } else {
      maintenanceBox.put(widget.editKey, maintenanceMap);
    }

    // So enable notifications
    if (_date != null &&
        _date!.isAfter(today) &&
        _notifications == true &&
        key != null &&
        mounted) {
      if (_bkDate == null) {
        scheduleEventNotifications(
          localizations,
          vehicleKey,
          key,
          _date,
          getMaintenanceTypeList(context)[_maintenanceType] ??
              getMaintenanceTypeList(context)[1],
          _titleCtrl.text.trim(),
        );
      } else if (_isSomethingChanged()) {
        deleteEventNotifications(vehicleKey!, key);

        scheduleEventNotifications(
          localizations,
          vehicleKey,
          key,
          _date,
          getMaintenanceTypeList(context)[_maintenanceType] ??
              getMaintenanceTypeList(context)[1],
          _titleCtrl.text.trim(),
        );
      } else {
        log('nothing changed, nothing to do');
      }
    } else {
      if (key != null) deleteEventNotifications(vehicleKey!, key);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _openMenu() {
    if (menuController.isOpen) {
      menuController.close();
    } else {
      menuController.open();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final maintenanceTypeList = getMaintenanceTypeList(context);

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
                hintText: localizations.asteriskTitle,
                maxLength: 35,
                action: TextInputAction.next,
                onSubmitted: (_) => _openMenu(),
                controller: _titleCtrl,
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
                child: DropdownMenu<int>(
                  expandedInsets: EdgeInsets.zero,
                  hintText: localizations.categoryUpper,
                  initialSelection: _maintenanceType,
                  dropdownMenuEntries: maintenanceTypeList.entries
                      .map(
                        (entry) => DropdownMenuEntry(
                          value: entry.key,
                          label: entry.value,
                        ),
                      )
                      .toList(),
                  trailingIcon: arrowDownIcon(),
                  selectedTrailingIcon: arrowUpIcon(),
                  menuStyle: const MenuStyle(
                    maximumSize: WidgetStatePropertyAll(
                      Size(double.infinity, 200),
                    ),
                  ),
                  onSelected: (value) {
                    setState(() {
                      _maintenanceType = value;
                    });
                    menuController.close();
                  },
                ),
              ),

              const SizedBox(width: 8),
              customTextField(
                context,
                hintText: localizations.placeUpper,
                action: TextInputAction.next,
                // TODO: Set focus to open datepicker
                // onSubmitted: (_) => //apri date picker,
                controller: _placeCtrl,
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
                editDate: isEdit ? _date : null,
                onSelected: (value) {
                  setState(() => _date = value);
                  // FocusScope.of(context).nextFocus();
                },
              ),

              SizedBox(width: 8),

              customTextField(
                context,
                hintText: localizations.kilometersUpper,
                maxLength: 7,
                type: TextInputType.number,
                formatter: [FilteringTextInputFormatter.digitsOnly],
                action: TextInputAction.next,
                controller: _kilometersCtrl,
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
                  controller: _descriptionCtrl,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  maxLines: 12,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: localizations.descriptionUpper,
                  ),
                ),
              ),
            ],
          ),
        ),

        // To use the external currency library the thext field is not generalized
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: SizedBox()),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _priceCtrl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: localizations.priceUpper,
                  ),
                ),
              ),
            ],
          ),
        ),

        if (_date != null && _date!.isAfter(today))
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
                  onPressed: () => _onSavePressed(maintenanceTypeList),
                  text: isEdit
                      ? localizations.updateUpper
                      : localizations.saveUpper,
                ),
              ),
            ],
          ),
        ),

        //Required fields section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  localizations.asteriskRequiredFields,
                  textAlign: TextAlign.center,
                  style: bottomMessageStyle,
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
                ? localizations.editValue(localizations.maintenanceUpper)
                : localizations.addValue(localizations.maintenanceUpper),
          ),
          leading: customBackButton(
            context,
            confirmation: true,
            checkChanges: _isSomethingChanged,
          ),
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
    return _titleCtrl.text != _bkTitle ||
        _placeCtrl.text != _bkPlace ||
        _kilometersCtrl.text != _bkKilometers ||
        _descriptionCtrl.text != _bkDescription ||
        _priceCtrl!.text != _bkPrice ||
        _date != _bkDate ||
        _maintenanceType != _bkType ||
        _notifications != _bkNotifications;
  }
}
