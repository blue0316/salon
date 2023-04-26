// ignore_for_file: file_names
import 'package:bbblient/src/theme/others/glam_gradient.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/color_constant.dart';
import 'package:flutter/material.dart';

const _accentColor = Color(0XFFFFB36A);

final ThemeData accentFFB36A = ThemeData(
  primaryColor: _accentColor,
  primaryColorDark: GlamGradientTheme.deepOrange,
  primaryColorLight: _accentColor,
  scaffoldBackgroundColor: Colors.black,
  textSelectionTheme: const TextSelectionThemeData(cursorColor: GlamGradientTheme.lightBlack),
  tabBarTheme: TabBarTheme(
    unselectedLabelColor: _accentColor,
    labelColor: Colors.black,
    labelStyle: GlamGradientTheme.bodyText1.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    indicator: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: _accentColor,
    ),
  ),
  dialogBackgroundColor: Colors.black,

  cardColor: _accentColor,
  colorScheme: ColorScheme(
    primary: (Colors.pink[900])!,
    secondary: Colors.black, // Color of title text on cards
    onSecondaryContainer: Colors.black, // Color of sub text on cardsf
    surface: Colors.white,
    background: ColorConstant.black900,
    error: GlamGradientTheme.redishPink,
    onPrimary: (Colors.green[900])!,
    onSecondary: GlamGradientTheme.creamBrownLight,
    onSurface: GlamGradientTheme.lightGrey,
    // Dialog Colors
    onBackground: Colors.white,
    tertiary: Colors.white, // Text colors on dialog
    onError: GlamGradientTheme.redishPink,
    brightness: Brightness.light,
    outlineVariant: Colors.white, // Color of divider on appbar

    // Use these 3 colors for gradient
    surfaceVariant: const Color(0XFFFFB36A),
    onSurfaceVariant: const Color(0XFFEFBB34),
    surfaceTint: const Color(0XFFEF5734),
  ),
  textTheme: TextTheme(
    displayLarge: GlamGradientTheme.headLine1.copyWith(color: _accentColor),
    displayMedium: GlamGradientTheme.headLine2.copyWith(color: _accentColor),
    displaySmall: GlamGradientTheme.headLine3.copyWith(color: _accentColor),
    headlineMedium: GlamGradientTheme.headLine4.copyWith(color: _accentColor),
    headlineSmall: GlamGradientTheme.headLine5.copyWith(color: _accentColor),

    bodyLarge: GlamGradientTheme.bodyText1.copyWith(color: _accentColor),
    bodyMedium: GlamGradientTheme.bodyText2.copyWith(color: _accentColor),
    //text-field style
    titleMedium: GlamGradientTheme.subTitle1.copyWith(color: _accentColor),
    titleSmall: GlamGradientTheme.subTitle2.copyWith(color: Colors.black), // Sub text under a section title in a section container
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: GlamGradientTheme.bodyText1,
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  dividerColor: const Color(0XFFF48B72),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: GlamGradientTheme.bodyText1.copyWith(color: Colors.black),
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
    hintStyle: GlamGradientTheme.bodyText1.copyWith(color: Colors.black),
  ),
  unselectedWidgetColor: Colors.grey[700], // Color for not valid time slot container
  highlightColor: _accentColor,

  // Stop
  focusColor: GlamGradientTheme.lightGrey,
  splashColor: GlamGradientTheme.lightGrey,
  hoverColor: GlamGradientTheme.lightGrey,
);
