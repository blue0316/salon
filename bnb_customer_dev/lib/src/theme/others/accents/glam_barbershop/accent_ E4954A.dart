// ignore_for_file: file_names
import 'package:flutter/material.dart';
import '../../glam_barbershop.dart';

const _accentColor = Color(0XFFE4954A);

final ThemeData accentE4954A = ThemeData(
  primaryColor: _accentColor,
  primaryColorDark: _accentColor,
  primaryColorLight: Colors.white,
  scaffoldBackgroundColor: Colors.black,
  textSelectionTheme: const TextSelectionThemeData(cursorColor: GlamBarberShopTheme.lightBlack),

  tabBarTheme: TabBarTheme(
    unselectedLabelColor: Colors.white,
    labelColor: Colors.black,
    labelStyle: GlamBarberShopTheme.bodyText1.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    indicator: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: _accentColor,
    ),
  ),
  dialogBackgroundColor: Colors.black,

  cardColor: Colors.black,
  colorScheme: ColorScheme(
    primary: (Colors.pink[900])!,
    secondary: _accentColor, // Color of title text on cards
    onSecondaryContainer: Colors.white, // Color of sub text on cards

    surface: Colors.white,
    background: const Color(0XFF101010),

    error: GlamBarberShopTheme.redishPink,
    onPrimary: (Colors.green[900])!,
    onSecondary: GlamBarberShopTheme.creamBrownLight,
    onSurface: GlamBarberShopTheme.lightGrey,
    onBackground: GlamBarberShopTheme.lightGrey,
    onError: GlamBarberShopTheme.redishPink,
    brightness: Brightness.light,

    outlineVariant: Colors.white, // Color of divider on appbar
  ),
  textTheme: TextTheme(
    displayLarge: GlamBarberShopTheme.headLine1.copyWith(color: _accentColor),
    displayMedium: GlamBarberShopTheme.headLine2.copyWith(color: _accentColor),
    displaySmall: GlamBarberShopTheme.headLine3.copyWith(color: _accentColor),
    headlineMedium: GlamBarberShopTheme.headLine4.copyWith(color: _accentColor),
    headlineSmall: GlamBarberShopTheme.headLine5.copyWith(color: _accentColor),

    bodyLarge: GlamBarberShopTheme.bodyText1.copyWith(color: _accentColor),
    bodyMedium: GlamBarberShopTheme.bodyText2.copyWith(color: _accentColor),
    //text-field style
    titleMedium: GlamBarberShopTheme.subTitle1.copyWith(color: _accentColor),
    titleSmall: GlamBarberShopTheme.subTitle2.copyWith(color: Colors.black), // Sub text under a section title in a section container
  ),
  dividerColor: Colors.white,

  inputDecorationTheme: InputDecorationTheme(
    labelStyle: GlamBarberShopTheme.bodyText1.copyWith(color: Colors.white),
    border: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1),
    ),
    hintStyle: GlamBarberShopTheme.bodyText1.copyWith(color: Colors.white),
  ),
  hintColor: Colors.white,
  unselectedWidgetColor: Colors.grey[700], // Color for not valid time slot container
  highlightColor: _accentColor,
  // Stop

  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: GlamBarberShopTheme.bodyText1,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  ),
  focusColor: GlamBarberShopTheme.lightGrey,
  splashColor: GlamBarberShopTheme.lightGrey,
  hoverColor: GlamBarberShopTheme.lightGrey,
);
