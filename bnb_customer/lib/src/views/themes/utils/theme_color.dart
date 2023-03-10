import 'package:bbblient/src/theme/others/barbershop.dart';
import 'package:bbblient/src/theme/others/glam_barbershop.dart';
import 'package:bbblient/src/theme/others/glam_gradient.dart';
import 'package:bbblient/src/theme/others/glam_one.dart';
import 'package:flutter/material.dart';

// Theme 1 - GLAM
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

// Theme 2 - GLAM BARBERSHOP
ThemeData getGlamBarbershopTheme(String colorCode) {
  switch (colorCode) {
    case 'FFC692':
      return GlamBarberShopTheme.mainTheme;
    case 'blublu':
      return GlamBarberShopTheme.theme2;
    // case 'FFC692':
    //   return GlamOneTheme.glamOneTheme;

    default:
      return GlamBarberShopTheme.mainTheme;
  }
}

// Theme 3 - GLAM GRADIENT
ThemeData getGlamGradientTheme(String colorCode) {
  switch (colorCode) {
    case 'FFC692':
      return GlamGradientTheme.mainTheme;
    case 'blublu':
      return GlamGradientTheme.mainTheme2;
    // case 'FFC692':
    //   return GlamGradientTheme.glamOneTheme;

    default:
      return GlamGradientTheme.mainTheme;
  }
}

// Theme 4 - BARBERSHOP
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

// Theme 5 - GLAM LIGHT
ThemeData getGlamLightTheme(String colorCode) {
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
