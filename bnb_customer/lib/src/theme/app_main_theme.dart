// ignore_for_file: use_full_hex_values_for_flutter_colors

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

  static final TextStyle aboutScreenStyle = TextStyle(
    fontFamily: "Poppins",
    fontSize: 40.sp,
    fontWeight: FontWeight.w600,
    color: bookingBlack,
  );

  static final TextStyle hintStyle = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: lightGrey,
  );

  static final TextStyle headLine1 = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: lightBlack,
  );
  static final TextStyle headLine2 = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static final TextStyle headLine3 = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: lightBlack,
  );
  static final TextStyle headLine4 = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: lightGrey,
  );
  static final TextStyle headLine5 = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 16.sp,
    fontWeight: FontWeight.w300,
    color: lightGrey,
  );
  static final TextStyle bodyText1 = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: textBlack,
  );
  static final TextStyle bodyText2 = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: lightGrey,
  );
  static final TextStyle subTitle1 = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: lightBlack,
  );
  static final TextStyle appointmentSubtitle = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: black2,
  );
  static const TextStyle calTextStyle = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle calTextStyle2 = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle appointmentTitleStyle = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 14,
    color: lightGrey3,
    fontWeight: FontWeight.w500,
  );

  static const Color primaryLightThemeColor = Colors.white;
  static const Color primaryDarkBackgroundThemeColor = Colors.black;
  static const Color darkPrimaryThemeColor = Color(0XFFF49071);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: creamBrown,
    dialogBackgroundColor: primaryLightThemeColor,
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.black,
      labelColor: Colors.white,
      indicator: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.black),
      labelStyle: AppTheme.bodyText1,
    ),
    colorScheme: const ColorScheme(
      primary: creamBrown,
      secondary: creamBrownLight,
      surface: Colors.white,
      background: primaryLightThemeColor,
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
    textSelectionTheme: const TextSelectionThemeData(cursorColor: lightBlack),
    inputDecorationTheme: InputDecorationTheme(hintStyle: hintStyle),
    textTheme: TextTheme(
      displayLarge: headLine1.copyWith(color: Colors.black),
      displayMedium: headLine2.copyWith(color: Colors.black),
      displaySmall: headLine3.copyWith(color: Colors.black),
      headlineMedium: headLine4.copyWith(color: Colors.black),
      headlineSmall: headLine5.copyWith(color: Colors.black),
      bodyLarge: bodyText1.copyWith(color: Colors.black),
      bodyMedium: bodyText2.copyWith(color: Colors.black),
      titleMedium: subTitle1.copyWith(color: Colors.black),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryLightThemeColor,
      titleTextStyle: bodyText1,
      iconTheme: const IconThemeData(color: textBlack),
    ),
    dividerColor: Colors.black,
    focusColor: lightGrey,
    highlightColor: const Color(0XFFEBE9E9), // Color to select services on booking dialog
    splashColor: milkeyGreyDark,
    hoverColor: milkeyGreyDark,
    unselectedWidgetColor: const Color.fromARGB(255, 239, 239, 239), // Color for not valid time slot container
    primaryIconTheme: const IconThemeData(color: Colors.black),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: darkPrimaryThemeColor,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: lightBlack),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: primaryDarkBackgroundThemeColor,
      elevation: 1.2,
    ),
    inputDecorationTheme: InputDecorationTheme(hintStyle: hintStyle),
    colorScheme: const ColorScheme(
      primary: creamBrown,
      secondary: creamBrownLight,
      surface: primaryDarkBackgroundThemeColor,
      background: primaryDarkBackgroundThemeColor,
      error: redishPink,
      onPrimary: creamBrown,
      onSecondary: creamBrownLight,
      onSurface: lightGrey,
      onBackground: lightGrey,
      onError: redishPink,
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      displayLarge: headLine1.copyWith(color: darkPrimaryThemeColor),
      displayMedium: headLine2.copyWith(color: Colors.white),
      displaySmall: headLine3.copyWith(color: Colors.white),
      headlineMedium: headLine4.copyWith(color: Colors.white),
      headlineSmall: headLine5.copyWith(color: Colors.white),
      bodyLarge: bodyText1.copyWith(color: Colors.white),
      bodyMedium: bodyText2.copyWith(color: Colors.white),
      titleMedium: subTitle1.copyWith(color: Colors.white),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryDarkBackgroundThemeColor,
      titleTextStyle: bodyText1,
      iconTheme: const IconThemeData(color: textBlack),
    ),
    dividerColor: Colors.white,
    focusColor: lightGrey,
    highlightColor: milkeyGreyDark,
    splashColor: milkeyGreyDark,
    hoverColor: milkeyGreyDark,
    primaryIconTheme: const IconThemeData(color: darkPrimaryThemeColor),
  );
}
