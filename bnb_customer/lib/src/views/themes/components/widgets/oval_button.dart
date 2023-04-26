import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OvalButton extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width ?? 145.h,
          height: height ?? 45.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.primaryColor,
              width: 1.5,
            ),
            borderRadius: const BorderRadius.all(Radius.elliptical(150, 50)),
          ),
          child: Padding(
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
        ),
      ),
    );
  }
}
