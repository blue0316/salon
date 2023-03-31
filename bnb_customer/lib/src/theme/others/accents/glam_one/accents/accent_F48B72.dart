// ignore_for_file: file_names

import 'package:bbblient/src/views/themes/glam_one/core/utils/color_constant.dart';
import 'package:flutter/material.dart';
import '../../../glam_one.dart';

const primaryOption2 = Color(0XFFF48B72);

final ThemeData accentF48B72 = ThemeData(
  primaryColor: primaryOption2,
  primaryColorDark: GlamOneTheme.primaryOption1,
  primaryColorLight: GlamOneTheme.primaryOption1,

  scaffoldBackgroundColor: Colors.black,
  textSelectionTheme: const TextSelectionThemeData(cursorColor: GlamOneTheme.lightBlack),
  tabBarTheme: TabBarTheme(
    unselectedLabelColor: primaryOption2,
    labelColor: Colors.black,
    labelStyle: GlamOneTheme.bodyText1.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    indicator: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: primaryOption2,
    ),
  ),

  dialogBackgroundColor: Colors.black,

  cardColor: primaryOption2,
  colorScheme: ColorScheme(
    primary: (Colors.pink[900])!,
    secondary: Colors.black, // Color of title text on cards
    onSecondaryContainer: Colors.black, // Color of sub text on cardsf
    surface: Colors.white,
    background: ColorConstant.black900,
    error: GlamOneTheme.redishPink,
    onPrimary: (Colors.green[900])!,
    onSecondary: GlamOneTheme.creamBrownLight,
    onSurface: GlamOneTheme.lightGrey,
    onBackground: GlamOneTheme.lightGrey,
    onError: GlamOneTheme.redishPink,
    brightness: Brightness.light, outlineVariant: Colors.white, // Color of divider on appbar
  ),
  textTheme: TextTheme(
    displayLarge: GlamOneTheme.headLine1.copyWith(color: primaryOption2),
    displayMedium: GlamOneTheme.headLine2.copyWith(color: primaryOption2),
    displaySmall: GlamOneTheme.headLine3.copyWith(color: primaryOption2),
    headlineMedium: GlamOneTheme.headLine4.copyWith(color: primaryOption2),
    headlineSmall: GlamOneTheme.headLine5.copyWith(color: primaryOption2),

    bodyLarge: GlamOneTheme.bodyText1.copyWith(color: primaryOption2),
    bodyMedium: GlamOneTheme.bodyText2.copyWith(color: primaryOption2),
    //text-field style
    titleMedium: GlamOneTheme.subTitle1.copyWith(color: primaryOption2),
    titleSmall: GlamOneTheme.subTitle2.copyWith(color: Colors.black), // Sub text under a section title in a section container
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: GlamOneTheme.bodyText1,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  ),
  dividerColor: primaryOption2,
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: GlamOneTheme.bodyText1.copyWith(color: Colors.black),
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
    hintStyle: GlamOneTheme.bodyText1.copyWith(color: Colors.black),
  ),
  unselectedWidgetColor: Colors.grey[700], // Color for not valid time slot container
  highlightColor: primaryOption2,

  // Stop
  focusColor: GlamOneTheme.lightGrey,

  splashColor: GlamOneTheme.lightGrey,
  hoverColor: GlamOneTheme.lightGrey,
);
