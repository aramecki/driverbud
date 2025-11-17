import 'package:flutter/material.dart';

class Invoices extends StatefulWidget {
  const Invoices({super.key});

  @override
  State<Invoices> createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text('Work in progress')],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Invoices')),
      body: content,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: pickFile,
      //   child: const Icon(Icons.outlet),
      // ),
    );
  }
}
