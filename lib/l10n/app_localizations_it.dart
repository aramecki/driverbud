// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get cancel => 'Annulla';

  @override
  String get stay => 'Resta';

  @override
  String get discard => 'Annulla';

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
    return 'In questa pagina troverai tutti gli eventi di $eventType.';
  }

  @override
  String get createYourFirstVehicle =>
      'Crea il tuo primo veicolo per aggiungerne uno.';

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
  String numCurrencyOnUnits(String num, String currency, String unit) {
    return '$num$currency/$unit';
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

  @override
  String get backupUpper => 'Backup';

  @override
  String get restorationUpper => 'Ripristino';

  @override
  String get exportBackup => 'Esporta backup';

  @override
  String get restoreBackup => 'Ripristina backup';

  @override
  String get backupAndRestore => 'Backup e ripristino';

  @override
  String get creatingBackupFile => 'Creo file di backup...';

  @override
  String get restoringFile => 'Ripristino file...';

  @override
  String get backupCompleted => 'Backup completato.';

  @override
  String get restoredSuccessfully => 'Ripristinato con successo.';

  @override
  String processNotCompleted(String process) {
    return '$process non completato.';
  }

  @override
  String get backupFileWontContainImage =>
      'Il file di backup non includerà immagini personalizzate.';

  @override
  String get checkoutMy => 'Dai un\'occhiata alla mia ';

  @override
  String get beloved => 'amata ';

  @override
  String get withSpace => 'con ';

  @override
  String poweredby(String energy) {
    return 'alimentata a $energy ';
  }

  @override
  String withStandard(String ecology) {
    return 'con standard $ecology.';
  }

  @override
  String get onDate => 'In data ';

  @override
  String get iPerformed => 'ho effettuato ';

  @override
  String get onMy => 'sulla mia ';

  @override
  String get withKm => 'con ';

  @override
  String get at => 'presso ';

  @override
  String get paying => 'pagando ';

  @override
  String get language => 'Lingua';

  @override
  String get country => 'Regione';

  @override
  String get currency => 'Valuta';

  @override
  String get theme => 'Tema';

  @override
  String get gotAFeedback => 'Hai un feedback?';

  @override
  String get about => 'Informazioni';

  @override
  String get languageSettings => 'Impostazioni lingua';

  @override
  String get themeSettings => 'Impostazioni tema';

  @override
  String get currencySettings => 'Impostazioni valuta';

  @override
  String get followSystemTheme => 'Segui impostazioni di sistema';

  @override
  String get darkMode => 'Modalità scura';

  @override
  String get homeNoEventsMessage =>
      'Gli ultimi eventi del veicolo selezionato saranno mostrati in questa pagina.';

  @override
  String get thirdPartyInsurance => 'Assicurazione RCA';

  @override
  String get carTax => 'Tassa automobilistica';

  @override
  String get carInspection => 'Revisione';

  @override
  String get expiring => 'In scadenza:';

  @override
  String get editInsuranceDetails => 'Modifica dettagli polizza';

  @override
  String get insurance => 'assicurazione';

  @override
  String get insuranceAgency => 'Agenzia assicurativa';

  @override
  String get notes => 'Note';

  @override
  String get totalAmount => 'Importo totale';

  @override
  String get customizeDues => 'Personalizza rate';

  @override
  String get dueSpace => 'Rata ';

  @override
  String duesCount(int duesNumber) {
    String _temp0 = intl.Intl.pluralLogic(
      duesNumber,
      locale: localeName,
      other: '$duesNumber rate',
      one: '1 rata',
    );
    return '$_temp0';
  }

  @override
  String get spaceInSpace => ' in ';

  @override
  String get notifications => 'Notifiche';

  @override
  String get permissionsRequired => 'Permessi richiesti';

  @override
  String get permissionsRequiredAlertBody =>
      'Per essere informato su scadenze ed eventi, devi consentire le notifiche nelle impostazioni dell\'app.';

  @override
  String get insuranceNotificationsTitle =>
      'La tua assicurazione sta per scadere!';

  @override
  String insuranceNotificationsBody(String vehicleName) {
    return 'L\'assicurazione della tua $vehicleName scadrà il ';
  }

  @override
  String get areYouSure => 'Sei sicuro?';

  @override
  String get dataNotSavedWillBeLost => 'I dati non salvati saranno persi.';

  @override
  String get actionCantBeUndone => 'Questa azione non potrà essere annullata.';

  @override
  String get delete => 'Elimina';

  @override
  String get reachedMaxEntry =>
      'Hai raggiunto il numero massimo di veicoli nel garage.';
}
