import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/focusable_dropdown.dart';
import 'package:mycargenie_2/utils/image_picker.dart';
import 'package:mycargenie_2/utils/reusable_textfield.dart';
import 'package:mycargenie_2/utils/support_fun.dart';
import 'package:mycargenie_2/utils/year_picker.dart';
import 'package:provider/provider.dart';
import '../utils/lists.dart';
import '../utils/puzzle.dart';
import '../boxes.dart';
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
  // final TextEditingController _yearCtrl = TextEditingController();
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
  bool _favourite = false;
  String? _assetImage;

  @override
  void initState() {
    super.initState();

    final eventToEdit = widget.vehicle;

    if (eventToEdit != null) {
      _savedImagePath = eventToEdit['assetImage'] as String?;
      _assetImage = _savedImagePath;

      _modelCtrl.text = eventToEdit['model'] ?? '';
      _configCtrl.text = eventToEdit['config'] ?? '';
      // _yearCtrl.text = eventToEdit['year']?.toString() ?? '';
      _capacityCtrl.text = eventToEdit['capacity']?.toString() ?? '';
      _powerCtrl.text = eventToEdit['power']?.toString() ?? '';
      _horseCtrl.text = eventToEdit['horse']?.toString() ?? '';

      _brand = eventToEdit['brand'] as String?;
      _year = eventToEdit['year'] as int?;
      _category = eventToEdit['category'] as String?;
      _energy = eventToEdit['energy'] as String?;
      _ecology = eventToEdit['ecology'] as String?;
      _favourite = eventToEdit['favourite'] ?? false;
    }
  }

  @override
  void dispose() {
    _modelCtrl.dispose();
    _configCtrl.dispose();
    // _yearCtrl.dispose();
    _capacityCtrl.dispose();
    _powerCtrl.dispose();
    _horseCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSavePressed() async {
    if (_previewImagePath != null) {
      if (_savedImagePath != null) {
        try {
          File(_savedImagePath!).delete;
          debugPrint('Old image deleted: $_savedImagePath');
        } catch (error) {
          debugPrint("Can't delete $_savedImagePath: $error");
        }
      }
      _assetImage = await saveImageToMmry(_previewImagePath!);
    }

    if (!_favourite) {
      if (getFavouriteKey() == null) {
        _favourite = true;
      }
    }

    final vehicleMap = <String, dynamic>{
      'brand': _brand,
      'model': _modelCtrl.text.trim(),
      'config': _configCtrl.text.trim(),
      'year': _year ?? DateTime.now().year.toInt(),
      // 'year': int.tryParse(_yearCtrl.text),
      'capacity': int.tryParse(_capacityCtrl.text),
      'power': int.tryParse(_powerCtrl.text),
      'horse': int.tryParse(_horseCtrl.text),
      'category': _category,
      'energy': _energy,
      'ecology': _ecology,
      'favourite': _favourite,
      'assetImage': _assetImage,
    };

    if (!mounted) return;

    if (vehicleMap['brand'].isEmpty || vehicleMap['model'].isEmpty) {
      showCustomToast(context, message: 'Brand and model are required fields');
      return;
    }

    if (_favourite) {
      final oldFav = getFavouriteKey();
      if (oldFav != null) {
        final old = vehicleBox.get(oldFav) as Map;
        old['favourite'] = false;
        vehicleBox.put(oldFav, old);
      }
    }

    final newKey = await saveEvent(vehicleMap, widget.editKey);

    if (!mounted) return;

    Provider.of<VehicleProvider>(context, listen: false).favouriteKey =
        getFavouriteKey();

    log('fav key updated: ${getFavouriteKey()}');

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
                  hintText: 'Brand',
                  initialSelection: _brand,
                  dropdownMenuEntries: vehicleBrandList
                      .map(
                        (item) => DropdownMenuEntry(value: item, label: item),
                      )
                      .toList(),
                  trailingIcon: arrowDownIcon,
                  selectedTrailingIcon: arrowUpIcon,
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
                hintText: 'Model',
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
                hintText: 'Configuration',
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
                hintText: 'Cilindrata cc',
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
                hintText: 'Power kw',
                type: TextInputType.number,
                maxLength: 4,
                formatter: [FilteringTextInputFormatter.digitsOnly],
                controller: _powerCtrl,
                action: TextInputAction.next,
              ),
              const SizedBox(width: 8),
              customTextField(
                context,
                hintText: 'HorsePower cv',
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
                  name: 'Category',
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
                  name: 'Energy',
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
                  name: 'Ecology',
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
                    isSelected: _favourite,
                    onChanged: (value) {
                      setState(() {
                        _favourite = value;
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
                  text: isEdit ? 'Update' : 'Save',
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => showCustomToast(context, message: 'Brand opened'),
          child: Text('Brand non presente?'),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit vehicle' : 'Add a new vehicle'),
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

// DateTime selectedYear = DateTime.now();

// YearPicker yearPicker = YearPicker(
//   firstDate: DateTime(1995),
//   lastDate: DateTime(2050),
//   selectedDate: DateTime.now(),
//   onChanged: (value) => selectedYear = value,
// );

// Future<dynamic> showYearPicker(BuildContext context,) {
//   return showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("Select Year"),
//         content: SizedBox(
//           width: 300,
//           height: 300,
//           child: YearPicker(
//             firstDate: DateTime(DateTime.now().year - 100, 1),
//             lastDate: DateTime(DateTime.now().year + 100, 1),
//             selectedDate: selectedYear,
//             onChanged: (DateTime dateTime) {
//               selectedYear = dateTime;
//               Navigator.pop(context);
//             },
//           ),
//         ),
//       );
//     },
//   );
// }
