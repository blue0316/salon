import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrevAndNextButtons extends ConsumerWidget {
  final VoidCallback backOnTap;
  final VoidCallback forwardOnTap;
  final Color? backColor;
  final Color? forwardColor;
  final double? leftFontSize;
  final double? rightFontSize;

  const PrevAndNextButtons({
    Key? key,
    required this.backOnTap,
    required this.forwardOnTap,
    this.leftFontSize,
    this.rightFontSize,
    this.backColor,
    this.forwardColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    ThemeType themeType = _salonProfileProvider.themeType;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: backOnTap,
            child: themeLeftIcon(
              context,
              themeType: themeType,
              theme: theme,
              backColor: backColor,
              fontSize: leftFontSize,
            ),
            // (themeType != ThemeType.GlamBarbershop && themeType != ThemeType.Barbershop)
            //     ? SvgPicture.asset(
            //         ThemeIcons.leftArrow,
            //         color: backColor ?? theme.primaryColor,
            //         height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
            //       )
            //     : Icon(
            //         Icons.arrow_back,
            //         size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
            //         color: Colors.white,
            //       ),
          ),
          SizedBox(width: DeviceConstraints.getResponsiveSize(context, 15.sp, 30.sp, 40.sp)),
          GestureDetector(
            onTap: forwardOnTap,
            child: themeRightIcon(
              context,
              themeType: themeType,
              theme: theme,
              forwardColor: forwardColor,
              fontSize: leftFontSize,
            ),
            // (_salonProfileProvider.theme != '2' && _salonProfileProvider.theme != '4')
            //     ? SvgPicture.asset(
            //         ThemeIcons.rightArrow,
            //         color: forwardColor ?? theme.primaryColor,
            //         height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
            //       )
            //     : Icon(
            //         Icons.arrow_forward,
            //         size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
            //         color: theme.primaryColor,
            //       ),
          ),
        ],
      ),
    );
  }
}

Widget themeLeftIcon(context, {required ThemeType themeType, required ThemeData theme, Color? backColor, double? fontSize}) {
  switch (themeType) {
    case ThemeType.GlamBarbershop:
      return Icon(
        Icons.arrow_back,
        size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
        color: Colors.white,
      );
    case ThemeType.Barbershop:
      return Text(
        String.fromCharCode(Icons.arrow_back.codePoint),
        style: TextStyle(
          inherit: false,
          fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
          color: Colors.white,
          fontWeight: FontWeight.w100,
          fontFamily: Icons.arrow_back.fontFamily,
        ),
      );
    // return Icon(
    //   Icons.arrow_back,
    //   size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
    //   color: Colors.white,
    // );
    case ThemeType.GlamMinimalLight:
      return Icon(
        Icons.arrow_back,
        size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
        color: const Color(0XFFB3B3B3),
      );
    case ThemeType.GlamMinimalDark:
      return Icon(
        Icons.arrow_back,
        size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
        color: const Color(0XFFB3B3B3),
      );

    case ThemeType.GlamLight:
      return SvgPicture.asset(
        ThemeIcons.glamLightLeftArrow,
        color: backColor ?? theme.primaryColor,
        height: fontSize ?? DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
      );

    default:
      return SvgPicture.asset(
        ThemeIcons.leftArrow,
        color: backColor ?? theme.primaryColor,
        height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
      );
  }
}

Widget themeRightIcon(context, {required ThemeType themeType, required ThemeData theme, Color? forwardColor, double? fontSize}) {
  switch (themeType) {
    case ThemeType.GlamBarbershop:
      return Icon(
        Icons.arrow_forward,
        size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
        color: Colors.white,
      );
    case ThemeType.Barbershop:
      return Text(
        String.fromCharCode(Icons.arrow_forward.codePoint),
        style: TextStyle(
          inherit: false,
          fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
          color: theme.primaryColor,
          fontWeight: FontWeight.w100,
          fontFamily: Icons.arrow_forward.fontFamily,
        ),
      );

    // return Icon(
    //   Icons.arrow_forward,
    // size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
    // color: theme.primaryColor,

    // );
    case ThemeType.GlamMinimalDark:
      return Icon(
        Icons.arrow_forward,
        size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
        color: Colors.white,
      );
    case ThemeType.GlamMinimalLight:
      return Icon(
        Icons.arrow_forward,
        size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
        color: Colors.black,
      );

    case ThemeType.GlamLight:
      return SvgPicture.asset(
        ThemeIcons.glamLightRightArrow,
        color: forwardColor ?? theme.primaryColor,
        height: fontSize ?? DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
      );

    default:
      return SvgPicture.asset(
        ThemeIcons.rightArrow,
        color: forwardColor ?? theme.primaryColor,
        height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
      );
  }
}
