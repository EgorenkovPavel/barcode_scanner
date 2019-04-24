import 'dart:async';

import 'package:barcode_scanner/objects/ScanException.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': '7Flowers',
      'price_checker': 'Price checker',
      'barcode_search_field_title': 'Enter barcode',
      'error_barcode_length': 'Wrong barcode length',
      'search': 'Search',
      'scan': 'Scan',
      'barcode': 'Barcode',
      'description': 'Description',
      'genus': 'Genus',
      'type': 'Type',
      'variety': 'Variety',
      'country': 'Country',
      'color': 'Color',
      'fix_price': 'No discounts',
      'search_history': 'Search history',

      'exception_title_no_connection': 'No internet connection',
      'exception_title_connection_error': 'Connection error',
      'exception_title_server_error': 'Server error',
      'exception_title_unknown_error': 'Unknown error',
      'exception_title_not_found': 'Product not found',
      'exception_title_wrong_format': 'Wrong barcode',
      'exception_message_no_connection': 'Connect to internet and try again',
      'exception_message_connection_error': 'Check internet connection',
      'exception_message_server_error': 'Server error',
      'exception_message_unknown_error': 'Unknown error',
      'exception_message_not_found': 'Try another barcode',
      'exception_message_wrong_format': 'Invalid format',
    },
    'ru': {
      'title': '7Цветов',
      'price_checker': 'Сканер цен',
      'barcode_search_field_title': 'Введите штрихкод',
      'error_barcode_length': 'Неверная длина штрихкода',
      'scan': 'Сканировать',
      'search': 'Поиск',
      'barcode': 'Штрихкод',
      'description': 'Характеристика',
      'genus': 'Род',
      'type': 'Тип',
      'variety': 'Сорт',
      'country': 'Страна',
      'color': 'Цвет',
      'fix_price': 'Скидки не распространяются',
      'search_history': 'История поиска',

      'exception_title_no_connection': 'Нет доступа в интернет',
      'exception_title_connection_error': 'Ошибка соединения',
      'exception_title_server_error': 'Ошибка сервера',
      'exception_title_unknown_error': 'Неизвестная ошибка',
      'exception_title_not_found': 'Товар не найден',
      'exception_title_wrong_format': 'Неверный штрихкод',
      'exception_message_no_connection': 'Подключитесь к интернету и попробуйте снова',
      'exception_message_connection_error': 'Проверьте интернет соединение',
      'exception_message_server_error': 'Сервер не отвечает. Попробуйте познее',
      'exception_message_unknown_error': 'Попробуйте обновить приложение',
      'exception_message_not_found': 'Попробуйте другой штрихкод',
      'exception_message_wrong_format': 'Неподдерживамый формат',
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  String get priceChecker {
    return _localizedValues[locale.languageCode]['price_checker'];
  }

  String get barcodeSearchFieldTitle {
    return _localizedValues[locale.languageCode]['barcode_search_field_title'];
  }

  String get errorBarcodeLength {
    return _localizedValues[locale.languageCode]['error_barcode_length'];
  }

  String get search {
    return _localizedValues[locale.languageCode]['search'];
  }

  String get scan {
    return _localizedValues[locale.languageCode]['scan'];
  }

  String get barcode {
    return _localizedValues[locale.languageCode]['barcode'];
  }

  String get description {
    return _localizedValues[locale.languageCode]['description'];
  }

  String get genus {
    return _localizedValues[locale.languageCode]['genus'];
  }

  String get type {
    return _localizedValues[locale.languageCode]['type'];
  }

  String get variety {
    return _localizedValues[locale.languageCode]['variety'];
  }

  String get country {
    return _localizedValues[locale.languageCode]['country'];
  }

  String get color {
    return _localizedValues[locale.languageCode]['color'];
  }

  String get fixPrice {
    return _localizedValues[locale.languageCode]['fix_price'];
  }

  String get searchHistory {
    return _localizedValues[locale.languageCode]['search_history'];
  }

  String errorTitle(ExceptionType type){
    switch (type){
      case ExceptionType.NO_CONNECTION: return _localizedValues[locale.languageCode]['exception_title_no_connection'];
      case ExceptionType.CONNECTION_ERROR: return _localizedValues[locale.languageCode]['exception_title_connection_error'];
      case ExceptionType.SERVER_ERROR: return _localizedValues[locale.languageCode]['exception_title_server_error'];
      case ExceptionType.UNKNOWN_ERROR: return _localizedValues[locale.languageCode]['exception_title_unknown_error'];
      case ExceptionType.NOT_FOUND: return _localizedValues[locale.languageCode]['exception_title_not_found'];
      case ExceptionType.WRONG_FORMAT: return _localizedValues[locale.languageCode]['exception_title_wrong_format'];
    }
  }

  String errorMessage(ExceptionType type){
    switch (type){
      case ExceptionType.NO_CONNECTION: return _localizedValues[locale.languageCode]['exception_message_no_connection'];
      case ExceptionType.CONNECTION_ERROR: return _localizedValues[locale.languageCode]['exception_message_connection_error'];
      case ExceptionType.SERVER_ERROR: return _localizedValues[locale.languageCode]['exception_message_server_error'];
      case ExceptionType.UNKNOWN_ERROR: return _localizedValues[locale.languageCode]['exception_message_unknown_error'];
      case ExceptionType.NOT_FOUND: return _localizedValues[locale.languageCode]['exception_message_not_found'];
      case ExceptionType.WRONG_FORMAT: return _localizedValues[locale.languageCode]['exception_message_wrong_format'];
    }
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}