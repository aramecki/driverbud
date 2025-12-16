import 'package:flutter/material.dart';
import '../utils/puzzle.dart';

class VehicleInfo extends StatelessWidget {
  const VehicleInfo({super.key});

  @override
  Widget build(BuildContext context) {
    // final localizations = AppLocalizations.of(context)!;

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text('Work in progress')],
    );

    return Scaffold(
      appBar: AppBar(leading: customBackButton(context)),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(child: content),
      ),
    );
  }
}
