import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultipleStatesButton extends ConsumerStatefulWidget {
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

  const MultipleStatesButton({
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
  ConsumerState<MultipleStatesButton> createState() => _MultipleStatesButtonState();
}

class _MultipleStatesButtonState extends ConsumerState<MultipleStatesButton> {
  bool isHovered = false;
  bool isTapped = false;

  void onEntered(bool isHovered) => setState(() {
        this.isHovered = isHovered;
      });

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return TapRegion(
      onTapInside: (event) => setState(() => isTapped = true),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => onEntered(true),
        onExit: (event) {
          onEntered(false);
          setState(() => isTapped = false);
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: widget.width, //  ?? 220.h,
            height: widget.height ?? 50.h,
            decoration: BoxDecoration(
              color: isHovered ? theme.colorScheme.secondary : widget.buttonColor ?? Colors.white,
              border: (isHovered && isTapped)
                  ? null
                  : Border.all(
                      color: widget.borderColor ?? Colors.white,
                      width: widget.buttonWidth ?? 1.5,
                    ),
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
              gradient: isHovered
                  ? null
                  : widget.isGradient
                      ? buttonGradient(themeType, theme)
                      : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isHovered && !isTapped)
                  Opacity(
                    opacity: 0.17, // 10% opacity
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                if (isTapped)
                  Opacity(
                    opacity: 0.2,
                    child: Container(
                      color: const Color(0XFF000000),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: widget.vSpacing ?? 10, horizontal: 15),
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: widget.textSize ?? 18.sp,
                      fontWeight: widget.weight ?? FontWeight.w600,
                      color: widget.textColor,
                      fontFamily: "Inter-Light",
                    ),
                  ),
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
