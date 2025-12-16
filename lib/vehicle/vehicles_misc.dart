import 'package:flutter/material.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/support_fun.dart';
import 'package:provider/provider.dart';

Widget? favoriteIconButton(bool? isEnabled, VoidCallback onChanged) {
  return IconButton(
    icon: isEnabled == true ? activeStarIcon : emptyStarIcon,
    onPressed: isEnabled == true ? null : onChanged,
  );
}

bool isEnabled(int itemId, int? favoriteItemId) {
  if (itemId == favoriteItemId) {
    return true;
  }
  return false;
}

Widget vehiclesListTile(
  BuildContext context,
  dynamic item,
  dynamic vehicleKey,
  Function onChanged,
) {
  final localizations = AppLocalizations.of(context)!;
  final vehicleProvider = Provider.of<VehicleProvider>(context);

  String vehicleTitle = '${item['brand']} ${item['model']}';

  int? vehiclePowerInt = item['power'];
  String? vehiclePower = vehiclePowerInt != null
      ? localizations.numKw(vehiclePowerInt)
      : null;

  int? vehicleHorseInt = item['horse'];
  String? vehicleHorse = vehicleHorseInt != null
      ? localizations.numCv(vehicleHorseInt)
      : null;

  int? vehicleCapacityInt = item['capacity'];
  String? vehicleCapacity = vehicleCapacityInt != null
      ? localizations.numCc(vehicleCapacityInt)
      : null;

  return SizedBox(
    child: ListTile(
      onTap: () => openShowVehicle(context, vehicleKey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      title: Text(vehicleTitle),
      subtitle: Row(
        children: [
          if (vehiclePower != null) Text('$vehiclePower '),
          if (vehicleHorse != null) Text('$vehicleHorse '),
          if (vehicleCapacity != null) Text(vehicleCapacity),
        ],
      ),
      trailing: favoriteIconButton(
        isEnabled(vehicleKey, vehicleProvider.favoriteKey),
        () {
          onChanged();
        },
      ),
    ),
  );
}
