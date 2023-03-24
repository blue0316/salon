// ignore_for_file: file_names
// Accent Color F79F7B
import 'package:bbblient/src/theme/others/glam_one.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/color_constant.dart';
import 'package:flutter/material.dart';

const primaryOption3 = Color(0XFFF79F7B);

final ThemeData accentF79F7B = ThemeData(
  primaryColor: primaryOption3,
  primaryColorDark: GlamOneTheme.primaryOption1,
  primaryColorLight: GlamOneTheme.primaryOption1,
  backgroundColor: ColorConstant.black900,
  scaffoldBackgroundColor: Colors.black,
  textSelectionTheme: const TextSelectionThemeData(cursorColor: GlamOneTheme.lightBlack),
  tabBarTheme: TabBarTheme(
    unselectedLabelColor: primaryOption3,
    labelColor: Colors.black,
    labelStyle: GlamOneTheme.bodyText1.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    indicator: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: primaryOption3,
    ),
  ),

  dialogBackgroundColor: Colors.black,
  bottomAppBarColor: Colors.white, // Color of divider on appbar

  cardColor: primaryOption3,
  colorScheme: ColorScheme(
    primary: (Colors.pink[900])!,
    secondary: Colors.black, // Color of title text on cards
    onSecondaryContainer: Colors.black, // Color of sub text on cardsf
    surface: Colors.white,
    background: primaryOption3,
    error: GlamOneTheme.redishPink,
    onPrimary: (Colors.green[900])!,
    onSecondary: GlamOneTheme.creamBrownLight,
    onSurface: GlamOneTheme.lightGrey,
    onBackground: GlamOneTheme.lightGrey,
    onError: GlamOneTheme.redishPink,
    brightness: Brightness.light,
  ),
  textTheme: TextTheme(
    headline1: GlamOneTheme.headLine1.copyWith(color: primaryOption3),
    headline2: GlamOneTheme.headLine2.copyWith(color: primaryOption3),
    headline3: GlamOneTheme.headLine3.copyWith(color: primaryOption3),
    headline4: GlamOneTheme.headLine4.copyWith(color: primaryOption3),
    headline5: GlamOneTheme.headLine5.copyWith(color: primaryOption3),

    bodyText1: GlamOneTheme.bodyText1.copyWith(color: primaryOption3),
    bodyText2: GlamOneTheme.bodyText2.copyWith(color: primaryOption3),
    //text-field style
    subtitle1: GlamOneTheme.subTitle1.copyWith(color: primaryOption3),
    subtitle2: GlamOneTheme.subTitle2.copyWith(color: Colors.black), // Sub text under a section title in a section container
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: GlamOneTheme.bodyText1,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  ),
  dividerColor: primaryOption3,
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
  highlightColor: primaryOption3,

  // Stop
  focusColor: GlamOneTheme.lightGrey,

  splashColor: GlamOneTheme.lightGrey,
  hoverColor: GlamOneTheme.lightGrey,
);
