import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycargenie_2/theme/icons.dart';

class IncrementableTextField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String text)? onChanged;

  const IncrementableTextField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  final iconSize = 38.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100.0,
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(color: Colors.deepOrange, width: 2.0),
          ),
          child: TextFormField(
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
              ),
            ),
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            onChanged: (value) {
              log('setting $value');
              if (value != '') {
                if (int.parse(value) > 12) {
                  controller.text = '12';
                }
                if (int.parse(value) < 1) {
                  controller.text = '1';
                }
              }
              onChanged?.call(value);
            },
          ),
        ),

        Padding(
          padding: EdgeInsetsGeometry.only(right: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Material(
                clipBehavior: Clip.antiAlias,
                shape: const CircleBorder(),
                child: InkWell(
                  child: arrowUpIcon(iconSize: iconSize),
                  onTap: () {
                    int currentValue = int.parse(controller.text);

                    if (currentValue < 12) {
                      currentValue++;
                      controller.text = (currentValue).toString();
                    }
                    onChanged?.call(controller.text);
                  },
                ),
              ),

              SizedBox(height: 2),

              Material(
                clipBehavior: Clip.antiAlias,
                shape: const CircleBorder(),
                child: InkWell(
                  child: arrowDownIcon(iconSize: iconSize),
                  onTap: () {
                    int currentValue = int.parse(controller.text);

                    if (currentValue > 1) {
                      currentValue--;
                      controller.text = currentValue.toString();
                    }
                    onChanged?.call(controller.text);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
