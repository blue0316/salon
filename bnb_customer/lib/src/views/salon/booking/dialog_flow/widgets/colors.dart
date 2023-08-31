import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';

// DON'T TOUCH THE DEFAULTS !!

Color? dialogLabelColorTheme(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Colors.white;
    case ThemeType.GlamMinimalDark:
      return Colors.black;

    default:
      return theme.tabBarTheme.labelColor;
  }
}

Color? isAddedSelectedColor(ThemeType themeType) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Colors.black;
    case ThemeType.GlamMinimalDark:
      return Colors.white;
    case ThemeType.GlamLight:
      return Colors.black;
    case ThemeType.Barbershop:
      return Colors.white;
    case ThemeType.DefaultLight:
      return Colors.black;

    default:
      return Colors.white;
  }
}

Color? serviceTabCategoryColor(ThemeType themeType) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Colors.white;
    case ThemeType.GlamMinimalDark:
      return Colors.black;
    case ThemeType.GlamLight:
      return Colors.white;
    case ThemeType.DefaultLight:
      return Colors.white;

    default:
      return Colors.black;
  }
}

Color loaderColor(ThemeType themeType) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Colors.white;
    case ThemeType.GlamMinimalDark:
      return Colors.black;
    case ThemeType.GlamLight:
      return Colors.white;
    case ThemeType.Barbershop:
      return Colors.black;
    case ThemeType.DefaultLight:
      return Colors.white;

    default:
      return Colors.black;
  }
}

Color selectMasterColor(ThemeType themeType) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Colors.black;
    case ThemeType.GlamMinimalDark:
      return Colors.white;
    case ThemeType.GlamLight:
      return Colors.black;
    case ThemeType.DefaultLight:
      return Colors.white;

    default:
      return Colors.white;
  }
}

Color? unSelectedMasterColor(ThemeType themeType) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Colors.white;
    case ThemeType.GlamMinimalDark:
      return Colors.black;
    case ThemeType.GlamLight:
      return Colors.black;
    case ThemeType.DefaultLight:
      return Colors.black;

    default:
      return Colors.black;
  }
}

Color? dialogButtonColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return theme.primaryColor;
    case ThemeType.GlamMinimalDark:
      return theme.primaryColor;
    case ThemeType.GlamLight:
      return theme.primaryColor;
    case ThemeType.Barbershop:
      return theme.primaryColor;

    default:
      return theme.primaryColor;
  }
}

Color? dialogBackButtonColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Colors.white;
    case ThemeType.GlamMinimalDark:
      return Colors.transparent;
    case ThemeType.GlamLight:
      return theme.dialogBackgroundColor;

    default:
      return theme.dialogBackgroundColor;
  }
}

Color dialogTextColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return theme.primaryColor;
    case ThemeType.GlamMinimalDark:
      return Colors.black;
    case ThemeType.GlamLight:
      return theme.primaryColor;
    case ThemeType.GlamGradient:
      return theme.primaryColor;

    default:
      return Colors.black;
  }
}

Color selectTimeSlot(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return theme.primaryColor;
    case ThemeType.GlamMinimalDark:
      return AppTheme.creamBrown;

    default:
      return theme.primaryColor;
  }
}

Color selectedServiceCardOnDayAndTime(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return theme.primaryColor;
    case ThemeType.GlamMinimalDark:
      return theme.primaryColor;
    case ThemeType.GlamLight:
      return theme.primaryColor.withOpacity(0.5);

    default:
      return theme.primaryColor;
  }
}

Color selectMasterContainerColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.DefaultLight:
      return Colors.black;

    default:
      return theme.dialogBackgroundColor;
  }
}

Color? selectSlots(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Colors.white;
    case ThemeType.GlamMinimalDark:
      return Colors.black;
    case ThemeType.GlamLight:
      return Colors.white;
    case ThemeType.Glam:
      return Colors.white;
    case ThemeType.DefaultLight:
      return Colors.white;

    default:
      return theme.colorScheme.tertiary;
  }
}

Color? currentDateTextColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Colors.white;
    case ThemeType.DefaultLight:
      return Colors.white;

    default:
      return theme.colorScheme.tertiary;
  }
}

Color? slotsBoxColorAvailableAndSelected(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Colors.white;

    default:
      return theme.primaryColor;
  }
}

Color? notCurrentDateTextColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Colors.black;
    case ThemeType.GlamMinimalDark:
      return Colors.white;
    case ThemeType.GlamLight:
      return Colors.black;
    case ThemeType.Glam:
      return Colors.white;
    case ThemeType.DefaultLight:
      return Colors.white;

    default:
      return theme.colorScheme.tertiary;
  }
}

Color? dropdownBackgroundColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    // case ThemeType.GlamMinimalLight:
    //   return Colors.black;
    // case ThemeType.GlamMinimalDark:
    //   return Colors.white;
    // case ThemeType.GlamLight:
    //   return Colors.black;
    // case ThemeType.Glam:
    //   return Colors.white;
    // case ThemeType.DefaultLight:
    //   return Colors.white;

    default:
      return theme.dialogBackgroundColor;
  }
}
