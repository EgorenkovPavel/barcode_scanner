import 'dart:async';

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