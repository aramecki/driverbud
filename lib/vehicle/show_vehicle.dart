import 'package:flutter/material.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'dart:io';
import '../utils/puzzle.dart';

class ShowVehicle extends StatefulWidget {
  final Map<String, dynamic>? vehicle;
  final dynamic editKey;

  const ShowVehicle({super.key, this.vehicle, this.editKey});

  @override
  State<ShowVehicle> createState() => _ShowVehicleState();
}

class _ShowVehicleState extends State<ShowVehicle> {
  String? _brand;
  String? _model;
  String? _config;
  String? _year;
  String? _capacity;
  String? _power;
  String? _horse;
  String? _category;
  String? _energy;
  String? _ecology;
  bool? _favourite;
  String? _assetImage;

  @override
  void initState() {
    super.initState();

    final v = widget.vehicle;

    if (v != null) {
      _assetImage = v['assetImage'] as String?;

      _brand = v['brand'] ?? '';
      _model = v['model'] ?? '';
      _config = v['config'] ?? '';
      _year = v['year']?.toString() ?? '';
      _capacity = v['capacity']?.toString() ?? '';
      _power = v['power']?.toString() ?? '';
      _horse = v['horse']?.toString() ?? '';

      _category = v['category'] as String?;
      _energy = v['energy'] as String?;
      _ecology = v['ecology'] as String?;
      _favourite = v['favourite'] ?? false;
    }
  }

  // TODO: Stylize because it's very very very ugly
  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 12),
          child: CircleAvatar(
            radius: 100,
            backgroundColor: Colors.deepOrange,
            backgroundImage: _assetImage != null
                ? FileImage(File(_assetImage!))
                : null,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                '$_brand $_model',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [if (_config != null) Text(_config!)],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (_year != null) Text(_year!),
              const SizedBox(width: 8),
              if (_capacity != null) Text(_capacity!),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (_power != null) Text(_power!),
              const SizedBox(width: 8),
              if (_horse != null) Text(_horse!),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (_category != null) Text(_category!),
              const SizedBox(width: 8),
              if (_energy != null) Text(_energy!),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [if (_ecology != null) Text(_ecology!)],
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     mainAxisSize: MainAxisSize.max,
        //     children: [
        //       Expanded(
        //         child: buildAddButton(
        //           context,
        //           onPressed: () =>
        //               showCustomToast(context, message: 'You clicked edit'),
        //           text: 'Edit',
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        // title: Text('$_brand $_model'),
        leading: customBackButton(context),

        actions: <Widget>[
          if (_favourite == true)
            // Padding(
            //   padding: EdgeInsetsGeometry.all(10),
            //   child:
            activeStarIcon,

          // ),
          IconButton(
            padding: EdgeInsets.all(0),
            icon: shareIcon,
            onPressed: () {
              showCustomToast(context, message: 'Share opened');
            },
          ),
        ],
      ),
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
