import 'package:flutter/material.dart';
import '../country.dart';
import '../json/country_codes.dart';
import 'country_localizations.dart';
import 'strings/en.dart';
import 'strings/es.dart';
import 'strings/fr.dart';
import 'strings/pt.dart';
import 'strings/uk.dart';

/// Used to parse simple string representations of countries, commonly used in
/// databases and other forms of storage, to a Country object.
class CountryParser {
  /// Returns a single country if [country] matches a country code or name.
  ///
  /// Throws an [ArgumentError] if no matching element is found.
  static Country parse(String country) {
    return tryParseCountryCode(country) ?? parseCountryName(country);
  }

  /// Returns a single country if [country] matches a country code or name.
  ///
  /// returns null if no matching element is found.
  static Country? tryParse(String country) {
    return tryParseCountryCode(country) ?? tryParseCountryName(country);
  }

  /// Returns a single country if it matches the given [countryCode] (iso2_cc).
  ///
  /// Throws a [StateError] if no matching element is found.
  static Country parseCountryCode(String countryCode) {
    return _getFromCode(countryCode.toUpperCase());
  }

  /// Returns a single country if it matches the given [phoneCode] (e164_cc).
  ///
  /// Throws a [StateError] if no matching element is found.
  static Country parsePhoneCode(String phoneCode) {
    return _getFromPhoneCode(phoneCode);
  }

  /// Returns a single country that matches the given [countryCode] (iso2_cc).
  ///
  /// Returns null if no matching element is found.
  static Country? tryParseCountryCode(String countryCode) {
    try {
      return parseCountryCode(countryCode);
    } catch (_) {
      return null;
    }
  }

  /// Returns a single country that matches the given [phoneCode] (e164_cc).
  ///
  /// Returns null if no matching element is found.
  static Country? tryParsePhoneCode(String phoneCode) {
    try {
      return parsePhoneCode(phoneCode);
    } catch (_) {
      return null;
    }
  }

  /// Returns a single country if it matches the given [countryName].
  ///
  /// Uses the application [context] to determine what language is used in the
  /// app, if provided, and checks the country names for this locale if any.
  /// If no match is found and no [locales] are given, the default language is
  /// checked (english), followed by the rest of the available translations. If
  /// any [locales] are given, only those supported languages are used, in
  /// addition to the [context] language.
  ///
  /// Throws an [ArgumentError] if no matching element is found.
  static Country parseCountryName(
    String countryName, {
    BuildContext? context,
    List<Locale>? locales,
  }) {
    final String countryNameLower = countryName.toLowerCase();

    final CountryLocalizations? localizations = context != null ? CountryLocalizations.of(context) : null;

    final String languageCode = _anyLocalizedNameToCode(
      countryNameLower,
      localizations?.locale,
      locales,
    );

    return _getFromCode(languageCode);
  }

  /// Returns a single country if it matches the given [countryName].
  ///
  /// Returns null if no matching element is found.
  static Country? tryParseCountryName(
    String countryName, {
    BuildContext? context,
    List<Locale>? locales,
  }) {
    try {
      return parseCountryName(countryName, context: context, locales: locales);
    } catch (_) {
      return null;
    }
  }

  /// Returns a country that matches the [countryCode] (e164_cc).
  static Country _getFromPhoneCode(String phoneCode) {
    return Country.from(
      json: countryCodes.singleWhere(
        (Map<String, dynamic> c) => c['e164_cc'] == phoneCode,
      ),
    );
  }

  /// Returns a country that matches the [countryCode] (iso2_cc).
  static Country _getFromCode(String countryCode) {
    return Country.from(
      json: countryCodes.singleWhere(
        (Map<String, dynamic> c) => c['iso2_cc'] == countryCode,
      ),
    );
  }

  /// Returns a country code that matches a country with the given [name] for
  /// any language, or the ones given by [locales]. If no locale list is given,
  /// the language for the [locale] is prioritized, followed by the default
  /// language, english.
  static String _anyLocalizedNameToCode(
    String name,
    Locale? locale,
    List<Locale>? locales,
  ) {
    String? code;

    if (locale != null) code = _localizedNameToCode(name, locale);
    if (code == null && locales == null) {
      code = _localizedNameToCode(name, const Locale('en'));
    }
    if (code != null) return code;

    final List<Locale> localeList = locales ?? <Locale>[];

    if (locales == null) {
      final List<Locale> exclude = <Locale>[const Locale('en')];
      if (locale != null) exclude.add(locale);
      localeList.addAll(_supportedLanguages(exclude: exclude));
    }

    return _nameToCodeFromGivenLocales(name, localeList);
  }

  /// Returns the country code that matches the given [name] for any of the
  /// [locales].
  ///
  /// Throws an [ArgumentError] if no matching element is found.
  static String _nameToCodeFromGivenLocales(String name, List<Locale> locales) {
    String? code;

    for (int i = 0; i < locales.length && code == null; i++) {
      code = _localizedNameToCode(name, locales[i]);
    }

    if (code == null) {
      throw ArgumentError.value('No country found');
    }

    return code;
  }

  /// Returns the code for the country that matches the given [name] in the
  /// language given by the [locale]. Defaults to english.
  ///
  /// Returns null if no match is found.
  static String? _localizedNameToCode(String name, Locale locale) {
    final Map<String, String> translation = _getTranslation(locale);

    String? code;

    translation.forEach((key, value) {
      if (value.toLowerCase() == name) code = key;
    });

    return code;
  }

  // ToDo: solution to prevent manual update on adding new localizations?
  /// Returns a translation for the given [locale]. Defaults to english.
  static Map<String, String> _getTranslation(Locale locale) {
    switch (locale.languageCode) {
      case 'es':
        return es;

      case 'pt':
        return pt;

      case 'uk':
        return uk;

      case 'fr':
        return fr;

      case 'en':
      default:
        return en;
    }
  }

  // ToDo: solution to prevent manual update on adding new localizations?
  /// A list of the supported locales, except those included in the [exclude]
  /// list.
  static List<Locale> _supportedLanguages({
    List<Locale> exclude = const <Locale>[],
  }) {
    return <Locale>[
      const Locale('en'),
      const Locale('es'),
      const Locale('fr'),
      const Locale('pt'),
      const Locale('uk'),
    ]..removeWhere((Locale l) => exclude.contains(l));
  }
}