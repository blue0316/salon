import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeviceConstraints {
  ///max width of widgets on tablets and other large devices
  static const double breakPointPhone = 600;
  static const double breakPointTab = 900;

  ///returns ht in percentage for example ht=20 means it will cover 20 percent height of the screen
  static double? getHt(double ht, BuildContext context) {
    try {
      return ht * MediaQuery.of(context).size.height / 100;
    } catch (e) {
      printIt(e);
      return null;
    }
  }


  ///returns wt in percentage for example wt=20 means it will cover 20 percent width of the screen
  static double? getWt(double wt, BuildContext context) {
    try {
      return wt * MediaQuery.of(context).size.width / 100;
    } catch (e) {
      printIt(e);
      return null;
    }
  }

  ///returns device screen type

  static DeviceScreenType getDeviceType(MediaQueryData mediaQuery) {
    final double deviceWidth = mediaQuery.size.width;

    if (deviceWidth > breakPointTab) return DeviceScreenType.tab;

    return (deviceWidth > breakPointPhone)
        ? DeviceScreenType.landScape
        : DeviceScreenType.portrait;
  }

  static getCrossAxisCount(
    context, {
    int large = 6,
    int medium = 3,
    int small = 2,
  }) {
    final double width = MediaQuery.of(context).size.width;
    if (width > breakPointTab) {
      return large;
    } else if (width > breakPointPhone) {
      return medium;
    }

    return small;
  }

  static double getResponsiveSize(
      context, double fontSize1, double fontSize2, double fontSize3) {
    DeviceScreenType _deviceType = getDeviceType(MediaQuery.of(context));
    switch (_deviceType) {
      case DeviceScreenType.portrait:
        return fontSize1;
      case DeviceScreenType.landScape:
        return fontSize2;
      case DeviceScreenType.tab:
        return fontSize3;

      default:
        return fontSize1;
    }
  }
}
