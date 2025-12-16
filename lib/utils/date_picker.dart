import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/theme/icons.dart';

class DatePickerWidget extends StatefulWidget {
  final ValueChanged<DateTime>? onSelected;
  final DateTime? editDate;
  final HugeIcon? pickerIcon;
  final DateTime? preSelectedDate;
  const DatePickerWidget({
    super.key,
    this.onSelected,
    this.editDate,
    this.pickerIcon,
    this.preSelectedDate,
  });

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? selectedDate;
  DateTime now = DateTime.now();
  DateTime get today => DateTime(now.year, now.month, now.day);
  DateTime? dateToShow;

  @override
  void initState() {
    super.initState();
    if (widget.editDate != null) {
      dateToShow = widget.editDate;
    } else {
      dateToShow = widget.preSelectedDate ?? today;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dateToShow,
      firstDate: DateTime(2005),
      lastDate: DateTime(2050),
    );

    setState(() {
      selectedDate = pickedDate;
      if (selectedDate != null) {
        widget.onSelected?.call(selectedDate!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Expanded(
      child: OutlinedButton(
        onPressed: _selectDate,
        style: OutlinedButton.styleFrom(
          minimumSize: Size(double.infinity, 55),
          alignment: AlignmentGeometry.directional(-0.9, 0),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyMedium,
                selectedDate != null
                    ? localizations.ggMmAaaa(
                        selectedDate!.day,
                        selectedDate!.month,
                        selectedDate!.year,
                      )
                    : localizations.ggMmAaaa(
                        dateToShow!.day,
                        dateToShow!.month,
                        dateToShow!.year,
                      ),
              ),
              widget.pickerIcon ?? calendarIcon, //
            ],
          ),
        ),
      ),
    );
  }
}
