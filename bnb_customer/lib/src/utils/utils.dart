// ignore_for_file: library_prefixes

import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'package:bbblient/src/models/customer/customer.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:country_codes/country_codes.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:map_launcher/map_launcher.dart' as mapLauncher;
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import '../models/country.dart';
import '../models/salon_master/master.dart';
import '../views/widgets/widgets.dart';
import 'country_code.dart';

printIt(Object? object) {
  if (kDebugMode) {
    dev.log(object.toString());
  }
}

class Utils {
  static String getProfessionFromCategoryId({String? id}) {
    switch (id) {
      case '1':
        return "Hair Dresser";
      case '2':
        return "Eye Artist";
      case '3':
        return "Tattoo Artist";
      case '4':
        return "Beard burner";
      case '5':
        return "Makeup Artist";
      case '6':
        return "Cosmotologist";
      case '7':
        return "Nail artist";
      case '8':
        return "Hair stealer";
      default:
        return "Hair Dresser";
    }
  }

  static final languages = <String>['English', 'Spanish', 'French', 'German', 'Italian', 'Russian'];

  static String getLanguageCode(String language) {
    switch (language) {
      case 'English':
        return 'en';
      case 'French':
        return 'fr';
      case 'Italian':
        return 'it';
      case 'Russian':
        return 'ru';
      case 'Spanish':
        return 'es';
      case 'German':
        return 'de';
      default:
        return 'en';
    }
  }

  launchCaller(number) async {
    try {
      if (number == null || number == '') {
        showToast("Phone number is not available !");
      } else {
        final String url = "tel:$number";
        if (await canLaunchUrl(Uri.parse(url))) {
          await canLaunchUrl(Uri.parse(url));
        } else {
          throw 'Could not launch $url';
        }
      }
    } catch (e) {
      printIt(e);
    }
  }

  launchMaps({required Coordinates coordinates, required String label, required BuildContext context}) async {
    openMapsSheet(context) async {
      try {
        final availableMaps = await MapLauncher.installedMaps;
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: SingleChildScrollView(
                child: SizedBox(
                  child: Wrap(
                    children: <Widget>[
                      for (var map in availableMaps)
                        ListTile(
                          onTap: () => map.showMarker(
                            coords: mapLauncher.Coords(coordinates.latitude, coordinates.longitude),
                            title: label,
                          ),
                          title: Text(map.mapName),
                          leading: SvgPicture.asset(
                            map.icon,
                            height: 30.0,
                            width: 30.0,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      } catch (e) {
        printIt(e);
      }
    }

    try {
      if (await mapLauncher.MapLauncher.isMapAvailable(mapLauncher.MapType.google) ?? false) {
        await mapLauncher.MapLauncher.showMarker(
          mapType: mapLauncher.MapType.google,
          coords: mapLauncher.Coords(coordinates.latitude, coordinates.longitude),
          title: label,
          description: label,
        );
      } else {
        openMapsSheet(context);
      }
    } catch (e) {
      printIt(e);
    }
  }

  launchUrl({required String? url}) async {
    if (url == null || url == '') {
      showToast("cant open!! long press to copy");
    } else {
      if (await canLaunchUrl(Uri.parse(url))) {
        await canLaunchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  void vibratePositively() async {
    if (await Vibration.hasCustomVibrationsSupport() ?? false) {
      Vibration.vibrate(amplitude: 40, duration: 50);
      // await Future.delayed(const Duration(milliseconds: 20));
      // Vibration.vibrate(amplitude: 40, duration: 50);
    } else if (await Vibration.hasAmplitudeControl() ?? false) {
      Vibration.vibrate(amplitude: 40, duration: 50);
    }
  }

  void vibrateNegatively() async {
    if (await Vibration.hasCustomVibrationsSupport() ?? false) {
      Vibration.vibrate(amplitude: 20, duration: 30);
      // await Future.delayed(const Duration(milliseconds: 13));
      // Vibration.vibrate(amplitude: 30, duration: 10);
    } else if (await Vibration.hasAmplitudeControl() ?? false) {
      Vibration.vibrate(amplitude: 20, duration: 30);
    }
  }

  ///returns the name from personal info available
  //returns '' if it's null
  String getName(PersonalInfo? info) {
    if (info == null) {
      debugPrint('personal info is null');
      return '';
    }
    return "${info.firstName ?? ''} ${info.lastName ?? ''}";
  }

  String getNameMaster(PersonalInfoMaster? info) {
    if (info == null) {
      debugPrint('personal info is null');
      return '';
    }
    return "${info.firstName ?? ''} ${info.lastName ?? ''}";
  }

  ///returns the plural and singular form of a string
  String pluralString({required int number, String? zeroString, required String oneString, required String otherString}) {
    try {
      // return Intl.plural(
      //   number,
      //   zero: zeroString ?? oneString,
      //   one: oneString,
      //   other: otherString,
      // );
      return '';
    } catch (e) {
      printIt(e);
      return '';
    }
  }

  static int colorCode = 0;
  //generates a color code between 1-10 in sequential manner
  assignColorCode() {
    if (colorCode > 9) colorCode = 0;
    return colorCode++;
  }

  //function generates a color on the basis of color code
  Color generateColor(int code) {
    if (code <= 10) {
      return AppTheme.masterColors[code];
    } else if (code > 10 && code <= 100) {
      code = (code / 10).round();

      return AppTheme.masterColors[code];
    }
    return AppTheme.masterColors[Random().nextInt(10)];
  }

  /// for phone number fields
//expected input (+91-912345678) only in this format
// returns the country code out of a phone number
  String? getCountryCodeFromPhone(String phone) {
    if (phone.contains('-') && phone.contains('+')) {
      try {
        return phone.split('-')[0].substring(1);
      } catch (e) {
        printIt(e);
      }
    }
    return null;
  }

//expected input (+91-912345678) only in this format
// returns the phone number without country code
  String getPhoneNumber(String phone) {
    if (phone.contains('-') && phone.contains('+')) {
      try {
        return phone.split('-')[1];
      } catch (e) {
        printIt(e);
      }
    }
    return phone;
  }

  //produces the phone number in format
  //+91-912345678
  String? formatPhoneNumber(String countryCode, String phoneNumber) {
    try {
      return "+$countryCode-$phoneNumber";
    } catch (e) {
      printIt(e);
      return null;
    }
  }

  //returns the device's country and phone codes
  Future<Country?> getDeviceCountry(bool isWeb) async {
    //returns the first element of the list, since local cannot be detected on web
    if (isWeb) return countryList[0];
    await CountryCodes.init();
    final Locale? deviceLocale = CountryCodes.getDeviceLocale();
    for (Country country in countryList) {
      if (country.isoCode == deviceLocale!.countryCode) {
        return country;
      }
    }
    return null;
  }

  //returns the device info in string format
  Future<String?> getDeviceInfo() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;

      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      var brand = androidInfo.brand;

      return 'Android $release (SDK $sdkInt), $brand $manufacturer $model';
      // Android 9 (SDK 28), Xiaomi Redmi Note 7
    }

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await DeviceInfoPlugin().iosInfo;

      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.name;
      var model = iosInfo.model;
      return '$systemName $version, $name $model';

      // iOS 13.1, iPhone 11 Pro Max iPhone
    }
    return null;
  }
}
