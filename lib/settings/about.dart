import 'package:flutter/material.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/theme/text_styles.dart';
import 'package:mycargenie_2/utils/puzzle.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({super.key});

  static const String appVersion = 'v0.3.0-alpha';
  static const String gitHub = 'GitHub';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final content = Column(
      children: [
        const SizedBox(height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              localizations.appName,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
        const Text(appVersion, style: bottomMessageStyle),
        const SizedBox(height: 50),

        Text(localizations.aSoloProject, style: const TextStyle(fontSize: 18)),
        SizedBox(height: 15),

        Text(localizations.getMoreInfoOn),
        const SizedBox(height: 5),

        const ElevatedButton(onPressed: _launchURL, child: Text(gitHub)),
      ],
    );

    return Scaffold(
      appBar: AppBar(leading: customBackButton(context)),
      body: content,
    );
  }
}

Future<void> _launchURL() async {
  final Uri url = Uri.parse('https://github.com/aramecki/driverbud');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
