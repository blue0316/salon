// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Theme 7 ThemeData
class GlamMinimalDark {
  static Color themeBackgroundColor = Colors.black;

  static const Color textBlack = Color(0xff0E141E);
  static const Color lightBlack = Color(0xff1E2D3D);
  static const Color redishPink = Color(0xffff006e);
  static const Color creamBrownLight = Color(0xffE3AF7B);
  static const Color lightGrey = Color(0xff89959F);

  // MAIN COLORS 1
  static Color primaryColor1 = Colors.white;

  // Main Theme 1
  static final ThemeData mainTheme = ThemeData(
    primaryColor: primaryColor1,
    primaryColorDark: primaryColor1,
    primaryColorLight: Colors.white,
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
    dialogBackgroundColor: Colors.black,
    cardColor: themeBackgroundColor,
    colorScheme: ColorScheme(
      primary: (Colors.pink[900])!,
      secondary: primaryColor1, // Color of title text on cards
      onSecondaryContainer: Colors.white, // Color of sub text on cards

      surface: Colors.white,
      background: themeBackgroundColor,
      error: redishPink,
      onPrimary: (Colors.green[900])!,
      onSecondary: creamBrownLight,
      onSurface: lightGrey,
      // Dialog Colors
      onBackground: primaryColor1,
      tertiary: primaryColor1, // Text colors on dialog

      onError: redishPink,
      brightness: Brightness.light,
      outlineVariant: Colors.black, // Color of divider on appbar
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
      titleSmall: subTitle2.copyWith(color: Colors.white), // Sub text under a section title in a section container
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
