import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color black90001 = fromHex('#000000');

  static Color black90033 = fromHex('#330a0a0a');

  static Color black900E5 = fromHex('#e50a0a0a');

  static Color black90000 = fromHex('#00000000');

  static Color black900 = fromHex('#090909');

  static Color deepOrange300 = fromHex('#f48b72');

  static Color amber100 = fromHex('#ffeeb2');

  static Color amber200 = fromHex('#ffda92');

  static Color deepPurpleA100 = fromHex('#c18fff');

  static Color blueGray900 = fromHex('#333333');

  static Color whiteA700 = fromHex('#ffffff');

  static Color orange200 = fromHex('#ffc692');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
