import 'package:flutter/material.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/theme/text_styles.dart';
import 'package:mycargenie_2/utils/puzzle.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final content = Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      //crossAxisAlignment: CrossAxisAlignment.center,
      //mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'DriverBud',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
        Text('v0.0.2', style: bottomMessageStyle),
        SizedBox(height: 50),

        Text('A solo project by aramecki', style: TextStyle(fontSize: 18)),
        SizedBox(height: 15),

        Text('Get more info on:'),
        SizedBox(height: 5),

        ElevatedButton(onPressed: _launchURL, child: Text('GitHub')),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        //title: Text(localizations.settings),
        leading: customBackButton(context),
      ),
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
