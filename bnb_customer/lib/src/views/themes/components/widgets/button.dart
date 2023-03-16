import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SquareButton extends StatelessWidget {
  final double? height, width;
  final String text;
  final double? textSize;
  final VoidCallback onTap;
  final Widget? suffixIcon;
  final Color? buttonColor, borderColor, textColor;
  final bool showSuffix;
  final double? borderRadius;

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width, //  ?? 220.h,
          height: height ?? 50.h,
          decoration: BoxDecoration(
            color: buttonColor ?? Colors.white,
            border: Border.all(color: borderColor ?? Colors.white, width: 1.5),
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: AppTheme.bodyText1.copyWith(
                    fontSize: textSize ?? 18.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                if (showSuffix) const SizedBox(width: 5),
                if (showSuffix)
                  Icon(
                    Icons.arrow_upward_rounded,
                    color: textColor ?? Colors.black,
                    size: textSize ?? 20.sp,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
