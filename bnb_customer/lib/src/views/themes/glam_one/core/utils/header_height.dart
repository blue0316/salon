import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

double getThemeHeaderHeight(context, ThemeType themeType) {
  switch (themeType) {
    case ThemeType.Glam:
      return DeviceConstraints.getResponsiveSize(
          context, 1000.h, 1000.h, 1000.h);
    case ThemeType.GlamBarbershop:
      return DeviceConstraints.getResponsiveSize(
          context, 1000.h, 1000.h, 1000.h);
    case ThemeType.GlamGradient:
      return DeviceConstraints.getResponsiveSize(
          context, 1000.h, 1000.h, 1000.h);
    case ThemeType.Barbershop:
      return DeviceConstraints.getResponsiveSize(context, 600.h, 600.h, 600.h);
    case ThemeType.GlamLight:
      return DeviceConstraints.getResponsiveSize(context, 900.h, 900.h, 900.h);
    case ThemeType.GlamMinimalDark:
      return DeviceConstraints.getResponsiveSize(context, 800.h, 800.h, 800.h);
    case ThemeType.GlamMinimalLight:
      return DeviceConstraints.getResponsiveSize(context, 800.h, 800.h, 800.h);

    default:
      return DeviceConstraints.getResponsiveSize(
          context, 1000.h, 1000.h, 1000.h);
  }
}

// enum ThemeType {
//   Default, // 0
//   Glam, // 1
//   GlamBarbershop, // 2
//   GlamGradient, // 3
//   Barbershop, // 4
//   GlamLight, // 5
//   GlamMinimalLight, // 6
//   GlamMinimalDark, 