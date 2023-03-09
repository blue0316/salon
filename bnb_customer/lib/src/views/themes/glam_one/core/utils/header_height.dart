import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

double getThemeHeaderHeight(context, String? themeNo) {
  switch (themeNo) {
    case '1':
      return DeviceConstraints.getResponsiveSize(
          context, 1000.h, 1000.h, 1000.h);
    case '2':
      return DeviceConstraints.getResponsiveSize(
          context, 1000.h, 1000.h, 1000.h);
    case '3':
      return DeviceConstraints.getResponsiveSize(
          context, 1000.h, 1000.h, 1000.h);
    case '4':
      return DeviceConstraints.getResponsiveSize(context, 700.h, 700.h, 700.h);
    case '5':
      return DeviceConstraints.getResponsiveSize(
          context, 1000.h, 1000.h, 1000.h);

    default:
      return DeviceConstraints.getResponsiveSize(
          context, 1000.h, 1000.h, 1000.h);
  }
}


//     '1', // Glam
//     '2', // Glam Barbershop
//     '3',
//     '4', // Barbershop