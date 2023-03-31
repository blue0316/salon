// ignore_for_file: file_names

import 'package:bbblient/src/theme/others/barbershop.dart';
import 'package:flutter/material.dart';

const _accentColor = Color(0XFFE4954A);

final ThemeData accentE4954A = ThemeData(
  primaryColor: _accentColor,
  primaryColorDark: _accentColor,
  primaryColorLight: Colors.white,
  scaffoldBackgroundColor: Colors.black,
  textSelectionTheme: const TextSelectionThemeData(cursorColor: BarbershopTheme.lightBlack),
  tabBarTheme: TabBarTheme(
    unselectedLabelColor: Colors.white,
    labelColor: Colors.black,
    labelStyle: BarbershopTheme.bodyText1.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
    indicator: BoxDecoration(borderRadius: BorderRadius.circular(50), color: _accentColor),
  ),

  dialogBackgroundColor: Colors.black,
  cardColor: Colors.black,
  colorScheme: ColorScheme(
    primary: (Colors.pink[900])!,
    secondary: _accentColor, // Color of title text on cards
    onSecondaryContainer: Colors.white, // Color of sub text on cards

    surface: Colors.white,
    background: const Color(0XFF0A0A0A),
    error: BarbershopTheme.redishPink,
    onPrimary: (Colors.green[900])!,
    onSecondary: BarbershopTheme.creamBrownLight,
    onSurface: BarbershopTheme.lightGrey,
    onBackground: BarbershopTheme.lightGrey,
    onError: BarbershopTheme.redishPink,
    brightness: Brightness.light,
    outlineVariant: Colors.transparent, // Color of divider on appbar
  ),
  textTheme: TextTheme(
    displayLarge: BarbershopTheme.headLine1.copyWith(color: _accentColor),
    displayMedium: BarbershopTheme.headLine2.copyWith(color: _accentColor),
    displaySmall: BarbershopTheme.headLine3.copyWith(color: _accentColor),
    headlineMedium: BarbershopTheme.headLine4.copyWith(color: _accentColor),
    headlineSmall: BarbershopTheme.headLine5.copyWith(color: _accentColor),

    bodyLarge: BarbershopTheme.bodyText1.copyWith(color: _accentColor),
    bodyMedium: BarbershopTheme.bodyText2.copyWith(color: _accentColor),
    //text-field style
    titleMedium: BarbershopTheme.subTitle1.copyWith(color: _accentColor),
    titleSmall: BarbershopTheme.subTitle2.copyWith(color: Colors.black), // Sub text under a section title in a section container
  ),
  dividerColor: Colors.white,

  inputDecorationTheme: InputDecorationTheme(
    labelStyle: BarbershopTheme.bodyText1.copyWith(color: Colors.white),
    border: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1),
    ),
    hintStyle: BarbershopTheme.bodyText1.copyWith(color: Colors.white),
  ),
  hintColor: Colors.white,
  unselectedWidgetColor: Colors.grey[700], // Color for not valid time slot container
  highlightColor: _accentColor,
  // Stop

  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: BarbershopTheme.bodyText1,
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  // focusColor: BarbershopTheme.lightGrey,
  // splashColor: BarbershopTheme.lightGrey,
  // hoverColor: BarbershopTheme.lightGrey,
);
