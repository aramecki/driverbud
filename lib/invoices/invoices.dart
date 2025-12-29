// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/invoices/tax.dart';
import 'package:mycargenie_2/invoices/inspection.dart';
import 'package:mycargenie_2/invoices/insurance.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/notifications/notifications_utils.dart';
import 'package:mycargenie_2/settings/currency_settings.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/puzzle.dart';
import 'package:provider/provider.dart';

class Invoices extends StatefulWidget {
  const Invoices({super.key});

  @override
  State<Invoices> createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  @override
  Widget build(BuildContext context) {
    final vehicleKey = Provider.of<VehicleProvider>(
      context,
      listen: false,
    ).vehicleToLoad;

    final localizations = AppLocalizations.of(context)!;

    final content = vehicleKey != null
        ? ListView(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(child: insuranceIcon),
                title: Text(
                  localizations.thirdPartyInsurance,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onTap: () =>
                    navigateToPage(context, Insurance(vehicleKey: vehicleKey)),
              ),
              Divider(height: 22),
              ListTile(
                leading: CircleAvatar(child: taxIcon),
                title: Text(
                  localizations.tax,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onTap: () =>
                    navigateToPage(context, Tax(vehicleKey: vehicleKey)),
              ),
              Divider(height: 22),
              ListTile(
                leading: CircleAvatar(child: revisionIcon),
                title: Text(
                  localizations.inspection,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onTap: () =>
                    navigateToPage(context, Inspection(vehicleKey: vehicleKey)),
              ),
              Divider(height: 22),
              Row(children: [Text(localizations.expiring)]),
            ],
          )
        : Column(
            //mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localizations.youWillFindInvoices,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              if (vehicleKey == null)
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 18),
                  child: Text(
                    localizations.createYourFirstVehicleToVisualize,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          );

    return Scaffold(
      appBar: AppBar(title: Text(localizations.invoices)),
      body: content,
    );
  }
}

void navigateToPage(BuildContext context, dynamic screen) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
}
