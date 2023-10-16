import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/theme/others/barbershop.dart';
import 'package:bbblient/src/theme/others/glam_barbershop.dart';
import 'package:bbblient/src/theme/others/gentle_touch_dark.dart';
import 'package:bbblient/src/theme/others/gentle_touch.dart';
import 'package:bbblient/src/theme/others/glam_minimal_dark.dart';
import 'package:bbblient/src/theme/others/glam_minimal_light.dart';
import 'package:bbblient/src/theme/others/glam_one.dart';
import 'package:flutter/material.dart';

// Theme 0 - DEFAULT LIGHT
ThemeData getDefaultLightTheme(String? colorCode) {
  switch (colorCode) {
    case null:
      AppTheme.primaryLightThemeColor = const Color(0XFF000000);

      return AppTheme.customLightTheme;

    default:
      if (colorCode != null) {
        try {
          // Decode color from string
          String valueString = colorCode.split('(0x')[1].split(')')[0];
          int value = int.parse(valueString, radix: 16);

          AppTheme.primaryLightThemeColor = Color(value);
        } catch (e) {
          AppTheme.primaryLightThemeColor = const Color(0XFF000000);
        }
      }

      return AppTheme.customLightTheme;
  }
}

// Theme 1 - DEFAULT DARK
ThemeData getDefaultDarkTheme(String? colorCode) {
  switch (colorCode) {
    case null:
      AppTheme.darkPrimaryThemeColor = const Color(0XFFF48B72);
      return AppTheme.darkTheme;

    default:
      if (colorCode != null) {
        try {
          // Decode color from string
          String valueString = colorCode.split('(0x')[1].split(')')[0];
          int value = int.parse(valueString, radix: 16);

          AppTheme.darkPrimaryThemeColor = Color(value);
        } catch (e) {
          AppTheme.darkPrimaryThemeColor = const Color(0XFFF48B72);
        }
      }

      return AppTheme.darkTheme;
  }
}

// Theme 2- GLAM
ThemeData getGlamDataTheme(String? colorCode) {
  switch (colorCode) {
    case null:
      GlamOneTheme.primaryOption1 = const Color(0XFFFFC692);
      return GlamOneTheme.mainTheme;
    // case 'F48B72':
    //   return GlamOneTheme.AccentF48B72;
    // case 'F79F7B':
    //   return GlamOneTheme.AccentF79F7B;
    // case 'FFCF71':
    //   return GlamOneTheme.AccentFFCF71;
    // case 'E3AB9E':
    //   return GlamOneTheme.AccentE3AB9E;
    // case 'E2BCBF':
    //   return GlamOneTheme.AccentE2BCBF;
    // case 'F9EFE6':
    //   return GlamOneTheme.AccentF9EFE6;
    // case 'AFC7D2':
    //   return GlamOneTheme.AccentAFC7D2;
    // case 'D7AFFF':
    //   return GlamOneTheme.AccentD7AFFF;
    // case 'F9E0CA':
    //   return GlamOneTheme.AccentF9E0CA;

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

      return GlamOneTheme.mainTheme;
  }
}

// Theme 3 - GLAM BARBERSHOP
ThemeData getGlamBarbershopTheme(String? colorCode) {
  switch (colorCode) {
    case null:
      GlamBarberShopTheme.primaryColor1 = const Color(0XFFDDC686);

      return GlamBarberShopTheme.mainTheme;

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

// Theme 4 - GLAM GRADIENT
ThemeData getGentleTouchDarkTheme(String? colorCode) {
  switch (colorCode) {
    case null:
      GentleTouchDarkTheme.accentColor = Colors.white;
      return GentleTouchDarkTheme.mainTheme;

    default:
      if (colorCode != null) {
        try {
          // Decode color from string
          String valueString = colorCode.split('(0x')[1].split(')')[0];
          int value = int.parse(valueString, radix: 16);

          GentleTouchDarkTheme.accentColor = Color(value);
        } catch (e) {
          GentleTouchDarkTheme.accentColor = Colors.white;
        }
      }
      return GentleTouchDarkTheme.mainTheme;
  }
}

// Theme 5 - BARBERSHOP
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

// Theme 6 - GLAM LIGHT
ThemeData getGentleTouchTheme(String? colorCode) {
  switch (colorCode) {
    case null:
      GentleTouchTheme.accentColor = Colors.black;
      return GentleTouchTheme.mainTheme;

    default:
      if (colorCode != null) {
        try {
          // Decode color from string
          String valueString = colorCode.split('(0x')[1].split(')')[0];
          int value = int.parse(valueString, radix: 16);

          GentleTouchTheme.accentColor = Color(value);
        } catch (e) {
          GentleTouchTheme.accentColor = Colors.black;
        }
      }
      return GentleTouchTheme.mainTheme;
  }
}

// Theme 7 - GLAM MINIMAL LIGHT
ThemeData getGlamMinimalLightTheme(String? colorCode) {
  switch (colorCode) {
    case null: // 'FFC692':
     // GlamMinimalLight.themeBackgroundColor = Colors.white;

      return GlamMinimalLight.lightTheme;

    // case 'FFC692':
    //   return GlamOneTheme.glamOneTheme;

    default:
      if (colorCode != null) {
        try {
          // Decode color from string
          String valueString = colorCode.split('(0x')[1].split(')')[0];
          int value = int.parse(valueString, radix: 16);

          GlamMinimalLight.accentColor = Color(value);
        } catch (e) {
          
          GlamMinimalLight.accentColor = Color(0xfff4dfe9);
        }
      }

       return GlamMinimalLight.lightTheme;
  }
   
}

// Theme 8 - GLAM MINIMAL DARK
ThemeData getGlamMinimalDarkTheme(String? colorCode) {
  switch (colorCode) {
    case null: // 'FFC692':
      GlamMinimalDark.primaryColor1 = Colors.white;

      return GlamMinimalDark.darkTheme;

    // case 'FFC692':
    //   return GlamOneTheme.glamOneTheme;

    default:
      if (colorCode != null) {
        try {
          // Decode color from string
          String valueString = colorCode.split('(0x')[1].split(')')[0];
          int value = int.parse(valueString, radix: 16);

          GlamMinimalDark.accentColor = Color(value);
        } catch (e) {
          GlamMinimalDark.accentColor= Color(0xfff4dfe9);
        }
      }

      return GlamMinimalDark.darkTheme;
  }
  // return GlamMinimalDark.darkTheme;
}
