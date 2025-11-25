import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mycargenie_2/boxes.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/sorting_funs.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showCustomToast(
  BuildContext context, {
  required String message,
  Duration duration = const Duration(seconds: 3),
  Color backgroundColor = Colors.deepOrangeAccent,
  VoidCallback? onUndo,
  double? topMargin,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
      backgroundColor: backgroundColor,
      elevation: 6.0,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      margin: EdgeInsets.only(left: 30, right: 30, bottom: 10),
    ),
  );
}

// Adaptive button
Widget buildAddButton(
  BuildContext context, {
  required VoidCallback onPressed,
  required String text,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(50),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    ),
    child: Text(text, style: TextStyle(fontSize: 20)),
  );
}

// Fun to parse strings into ints removing chars
// int? parseDigits(String input) {
//   final digitsOnly = input.replaceAll(RegExp(r'[^0-9]'), '');
//   return int.tryParse(digitsOnly);
// }

class CustomCheckbox extends StatefulWidget {
  final ValueChanged<bool> onChanged;

  const CustomCheckbox({super.key, required this.onChanged});

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool _isSelected = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _isSelected = widget.initialValue;
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Checkbox(
            shape: CircleBorder(),
            value: _isSelected,
            onChanged: (bool? newValue) {
              if (newValue == null) return;
              setState(() {
                _isSelected = newValue;
              });
              widget.onChanged(_isSelected);
            },
          ),
        ),
        Text(
          'Favourite',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// Custom switch
class CustomSwitch extends StatelessWidget {
  final bool isSelected;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    super.key,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Switch(value: isSelected, onChanged: onChanged),
        const SizedBox(width: 4),

        Text(
          'Favourite',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// CustomSlideableAction custom icon
Widget slideableIcon(
  BuildContext context, {
  required SlidableActionCallback? onPressed,
  required HugeIcon icon,
  Color color = Colors.deepOrange,
}) {
  return CustomSlidableAction(
    onPressed: onPressed,
    autoClose: true,
    backgroundColor: Colors.transparent,
    //alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: 3),
    child: SizedBox.expand(
      //child: Center(
      child: Container(
        width: 28,
        height: 28,
        padding: const EdgeInsets.all(2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: icon,
      ),
      //),
    ),
  );
}

// Box containing latest events for selected vehicle in home screen
Widget homeRowBox(
  BuildContext context, {
  //   required VoidCallback onPressed,
  required bool isRefueling,
  required String date,
  String? title,
  String? place,
  String? price,
  String? priceForUnit,
}) {
  TextStyle textStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);

  return Padding(
    padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 8),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepOrange, width: 2),
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: isRefueling
                ? [
                    Text(date, style: textStyle),
                    if (price != null) Text(price, style: textStyle),
                  ]
                : [Text(title!, style: textStyle)],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: isRefueling
                ? [
                    if (place != null) Text(place, style: textStyle),
                    if (priceForUnit != null)
                      Text(priceForUnit, style: textStyle),
                  ]
                : [
                    if (place != null) Text(place, style: textStyle),
                    Text(date, style: textStyle),
                  ],
          ),
        ],
      ),
    ),
  );
}

// Custom back button for appbar
Widget customBackButton(BuildContext context) {
  return IconButton(
    icon: backIcon,
    onPressed: () => Navigator.of(context).pop(),
  );
}

Widget customSortingPanel(
  BuildContext context,
  void Function(String sortType) onSort,
  bool isDecrementing,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    spacing: 12,
    children: [
      HugeIcon(
        icon: isDecrementing
            ? HugeIcons.strokeRoundedSorting01
            : HugeIcons.strokeRoundedSorting02,
      ),
      OutlinedButton(
        onPressed: () {
          onSort('name');
        },
        child: Text(textAlign: TextAlign.center, "Titolo"),
      ),
      OutlinedButton(
        onPressed: () {
          onSort('price');
        },
        child: Text(textAlign: TextAlign.center, "Prezzo"),
      ),
      OutlinedButton(
        onPressed: () {
          onSort('date');
        },
        child: Text(textAlign: TextAlign.center, "Data"),
      ),
    ],
  );
}

// TODO: Complete search logic
Widget customSearchingPanel(
  BuildContext context,
  void Function(String, List<Map<String, dynamic>>) onChange,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    spacing: 12,
    children: [
      Expanded(
        child: TextField(
          autofocus: true,
          decoration: InputDecoration(
            // prefixIcon: Padding(
            //   padding: EdgeInsetsGeometry.only(left: 8),
            //   child: searchIcon,
            // ),
            // prefixStyle: TextStyle(),
            hintText: 'Cerca tra le manutenzioni',
            floatingLabelBehavior: FloatingLabelBehavior.never,
            counterText: '',
          ),
          keyboardType: TextInputType.text,
          maxLength: 20,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          onChanged: (value) {
            if (value.isEmpty) {
              onChange('', []);
              return;
            }

            List<Map<String, dynamic>> result = searchByText(
              maintenanceBox,
              value,
            );
            log(result.toString());
            onChange(value, result);
          },
        ),
      ),
    ],
  );
}
