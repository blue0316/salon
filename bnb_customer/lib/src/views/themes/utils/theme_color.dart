import 'package:bbblient/src/theme/others/barbershop.dart';
import 'package:bbblient/src/theme/others/glam_barbershop.dart';
import 'package:bbblient/src/theme/others/glam_one.dart';
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

ThemeData getGlamBarbershopTheme(String colorCode) {
  switch (colorCode) {
    case 'FFC692': // TODO: CHANGE THIS
      return GlamBarberShopTheme.mainTheme;
    case 'blublu':
      return GlamBarberShopTheme.theme2;
    // case 'FFC692':
    //   return GlamOneTheme.glamOneTheme;

    default:
      return GlamBarberShopTheme.mainTheme;
  }
}

ThemeData getBarbershopTheme(String colorCode) {
  switch (colorCode) {
    case 'FFC692': // TODO: CHANGE THIS
      return BarbershopTheme.mainTheme;
    case 'blublu':
      return BarbershopTheme.theme2;
    // case 'FFC692':
    //   return GlamOneTheme.glamOneTheme;

    default:
      return BarbershopTheme.mainTheme;
  }
}
