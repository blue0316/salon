import 'package:bbblient/src/theme/glam_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OvalButton extends StatelessWidget {
  final double? height, width;
  final String text;
  final double? textSize;
  final VoidCallback onTap;

  const OvalButton({
    Key? key,
    required this.text,
    this.textSize,
    this.height,
    this.width,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 145.h,
        height: height ?? 45.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: GlamOneTheme.primaryColor,
            width: 1.5,
          ),
          borderRadius: const BorderRadius.all(
            Radius.elliptical(150, 50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Center(
            child: Text(
              text,
              style: GlamOneTheme.bodyText2.copyWith(
                fontSize: textSize ?? 14.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
