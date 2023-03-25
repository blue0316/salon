import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RotatedBookNow extends ConsumerWidget {
  final VoidCallback onTap;
  final String buttonText;
  final Color? buttonBorderColor;

  const RotatedBookNow({
    Key? key,
    required this.onTap,
    required this.buttonText,
    this.buttonBorderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 180.h,
                height: 180.h,
                child: SvgPicture.asset(
                  AppIcons.bookNow,
                  // color: buttonBorderColor ?? theme.primaryColor,
                  color: Colors.black, // TODO: REVERT
                ),
              ),
              Text(
                buttonText,
                style: theme.textTheme.bodyText1!.copyWith(color: buttonBorderColor),
              ),
            ],
          )),
    );
  }
}

class HorizontalBookNow extends ConsumerWidget {
  final VoidCallback onTap;
  final String buttonText;
  final Color? buttonBorderColor;

  const HorizontalBookNow({
    Key? key,
    required this.onTap,
    required this.buttonText,
    this.buttonBorderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 180.h,
                height: 180.h,
                child: SvgPicture.asset(
                  AppIcons.horizontalBookNow,
                  color: buttonBorderColor,
                ),
              ),
              Text(
                buttonText,
                style: theme.textTheme.bodyText1!.copyWith(color: buttonBorderColor),
              ),
            ],
          )),
    );
  }
}
