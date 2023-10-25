// ignore_for_file: use_full_hex_values_for_flutter_colors, non_constant_identifier_names

import 'package:bbblient/src/views/themes/glam_one/core/utils/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// FORMERLY BARBERSHOP THEME
// Theme 4 ThemeData
class VintageCraftTheme {
  static Color themeBackgroundColor = ColorConstant.black900;

  static const Color textBlack = Color(0xff0E141E);
  static const Color lightBlack = Color(0xff1E2D3D);
  static const Color redishPink = Color(0xffff006e);
  static const Color creamBrownLight = Color(0xffE3AF7B);
  static const Color lightGrey = Color(0xff89959F);

  static Color primaryColor1 = Colors.white;
  static Color accentColor = const Color(0XFFDDC686);

  // Main Theme 1
  static final ThemeData mainTheme = ThemeData(
    primaryColor: primaryColor1,
    primaryColorDark: primaryColor1,
    primaryColorLight: Colors.white,
    scaffoldBackgroundColor: const Color(0XFF0D0D0E),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: lightBlack),
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.white,
      labelColor: const Color(0XFF0D0D0E),
      labelStyle: bodyText1.copyWith(color: const Color(0XFF0D0D0E), fontWeight: FontWeight.w600),
      indicator: BoxDecoration(borderRadius: BorderRadius.circular(50), color: primaryColor1),
    ),

    dialogBackgroundColor: const Color(0XFF0D0D0E),
    cardColor: Colors.black,
    colorScheme: ColorScheme(
      primary: (Colors.pink[900])!,
      secondary: accentColor,
      onSecondaryContainer: Colors.white, // Color of sub text on cards

      surface: Colors.white,
      background: const Color(0XFF0D0D0E),
      error: redishPink,
      onPrimary: (Colors.green[900])!,
      onSecondary: creamBrownLight,
      onSurface: lightGrey,
      onBackground: lightGrey,
      tertiary: Colors.white,
      onError: redishPink,
      brightness: Brightness.light,
      outlineVariant: Colors.transparent, // Color of divider on appbar
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
      // titleMedium: subTitle1.copyWith(color: primaryColor1),
      // titleSmall: subTitle2.copyWith(color: Colors.black), // Sub text under a section title in a section container
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
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    focusColor: lightGrey,
    splashColor: lightGrey,
    hoverColor: lightGrey,
  );

  static final TextStyle headLine1 = GoogleFonts.playfairDisplay(
    // fontFamily: "UNDERRATED",
    fontSize: 100.sp,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle headLine2 = GoogleFonts.playfairDisplay(
    // fontFamily: "UNDERRATED",
    fontSize: 50.sp,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle headLine3 = GoogleFonts.playfairDisplay(
    // fontFamily: "UNDERRATED",
    fontSize: 30.sp,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle headLine4 = GoogleFonts.playfairDisplay(
    // fontFamily: "UNDERRATED",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle headLine5 = GoogleFonts.playfairDisplay(
    // fontFamily: "UNDERRATED",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle bodyText1 = GoogleFonts.openSans(
    // fontFamily: "Poppins",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle bodyText2 = GoogleFonts.openSans(
    // fontFamily: "Poppins",
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );
}
