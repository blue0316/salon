import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';

BoxDecoration shopTabBarTheme(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GlamLight:
      return BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: theme.primaryColorDark),
        ),
      );
    case ThemeType.GlamMinimalLight:
      return BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: theme.primaryColorDark),
        ),
      );
    case ThemeType.GlamMinimalDark:
      return BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: theme.primaryColorDark),
        ),
      );
    case ThemeType.Glam:
      return BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: theme.primaryColorDark),
        ),
      );

    default:
      return BoxDecoration(
        color: theme.primaryColor,
        border: Border(
          bottom: BorderSide(width: 1.5, color: theme.primaryColorDark),
        ),
      );
  }
}
