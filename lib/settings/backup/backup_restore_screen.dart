import 'package:flutter/material.dart';
import 'package:mycargenie_2/settings/backup/backup.dart';
import 'package:mycargenie_2/settings/backup/restore.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/theme/text_styles.dart';
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

    final content = ListView(
      children: [
        ListTile(
          title: Text(
            localizations.exportBackup,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          subtitle: _statusBackup != '' ? Text(_statusBackup) : null,
          trailing: _isBackingUp ? sizedProgressIndicator() : null,
          onTap: () => _performBackup(localizations),
        ),
        Divider(height: 20),
        ListTile(
          title: Text(
            localizations.restoreBackup,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          subtitle: _statusRestore != '' ? Text(_statusRestore) : null,
          trailing: _isRestoring ? sizedProgressIndicator() : null,
          onTap: () => _performRestore(vehicleProvider, localizations),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 34),
          child: Text(
            localizations.backupFileWontContainImage,
            textAlign: TextAlign.center,
            style: bottomMessageStyle,
          ),
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

Widget sizedProgressIndicator() {
  return SizedBox(height: 20, width: 20, child: CircularProgressIndicator());
}
