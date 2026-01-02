import 'package:flutter/widgets.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';

final List<Map<String, String>> currenciesList = [
  {'symbol': '€', 'name': 'Euro', 'code': 'EUR', 'country': ''},
  {'symbol': 'zł', 'name': 'Złoty', 'code': 'PLN', 'country': 'PL'},
  {'symbol': 'Ft', 'name': 'Forint', 'code': 'HUF', 'country': 'HU'},
  {'symbol': 'Kč', 'name': 'Česká Koruna', 'code': 'CZK', 'country': 'CZ'},
  {
    'symbol': 'kr',
    'name': 'Svensk Krona/Dansk Krone',
    'code': 'SEK/DKK',
    'country': 'SE/DK',
  },
  {'symbol': 'lei', 'name': 'Leu Românesc', 'code': 'RON', 'country': 'RO'},
  {'symbol': 'лв', 'name': 'Български Лев', 'code': 'BGN', 'country': 'BG'},
];

// List<String> getVehicleCategoryList(BuildContext context) {
//   final localizations = AppLocalizations.of(context)!;
//   return [localizations.cars, localizations.motorcycles, localizations.other];
// }

Map<int, String> getVehicleCategoryList(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  return {
    1: localizations.cars,
    2: localizations.motorcycles,
    3: localizations.other,
  };
}

List<String> getVehicleTypeList(BuildContext context) {
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

const List<String> carBrandList = <String>[
  'Abarth',
  'Alfa Romeo',
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
  'Daihatsu',
  'Dodge',
  'DS',
  'Ferrari',
  'Fiat',
  'Ford',
  'Genesis',
  'Honda',
  'Hyundai',
  'Infiniti',
  'Jaguar',
  'Jeep',
  'Kia',
  'Lamborghini',
  'Lancia',
  'Land Rover',
  'Lexus',
  'Maserati',
  'Mazda',
  'Mercedes-Benz',
  'Mini',
  'Mitsubishi',
  'Nissan',
  'Opel',
  'Peugeot',
  'Porsche',
  'Renault',
  'Rolls-Royce',
  'SEAT',
  'Škoda',
  'Smart',
  'Ssangyong/KGM',
  'Subaru',
  'Suzuki',
  'Tesla',
  'Toyota',
  'Volkswagen',
  'Volvo',
];

const List<String> motorcycleBrandList = <String>[
  'Aprilia',
  'BMW',
  'Ducati',
  'Harley-Davidson',
  'Honda',
  'Kawasaki',
  'KTM',
  'Moto Guzzi',
  'MV Agusta',
  'Piaggio',
  'Suzuki',
  'Sym',
  'Triumph',
  'Yamaha',
  'Zero Motorcycles',
];

const List<String> otherBrandList = <String>[
  'DAF',
  'Hymer',
  'Iveco',
  'MAN',
  'MANS',
  'Scania',
  'Renault Trucks',
  'Fuso',
  'Adria',
  'Bürstner',
  'Chausson',
  'Isuzu',
];
