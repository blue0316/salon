import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';

Color? headerColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.DefaultLight:
      return const Color(0XFFFFFFFF);
    case ThemeType.DefaultDark:
      return const Color(0XFF202020);
    case ThemeType.GentleTouch:
      return const Color(0XFFFFFFFF);
    case ThemeType.GlamMinimalLight:
      return const Color(0XFFFFFFFF);
    default:
      return const Color(0XFF202020);
  }
}

Color? titleColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.DefaultLight:
      return Colors.black;
    // case ThemeType.DefaultDark:
    //   return theme.primaryColor;

    default:
      return theme.primaryColor;
  }
}

Color? valueColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.DefaultLight:
      return Colors.black;
    case ThemeType.GentleTouch:
      return Colors.black;
    case ThemeType.GlamMinimalLight:
      return Colors.black;

    default:
      return Colors.white;
  }
}

Color? chooseReviewTag(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GlamMinimalDark:
      return Colors.black;

    default:
      return Colors.white;
  }
}

Color? buttonColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.DefaultLight:
      return Colors.black;

    default:
      return Colors.white;
  }
}

Color? confirmButton(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    default:
      return theme.primaryColor;
  }
}

Color buttonTextColor(ThemeType themeType) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Colors.white;
    case ThemeType.GlamMinimalDark:
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

Color borderColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.DefaultLight:
      return Colors.black;
    case ThemeType.GentleTouch:
      return Colors.black;
    case ThemeType.GlamMinimalLight:
      return Colors.black;

    default:
      return theme.primaryColor;
  }
}

Color textBorderColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.DefaultLight:
      return const Color(0XFFACACAC);
    case ThemeType.GentleTouch:
      return Colors.black;
    case ThemeType.GlamMinimalLight:
      return Colors.black;

    default:
      return const Color(0XFF35373B);
  }
}

Color confirmationTextColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.DefaultLight:
      return Colors.black;
    case ThemeType.GentleTouch:
      return Colors.black;
    case ThemeType.GlamMinimalLight:
      return Colors.black;

    default:
      return Colors.white;
  }
}

Color boxColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.DefaultLight:
      return const Color(0XFFFFFFFF);
    case ThemeType.GentleTouch:
      return const Color(0XFFFFFFFF);
    case ThemeType.GlamMinimalLight:
      return const Color(0XFFFFFFFF);

    default:
      return const Color(0XFF202020);
  }
}

Color scaffoldBGColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.DefaultLight:
      return const Color(0XFFEFEFEF);
    case ThemeType.GentleTouch:
      return const Color(0XFFEFEFEF);
    case ThemeType.GlamMinimalLight:
      return const Color(0XFFEFEFEF);

    default:
      return theme.colorScheme.background;
  }
}

Color transparentLoaderColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.DefaultLight:
      return Colors.black;
    case ThemeType.GentleTouch:
      return Colors.black;
    case ThemeType.GlamMinimalLight:
      return Colors.black;

    default:
      return theme.primaryColor;
  }
}

Color loaderColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.DefaultLight:
      return Colors.white;
    case ThemeType.GentleTouch:
      return Colors.white;
    case ThemeType.GlamMinimalLight:
      return Colors.white;

    default:
      return Colors.black; // theme.primaryColor;
  }
}

Color reviewButtonText(ThemeType themeType) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Colors.white;
    case ThemeType.GlamMinimalDark:
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

Color feedbackBGColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.DefaultLight:
      return Colors.white;
    case ThemeType.GentleTouch:
      return Colors.white;
    case ThemeType.GlamMinimalLight:
      return Colors.white;

    default:
      return const Color(0xFF383838);
  }
}
