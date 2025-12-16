import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/settings/settings_logics.dart';
import 'package:mycargenie_2/utils/puzzle.dart';
import 'package:provider/provider.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final settingsProvider = context.read<SettingsProvider>();
    final currentTheme = context.select((SettingsProvider p) => p.themeMode);

    final systemTheme = context.select(
      (SettingsProvider p) => p.followsSystemTheme,
    );

    var isUsingSystemTheme = systemTheme;

    log('system theme: $systemTheme');

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.themeSettings),
        leading: customBackButton(context),
      ),
      body: ListView(
        // padding: const EdgeInsets.all(16.0),
        children: [
          // Theme Mode Switch
          // Text('Dark Mode', style: Theme.of(context).textTheme.headlineSmall),
          ListTile(
            title: Text(
              localizations.followSystemTheme,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            trailing: Switch(
              value: systemTheme == true,
              onChanged: (followsSystem) {
                log('passing bool for using system theme: $followsSystem');

                settingsProvider.setFollowSystemTheme(followsSystem);

                isUsingSystemTheme = !isUsingSystemTheme;

                log('current theme is: $currentTheme');
              },
            ),
          ),

          animateChildFromTop(
            Divider(height: 20),
            !isUsingSystemTheme,
            'hidden-divider',
          ),

          animateChildFromTop(
            ListTile(
              title: Text(
                localizations.darkMode,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              trailing: Switch(
                value: currentTheme == ThemeMode.dark,
                onChanged: (isDark) {
                  systemTheme == true
                      ? null
                      : settingsProvider.setThemeMode(
                          isDark ? ThemeMode.dark : ThemeMode.light,
                        );
                },
              ),
            ),
            !isUsingSystemTheme,
            'hidden-dark',
          ),
        ],
      ),
    );
  }
}

Widget animateChildFromTop(Widget child, bool condition, String key) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 100),
    transitionBuilder: (Widget child, Animation<double> animation) {
      return SizeTransition(
        sizeFactor: animation,
        axisAlignment: -1.0,
        child: child,
      );
    },
    child: condition ? child : const SizedBox.shrink(key: ValueKey('hidden')),
  );
}
