import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/utils/date_picker.dart';
import 'package:mycargenie_2/utils/focusable_dropdown.dart';
import 'package:mycargenie_2/utils/reusable_textfield.dart';
import 'package:provider/provider.dart';
import '../utils/lists.dart';
import '../utils/puzzle.dart';
import '../boxes.dart';

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

  final CurrencyTextFieldController _priceCtrl = CurrencyTextFieldController(
    currencySymbol: "€",
    decimalSymbol: ",",
    thousandSymbol: ".",
    maxDigits: 8,
    enableNegative: false,
  );

  final MenuController menuController = MenuController();

  DateTime? _date;
  String? _maintenanceType;

  final now = DateTime.now();
  DateTime get today => DateTime(now.year, now.month, now.day);

  @override
  void initState() {
    super.initState();

    final eventToEdit = widget.maintenanceEvent;

    if (eventToEdit != null) {
      _titleCtrl.text = eventToEdit['title'] ?? '';
      _placeCtrl.text = eventToEdit['place'] ?? '';
      _kilometersCtrl.text = eventToEdit['kilometers']?.toString() ?? '';
      _descriptionCtrl.text = eventToEdit['description'] ?? '';
      _priceCtrl.text = eventToEdit['price']?.toString() ?? '';

      _date = eventToEdit['date'] as DateTime;
      _maintenanceType = eventToEdit['maintenanceType'] as String?;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _placeCtrl.dispose();
    _kilometersCtrl.dispose();
    _descriptionCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSavePressed() async {
    final vehicleKey = Provider.of<VehicleProvider>(
      context,
      listen: false,
    ).vehicleToLoad;

    if (!mounted) return;

    final double priceDoubleValue = _priceCtrl.doubleValue;

    // log(priceDoubleValue.toStringAsFixed(2));

    final maintenanceMap = <String, dynamic>{
      'title': _titleCtrl.text.trim(),
      'maintenanceType': _maintenanceType,
      'place': _placeCtrl.text.trim(),
      'date': _date ?? today,
      'kilometers': int.tryParse(_kilometersCtrl.text),
      'description': _descriptionCtrl.text.trim(),
      'price': priceDoubleValue.toStringAsFixed(2),
      'vehicleKey': vehicleKey,
    };

    if (maintenanceMap['title'].isEmpty) {
      showCustomToast(context, message: 'Title is a required field.');
      return;
    }

    if (widget.editKey == null) {
      maintenanceBox.add(maintenanceMap);
    } else {
      maintenanceBox.put(widget.editKey, maintenanceMap);
    }

    Navigator.of(context).pop();
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
                hintText: 'Titolo*',
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
                child: FocusableDropdown(
                  menuController: menuController,
                  name: 'Tipo',
                  items: maintenanceTypeList,
                  selectedItem: _maintenanceType,
                  onSelected: (value) {
                    setState(() => _maintenanceType = value);
                    menuController.close();
                    FocusScope.of(context).nextFocus();
                  },
                ),
              ),

              const SizedBox(width: 8),
              customTextField(
                context,
                hintText: 'Luogo',
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
              DatePickerExample(
                editDate: isEdit ? _date : null,
                onSelected: (value) {
                  setState(() => _date = value);
                  // FocusScope.of(context).nextFocus();
                },
              ),

              const SizedBox(width: 8),
              customTextField(
                context,
                hintText: 'Kilometri',
                maxLength: 7,
                type: TextInputType.number,
                action: TextInputAction.next,
                controller: _kilometersCtrl,
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
              customTextField(
                context,
                hintText: 'Descrizione',
                maxLines: 12,
                maxLength: 500,
                expands: true,
                controller: _descriptionCtrl,
                type: TextInputType.multiline,
                action: TextInputAction.newline,
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
                  decoration: InputDecoration(hintText: 'Price'),
                ),
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
                  onPressed: _onSavePressed,
                  text: isEdit ? 'Update' : 'Save',
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
                  'I campi contrassegnati da * sono obbligatori.',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Maintenance' : 'Add Maintenance'),
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
