import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrevAndNextButtons extends ConsumerWidget {
  final VoidCallback backOnTap;
  final VoidCallback forwardOnTap;

  const PrevAndNextButtons(
      {Key? key, required this.backOnTap, required this.forwardOnTap})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider =
        ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Row(
        children: [
          GestureDetector(
            onTap: backOnTap,
            child: (_salonProfileProvider.theme != '2' &&
                    _salonProfileProvider.theme != '4')
                ? SvgPicture.asset(
                    ThemeIcons.leftArrow,
                    color: theme.primaryColor,
                    height: DeviceConstraints.getResponsiveSize(
                        context, 30.sp, 40.sp, 50.sp),
                  )
                : Icon(
                    Icons.arrow_back,
                    size: DeviceConstraints.getResponsiveSize(
                        context, 30.sp, 40.sp, 50.sp),
                    color: Colors.white,
                  ),
          ),
          SizedBox(
              width: DeviceConstraints.getResponsiveSize(context, 15, 30, 40)),
          GestureDetector(
            onTap: forwardOnTap,
            child: (_salonProfileProvider.theme != '2' &&
                    _salonProfileProvider.theme != '4')
                ? SvgPicture.asset(
                    ThemeIcons.rightArrow,
                    height: DeviceConstraints.getResponsiveSize(
                        context, 30.sp, 40.sp, 50.sp),
                  )
                : Icon(
                    Icons.arrow_forward,
                    size: DeviceConstraints.getResponsiveSize(
                        context, 30.sp, 40.sp, 50.sp),
                    color: theme.primaryColor,
                  ),
          ),
        ],
      ),
    );
  }
}
