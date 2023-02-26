import 'package:bbblient/src/theme/glam_one.dart';
import 'package:flutter/material.dart';

ThemeData getGlamDataTheme(String colorCode) {
  switch (colorCode) {
    case 'FFC692':
      return GlamOneTheme.glamOneTheme;
    case 'blublu':
      return GlamOneTheme.main2;
    // case 'FFC692':
    //   return GlamOneTheme.glamOneTheme;

    default:
      return GlamOneTheme.glamOneTheme;
  }
}
