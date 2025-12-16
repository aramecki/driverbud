import 'package:flutter/material.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/settings/settings_logics.dart';
import 'package:mycargenie_2/theme/colors.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/lists.dart';
import 'package:mycargenie_2/utils/puzzle.dart';
import 'package:provider/provider.dart';

class CurrencySettingsPage extends StatelessWidget {
  const CurrencySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final settingsProvider = context.read<SettingsProvider>();
    final currentCurrency = context.select((SettingsProvider p) => p.currency);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.currencySettings),
        leading: customBackButton(context),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 8),
          ...currenciesList.map((currency) {
            String currencySymbol = currency['symbol']!;
            final isSelected = currencySymbol == currentCurrency;

            return Card(
              color: isSelected ? null : darkGrey,
              margin: EdgeInsets.symmetric(vertical: 12),
              child: ListTile(
                leading: Text(currencySymbol),
                title: Text(
                  currency['name']!,
                  style: TextStyle(
                    color: isSelected ? darkGrey : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: isSelected ? checkIcon : null,
                onTap: () {
                  settingsProvider.setCurrency(currencySymbol);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

String parseShowedPrice(String price) {
  return price.replaceAll('.', ',');
}

// String getCurrencyDecimalDivider(String currencySymbol) {
//   for (var currency in currenciesList) {
//     if (currency['symbol'] == currencySymbol) {
//       return currency['decimalDivider']!;
//     }
//   }
//   return '.';
// }

// String getCurrencyThousandDivider(String decimalDivider) {
//   if (decimalDivider == ',') {
//     return '.';
//   } else {
//     return ',';
//   }
// }

// String parseShowedPrice(String price, String currencySymbol) {
//   for (var currency in currenciesList) {
//     if (currencySymbol == currency['symbol']) {
//       if (currency['decimalDivider'] == ',') {
//         return price.replaceAll('.', ',');
//       }
//     }
//   }
//   return price;
// }
