import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Custom reusable text field
Widget customTextField(
  BuildContext context, {
  required TextEditingController controller,
  Widget? suffixIcon,
  required String hintText,
  String counterText = '',
  int minLines = 1,
  int maxLines = 1,
  int maxLength = 15,
  TextInputType type = TextInputType.text,
  TextInputAction? action,
  List<TextInputFormatter>? formatter,
  void Function(String text)? format,
  ValueChanged<String>? onSubmitted,
}) {
  return Expanded(
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        suffixIconConstraints: BoxConstraints(maxHeight: 30.0, maxWidth: 30.0),
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        counterText: counterText,
      ),
      keyboardType: type,
      textInputAction: action,
      textCapitalization: TextCapitalization.sentences,
      autocorrect: true,
      maxLength: maxLength,
      minLines: 1,
      maxLines: maxLines,
      inputFormatters: formatter,
      onChanged: format,
      onSubmitted: onSubmitted,
    ),
  );
}
