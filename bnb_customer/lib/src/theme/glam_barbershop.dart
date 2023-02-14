// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlamBarberShopTheme {
  static const primaryColor = Color(0XFFDDC686);

  static final TextStyle headLine1 = TextStyle(
    fontFamily: "VASQUZ", // TODO: CHANGE TO UNDERRATED
    fontSize: 100.sp,
    fontWeight: FontWeight.w600,
    color: primaryColor,
  );
  static final TextStyle headLine2 = TextStyle(
    fontFamily: "VASQUZ",
    fontSize: 50.sp,
    fontWeight: FontWeight.w500,
    color: primaryColor,
  );

  static final TextStyle headLine3 = TextStyle(
    fontFamily: "VASQUZ",
    fontSize: 30.sp,
    fontWeight: FontWeight.w500,
    color: primaryColor,
  );
  static final TextStyle headLine4 = TextStyle(
    fontFamily: "VASQUZ",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: primaryColor,
  );
  static final TextStyle headLine5 = TextStyle(
    fontFamily: "VASQUZ",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: primaryColor,
  );
  static final TextStyle bodyText1 = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: primaryColor,
  );
  static final TextStyle bodyText2 = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: primaryColor,
  );
  static final TextStyle subTitle1 = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: primaryColor,
  );
  static final TextStyle appointmentSubtitle = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: primaryColor,
  );
  static const TextStyle calTextStyle = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 14,
    color: primaryColor,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle calTextStyle2 = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 14,
    color: primaryColor,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle appointmentTitleStyle = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 14,
    color: primaryColor,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle subTitle2 = TextStyle(
    fontFamily: "Gilroy",
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
