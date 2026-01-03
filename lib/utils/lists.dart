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

Map<int, String> getVehicleCategoryList(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  return {
    1: localizations.cars,
    2: localizations.motorcycles,
    3: localizations.other,
  };
}

Map<int, String> getVehicleTypeList(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  return {
    1: localizations.sedan,
    2: localizations.coupe,
    3: localizations.sportsCar,
    4: localizations.suv,
    5: localizations.stationWagon,
    6: localizations.minivan,
    7: localizations.supercar,
    8: localizations.other,
  };
}

Map<int, String> getVehicleEnergyList(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  return {
    1: localizations.petrol,
    2: localizations.diesel,
    3: localizations.lpg,
    4: localizations.cng,
    5: localizations.electric,
    6: localizations.other,
  };
}

Map<int, String> getVehicleEcologyList(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  return {
    1: 'Euro 1',
    2: 'Euro 2',
    3: 'Euro 3',
    4: 'Euro 4',
    5: 'Euro 5',
    6: 'Euro 6 (ABCD)',
    7: localizations.other,
  };
}

Map<int, String> getMaintenanceTypeList(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  return {
    1: localizations.mechanic,
    2: localizations.electrician,
    3: localizations.bodyShop,
    4: localizations.other,
  };
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
