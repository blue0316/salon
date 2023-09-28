import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SquareButton extends ConsumerWidget {
  final double? height, width;
  final String text;
  final double? textSize;
  final VoidCallback onTap;
  final Widget? suffixIcon;
  final Color? buttonColor, borderColor, textColor;
  final bool showSuffix;
  final double? borderRadius;
  final double? spaceBetweenButtonAndText, buttonWidth;
  final FontWeight? weight;
  final double? vSpacing;
  final bool isGradient;

  const SquareButton({
    Key? key,
    this.height,
    this.width,
    required this.text,
    this.textSize,
    required this.onTap,
    this.suffixIcon,
    this.buttonColor,
    this.borderColor,
    this.textColor,
    this.showSuffix = true,
    this.borderRadius,
    this.spaceBetweenButtonAndText,
    this.buttonWidth,
    this.weight,
    this.vSpacing,
    this.isGradient = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width, //  ?? 220.h,
          height: height ?? 50.h,
          decoration: BoxDecoration(
            color: buttonColor ?? Colors.white,
            border: Border.all(color: borderColor ?? Colors.white, width: buttonWidth ?? 1.5),
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
            gradient: isGradient ? buttonGradient(themeType, theme) : null,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: vSpacing ?? 10, horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: textSize ?? 18.sp,
                    fontWeight: weight ?? FontWeight.w600,
                    color: textColor,
                    fontFamily: "Inter-Light",
                  ),
                ),
                if (showSuffix) SizedBox(width: spaceBetweenButtonAndText ?? 10),
                if (showSuffix)
                  SvgPicture.asset(
                    ThemeIcons.arrowDiagonal,
                    height: textSize ?? 15.sp,
                    color: textColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Gradient? buttonGradient(ThemeType type, ThemeData theme, {double? opacity}) {
  switch (type) {
    case ThemeType.GentleTouch:
      return LinearGradient(
        begin: const Alignment(-0.6, -0.4),
        end: const Alignment(2, 1),
        colors: [theme.colorScheme.secondary, Colors.white],
      );

    case ThemeType.GentleTouchDark:
      return LinearGradient(
        begin: const Alignment(-0.6, -0.4),
        end: const Alignment(2, 1),
        colors: [theme.colorScheme.secondary.withOpacity(opacity ?? 1), Colors.white],
      );

    default:
      return null;
  }
}
