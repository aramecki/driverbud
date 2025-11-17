import 'package:flutter/material.dart';

class Refueling extends StatefulWidget {
  const Refueling({super.key});

  @override
  State<Refueling> createState() => _RefuelingState();
}

class _RefuelingState extends State<Refueling> {
  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text('Work in progress')],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Refueling')),
      body: content,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: pickFile,
      //   child: const Icon(Icons.outlet),
      // ),
    );
  }
}
