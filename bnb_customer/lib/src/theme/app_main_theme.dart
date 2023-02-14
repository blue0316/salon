// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:bbblient/src/theme/glam_barbershop.dart';
import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/views/themes/glam_two/glam_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  AppTheme._() : super();

  //shadows
  static final List<BoxShadow> defaultShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.30),
      offset: const Offset(0.0, 0),
      blurRadius: 4.0,
    ),
  ];
  static final List<BoxShadow> lightShadow = [
    const BoxShadow(color: Colors.black12, offset: Offset(1, 2), blurRadius: 3.0, spreadRadius: 3),
  ];

  static const padding = EdgeInsets.all(margin);

  static const double margin = 16;
  static const double borderRadius = 10;

  static const Color white = Colors.white;
  static const Color creamBrown = Color(0xffAB7358);
  static const Color creamBrownLight = Color(0xffE3AF7B);
  static const Color lightBlack = Color(0xff1E2D3D);

  static const Color lightGrey2 = Color(0xffF6F6F6);
  static const Color midGrey = Color(0xffEAEAEA);
  static const Color coolerGrey = Color(0xffF2F4F9);
  static const Color coolGrey = Color(0xffD8DDE8);
  static const Color coolergrey = Color(0xffF2F4F9);
  static const Color milkeyGrey = Color(0xffF7F8FA);
  static const Color iconGrey = Color(0xff97A1AA);
  static const Color divider2 = Color(0xffDADCE0);
  static const Color milkeyGreyDark = Color(0xFFC4C5C6);
  static const Color lightGrey = Color(0xff89959F);
  static const Color textBlack = Color(0xff0E141E);
  static const Color lightGrey3 = Color(0xff857E7B);

  static const Color redishPink = Color(0xffff006e);
  static const Color redishWarning = Color(0xffDB6960);
  static const Color pitchBlack = Color(0xff0C0F13);
  static const Color oliveLight = Color(0xff8AB5A6);

  static const Color white2 = Color(0xffFCFCFC);
  static const Color white3 = Color(0xffE5E5E5);
  static const Color black = Colors.black;
  static const Color black2 = Color(0xff352B28);
  static const Color black3 = Color(0xff343434);
  static const Color green = Color(0xff5E9D72);
  static const Color green2 = Color(0xff95AB9D);
  static const Color green3 = Color(0xff7EB18E);
  static const Color grey = Color(0xffC4C4C4);
  static const Color grey2 = Color(0xffD6D4D4);
  static const Color grey3 = Color(0xffEBE9E9);
  static const Color grey4 = Color(0xffD7D6D6);
  static const Color grey5 = Color(0xffD3D3D3);
  static const Color greyBegie = Color(0xffFCF8F7);
  static const Color greyshade = Color(0xffFAFAFA);
  static const Color btnColor = Color(0xff1bb534b);
  //master theme  colors
  static const Color divider = Color(0xffE3B5A5);
  static const Color yellow = Color(0xffFFC775);
  static const Color bottomBarIconColor = Color(0xff81665E);
  static const Color master1 = green2;
  static const Color grey1 = Color(0xff6E6E6E);

  //New theme colors for new booking flow
  static const Color bookingBlack = Color(0xff0A0A0A);
  static const Color bookingWhite = Color(0xffF5F5F5);
  static const Color bookingGray = Color(0xff9D9D9D);
  static const Color bookingYellow = Color(0xffFBC844);

  static const Color master2 = divider;
  static const Color master3 = Color(0xffB6CDD7);
  static const Color master4 = yellow;
  static const Color master5 = Color(0xffC36642);
  static const Color master6 = bottomBarIconColor;
  static const Color master7 = Color(0xff48cae4);
  static const Color master8 = Color(0xff14213d);
  static const Color master9 = Color(0xffcaffbf);
  static const Color master10 = Color(0xffa5a58d);
  static const List<Color> masterColors = [master1, master2, master3, master4, master5, master6, master7, master8, master9, master10];

// colorScheme
  static const Color creamBrownPrimaryVariant = Color(0xFFAE7C63);
  static const Color creamBrownSecondaryVarient = Color(0xffE3AF7B);

  static final TextStyle hintStyle = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: lightGrey,
  );

  static final TextStyle headLine1 = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: lightBlack,
  );
  static final TextStyle headLine2 = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static final TextStyle headLine3 = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: lightBlack,
  );
  static final TextStyle headLine4 = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: lightGrey,
  );
  static final TextStyle headLine5 = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 16.sp,
    fontWeight: FontWeight.w300,
    color: lightGrey,
  );
  static final TextStyle bodyText1 = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: textBlack,
  );
  static final TextStyle bodyText2 = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: lightGrey,
  );
  static final TextStyle subTitle1 = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: lightBlack,
  );
  static final TextStyle appointmentSubtitle = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: black2,
  );
  static const TextStyle calTextStyle = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle calTextStyle2 = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle appointmentTitleStyle = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 14,
    color: lightGrey3,
    fontWeight: FontWeight.w500,
  );

  static final ThemeData lightTheme = ThemeData(
    primaryColor: creamBrown,
    dialogBackgroundColor: Colors.white,
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.black,
      labelColor: Colors.white,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.black,
      ),
    ),
    colorScheme: const ColorScheme(
      primary: creamBrown,
      secondary: creamBrownLight,
      surface: Colors.white,
      background: milkeyGrey,
      error: redishPink,
      onPrimary: creamBrown,
      onSecondary: creamBrownLight,
      onSurface: lightGrey,
      onBackground: lightGrey,
      onError: redishPink,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: milkeyGrey,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 1.2,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: lightBlack,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: hintStyle,
    ),
    textTheme: TextTheme(
      headline1: headLine1,
      headline2: headLine2,
      headline3: headLine3,
      headline4: headLine4,
      headline5: headLine5,
      bodyText1: bodyText1,
      bodyText2: bodyText2,
      //text-field style
      subtitle1: subTitle1,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: bodyText1,
      iconTheme: const IconThemeData(
        color: textBlack,
      ),
    ),
    dividerColor: Colors.white,
    focusColor: lightGrey,
    highlightColor: milkeyGreyDark,
    splashColor: milkeyGreyDark,
    hoverColor: milkeyGreyDark,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: lightBlack,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: lightBlack),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 1.2,
    ),
    inputDecorationTheme: InputDecorationTheme(hintStyle: hintStyle),
    colorScheme: const ColorScheme(
      primary: creamBrown,
      secondary: creamBrownLight,
      surface: Colors.white,
      background: milkeyGrey,
      error: redishPink,
      onPrimary: creamBrown,
      onSecondary: creamBrownLight,
      onSurface: lightGrey,
      onBackground: lightGrey,
      onError: redishPink,
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      headline1: headLine1,
      headline2: headLine2,
      headline3: headLine3,
      headline4: headLine4,
      headline5: headLine5,

      bodyText1: bodyText1,
      bodyText2: bodyText2,
      //text-field style
      subtitle1: subTitle1,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: bodyText1,
      iconTheme: const IconThemeData(
        color: textBlack,
      ),
    ),
    dividerColor: Colors.white,
    focusColor: lightGrey,
    highlightColor: milkeyGreyDark,
    splashColor: milkeyGreyDark,
    hoverColor: milkeyGreyDark,
  );

  // Theme 1
  static final ThemeData glamOneTheme = ThemeData(
    primaryColor: GlamOneTheme.primaryColor,
    primaryColorDark: GlamOneTheme.deepOrange,
    primaryColorLight: GlamOneTheme.primaryColor,
    // backgroundColor: GlamOneTheme.primaryColor,
    scaffoldBackgroundColor: Colors.black,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: lightBlack),

    tabBarTheme: TabBarTheme(
      unselectedLabelColor: GlamOneTheme.primaryColor,
      labelColor: GlamOneTheme.deepOrange,
      labelStyle: GlamBarberShopTheme.bodyText1.copyWith(
        color: GlamOneTheme.deepOrange,
        fontWeight: FontWeight.w600,
      ),
      indicator: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.5, color: GlamOneTheme.deepOrange)),
      ),
    ),
    dialogBackgroundColor: Colors.black,
    cardColor: GlamOneTheme.primaryColor,
    colorScheme: ColorScheme(
      primary: (Colors.pink[900])!,
      secondary: Colors.black, // Color of title text on cards
      onSecondaryContainer: Colors.black, // Color of sub text on cards
      surface: Colors.white,
      background: GlamOneTheme.primaryColor,
      error: redishPink,
      onPrimary: (Colors.green[900])!,
      onSecondary: creamBrownLight,
      onSurface: lightGrey,
      onBackground: lightGrey,
      onError: redishPink,
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      headline1: GlamOneTheme.headLine1,
      headline2: GlamOneTheme.headLine2,
      headline3: GlamOneTheme.headLine3,
      headline4: GlamOneTheme.headLine4,
      headline5: GlamOneTheme.headLine5,

      bodyText1: GlamOneTheme.bodyText1,
      bodyText2: GlamOneTheme.bodyText2,
      //text-field style
      subtitle1: GlamOneTheme.subTitle1,
      subtitle2: GlamOneTheme.subTitle2, // Sub text under a section title in a section container
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

    // Stop
    focusColor: lightGrey,
    highlightColor: milkeyGreyDark,
    splashColor: milkeyGreyDark,
    hoverColor: milkeyGreyDark,
  );

  // Theme 2
  static final ThemeData barbershopTheme = ThemeData(
    primaryColor: GlamBarberShopTheme.primaryColor,
    primaryColorDark: GlamBarberShopTheme.primaryColor,
    primaryColorLight: Colors.white,

    // backgroundColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: lightBlack),

    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.white,
      labelColor: GlamBarberShopTheme.primaryColor,
      labelStyle: GlamBarberShopTheme.bodyText1.copyWith(
        color: GlamBarberShopTheme.primaryColor,
        fontWeight: FontWeight.w600,
      ),
      indicator: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.5, color: Colors.white)),
      ),
    ),
    dialogBackgroundColor: Colors.black,
    cardColor: Colors.black,
    colorScheme: ColorScheme(
      primary: (Colors.pink[900])!,
      secondary: GlamBarberShopTheme.primaryColor, // Color of title text on cards
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
      headline1: GlamBarberShopTheme.headLine1,
      headline2: GlamBarberShopTheme.headLine2,
      headline3: GlamBarberShopTheme.headLine3,
      headline4: GlamBarberShopTheme.headLine4,
      headline5: GlamBarberShopTheme.headLine5,

      bodyText1: GlamBarberShopTheme.bodyText1,
      bodyText2: GlamBarberShopTheme.bodyText2,
      //text-field style
      subtitle1: GlamBarberShopTheme.subTitle1,
      subtitle2: GlamBarberShopTheme.subTitle2, // Sub text under a section title in a section container
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

    // Stop

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: bodyText1,
      iconTheme: const IconThemeData(
        color: textBlack,
      ),
    ),
    focusColor: lightGrey,
    highlightColor: milkeyGreyDark,
    splashColor: milkeyGreyDark,
    hoverColor: milkeyGreyDark,
  );
}
