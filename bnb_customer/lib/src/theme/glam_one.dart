// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlamOneTheme {
  static const Color textBlack = Color(0xff0E141E);
  static const Color lightBlack = Color(0xff1E2D3D);
  static const Color redishPink = Color(0xffff006e);
  static const Color creamBrownLight = Color(0xffE3AF7B);
  static const Color lightGrey = Color(0xff89959F);

  // MAIN COLORS 1
  static const primaryColor1 = Color(0XFFFFC692);
  static const deepOrange = Color(0XFFF48B72);

  // MAIN COLORS 2
  static const primaryColor2 = Colors.purple;

  // Theme 1
  static final ThemeData glamOneTheme = ThemeData(
    primaryColor: primaryColor1,
    primaryColorDark: deepOrange,
    primaryColorLight: primaryColor1,
    // backgroundColor: primaryColor1,
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
    cardColor: primaryColor1,
    colorScheme: ColorScheme(
      primary: (Colors.pink[900])!,
      secondary: Colors.black, // Color of title text on cards
      onSecondaryContainer: Colors.black, // Color of sub text on cardsf
      surface: Colors.white,
      background: primaryColor1,
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
      subtitle2: subTitle2.copyWith(color: Colors.black), // Sub text under a section title in a section container
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: bodyText1,
      iconTheme: const IconThemeData(
        color: textBlack,
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
    highlightColor: primaryColor1,

    // Stop
    focusColor: lightGrey,
    splashColor: lightGrey,
    hoverColor: lightGrey,
  );

  // Theme 2
  static final ThemeData main2 = ThemeData(
    primaryColor: Colors.purple,
    primaryColorDark: Colors.deepPurple,
    primaryColorLight: primaryColor1,
    // backgroundColor: primaryColor1,
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
    cardColor: primaryColor1,
    colorScheme: ColorScheme(
      primary: (Colors.pink[900])!,
      secondary: Colors.black, // Color of title text on cards
      onSecondaryContainer: Colors.black, // Color of sub text on cardsf
      surface: Colors.white,
      background: primaryColor1,
      error: redishPink,
      onPrimary: (Colors.green[900])!,
      onSecondary: creamBrownLight,
      onSurface: lightGrey,
      onBackground: lightGrey,
      onError: redishPink,
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      headline1: headLine1.copyWith(color: primaryColor2),
      headline2: headLine2.copyWith(color: primaryColor2),
      headline3: headLine3.copyWith(color: primaryColor2),
      headline4: headLine4.copyWith(color: primaryColor2),
      headline5: headLine5.copyWith(color: primaryColor2),

      bodyText1: bodyText1.copyWith(color: primaryColor2),
      bodyText2: bodyText2.copyWith(color: primaryColor2),
      //text-field style
      subtitle1: subTitle1.copyWith(color: primaryColor2),
      subtitle2: subTitle2.copyWith(color: Colors.black), // Sub text under a section title in a section container
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: bodyText1,
      iconTheme: const IconThemeData(
        color: textBlack,
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
    // Stop
    focusColor: lightGrey,
    highlightColor: primaryColor1,

    splashColor: lightGrey,
    hoverColor: lightGrey,
  );

  static final TextStyle headLine1 = TextStyle(
    fontFamily: "VASQUZ",
    fontSize: 100.sp,
    fontWeight: FontWeight.w600,
    // color: primaryColor1,
  );
  static final TextStyle headLine2 = TextStyle(
    fontFamily: "VASQUZ",
    fontSize: 50.sp,
    fontWeight: FontWeight.w500,
    // color: primaryColor1,
  );

  static final TextStyle headLine3 = TextStyle(
    fontFamily: "VASQUZ",
    fontSize: 30.sp,
    fontWeight: FontWeight.w500,
    // color: primaryColor1,
  );
  static final TextStyle headLine4 = TextStyle(
    fontFamily: "VASQUZ",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    // color: primaryColor1,
  );
  static final TextStyle headLine5 = TextStyle(
    fontFamily: "VASQUZ",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    // color: primaryColor1,
  );
  static final TextStyle bodyText1 = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    // color: primaryColor1,
  );
  static final TextStyle bodyText2 = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    // color: primaryColor1,
  );
  static final TextStyle subTitle1 = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    // color: primaryColor1,
  );
  static final TextStyle appointmentSubtitle = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    // color: primaryColor1,
  );
  static const TextStyle calTextStyle = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 14,
    // color: primaryColor1,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle calTextStyle2 = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 14,
    // color: primaryColor1,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle appointmentTitleStyle = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 14,
    // color: primaryColor1,
    fontWeight: FontWeight.w500,
  );

  // Sub Text under a Section Title
  static final TextStyle subTitle2 = TextStyle(
    fontFamily: "Gilroy",
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
