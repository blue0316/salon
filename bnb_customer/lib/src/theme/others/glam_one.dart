// ignore_for_file: use_full_hex_values_for_flutter_colors, non_constant_identifier_names

import 'package:bbblient/src/views/themes/glam_one/core/utils/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'glam_one/accents/accent_AFC7D2.dart';
import 'glam_one/accents/accent_D7AFFF.dart';
import 'glam_one/accents/accent_E2BCBF.dart';
import 'glam_one/accents/accent_F48B72.dart';
import 'glam_one/accents/accent_F79F7B.dart';
import 'glam_one/accents/accent_F9E0CA.dart';
import 'glam_one/accents/accent_F9EFE6.dart';
import 'glam_one/accents/accent_FFCF71.dart';
import 'glam_one/accents/accent_E3AB9E.dart';

// Theme 1 ThemeData
class GlamOneTheme {
  static const Color textBlack = Color(0xff0E141E);
  static const Color lightBlack = Color(0xff1E2D3D);
  static const Color redishPink = Color(0xffff006e);
  static const Color creamBrownLight = Color(0xffE3AF7B);
  static const Color lightGrey = Color(0xff89959F);

  // MAIN COLORS 1
  static const primaryOption1 = Color(0XFFFFC692);
  static const primaryDeepOption1 = Color(0XFFF48B72);

  // Accent Color FFC692
  static final ThemeData AccentFFC692 = ThemeData(
    primaryColor: primaryOption1,
    primaryColorDark: primaryDeepOption1,
    primaryColorLight: primaryOption1,
    backgroundColor: ColorConstant.black900,
    scaffoldBackgroundColor: Colors.black,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: lightBlack),
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: primaryOption1,
      labelColor: Colors.black,
      labelStyle: bodyText1.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: primaryOption1,
      ),
    ),
    dialogBackgroundColor: Colors.black,
    bottomAppBarColor: Colors.white, // Color of divider on appbar

    cardColor: primaryOption1,
    colorScheme: ColorScheme(
      primary: (Colors.pink[900])!,
      secondary: Colors.black, // Color of title text on cards
      onSecondaryContainer: Colors.black, // Color of sub text on cardsf
      surface: Colors.white,
      background: primaryOption1,
      error: redishPink,
      onPrimary: (Colors.green[900])!,
      onSecondary: creamBrownLight,
      onSurface: lightGrey,
      onBackground: lightGrey,
      onError: redishPink,
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      headline1: headLine1.copyWith(color: primaryOption1),
      headline2: headLine2.copyWith(color: primaryOption1),
      headline3: headLine3.copyWith(color: primaryOption1),
      headline4: headLine4.copyWith(color: primaryOption1),
      headline5: headLine5.copyWith(color: primaryOption1),

      bodyText1: bodyText1.copyWith(color: primaryOption1),
      bodyText2: bodyText2.copyWith(color: primaryOption1),
      //text-field style
      subtitle1: subTitle1.copyWith(color: primaryOption1),
      subtitle2: subTitle2.copyWith(color: Colors.black), // Sub text under a section title in a section container
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: bodyText1,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
    dividerColor: const Color(0XFFF48B72),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: bodyText1.copyWith(color: Colors.black),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      hintStyle: bodyText1.copyWith(color: Colors.black),
    ),
    unselectedWidgetColor: Colors.grey[700], // Color for not valid time slot container
    highlightColor: primaryOption1,

    // Stop
    focusColor: lightGrey,
    splashColor: lightGrey,
    hoverColor: lightGrey,
  );

  // Accent Color F48B72
  static final ThemeData AccentF48B72 = accentF48B72;

  // Accent Color F79F7B
  static final ThemeData AccentF79F7B = accentF79F7B;

  // Accent Color FFCF71
  static final ThemeData AccentFFCF71 = accentFFCF71;

  // Accent Color E3AB9E
  static final ThemeData AccentE3AB9E = accentE3AB9E;

  // Accent Color E2BCBF
  static final ThemeData AccentE2BCBF = accentE2BCBF;

  // Accent Color F9EFE6
  static final ThemeData AccentF9EFE6 = accentF9EFE6;

  // Accent Color AFC7D2
  static final ThemeData AccentAFC7D2 = accentAFC7D2;

  // Accent Color D7AFFF
  static final ThemeData AccentD7AFFF = accentD7AFFF;

  // Accent Color F9E0CA
  static final ThemeData AccentF9E0CA = accentF9E0CA;

  static final TextStyle headLine1 = TextStyle(
    fontFamily: "VASQUZ",
    fontSize: 100.sp,
    fontWeight: FontWeight.w600,
    // color: primaryOption1,
  );
  static final TextStyle headLine2 = TextStyle(
    fontFamily: "VASQUZ",
    fontSize: 50.sp,
    fontWeight: FontWeight.w500,
    // color: primaryOption1,
  );

  static final TextStyle headLine3 = TextStyle(
    fontFamily: "VASQUZ",
    fontSize: 30.sp,
    fontWeight: FontWeight.w500,
    // color: primaryOption1,
  );
  static final TextStyle headLine4 = TextStyle(
    fontFamily: "VASQUZ",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    // color: primaryOption1,
  );
  static final TextStyle headLine5 = TextStyle(
    fontFamily: "VASQUZ",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    // color: primaryOption1,
  );
  static final TextStyle bodyText1 = TextStyle(
    fontFamily: "Poppins",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    // color: primaryOption1,
  );
  static final TextStyle bodyText2 = TextStyle(
    fontFamily: "Poppins",
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    // color: primaryOption1,
  );
  static final TextStyle subTitle1 = TextStyle(
    fontFamily: "Poppins",
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    // color: primaryOption1,
  );
  static final TextStyle appointmentSubtitle = TextStyle(
    fontFamily: "Poppins",
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    // color: primaryOption1,
  );
  static const TextStyle calTextStyle = TextStyle(
    fontFamily: "Poppins",
    fontSize: 14,
    // color: primaryOption1,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle calTextStyle2 = TextStyle(
    fontFamily: "Poppins",
    fontSize: 14,
    // color: primaryOption1,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle appointmentTitleStyle = TextStyle(
    fontFamily: "Poppins",
    fontSize: 14,
    // color: primaryOption1,
    fontWeight: FontWeight.w500,
  );

  // Sub Text under a Section Title
  static final TextStyle subTitle2 = TextStyle(
    fontFamily: "Poppins",
    fontSize: 17.5.sp,
    fontWeight: FontWeight.w400,
    // color: Colors.black,
  );

  static const BoxDecoration orangeGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment(-1.03, 0),
      end: Alignment(1.84, 1),
      colors: [
        Color(0xfff48b72),
        Color(0x00ffda92),
        Color(0x00c18fff),
      ],
    ),
  );
}
