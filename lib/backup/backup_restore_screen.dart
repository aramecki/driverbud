import 'package:flutter/material.dart';
import 'package:mycargenie_2/backup/backup.dart';
import 'package:mycargenie_2/backup/restore.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/utils/puzzle.dart';
import 'package:provider/provider.dart';

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  final List<String> _boxNames = ['vehicle', 'maintenance', 'refueling'];
  String _statusBackup = '';
  String _statusRestore = '';
  bool _isBackingUp = false;
  bool _isRestoring = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final vehicleProvider = Provider.of<VehicleProvider>(context);

    final content = Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: OutlinedButton(
                  style: ButtonStyle(
                    textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 20)),
                  ),
                  onPressed: () => _performBackup(localizations),
                  child: Text(localizations.exportBackup),
                ),
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            if (_isBackingUp)
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ),
            Text(_statusBackup, style: TextStyle(fontSize: 18)),
          ],
        ),

        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: OutlinedButton(
                  style: ButtonStyle(
                    textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 20)),
                  ),
                  onPressed: () =>
                      _performRestore(vehicleProvider, localizations),
                  child: Text(localizations.restoreBackup),
                ),
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            if (_isRestoring)
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ),
            Text(_statusRestore, style: TextStyle(fontSize: 18)),
          ],
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.backupAndRestore),
        leading: customBackButton(context),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: content,
      ),
    );
  }

  Future<void> _performBackup(AppLocalizations localizations) async {
    setState(() {
      _statusBackup = localizations.creatingBackupFile;
      _isBackingUp = true;
    });

    final String? path = await backupBoxesToPath(_boxNames);
    setState(() {
      if (path != null) {
        _statusBackup = localizations.backupCompleted;
        _isBackingUp = false;
      } else {
        _statusBackup = localizations.processNotCompleted(
          localizations.backupUpper,
        );
        _isBackingUp = false;
      }
    });
  }

  Future<void> _performRestore(
    VehicleProvider vehicleProvider,
    AppLocalizations localizations,
  ) async {
    setState(() {
      _statusRestore = localizations.restoringFile;
      _isRestoring = true;
    });

    final bool success = await restoreBoxFromPath(vehicleProvider);

    setState(() {
      if (success) {
        _statusRestore = localizations.restoredSuccessfully;
        _isRestoring = false;
      } else {
        _statusRestore = localizations.processNotCompleted(
          localizations.restorationUpper,
        );
        _isRestoring = false;
      }
    });
  }
}
