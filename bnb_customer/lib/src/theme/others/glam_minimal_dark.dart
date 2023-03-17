// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Theme 7 ThemeData
class GlamMinimalDark {
  static const Color themeBackgroundColor = Colors.black;

  static const Color textBlack = Color(0xff0E141E);
  static const Color lightBlack = Color(0xff1E2D3D);
  static const Color redishPink = Color(0xffff006e);
  static const Color creamBrownLight = Color(0xffE3AF7B);
  static const Color lightGrey = Color(0xff89959F);

  // MAIN COLORS 1
  static const primaryColor1 = Colors.white;

  // MAIN COLORS 2
  static const primaryColor2 = Colors.yellow;

  // Main Theme 1
  static final ThemeData mainTheme = ThemeData(
    primaryColor: primaryColor1,
    primaryColorDark: primaryColor1,
    primaryColorLight: Colors.white,
    backgroundColor: themeBackgroundColor,
    scaffoldBackgroundColor: Colors.black,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: lightBlack),

    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.white,
      labelColor: Colors.white,
      labelStyle: bodyText1.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: primaryColor1,
      ),
    ),
    bottomAppBarColor: Colors.black, // Color of divider on appbar
    dialogBackgroundColor: Colors.black,
    cardColor: themeBackgroundColor,
    colorScheme: ColorScheme(
      primary: (Colors.pink[900])!,
      secondary: primaryColor1, // Color of title text on cards
      onSecondaryContainer: Colors.white, // Color of sub text on cards

      surface: Colors.white,
      background: Colors.black,
      error: redishPink,
      onPrimary: (Colors.green[900])!,
      onSecondary: creamBrownLight,
      onSurface: lightGrey,
      onBackground: lightGrey,
      onError: redishPink,
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      headline1: headLine1.copyWith(color: primaryColor1),
      headline2: headLine2.copyWith(color: primaryColor1),
      headline3: headLine3.copyWith(color: primaryColor1),
      headline4: headLine4.copyWith(color: primaryColor1),
      headline5: headLine5.copyWith(color: primaryColor1),

      bodyText1: bodyText1.copyWith(color: primaryColor1),
      bodyText2: bodyText2.copyWith(color: primaryColor1),
      //text-field style
      subtitle1: subTitle1.copyWith(color: primaryColor1),
      subtitle2: subTitle2.copyWith(
          color: Colors
              .white), // Sub text under a section title in a section container
    ),
    dividerColor: Colors.white,

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: bodyText1.copyWith(color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      hintStyle: bodyText1.copyWith(color: Colors.white),
    ),
    hintColor: Colors.white,
    unselectedWidgetColor:
        Colors.grey[700], // Color for not valid time slot container
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

  // Theme 2
  static final ThemeData theme2 = ThemeData(
    primaryColor: primaryColor1,
    primaryColorDark: primaryColor1,
    primaryColorLight: Colors.white,

    backgroundColor: themeBackgroundColor,
    scaffoldBackgroundColor: Colors.black,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white),

    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.white,
      labelColor: Colors.white,
      labelStyle: bodyText1.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: primaryColor1,
      ),
    ),
    dialogBackgroundColor: Colors.black,
    bottomAppBarColor: Colors.transparent, // Color of divider on appbar

    cardColor: themeBackgroundColor,
    colorScheme: ColorScheme(
      primary: (Colors.pink[900])!,
      secondary: primaryColor1, // Color of title text on cards
      onSecondaryContainer: Colors.white, // Color of sub text on cards

      surface: Colors.white,
      background: Colors.white,
      error: redishPink,
      onPrimary: (Colors.green[900])!,
      onSecondary: creamBrownLight,
      onSurface: lightGrey,
      onBackground: lightGrey,
      onError: redishPink,
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      headline1: headLine1.copyWith(color: primaryColor1),
      headline2: headLine2.copyWith(color: primaryColor1),
      headline3: headLine3.copyWith(color: primaryColor1),
      headline4: headLine4.copyWith(color: primaryColor1),
      headline5: headLine5.copyWith(color: primaryColor1),

      bodyText1: bodyText1.copyWith(color: primaryColor1),
      bodyText2: bodyText2.copyWith(color: primaryColor1),
      //text-field style
      subtitle1: subTitle1.copyWith(color: primaryColor1),
      subtitle2: subTitle2.copyWith(
          color: Colors
              .white), // Sub text under a section title in a section container
    ),
    dividerColor: Colors.white,

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: bodyText1.copyWith(color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      hintStyle: bodyText1.copyWith(color: Colors.white),
    ),
    hintColor: Colors.white,
    unselectedWidgetColor:
        Colors.grey[700], // Color for not valid time slot container
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

  static final TextStyle headLine1 = TextStyle(
    fontFamily: "Jost",
    fontSize: 100.sp,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle headLine2 = TextStyle(
    fontFamily: "Jost",
    fontSize: 50.sp,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle headLine3 = TextStyle(
    fontFamily: "Jost",
    fontSize: 30.sp,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle headLine4 = TextStyle(
    fontFamily: "Jost",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle headLine5 = TextStyle(
    fontFamily: "Jost",
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
