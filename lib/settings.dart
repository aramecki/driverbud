import 'package:flutter/material.dart';
import 'package:mycargenie_2/backup/backup_restore_screen.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
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

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => BackupRestoreScreen())),
          child: Text('Backup'),
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
