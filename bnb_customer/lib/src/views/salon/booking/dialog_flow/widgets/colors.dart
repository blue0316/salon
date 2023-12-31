import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';

// DON'T TOUCH THE DEFAULTS !!

Color? dialogLabelColorTheme(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.CityMuseLight:
      return Colors.white;
    case ThemeType.CityMuseDark:
      return Colors.black;

    default:
      return theme.tabBarTheme.labelColor;
  }
}

Color? isAddedSelectedColor(ThemeType themeType) {
  switch (themeType) {
    case ThemeType.CityMuseLight:
      return Colors.black;
    case ThemeType.CityMuseDark:
      return Colors.white;
    case ThemeType.GentleTouch:
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
    case ThemeType.CityMuseLight:
      return Colors.white;
    case ThemeType.CityMuseDark:
      return Colors.black;
    case ThemeType.GentleTouch:
      return Colors.white;
    case ThemeType.DefaultLight:
      return Colors.white;

    default:
      return Colors.black;
  }
}

Color loaderColor(ThemeType themeType) {
  switch (themeType) {
    case ThemeType.CityMuseLight:
      return Colors.white;
    case ThemeType.CityMuseDark:
      return Colors.black;
    case ThemeType.GentleTouch:
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
    case ThemeType.CityMuseLight:
      return Colors.black;
    case ThemeType.CityMuseDark:
      return Colors.white;
    case ThemeType.GentleTouch:
      return Colors.black;
    case ThemeType.DefaultLight:
      return Colors.white;

    default:
      return Colors.white;
  }
}

Color? unSelectedMasterColor(ThemeType themeType) {
  switch (themeType) {
    case ThemeType.CityMuseLight:
      return Colors.white;
    case ThemeType.CityMuseDark:
      return Colors.black;
    case ThemeType.GentleTouch:
      return Colors.black;
    case ThemeType.DefaultLight:
      return Colors.black;

    default:
      return Colors.black;
  }
}

Color? dialogButtonColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    // case ThemeType.GlamMinimalLight:
    //   return theme.primaryColor;
    // case ThemeType.GlamMinimalDark:
    //   return theme.primaryColor;
    // case ThemeType.GentleTouch:
    //   return theme.primaryColor;
    case ThemeType.Barbershop:
      return theme.primaryColor;

    default:
      return theme.colorScheme.secondary;
  }
}

Color? dialogBackButtonColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.CityMuseLight:
      return Colors.white;
    case ThemeType.CityMuseDark:
      return Colors.transparent;
    case ThemeType.GentleTouch:
      return theme.dialogBackgroundColor;

    default:
      return theme.dialogBackgroundColor;
  }
}

Color dialogTextColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.CityMuseLight:
      return theme.primaryColor;
    case ThemeType.CityMuseDark:
      return Colors.black;
    case ThemeType.GentleTouch:
      return theme.primaryColor;
    case ThemeType.GentleTouchDark:
      return theme.primaryColor;

    default:
      return Colors.black;
  }
}

Color selectTimeSlot(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.CityMuseLight:
      return theme.primaryColor;
    case ThemeType.CityMuseDark:
      return AppTheme.creamBrown;

    default:
      return theme.primaryColor;
  }
}

Color selectedServiceCardOnDayAndTime(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.CityMuseLight:
      return theme.primaryColor;
    case ThemeType.CityMuseDark:
      return theme.primaryColor;
    case ThemeType.GentleTouch:
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
    case ThemeType.CityMuseLight:
      return Colors.white;
    case ThemeType.CityMuseDark:
      return Colors.black;
    case ThemeType.GentleTouch:
      return Colors.white;
    case ThemeType.GentleTouchDark:
      return Colors.black;
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
    case ThemeType.CityMuseLight:
      return Colors.white;
    case ThemeType.DefaultLight:
      return Colors.white;
    case ThemeType.GentleTouch:
      return Colors.white;
    case ThemeType.GentleTouchDark:
      return Colors.black;
    case ThemeType.CityMuseDark:
      return Colors.black;

    default:
      return theme.colorScheme.tertiary;
  }
}

Color? slotsBoxColorAvailableAndSelected(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.CityMuseLight:
      return Colors.white;

    default:
      return theme.primaryColor;
  }
}

Color? notCurrentDateTextColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.CityMuseLight:
      return Colors.black;
    case ThemeType.CityMuseDark:
      return Colors.white;
    case ThemeType.GentleTouch:
      return Colors.black;
    case ThemeType.Glam:
      return Colors.white;
    case ThemeType.DefaultLight:
      return Colors.black;

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
    // case ThemeType.GentleTouch:
    //   return Colors.black;
    // case ThemeType.Glam:
    //   return Colors.white;
    // case ThemeType.DefaultLight:
    //   return Colors.white;

    default:
      return theme.dialogBackgroundColor;
  }
}

Color? horizontalTimePickerColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GentleTouchDark:
      return Colors.black;
    case ThemeType.CityMuseDark:
      return Colors.black;

    default:
      return Colors.white;
  }
}
