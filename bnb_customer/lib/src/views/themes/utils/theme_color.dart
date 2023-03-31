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
      GlamOneTheme.primaryOption1 = const Color(0XFFFFC692);
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
      if (colorCode != null) {
        try {
          // Decode color from string
          String valueString = colorCode.split('(0x')[1].split(')')[0];
          int value = int.parse(valueString, radix: 16);

          GlamOneTheme.primaryOption1 = Color(value);
        } catch (e) {
          GlamOneTheme.primaryOption1 = const Color(0XFFFFC692);
        }
      }

      return GlamOneTheme.AccentFFC692;
  }
}

// Theme 2 - GLAM BARBERSHOP
ThemeData getGlamBarbershopTheme(String? colorCode) {
  switch (colorCode) {
    case null:
      GlamBarberShopTheme.primaryColor1 = const Color(0XFFDDC686);

      return GlamBarberShopTheme.mainTheme;
    case 'DDC686':
      return GlamBarberShopTheme.AccentDDC686;
    case 'E3824F':
      return GlamBarberShopTheme.AccentE3824F;
    case 'D5824C':
      return GlamBarberShopTheme.AccentD5824C;
    case 'FABD64':
      return GlamBarberShopTheme.AccentFABD64;
    case 'E3A681':
      return GlamBarberShopTheme.AccentE3A681;
    case 'F89F54':
      return GlamBarberShopTheme.AccentF89F54;
    case 'C17150':
      return GlamBarberShopTheme.AccentC17150;
    case 'E4954A':
      return GlamBarberShopTheme.AccentE4954A;

    default:
      if (colorCode != null) {
        try {
          // Decode color from string
          String valueString = colorCode.split('(0x')[1].split(')')[0];
          int value = int.parse(valueString, radix: 16);

          GlamBarberShopTheme.primaryColor1 = Color(value);
        } catch (e) {
          GlamBarberShopTheme.primaryColor1 = const Color(0XFFDDC686);
        }
      }
      return GlamBarberShopTheme.mainTheme;
  }
}

// Theme 3 - GLAM GRADIENT
ThemeData getGlamGradientTheme(String? colorCode) {
  switch (colorCode) {
    case null: // 'FFC692':
      return GlamGradientTheme.mainTheme;
    case 'Color(0xfff49457)':
      return GlamGradientTheme.AccentF49457;
    case 'Color(0xfff1affc)':
      return GlamGradientTheme.AccentF1AFFC;
    case 'Color(0xffffb36a)':
      return GlamGradientTheme.AccentFFB36A;
    case 'Color(0xffef7158)':
      return GlamGradientTheme.AccentEF7158;
    case 'Color(0xff58ddef)':
      return GlamGradientTheme.Accent58DDEF;

    default:
      return GlamGradientTheme.mainTheme;
  }
}

// Theme 4 - BARBERSHOP
ThemeData getBarbershopTheme(String? colorCode) {
  switch (colorCode) {
    case null:
      BarbershopTheme.primaryColor1 = const Color(0XFFDDC686);

      return BarbershopTheme.mainTheme;
    case 'E3824F':
      return BarbershopTheme.AccentE3824F;

    case 'D5824C':
      return BarbershopTheme.AccentD5824C;

    case 'FABD64':
      return BarbershopTheme.AccentFABD64;

    case 'E3A681':
      return BarbershopTheme.AccentE3A681;

    case 'F89F54':
      return BarbershopTheme.AccentF89F54;

    case 'C17150':
      return BarbershopTheme.AccentC17150;

    case 'E4954A':
      return BarbershopTheme.AccentE4954A;

    default:
      if (colorCode != null) {
        try {
          // Decode color from string
          String valueString = colorCode.split('(0x')[1].split(')')[0];
          int value = int.parse(valueString, radix: 16);

          BarbershopTheme.primaryColor1 = Color(value);
        } catch (e) {
          BarbershopTheme.primaryColor1 = const Color(0XFFDDC686);
        }
      }

      return BarbershopTheme.mainTheme;
  }
}

// Theme 5 - GLAM LIGHT
ThemeData getGlamLightTheme(String? colorCode) {
  switch (colorCode) {
    case null:
      GlamLightTheme.primaryColor1 = Colors.black;

      return GlamLightTheme.mainTheme;

    // case 'FFC692':
    //   return GlamOneTheme.glamOneTheme;

    default:
      if (colorCode != null) {
        try {
          // Decode color from string
          String valueString = colorCode.split('(0x')[1].split(')')[0];
          int value = int.parse(valueString, radix: 16);

          GlamLightTheme.primaryColor1 = Color(value);
        } catch (e) {
          GlamLightTheme.primaryColor1 = Colors.black;
        }
      }
      return GlamLightTheme.mainTheme;
  }
}

// Theme 6 - GLAM MINIMAL LIGHT
ThemeData getGlamMinimalLightTheme(String? colorCode) {
  switch (colorCode) {
    case null: // 'FFC692':
      GlamMinimalLight.themeBackgroundColor = Colors.white;

      return GlamMinimalLight.mainTheme;

    // case 'FFC692':
    //   return GlamOneTheme.glamOneTheme;

    default:
      if (colorCode != null) {
        try {
          // Decode color from string
          String valueString = colorCode.split('(0x')[1].split(')')[0];
          int value = int.parse(valueString, radix: 16);

          GlamMinimalLight.themeBackgroundColor = Color(value);
        } catch (e) {
          GlamMinimalLight.themeBackgroundColor = Colors.white;
        }
      }

      return GlamMinimalLight.mainTheme;
  }
}

// Theme 7 - GLAM MINIMAL DARK
ThemeData getGlamMinimalDarkTheme(String? colorCode) {
  switch (colorCode) {
    case null: // 'FFC692':
      GlamMinimalDark.primaryColor1 = Colors.white;

      return GlamMinimalDark.mainTheme;

    // case 'FFC692':
    //   return GlamOneTheme.glamOneTheme;

    default:
      if (colorCode != null) {
        try {
          // Decode color from string
          String valueString = colorCode.split('(0x')[1].split(')')[0];
          int value = int.parse(valueString, radix: 16);

          GlamMinimalDark.primaryColor1 = Color(value);
        } catch (e) {
          GlamMinimalDark.primaryColor1 = Colors.white;
        }
      }

      return GlamMinimalDark.mainTheme;
  }
}
