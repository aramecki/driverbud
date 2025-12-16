import 'package:flutter/material.dart';
import 'package:mycargenie_2/settings/backup/backup_restore_screen.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/settings/currency_settings.dart';
import 'package:mycargenie_2/settings/language_settings.dart';
import 'package:mycargenie_2/settings/theme_settings.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/puzzle.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final content = ListView(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(child: languageIcon),
          title: Text(
            localizations.language,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          onTap: () => navigateToPage(context, LanguageSettingsPage()),
        ),
        Divider(height: 22),
        ListTile(
          leading: CircleAvatar(child: regionIcon),
          title: Text(
            localizations.country,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        Divider(height: 22),
        ListTile(
          leading: CircleAvatar(child: currencyIcon),
          title: Text(
            localizations.currency,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          onTap: () => navigateToPage(context, CurrencySettingsPage()),
        ),
        Divider(height: 22),
        ListTile(
          leading: CircleAvatar(child: themeIcon),
          title: Text(
            localizations.theme,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          onTap: () => navigateToPage(context, ThemeSettingsPage()),
        ),
        Divider(height: 22),
        ListTile(
          leading: CircleAvatar(child: backupAndRestoreIcon),
          title: Text(
            localizations.backupAndRestore,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          onTap: () => navigateToPage(context, BackupRestoreScreen()),
        ),
        Divider(height: 22),
        ListTile(
          leading: CircleAvatar(child: feedbackIcon),
          title: Text(
            localizations.gotAFeedback,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          // onTap: () => navigateToPage(context, BackupRestoreScreen()),
        ),
        Divider(height: 22),
        ListTile(
          leading: CircleAvatar(child: infoIcon),
          title: Text(
            localizations.about,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          // onTap: () => navigateToPage(context, BackupRestoreScreen()),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
        leading: customBackButton(context),
      ),
      body: content,
    );
  }
}

void navigateToPage(BuildContext context, dynamic screen) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
}
