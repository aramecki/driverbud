import 'package:flutter/widgets.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';

List<String> getVehicleCategoryList(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  return [
    localizations.sedan,
    localizations.coupe,
    localizations.sportsCar,
    localizations.suv,
    localizations.stationWagon,
    localizations.minivan,
    localizations.supercar,
    localizations.other,
  ];
}

// const List<String> vehicleCategoryList = <String>[
//   'Berlina',
//   'Coupé',
//   'Sportiva',
//   'SUV',
//   'Station Wagon',
//   'Monovolume',
//   'Supercar',
//   'Altro',
// ];

List<String> getVehicleEnergyList(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  return [
    localizations.petrol,
    localizations.diesel,
    localizations.lpg,
    localizations.cng,
    localizations.electric,
    localizations.other,
  ];
}

// const List<String> vehicleEnergyList = <String>[
//   'Benzina',
//   'Gasolio',
//   'GPL',
//   'Metano',
//   'Elettrico',
//   'Altro',
// ];

const List<String> vehicleEcoList = <String>[
  'Euro 1',
  'Euro 2',
  'Euro 3',
  'Euro 4',
  'Euro 5',
  'Euro 6 (ABCD)',
  'Altro',
];

List<String> getMaintenanceTypeList(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  return [
    localizations.mechanic,
    localizations.electrician,
    localizations.bodyShop,
    localizations.other,
  ];
}

// const List<String> maintenanceTypeList = <String>[
//   'Meccanico',
//   'Elettrauto',
//   'Carroziere',
//   'Altro',
// ];

// TODO: Valuate if changing the ui to make the user select the vehicle category first
// TODO: Valuate if divide the list in cars and motorbikes brand
// TODO: Valuate if inserting truck brands too

const List<String> vehicleBrandList = <String>[
  'Abarth',
  'Alfa Romeo',
  'Aprilia',
  'Aston Martin',
  'Audi',
  'Bentley',
  'BMW',
  'Cadillac',
  'Chevrolet',
  'Chrysler',
  'Citroën',
  'Cupra',
  'Dacia',
  'Daihatsu', // Remove? (Retired from European market, but plenty of used vehicles)
  'Dodge',
  'Ducati',
  'DS',
  'Ferrari',
  'Fiat',
  'Ford',
  'Genesis',
  'Harley-Davidson',
  'Honda',
  'Hyundai',
  'Infiniti', // Remove? (Retired from European market, evaluate how spread in used market)
  'Jaguar',
  'Jeep',
  'Kawasaki',
  'Kia',
  'KTM',
  'Lamborghini',
  'Lancia',
  'Land Rover',
  'Lexus',
  'Maserati',
  'Mazda',
  'Mercedes-Benz',
  'Mini',
  'Mitsubishi',
  'Moto Guzzi',
  'MV Agusta',
  'Nissan',
  'Opel',
  'Peugeot',
  'Piaggio',
  'Porsche',
  'Renault',
  'Rolls-Royce',
  'SEAT',
  'Škoda',
  'Smart',
  'Ssangyong/KGM', // Chose? If the choise is 'KGM' only move it under 'Kawasaki'
  'Subaru',
  'Suzuki',
  'Sym',
  'Tesla',
  'Toyota',
  'Triumph',
  'Volkswagen',
  'Volvo',
  'Yamaha',
  'Zero Motorcycles',
];
