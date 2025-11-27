import 'package:flutter/material.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';

class Invoices extends StatefulWidget {
  const Invoices({super.key});

  @override
  State<Invoices> createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text('Work in progress')],
    );

    return Scaffold(
      appBar: AppBar(title: Text(localizations.invoices)),
      body: content,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: pickFile,
      //   child: const Icon(Icons.outlet),
      // ),
    );
  }
}
