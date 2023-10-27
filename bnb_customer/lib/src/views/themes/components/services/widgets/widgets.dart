import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/booking_dialog_2.dart';
import 'package:bbblient/src/views/themes/components/widgets/button.dart';
import 'package:bbblient/src/views/themes/components/widgets/multiple_states_button.dart';
import 'package:bbblient/src/views/themes/components/widgets/oval_button.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Color? labelColorTheme(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.CityMuseLight:
      return Colors.white;
    case ThemeType.CityMuseDark:
      return Colors.white;
    case ThemeType.GentleTouch:
      return Colors.black;
    case ThemeType.GentleTouchDark:
      return Colors.white;

    default:
      return theme.tabBarTheme.labelColor;
  }
}

BoxDecoration servicesTabBarTheme(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GentleTouch:
      return BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2, color: theme.colorScheme.secondary),
        ),
      );

    case ThemeType.GentleTouchDark:
      return BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2, color: theme.colorScheme.secondary),
        ),
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
    {required ThemeType themeType,
    required ThemeData theme,
    bool hasGradient = false}) {
  switch (themeType) {
    case ThemeType.GentleTouch:
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MultipleStatesButton(
            borderColor: Colors.transparent,
            buttonColor: theme.colorScheme.secondary,
            width: 180.sp,
            text: (AppLocalizations.of(context)?.bookNow ?? "Book Now"),
            weight: FontWeight.normal,
            textColor: const Color(0XFFFFFFFF),
            height: 47.h,
            showSuffix: false,
            borderRadius: 2,
            isGradient: hasGradient,
            onTap: () => const BookingDialogWidget222().show(context),
          ),
        ],
      );

    case ThemeType.GentleTouchDark:
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MultipleStatesButton(
            borderColor: Colors.transparent,
            buttonColor: theme.colorScheme.secondary,
            width: 180.sp,
            text: (AppLocalizations.of(context)?.bookNow ?? "Book Now"),
            weight: FontWeight.normal,
            textColor: Colors.black,
            height: 47.h,
            showSuffix: false,
            borderRadius: 2,
            isGradient: hasGradient,
            onTap: () => const BookingDialogWidget222().show(context),
          ),
        ],
      );

    case ThemeType.CityMuseLight:
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SquareButton(
            text: '  ${AppLocalizations.of(context)?.bookNow ?? "BOOK NOW"}  ',
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
            text: '  ${AppLocalizations.of(context)?.bookNow ?? "BOOK NOW"}  ',
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
            text: AppLocalizations.of(context)?.bookNow ?? "BOOK NOW",
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
            text: AppLocalizations.of(context)?.bookNow ?? "BOOK NOW",
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
        text:
            (AppLocalizations.of(context)?.bookNow ?? "BOOK NOW").toTitleCase(),
        onTap: () => const BookingDialogWidget222().show(context),
      );
  }
}
