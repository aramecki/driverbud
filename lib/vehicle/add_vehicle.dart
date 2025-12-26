import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/focusable_dropdown.dart';
import 'package:mycargenie_2/utils/image_picker.dart';
import 'package:mycargenie_2/utils/reusable_textfield.dart';
import 'package:mycargenie_2/utils/support_fun.dart';
import 'package:mycargenie_2/utils/year_picker.dart';
import 'package:provider/provider.dart';
import '../utils/lists.dart';
import '../utils/puzzle.dart';
import '../utils/boxes.dart';
import '../home.dart';

class AddVehicle extends StatefulWidget {
  final Map<String, dynamic>? vehicle;
  final dynamic editKey;

  const AddVehicle({super.key, this.vehicle, this.editKey});

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  final TextEditingController _modelCtrl = TextEditingController();
  final TextEditingController _configCtrl = TextEditingController();
  final TextEditingController _capacityCtrl = TextEditingController();
  final TextEditingController _powerCtrl = TextEditingController();
  final TextEditingController _horseCtrl = TextEditingController();

  final MenuController brandMenuController = MenuController();
  final MenuController categoryMenuController = MenuController();
  final MenuController energyMenuController = MenuController();
  final MenuController ecologyMenuController = MenuController();

  String? _savedImagePath;
  String? _previewImagePath;

  String? _brand;
  int? _year;
  String? _category;
  String? _energy;
  String? _ecology;
  bool _favorite = false;
  String? _assetImage;

  String? _bkModel;
  String? _bkConfig;
  String? _bkCapacity;
  String? _bkPower;
  String? _bkHorse;
  String? _bkImage;
  String? _bkBrand;
  int? _bkYear;
  String? _bkCategory;
  String? _bkEnergy;
  String? _bkEcology;
  bool? _bkFavorite;

  @override
  void initState() {
    super.initState();

    final eventToEdit = widget.vehicle;

    if (eventToEdit != null) {
      _savedImagePath = eventToEdit['assetImage'] as String?;
      _previewImagePath = _savedImagePath;
      _bkImage = _savedImagePath;
      _assetImage = _savedImagePath;

      _modelCtrl.text = eventToEdit['model'] ?? '';
      _bkModel = _modelCtrl.text;

      _configCtrl.text = eventToEdit['config'] ?? '';
      _bkConfig = _configCtrl.text;

      _capacityCtrl.text = eventToEdit['capacity']?.toString() ?? '';
      _bkCapacity = _capacityCtrl.text;

      _powerCtrl.text = eventToEdit['power']?.toString() ?? '';
      _bkPower = _powerCtrl.text;

      _horseCtrl.text = eventToEdit['horse']?.toString() ?? '';
      _bkHorse = _horseCtrl.text;

      _brand = eventToEdit['brand'] as String?;
      _bkBrand = _brand;

      _year = eventToEdit['year'] as int?;
      _bkYear = _year;

      _category = eventToEdit['category'] as String?;
      _bkCategory = _category;

      _energy = eventToEdit['energy'] as String?;
      _bkEnergy = _energy;

      _ecology = eventToEdit['ecology'] as String?;
      _bkEcology = _ecology;

      _favorite = eventToEdit['favorite'] ?? false;
      _bkFavorite = _favorite;
    }
  }

  @override
  void dispose() {
    _modelCtrl.dispose();
    _configCtrl.dispose();
    _capacityCtrl.dispose();
    _powerCtrl.dispose();
    _horseCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSavePressed() async {
    final localizations = AppLocalizations.of(context)!;

    if (_previewImagePath != null) {
      deleteImageFromMmry(_savedImagePath);
      _assetImage = await saveImageToMmry(_previewImagePath!);
    }

    if (!_favorite) {
      if (getFavoriteKey() == null) {
        _favorite = true;
      }
    }

    final vehicleMap = <String, dynamic>{
      'brand': _brand,
      'model': _modelCtrl.text.trim(),
      'config': _configCtrl.text.trim(),
      'year': _year ?? DateTime.now().year.toInt(),
      'capacity': int.tryParse(_capacityCtrl.text),
      'power': int.tryParse(_powerCtrl.text),
      'horse': int.tryParse(_horseCtrl.text),
      'category': _category,
      'energy': _energy,
      'ecology': _ecology,
      'favorite': _favorite,
      'assetImage': _assetImage,
    };

    if (!mounted) return;

    if (vehicleMap['brand'] == null ||
        vehicleMap['model'] == null ||
        vehicleMap['model'] == '') {
      showCustomToast(context, message: localizations.brandModelRequiredField);
      return;
    }

    if (_favorite) {
      final oldFav = getFavoriteKey();
      if (oldFav != null) {
        final old = vehicleBox.get(oldFav) as Map;
        old['favorite'] = false;
        vehicleBox.put(oldFav, old);
      }
    }

    final newKey = await saveEvent(vehicleMap, widget.editKey);

    if (!mounted) return;

    Provider.of<VehicleProvider>(context, listen: false).favoriteKey =
        getFavoriteKey();

    log('fav key updated: ${getFavoriteKey()}');

    Provider.of<VehicleProvider>(context, listen: false).vehicleToLoad = newKey;

    Navigator.of(context).pop();
  }

  Future<int> saveEvent(Map<String, dynamic> vehicleMap, int? editKey) async {
    if (editKey != null) {
      vehicleBox.put(widget.editKey, vehicleMap);
      return editKey;
    } else {
      return vehicleBox.add(vehicleMap);
    }
  }

  void _openMenu(MenuController controller) {
    if (controller.isOpen) {
      controller.close();
    } else {
      controller.open();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final vehicleCategoryList = getVehicleCategoryList(context);
    final vehicleEnergyList = getVehicleEnergyList(context);

    final isEdit = widget.editKey != null;

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        VehicleImagePicker(
          initialImagePath: _savedImagePath,
          onImagePicked: (value) => _previewImagePath = value,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: DropdownMenu<String>(
                  hintText: localizations.brandUpper,
                  initialSelection: _brand,
                  dropdownMenuEntries: vehicleBrandList
                      .map(
                        (item) => DropdownMenuEntry(value: item, label: item),
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
                    setState(() => _brand = value);
                    brandMenuController.close();
                  },
                ),
              ),
              const SizedBox(width: 8),
              customTextField(
                context,
                hintText: localizations.modelUpper,
                controller: _modelCtrl,
                action: TextInputAction.next,
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
                hintText: localizations.configurationUpper,
                maxLength: 30,
                controller: _configCtrl,
                action: TextInputAction.next,
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
              YearPickerButton(
                editDate: isEdit ? DateTime(_year!) : null,
                onSelected: (value) {
                  setState(() => _year = value.year);
                },
              ),
              const SizedBox(width: 8),
              customTextField(
                context,
                hintText: localizations.capacityCcUpper,
                type: TextInputType.number,
                maxLength: 4,
                formatter: [FilteringTextInputFormatter.digitsOnly],
                controller: _capacityCtrl,
                action: TextInputAction.next,
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
                hintText: localizations.powerKwUpper,
                type: TextInputType.number,
                maxLength: 4,
                formatter: [FilteringTextInputFormatter.digitsOnly],
                controller: _powerCtrl,
                action: TextInputAction.next,
              ),
              const SizedBox(width: 8),
              customTextField(
                context,
                hintText: localizations.horsePowerCvUpper,
                type: TextInputType.number,
                maxLength: 4,
                formatter: [FilteringTextInputFormatter.digitsOnly],
                controller: _horseCtrl,
                onSubmitted: (_) => _openMenu(categoryMenuController),
                action: TextInputAction.next,
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
                  menuController: categoryMenuController,
                  name: localizations.categoryUpper,
                  items: vehicleCategoryList,
                  selectedItem: _category,
                  onSelected: (value) {
                    setState(() => _category = value);
                    categoryMenuController.close();
                    _openMenu(energyMenuController);
                  },
                ),
              ),

              const SizedBox(width: 8),
              Expanded(
                child: FocusableDropdown(
                  menuController: energyMenuController,
                  name: localizations.energyUpper,
                  items: vehicleEnergyList,
                  selectedItem: _energy,
                  onSelected: (value) {
                    setState(() => _energy = value);
                    categoryMenuController.close();
                    _openMenu(ecologyMenuController);
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: FocusableDropdown(
                  menuController: ecologyMenuController,
                  name: localizations.ecologyUpper,
                  items: vehicleEcoList,
                  selectedItem: _ecology,
                  onSelected: (value) {
                    setState(() => _ecology = value);
                    categoryMenuController.close();
                    FocusScope.of(context).nextFocus();
                  },
                ),
              ),

              const SizedBox(width: 8),
              if (!isEdit)
                Expanded(
                  child: CustomSwitch(
                    isSelected: _favorite,
                    onChanged: (value) {
                      setState(() {
                        _favorite = value;
                      });
                    },
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
                child: buildAddButton(
                  context,
                  onPressed: _onSavePressed,
                  text: isEdit
                      ? localizations.updateUpper
                      : localizations.saveUpper,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => showCustomToast(
            context,
            message: 'Brand opened',
          ), // TODO: Remove, for debugging
          child: Text(localizations.cantFindYourVehicleBrand),
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
                ? localizations.editValue(localizations.vehicleUpper)
                : localizations.addValue(localizations.vehicleUpper),
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
    return _previewImagePath != _bkImage ||
        _modelCtrl.text != _bkModel ||
        _configCtrl.text != _bkConfig ||
        _capacityCtrl.text != _bkCapacity ||
        _powerCtrl.text != _bkPower ||
        _horseCtrl.text != _bkHorse ||
        _brand != _bkBrand ||
        _year != _bkYear ||
        _category != _bkCategory ||
        _energy != _bkEnergy ||
        _ecology != _bkEcology ||
        _favorite != _bkFavorite;
  }
}
