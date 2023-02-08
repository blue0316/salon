import 'package:bbblient/src/theme/glam_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OvalButton extends StatelessWidget {
  final String text;
  final double? textSize;
  const OvalButton({Key? key, required this.text, this.textSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145.h,
      height: 45.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: GlamOneTheme.primaryColor,
          width: 1.5,
        ),
        borderRadius: const BorderRadius.all(Radius.elliptical(150, 50)),
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
    );
  }
}
