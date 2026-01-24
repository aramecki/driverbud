import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/refueling/refueling_misc.dart';
import 'package:mycargenie_2/refueling/show_refueling.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/theme/text_styles.dart';
import 'package:mycargenie_2/utils/custom_currency_text_field_controller.dart';
import 'package:mycargenie_2/utils/date_picker.dart';
import 'package:mycargenie_2/utils/reusable_textfield.dart';
import 'package:provider/provider.dart';
import '../utils/lists.dart';
import '../utils/puzzle.dart';
import '../utils/boxes.dart';

class AddRefueling extends StatefulWidget {
  final Map<String, dynamic>? refuelingEvent;
  final dynamic editKey;

  const AddRefueling({super.key, this.refuelingEvent, this.editKey});

  @override
  State<AddRefueling> createState() => _AddRefuelingState();
}

class _AddRefuelingState extends State<AddRefueling> {
  final TextEditingController _placeCtrl = TextEditingController();
  final TextEditingController _kilometersCtrl = TextEditingController();
  final TextEditingController _notesCtrl = TextEditingController();

  CurrencyTextFieldController? _totalPriceCtrl;
  CurrencyTextFieldController? _pricePerUnitCtrl;
  CurrencyTextFieldController? _fuelAmountCtrl;

  final MenuController menuController = MenuController();

  DateTime? _date;
  int? _refuelingType;
  String? _fuelUnit;
  bool _automatic = false;

  String? _bkPlace;
  String? _bkKilometers;
  String? _bkNotes;
  String? _bkTotalPrice;
  String? _bkPricePerUnit;
  String? _bkFuelAmount;
  DateTime? _bkDate;
  int? _bkType;
  bool? _bkAutomatic;

  bool _showAutoErrorMessage = false;

  final now = DateTime.now();
  DateTime get today => DateTime(now.year, now.month, now.day);

  @override
  void initState() {
    super.initState();

    _totalPriceCtrl = customCurrencyTextFieldController(context);
    _pricePerUnitCtrl = customCurrencyTextFieldController(
      context,
      maxDigits: 4,
    );
    _fuelAmountCtrl = CurrencyTextFieldController(
      currencySymbol: '',
      maxDigits: 5,
    );

    final eventToEdit = widget.refuelingEvent;

    if (eventToEdit != null) {
      _placeCtrl.text = eventToEdit['place'] ?? '';
      _bkPlace = _placeCtrl.text;

      _kilometersCtrl.text = eventToEdit['kilometers']?.toString() ?? '';
      _bkKilometers = _kilometersCtrl.text;

      _notesCtrl.text = eventToEdit['notes'] ?? '';
      _bkNotes = _notesCtrl.text;

      _totalPriceCtrl!.text = eventToEdit['price']?.toString() ?? '';
      _bkTotalPrice = _totalPriceCtrl!.text;

      _pricePerUnitCtrl!.text = eventToEdit['pricePerUnit']?.toString() ?? '';
      _bkPricePerUnit = _pricePerUnitCtrl!.text;

      _fuelAmountCtrl!.text = eventToEdit['fuelAmount']?.toString() ?? '';
      _bkFuelAmount = _fuelAmountCtrl!.text;

      _date = eventToEdit['date'] as DateTime;
      _bkDate = _date;

      _refuelingType = eventToEdit['refuelingType'] as int?;
      _bkType = _refuelingType;
      _fuelUnit = getFuelUnit(_refuelingType!);

      _automatic = eventToEdit['automatic'] as bool;
      _bkAutomatic = _automatic;
    }
  }

  @override
  void dispose() {
    _placeCtrl.dispose();
    _kilometersCtrl.dispose();
    _notesCtrl.dispose();
    _totalPriceCtrl!.dispose();
    _pricePerUnitCtrl!.dispose();
    _fuelAmountCtrl!.dispose();
    super.dispose();
  }

  Future<void> _onSavePressed() async {
    final localizations = AppLocalizations.of(context)!;

    final vehicleKey = Provider.of<VehicleProvider>(
      context,
      listen: false,
    ).vehicleToLoad;

    if (!mounted) return;

    final double totalPriceDoubleValue = _totalPriceCtrl!.doubleValue;
    final double priceFerUnitDoubleValue = _pricePerUnitCtrl!.doubleValue;
    final double totalAmountDoubleValue = _fuelAmountCtrl!.doubleValue;

    final refuelingMap = <String, dynamic>{
      'refuelingType': _refuelingType ?? 6,
      'place': _placeCtrl.text.trim(),
      'date': _date ?? today,
      'kilometers': int.tryParse(_kilometersCtrl.text),
      'notes': _notesCtrl.text.trim(),
      'price': totalPriceDoubleValue.toStringAsFixed(2),
      'pricePerUnit': priceFerUnitDoubleValue.toStringAsFixed(2),
      'fuelAmount': totalAmountDoubleValue.toStringAsFixed(2),
      'automatic': _automatic,
      'vehicleKey': vehicleKey,
    };

    if (refuelingMap['price'] == '0.00') {
      showCustomToast(context, message: localizations.priceRequiredField);
      return;
    }

    int? key = widget.editKey;

    if (key == null) {
      key = await refuelingBox.add(refuelingMap);
    } else {
      refuelingBox.put(widget.editKey, refuelingMap);
    }

    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => ShowRefueling(editKey: key)));
    }
  }

  // void _openMenu() {
  //   if (menuController.isOpen) {
  //     menuController.close();
  //   } else {
  //     menuController.open();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final refuelingTypeList = getVehicleEnergyList(context);

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
              Expanded(
                child: DropdownMenu<int>(
                  expandedInsets: EdgeInsets.zero,
                  hintText: localizations.typeUpper,
                  initialSelection: _refuelingType,
                  dropdownMenuEntries: refuelingTypeList.entries
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
                      _refuelingType = value;
                      if (value == 4) {
                        _fuelUnit = fuelUnitsList[2];
                      } else if (value == 5) {
                        _fuelUnit = fuelUnitsList[3];
                      } else if (value == 6) {
                        _fuelUnit = fuelUnitsList[4];
                      } else {
                        _fuelUnit = fuelUnitsList[1];
                      }
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
                maxLength: 20,
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
                suffixText: 'km',
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
                  controller: _notesCtrl,
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

        // To use the external currency library the thext field is not generalized
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: TextField(
                  controller: _totalPriceCtrl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: localizations.totalPrice,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _pricePerUnitCtrl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: localizations.pricePerUnit,
                  ),
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
                child: TextField(
                  controller: _fuelAmountCtrl,
                  enabled: !_automatic,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: localizations.fuelAmount,
                    suffixText: _fuelUnit ?? '',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomSwitch(
                  text: localizations.automatic,
                  isSelected: _automatic,
                  onChanged: (value) {
                    _showAutoErrorMessage = false;

                    if (value) {
                      if (_totalPriceCtrl!.doubleValue != 0.00 &&
                          _pricePerUnitCtrl!.doubleValue != 0.00) {
                        setState(() {
                          _automatic = value;
                        });
                        double fuelAmount = calculateTotalFuel(
                          _totalPriceCtrl!.doubleValue,
                          _pricePerUnitCtrl!.doubleValue,
                        );
                        if (fuelAmount != 0.00) {
                          setState(() {
                            _fuelAmountCtrl!.text = fuelAmount.toStringAsFixed(
                              2,
                            );
                          });
                        }
                      } else {
                        setState(() {
                          _showAutoErrorMessage = true;
                        });
                      }
                    } else {
                      setState(() {
                        _automatic = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),

        Visibility(
          visible: _showAutoErrorMessage,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
              localizations.autoFuelCalculationMessage,
            ),
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
                  onPressed: () => _onSavePressed(),
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
                ? localizations.editValue(localizations.refuelingLower)
                : localizations.addValue(localizations.refuelingLower),
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
    return _placeCtrl.text != _bkPlace ||
        _kilometersCtrl.text != _bkKilometers ||
        _notesCtrl.text != _bkNotes ||
        _totalPriceCtrl!.text != _bkTotalPrice ||
        _pricePerUnitCtrl!.text != _bkPricePerUnit ||
        _fuelAmountCtrl!.text != _bkFuelAmount ||
        _date != _bkDate ||
        _refuelingType != _bkType ||
        _automatic != _bkAutomatic;
  }
}

double calculateTotalFuel(double price, double pricePerUnit) {
  if (price != 0.00 && pricePerUnit != 0.00) {
    return price / pricePerUnit;
  }
  return 0.00;
}
