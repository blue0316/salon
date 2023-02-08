import 'package:bbblient/src/theme/glam_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeHeader extends StatelessWidget {
  const ThemeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Miami's Best",
          style: GlamOneTheme.headLine1.copyWith(
            letterSpacing: 0.5,
          ),
        ),
        Text(
          "Beauty Salon",
          style: GlamOneTheme.headLine2.copyWith(
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 20.h),
        Stack(
          alignment: Alignment.center,
          children: [
            RotationTransition(
              turns: const AlwaysStoppedAnimation(175 / 360), // (15 / 360),
              child: Container(
                width: 170.h,
                height: 65.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: GlamOneTheme.primaryColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(170),
                ),
              ),
            ),
            Text(
              "Book Now",
              style: GlamOneTheme.bodyText1.copyWith(),
            ),
          ],
        ),
        SizedBox(height: 200.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const GlamOneButton(
              text: "Makeup",
            ),
            SizedBox(width: 10.w),
            const GlamOneButton(
              text: "Hairdresser",
            ),
          ],
        ),
      ],
    );
  }
}

class GlamOneButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const GlamOneButton({Key? key, required this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120.h,
        height: 50.h,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Center(
          child: Text(
            text,
            style: GlamOneTheme.bodyText1.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
