import 'package:bbblient/src/views/salon/booking/dialog_flow/booking_dialog_2.dart';
import 'package:bbblient/src/views/themes/components/widgets/button.dart';
import 'package:bbblient/src/views/themes/components/widgets/oval_button.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Color? labelColorTheme(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.CityMuseLight:
      return Colors.white;
    case ThemeType.CityMuseDark:
      return Colors.white;

    default:
      return theme.tabBarTheme.labelColor;
  }
}

BoxDecoration servicesTabBarTheme(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GentleTouch:
      return BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(60),
      );
    case ThemeType.CityMuseLight:
      return const BoxDecoration(
        color: Colors.black,
      );
    case ThemeType.CityMuseDark:
      return BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white),
      );

    default:
      return BoxDecoration(
        color: theme.primaryColor,
        border: Border(
          bottom: BorderSide(width: 1.5, color: theme.primaryColorDark),
        ),
      );
  }
}

Widget bookNowButtonTheme(context,
    {required ThemeType themeType, required ThemeData theme}) {
  switch (themeType) {
    case ThemeType.CityMuseLight:
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SquareButton(
            text: '  BOOK NOW  ',
            height: 60.h,
            // buttonColor: Colors.white,
            // borderColor: Colors.black,
            // textColor: Colors.black,
            buttonColor: theme.cardColor,
            textColor: theme.primaryColor,
            borderColor: theme.primaryColor,
            showSuffix: false,
            onTap: () => const BookingDialogWidget222().show(context),
          ),
        ],
      );
    case ThemeType.CityMuseDark:
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SquareButton(
            text: '  BOOK NOW  ',
            height: 60.h,
            // buttonColor: Colors.black,
            // borderColor: Colors.white,
            // textColor: Colors.white,
            buttonColor: theme.cardColor,
            textColor: theme.primaryColor,
            borderColor: theme.primaryColor,
            showSuffix: false,
            onTap: () => const BookingDialogWidget222().show(context),
          ),
        ],
      );
    case ThemeType.GlamBarbershop:
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SquareButton(
            text: 'BOOK NOW',
            height: 60.h,
            buttonColor: theme.primaryColor,
            borderColor: Colors.transparent,
            textColor: Colors.black,
            onTap: () => const BookingDialogWidget222().show(context),
          ),
        ],
      );
    case ThemeType.Barbershop:
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SquareButton(
            text: 'BOOK NOW',
            height: 60.h,
            buttonColor: theme.primaryColor,
            borderColor: Colors.transparent,
            textColor: Colors.black,
            onTap: () => const BookingDialogWidget222().show(context),
          ),
        ],
      );

    default:
      return OvalButton(
        width: 180.h,
        height: 60.h,
        textSize: 18.sp,
        text: 'Book Now',
        onTap: () => const BookingDialogWidget222().show(context),
      );
  }
}
