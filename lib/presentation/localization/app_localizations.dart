import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('ru')];

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    _AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  Map<String, String> get _values {
    return locale.languageCode == 'ru' ? _ru : _en;
  }

  String text(String key) {
    return _values[key] ?? _en[key] ?? key;
  }

  String count(String key, int count) {
    return text(key).replaceAll('{count}', count.toString());
  }

  String get appTitle => text('appTitle');
  String get welcomeTitle => text('welcomeTitle');
  String get welcomeSubtitle => text('welcomeSubtitle');
  String get settings => text('settings');
  String get home => text('home');
  String get photos => text('photos');
  String get history => text('history');
  String get premium => text('premium');
  String get firstScanTitle => text('firstScanTitle');
  String get firstScanSubtitle => text('firstScanSubtitle');
  String get photoAccess => text('photoAccess');
  String get photoAccessRequired => text('photoAccessRequired');
  String get grantAccess => text('grantAccess');
  String get scan => text('scan');
  String get checkingAccess => text('checkingAccess');
  String get scanningLibrary => text('scanningLibrary');
  String get readyToScan => text('readyToScan');
  String get scanComplete => text('scanComplete');
  String get scanFailed => text('scanFailed');
  String get foundPhotos => text('foundPhotos');
  String get indexedPhotos => text('indexedPhotos');
  String get discoveredSources => text('discoveredSources');
  String get permissionGranted => text('permissionGranted');
  String get permissionLimited => text('permissionLimited');
  String get permissionDenied => text('permissionDenied');
  String get permissionBlocked => text('permissionBlocked');
  String get permissionUnavailable => text('permissionUnavailable');
  String get permissionUnknown => text('permissionUnknown');
  String get emptyPhotos => text('emptyPhotos');
  String get language => text('language');
  String get googleDrive => text('googleDrive');
  String get backupProfile => text('backupProfile');
  String get indexedPhotoList => text('indexedPhotoList');
  String get backupOperations => text('backupOperations');
  String get accessLevel => text('accessLevel');
  String get photoDetails => text('photoDetails');
  String get photoDetailsSubtitle => text('photoDetailsSubtitle');
  String get protectFirst => text('protectFirst');
  String get cleanLater => text('cleanLater');
  String get driveConnection => text('driveConnection');
  String get qualityAndNetwork => text('qualityAndNetwork');
  String get backupProgress => text('backupProgress');
  String get currentBackupJob => text('currentBackupJob');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) {
    return false;
  }
}

const _en = {
  'appTitle': 'Photo Organizer',
  'welcomeTitle': 'Welcome to Photo Organizer',
  'welcomeSubtitle':
      'Give photo access first. Then the app can build the local photo index.',
  'settings': 'Settings',
  'home': 'Home',
  'photos': 'Photos',
  'history': 'History',
  'premium': 'Premium',
  'firstScanTitle': 'First photo scan',
  'firstScanSubtitle': 'Index the photos available on this device.',
  'photoAccess': 'Photo access',
  'photoAccessRequired':
      'Photo Organizer cannot work without media access. Grant access to continue.',
  'grantAccess': 'Grant access',
  'scan': 'Scan',
  'checkingAccess': 'Checking access',
  'scanningLibrary': 'Scanning library',
  'readyToScan': 'Ready to scan',
  'scanComplete': 'Scan complete',
  'scanFailed': 'Scan failed',
  'foundPhotos': 'Found photos',
  'indexedPhotos': 'Indexed photos',
  'discoveredSources': 'Sources',
  'permissionGranted': 'Granted',
  'permissionLimited': 'Limited',
  'permissionDenied': 'Denied',
  'permissionBlocked': 'Blocked',
  'permissionUnavailable': 'Unavailable',
  'permissionUnknown': 'Unknown',
  'emptyPhotos': 'No photos were found.',
  'language': 'Language',
  'googleDrive': 'Google Drive',
  'backupProfile': 'Backup profile',
  'indexedPhotoList': 'Indexed photo list',
  'backupOperations': 'Backup operations',
  'accessLevel': 'Access level',
  'photoDetails': 'Photo details',
  'photoDetailsSubtitle': 'Backup status and cloud location',
  'protectFirst': 'Protect first',
  'cleanLater': 'Clean later',
  'driveConnection': 'Drive connection',
  'qualityAndNetwork': 'Quality and network',
  'backupProgress': 'Backup progress',
  'currentBackupJob': 'Current backup job',
};

const _ru = {
  'appTitle': 'Photo Organizer',
  'welcomeTitle': 'Добро пожаловать в Photo Organizer',
  'welcomeSubtitle':
      'Сначала дайте доступ к фото. После этого приложение построит локальный индекс.',
  'settings': 'Настройки',
  'home': 'Главная',
  'photos': 'Фото',
  'history': 'История',
  'premium': 'Premium',
  'firstScanTitle': 'Первое сканирование',
  'firstScanSubtitle': 'Индексируем фото, доступные на этом устройстве.',
  'photoAccess': 'Доступ к фото',
  'photoAccessRequired':
      'Photo Organizer не может работать без доступа к медиа. Дайте доступ, чтобы продолжить.',
  'grantAccess': 'Дать доступ',
  'scan': 'Сканировать',
  'checkingAccess': 'Проверяем доступ',
  'scanningLibrary': 'Сканируем галерею',
  'readyToScan': 'Готово к сканированию',
  'scanComplete': 'Сканирование завершено',
  'scanFailed': 'Сканирование не выполнено',
  'foundPhotos': 'Найдено фото',
  'indexedPhotos': 'Проиндексировано',
  'discoveredSources': 'Источники',
  'permissionGranted': 'Доступ дан',
  'permissionLimited': 'Ограниченный доступ',
  'permissionDenied': 'Доступ не дан',
  'permissionBlocked': 'Доступ заблокирован',
  'permissionUnavailable': 'Недоступно',
  'permissionUnknown': 'Неизвестно',
  'emptyPhotos': 'Фото не найдены.',
  'language': 'Язык',
  'googleDrive': 'Google Drive',
  'backupProfile': 'Профиль бэкапа',
  'indexedPhotoList': 'Список проиндексированных фото',
  'backupOperations': 'Операции бэкапа',
  'accessLevel': 'Уровень доступа',
  'photoDetails': 'Детали фото',
  'photoDetailsSubtitle': 'Статус бэкапа и расположение в облаке',
  'protectFirst': 'Сначала защитить',
  'cleanLater': 'Почистить позже',
  'driveConnection': 'Подключение Drive',
  'qualityAndNetwork': 'Качество и сеть',
  'backupProgress': 'Прогресс бэкапа',
  'currentBackupJob': 'Текущая задача бэкапа',
};
