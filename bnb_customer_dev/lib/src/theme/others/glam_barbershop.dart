// ignore_for_file: use_full_hex_values_for_flutter_colors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'accents/glam_barbershop/accent_ C17150.dart';
import 'accents/glam_barbershop/accent_ E3A681.dart';
import 'accents/glam_barbershop/accent_ E4954A.dart';
import 'accents/glam_barbershop/accent_ F89F54.dart';
import 'accents/glam_barbershop/accent_ FABD64.dart';
import 'accents/glam_barbershop/accent_D5824C.dart';
import 'accents/glam_barbershop/accent_DDC686.dart';
import 'accents/glam_barbershop/accent_E3824F.dart';

// Theme 2 ThemeData
class GlamBarberShopTheme {
  static const Color textBlack = Color(0xff0E141E);
  static const Color lightBlack = Color(0xff1E2D3D);
  static const Color redishPink = Color(0xffff006e);
  static const Color creamBrownLight = Color(0xffE3AF7B);
  static const Color lightGrey = Color(0xff89959F);

  // MAIN COLORS 1
  static Color primaryColor1 = const Color(0XFFDDC686);

  // Main Theme 1
  static final ThemeData mainTheme = ThemeData(
    primaryColor: primaryColor1,
    primaryColorDark: primaryColor1,
    primaryColorLight: Colors.white,

    scaffoldBackgroundColor: Colors.black,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: lightBlack),

    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.white,
      labelColor: Colors.black,
      labelStyle: bodyText1.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: primaryColor1,
      ),
    ),
    dialogBackgroundColor: Colors.black,

    cardColor: Colors.black,
    colorScheme: ColorScheme(
      primary: (Colors.pink[900])!,
      secondary: primaryColor1, // Color of title text on cards
      onSecondaryContainer: Colors.white, // Color of sub text on cards

      surface: Colors.white,
      background: const Color(0XFF101010),
      error: redishPink,
      onPrimary: (Colors.green[900])!,
      onSecondary: creamBrownLight,
      onSurface: lightGrey,
      // Dialog Colors
      onBackground: Colors.white,
      tertiary: Colors.white, // Text colors on dialog

      onError: redishPink,
      brightness: Brightness.light,
      outlineVariant: Colors.white, // Color of divider on appbar
    ),
    textTheme: TextTheme(
      displayLarge: headLine1.copyWith(color: primaryColor1),
      displayMedium: headLine2.copyWith(color: primaryColor1),
      displaySmall: headLine3.copyWith(color: primaryColor1),
      headlineMedium: headLine4.copyWith(color: primaryColor1),
      headlineSmall: headLine5.copyWith(color: primaryColor1),

      bodyLarge: bodyText1.copyWith(color: primaryColor1),
      bodyMedium: bodyText2.copyWith(color: primaryColor1),
      //text-field style
      titleMedium: subTitle1.copyWith(color: primaryColor1),
      titleSmall: subTitle2.copyWith(color: Colors.black), // Sub text under a section title in a section container
    ),
    dividerColor: Colors.white,

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: bodyText1.copyWith(color: Colors.white),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1),
      ),
      hintStyle: bodyText1.copyWith(color: Colors.white),
    ),
    hintColor: Colors.white,
    unselectedWidgetColor: Colors.grey[700], // Color for not valid time slot container
    highlightColor: primaryColor1,
    // Stop

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: bodyText1,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
    focusColor: lightGrey,
    splashColor: lightGrey,
    hoverColor: lightGrey,
  );

  // Accent Color F79F7B
  static final ThemeData AccentDDC686 = accentDDC686;

  // Accent Color E3824F
  static final ThemeData AccentE3824F = accentE3824F;

  // Accent Color D5824C
  static final ThemeData AccentD5824C = accentD5824C;

  // Accent Color FABD64
  static final ThemeData AccentFABD64 = accentFABD64;

  // Accent Color E3A681
  static final ThemeData AccentE3A681 = accentE3A681;

  // Accent Color F89F54
  static final ThemeData AccentF89F54 = accentF89F54;

  // Accent Color C17150
  static final ThemeData AccentC17150 = accentC17150;

  // Accent Color E4954A
  static final ThemeData AccentE4954A = accentE4954A;

  static final TextStyle headLine1 = TextStyle(
    fontFamily: "UNDERRATED",
    fontSize: 100.sp,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle headLine2 = TextStyle(
    fontFamily: "UNDERRATED",
    fontSize: 50.sp,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle headLine3 = TextStyle(
    fontFamily: "UNDERRATED",
    fontSize: 30.sp,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle headLine4 = TextStyle(
    fontFamily: "UNDERRATED",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle headLine5 = TextStyle(
    fontFamily: "UNDERRATED",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle bodyText1 = TextStyle(
    fontFamily: "Poppins",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle bodyText2 = TextStyle(
    fontFamily: "Poppins",
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle subTitle1 = TextStyle(
    fontFamily: "Poppins",
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle appointmentSubtitle = TextStyle(
    fontFamily: "Poppins",
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle calTextStyle = TextStyle(
    fontFamily: "Poppins",
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle calTextStyle2 = TextStyle(
    fontFamily: "Poppins",
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle appointmentTitleStyle = TextStyle(
    fontFamily: "Poppins",
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle subTitle2 = TextStyle(
    fontFamily: "Poppins",
    fontSize: 17.5.sp,
    fontWeight: FontWeight.w400,
    color: Colors.white,
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
