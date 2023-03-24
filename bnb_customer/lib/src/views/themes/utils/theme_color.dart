import 'package:bbblient/src/theme/others/barbershop.dart';
import 'package:bbblient/src/theme/others/glam_barbershop.dart';
import 'package:bbblient/src/theme/others/glam_gradient.dart';
import 'package:bbblient/src/theme/others/glam_light.dart';
import 'package:bbblient/src/theme/others/glam_minimal_dark.dart';
import 'package:bbblient/src/theme/others/glam_minimal_light.dart';
import 'package:bbblient/src/theme/others/glam_one.dart';
import 'package:flutter/material.dart';

// Theme 1 - GLAM
ThemeData getGlamDataTheme(String? colorCode) {
  switch (colorCode) {
    case null:
      return GlamOneTheme.AccentFFC692;
    case 'F48B72':
      return GlamOneTheme.AccentF48B72;
    case 'F79F7B':
      return GlamOneTheme.AccentF79F7B;
    case 'FFCF71':
      return GlamOneTheme.AccentFFCF71;
    case 'E3AB9E':
      return GlamOneTheme.AccentE3AB9E;
    case 'E2BCBF':
      return GlamOneTheme.AccentE2BCBF;
    case 'F9EFE6':
      return GlamOneTheme.AccentF9EFE6;
    case 'AFC7D2':
      return GlamOneTheme.AccentAFC7D2;
    case 'D7AFFF':
      return GlamOneTheme.AccentD7AFFF;
    case 'F9E0CA':
      return GlamOneTheme.AccentF9E0CA;

    default:
      return GlamOneTheme.AccentFFC692;
  }
}

// Theme 2 - GLAM BARBERSHOP
ThemeData getGlamBarbershopTheme(String? colorCode) {
  switch (colorCode) {
    case null: // 'FFC692':
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
ThemeData getGlamGradientTheme(String? colorCode) {
  switch (colorCode) {
    case null: // 'FFC692':
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
ThemeData getBarbershopTheme(String? colorCode) {
  switch (colorCode) {
    case null: // 'FFC692': // TODO: CHANGE THIS
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
ThemeData getGlamLightTheme(String? colorCode) {
  switch (colorCode) {
    case null: // 'FFC692': // TODO: CHANGE THIS
      return GlamLightTheme.mainTheme;
    case 'blublu':
      return GlamLightTheme.theme2;
    // case 'FFC692':
    //   return GlamOneTheme.glamOneTheme;

    default:
      return GlamLightTheme.mainTheme;
  }
}

// Theme 6 - GLAM MINIMAL LIGHT
ThemeData getGlamMinimalLightTheme(String? colorCode) {
  switch (colorCode) {
    case null: // 'FFC692':
      return GlamMinimalLight.mainTheme;
    case 'blublu':
      return GlamMinimalLight.theme2;
    // case 'FFC692':
    //   return GlamOneTheme.glamOneTheme;

    default:
      return GlamMinimalLight.mainTheme;
  }
} // Theme 6 - GLAM MINIMAL DARK

ThemeData getGlamMinimalDarkTheme(String? colorCode) {
  switch (colorCode) {
    case null: // 'FFC692':
      return GlamMinimalDark.mainTheme;
    case 'blublu':
      return GlamMinimalDark.theme2;
    // case 'FFC692':
    //   return GlamOneTheme.glamOneTheme;

    default:
      return GlamMinimalLight.mainTheme;
  }
}
