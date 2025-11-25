import 'package:flutter/material.dart';
import 'package:mycargenie_2/theme/icons.dart';

class YearPickerButton extends StatefulWidget {
  final ValueChanged<DateTime>? onSelected;
  final DateTime? editDate;
  const YearPickerButton({super.key, this.onSelected, this.editDate});

  @override
  State<YearPickerButton> createState() => _YearPickerButtonState();
}

class _YearPickerButtonState extends State<YearPickerButton> {
  DateTime now = DateTime.now();
  DateTime get thisYear => DateTime(now.year);
  DateTime? selectedYear;
  DateTime? dateToShow;

  @override
  void initState() {
    super.initState();
    if (widget.editDate != null) {
      selectedYear = widget.editDate;
      dateToShow = widget.editDate;
    } else {
      selectedYear = thisYear;
    }
  }

  Future<dynamic> showYearPicker(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Year"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 100, 1),
              lastDate: DateTime(DateTime.now().year),
              selectedDate: selectedYear,
              onChanged: (DateTime pickedYear) {
                setState(() {
                  // log(
                  //   'picked year: $pickedYear, selectedYear: $selectedYear, dateToShow: $dateToShow',
                  // );
                  selectedYear = pickedYear;
                  dateToShow = pickedYear;
                  if (selectedYear != null) {
                    // log('calling');
                    widget.onSelected?.call(selectedYear!);
                  }
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => showYearPicker(context),
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
                dateToShow != null ? '${dateToShow!.year}' : 'Year',
              ),
              calendarIcon,
            ],
          ),
        ),
      ),
    );
  }
}
