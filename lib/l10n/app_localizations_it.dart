// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get favorite => 'Preferito';

  @override
  String get brandUpper => 'Marchio';

  @override
  String get modelUpper => 'Modello';

  @override
  String get configurationUpper => 'Configurazione';

  @override
  String get capacityCcUpper => 'Cilindrata cc';

  @override
  String get powerKwUpper => 'Potenza kw';

  @override
  String get horsePowerCvUpper => 'Cavalli cv';

  @override
  String get maintenanceUpper => 'Manutenzione';

  @override
  String get maintenanceLower => 'manutenzione';

  @override
  String get vehicleUpper => 'Veicolo';

  @override
  String get vehicleLower => 'veicolo';

  @override
  String get refuelingUpper => 'Rifornimento';

  @override
  String get refuelingLower => 'rifornimento';

  @override
  String get invoices => 'Scadenze';

  @override
  String get settings => 'Impostazioni';

  @override
  String get myGarage => 'Il mio garage';

  @override
  String get titleRequiredField => 'Dai un titolo all\'evento.';

  @override
  String get brandModelRequiredField =>
      'Marchio è modello sono campi obbligatori.';

  @override
  String youWillFindEvents(String eventType) {
    return 'In questa pagina troverai tutti gli eventi di $eventType aggiunti.';
  }

  @override
  String get youWillFindVehicles =>
      'In questa pagina troverai tutti i veicoli aggiunti.';

  @override
  String get titleUpper => 'Titolo';

  @override
  String get asteriskTitle => 'Titolo*';

  @override
  String get typeUpper => 'Tipo';

  @override
  String get placeUpper => 'Luogo';

  @override
  String get kilometersUpper => 'Kilometri';

  @override
  String get descriptionUpper => 'Descrizione';

  @override
  String get priceUpper => 'Importo';

  @override
  String get yearUpper => 'Anno';

  @override
  String get selectYear => 'Seleziona Anno';

  @override
  String get categoryUpper => 'Categoria';

  @override
  String get energyUpper => 'Energia';

  @override
  String get ecologyUpper => 'Ecologia';

  @override
  String get updateUpper => 'Aggiorna';

  @override
  String get saveUpper => 'Salva';

  @override
  String get editUpper => 'Modifica';

  @override
  String get cantFindYourVehicleBrand => 'Marchio non presente?';

  @override
  String get asteriskRequiredFields =>
      'I campi contrassegnati da * sono obbligatori.';

  @override
  String addValue(String value) {
    return 'Aggiungi $value';
  }

  @override
  String editValue(String value) {
    return 'Modifica $value';
  }

  @override
  String searchInEvents(String eventType) {
    return 'Cerca tra gli eventi di $eventType';
  }

  @override
  String get date => 'Data';

  @override
  String ggMmAaaa(int day, int month, int year) {
    return '$day/$month/$year';
  }

  @override
  String numKm(int num) {
    return '${num}km';
  }

  @override
  String numCc(int num) {
    return '${num}cc';
  }

  @override
  String numKw(int num) {
    return '${num}kW';
  }

  @override
  String numCv(int num) {
    return '${num}CV';
  }

  @override
  String numCurrency(String num, String currency) {
    return '$num$currency';
  }

  @override
  String get latestEvents => 'Ultimi eventi:';

  @override
  String get noVehicles => 'Nessun veicolo';

  @override
  String get other => 'Altro';

  @override
  String get sedan => 'Berlina';

  @override
  String get coupe => 'Coupé';

  @override
  String get sportsCar => 'Sportiva';

  @override
  String get suv => 'SUV';

  @override
  String get stationWagon => 'Station Wagon';

  @override
  String get minivan => 'Monovolume';

  @override
  String get supercar => 'Supercar';

  @override
  String get petrol => 'Benzina';

  @override
  String get diesel => 'Gasolio';

  @override
  String get lpg => 'GPL';

  @override
  String get cng => 'Metano';

  @override
  String get electric => 'Elettrico';

  @override
  String get mechanic => 'Meccanico';

  @override
  String get electrician => 'Elettrauto';

  @override
  String get bodyShop => 'Carrozziere';
}
