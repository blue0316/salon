import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SquareButton extends ConsumerStatefulWidget {
  final double? height, width;
  final String text;
  final double? textSize;
  final VoidCallback onTap;
  final Widget? suffixIcon;
  final Color? buttonColor, borderColor, textColor, hoveredColor;
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
    this.hoveredColor,
    this.showSuffix = true,
    this.borderRadius,
    this.spaceBetweenButtonAndText,
    this.buttonWidth,
    this.weight,
    this.vSpacing,
    this.isGradient = false,
  }) : super(key: key);

  @override
  ConsumerState<SquareButton> createState() => _SquareButtonState();
}

class _SquareButtonState extends ConsumerState<SquareButton> {
  bool isHovered = false;

  void onEntered(bool isHovered) => setState(() {
        this.isHovered = isHovered;
      });

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => onEntered(true),
      onExit: (event) => onEntered(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: widget.width, //  ?? 220.h,
          height: widget.height ?? 50.h,
          decoration: BoxDecoration(
            color: isHovered ? (widget.hoveredColor ?? widget.buttonColor) : widget.buttonColor ?? Colors.white,
            border: Border.all(color: widget.borderColor ?? Colors.white, width: widget.buttonWidth ?? 1.5),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
            gradient: isHovered
                ? null
                : widget.isGradient
                    ? buttonGradient(themeType, theme)
                    : null,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: widget.vSpacing ?? 10, horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: widget.textSize ?? 18.sp,
                    fontWeight: widget.weight ?? FontWeight.w600,
                    color: widget.textColor,
                    fontFamily: "Inter-Light",
                  ),
                ),
                if (widget.showSuffix) SizedBox(width: widget.spaceBetweenButtonAndText ?? 10),
                if (widget.showSuffix)
                  SvgPicture.asset(
                    ThemeIcons.arrowDiagonal,
                    height: widget.textSize ?? 15.sp,
                    color: widget.textColor,
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
