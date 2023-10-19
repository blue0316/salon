// ignore_for_file: use_full_hex_values_for_flutter_colors, non_constant_identifier_names

import 'package:bbblient/src/views/themes/glam_one/core/utils/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Theme 3 ThemeData
class GentleTouchDarkTheme {
  static const Color textBlack = Color(0xff0E141E);
  static const Color lightBlack = Color(0xff1E2D3D);
  static const Color redishPink = Color(0xffff006e);
  static const Color creamBrownLight = Color(0xffE3AF7B);
  static const Color lightGrey = Color(0xff89959F);

  // MAIN COLORS 1
  static const primaryColor1 = Colors.white;
  static Color accentColor = Colors.white;

  // Theme 1
  static final ThemeData mainTheme = ThemeData(
    primaryColor: primaryColor1,
    primaryColorDark: primaryColor1,
    primaryColorLight: primaryColor1,
    scaffoldBackgroundColor: Colors.black,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: lightBlack),
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: primaryColor1,
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
      secondary: accentColor, // Color of title text on cards
      onSecondaryContainer: Colors.black, // Color of sub text on cardsf
      surface: Colors.white,
      background: ColorConstant.black900,
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

      // Use these 3 colors for gradient
      surfaceVariant: const Color(0XFF8DBBEC),
      onSurfaceVariant: const Color(0XFFFFDA92),
      surfaceTint: const Color(0XFFF48B72),
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
      titleSmall: subTitle2.copyWith(color: primaryColor1), // Sub text under a section title in a section container
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: bodyText1,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    dividerColor: const Color(0XFF616161),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: bodyText1.copyWith(color: const Color(0XFF9A9A9A)),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0XFF1D1E20), width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0XFF1D1E20), width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0XFF1D1E20), width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      hintStyle: bodyText1.copyWith(color: const Color(0XFF9A9A9A)),
    ),
    unselectedWidgetColor: Colors.grey[700], // Color for not valid time slot container
    highlightColor: primaryColor1,

    // Stop
    focusColor: lightGrey,
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
    fontFamily: "Poppins",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    // color: primaryColor1,
  );
  static final TextStyle bodyText2 = TextStyle(
    fontFamily: "Poppins",
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    // color: primaryColor1,
  );
  static final TextStyle subTitle1 = TextStyle(
    fontFamily: "Poppins",
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    // color: primaryColor1,
  );
  static final TextStyle appointmentSubtitle = TextStyle(
    fontFamily: "Poppins",
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    // color: primaryColor1,
  );
  static const TextStyle calTextStyle = TextStyle(
    fontFamily: "Poppins",
    fontSize: 14,
    // color: primaryColor1,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle calTextStyle2 = TextStyle(
    fontFamily: "Poppins",
    fontSize: 14,
    // color: primaryColor1,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle appointmentTitleStyle = TextStyle(
    fontFamily: "Poppins",
    fontSize: 14,
    // color: primaryColor1,
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
