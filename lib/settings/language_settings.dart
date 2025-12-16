import 'package:flutter/material.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/settings/settings_logics.dart';
import 'package:mycargenie_2/theme/colors.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/puzzle.dart';
import 'package:provider/provider.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final settingsProvider = context.read<SettingsProvider>();
    final currentLocale = context.select((SettingsProvider p) => p.locale);

    final List<Map<String, String>> languages = [
      {'code': 'en', 'name': 'English'},
      {'code': 'it', 'name': 'Italiano'},
      // {'code': 'es', 'name': 'Español'},
      // {'code': 'fr', 'name': 'Français'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.languageSettings),
        leading: customBackButton(context),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 8),
          ...languages.map((lang) {
            final locale = Locale(lang['code']!);
            final isSelected =
                locale.languageCode == currentLocale!.languageCode;

            return Card(
              color: isSelected ? null : darkGrey,
              margin: EdgeInsets.symmetric(vertical: 12),
              child: ListTile(
                title: Text(
                  lang['name']!,
                  style: TextStyle(
                    color: isSelected ? darkGrey : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: isSelected ? checkIcon : null,
                onTap: () {
                  settingsProvider.setLocale(locale);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
