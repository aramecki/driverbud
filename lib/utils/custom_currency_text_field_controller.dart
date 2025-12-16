import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:mycargenie_2/settings/settings_logics.dart';
import 'package:provider/provider.dart';

CurrencyTextFieldController customCurrencyTextFieldController(
  BuildContext context,
) {
  final settingsProvider = context.read<SettingsProvider>();
  final currencySymbol = settingsProvider.currency;

  return CurrencyTextFieldController(
    currencySymbol: currencySymbol!,
    decimalSymbol: ',',
    thousandSymbol: ' ',
    maxDigits: 8,
    enableNegative: false,
  );
}
