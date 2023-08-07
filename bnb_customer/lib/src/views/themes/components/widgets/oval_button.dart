import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class OvalButton extends ConsumerWidget {
  final double? height, width;
  final String text;
  final double? textSize, buttonWidth;
  final VoidCallback onTap;

  const OvalButton({
    Key? key,
    required this.text,
    this.textSize,
    this.height,
    this.width,
    this.buttonWidth,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: width ?? 145.sp,
          height: height ?? 45.sp,
          // color: Colors.blue,
          // decoration: BoxDecoration(
          //   border: Border.all(
          //     color: theme.primaryColor,
          //     width: buttonWidth ?? 1.5,
          //   ),
          //   borderRadius: const BorderRadius.all(Radius.elliptical(150, 50)),
          // ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                'assets/themes/glam_one/svg/button_oval.svg',
                fit: BoxFit.fitWidth,
                color: theme.primaryColor,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Center(
                  child: Text(
                    text,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: textSize ?? 14.sp,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
