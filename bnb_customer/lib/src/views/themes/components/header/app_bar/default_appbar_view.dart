import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/components/header/app_bar/default_appbar_view.dart';
import 'package:bbblient/src/views/themes/glam_one/views/app_bar.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DefaultAppBarTheme extends ConsumerWidget {
  final SalonModel salonModel;
  const DefaultAppBarTheme({Key? key, required this.salonModel})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isTab =
        (DeviceConstraints.getDeviceType(MediaQuery.of(context)) ==
            DeviceScreenType.tab);
    final SalonProfileProvider _salonProfileProvider =
        ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            DeviceConstraints.getResponsiveSize(context, 3.w, 10.w, 15.w),
        // vertical: DeviceConstraints.getResponsiveSize(context, 5.h, 7.h, 10.h),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!isTab) const Spacer(),
              if (isTab)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Socials(
                        socialIcon: ThemeIcons.insta,
                        socialUrl: salonModel.links?.instagram,
                      ),
                      const SizedBox(width: 20),
                      Socials(
                        socialIcon: ThemeIcons.tiktok,
                        socialUrl: salonModel.links?.facebookMessenger,
                      ),
                      const SizedBox(width: 20),
                      Socials(
                        socialIcon: ThemeIcons.whatsapp,
                        socialUrl: salonModel.links?.whatsapp,
                      ),
                    ],
                  ),
                ),
              if (isTab) const Spacer(),
              // (salonModel.salonLogo != '')
              //     ? SizedBox(
              //         height: DeviceConstraints.getResponsiveSize(context, 50.h, 50.h, 70.h),
              //         width: DeviceConstraints.getResponsiveSize(context, 100.w, 100.w, 50.w),
              //         child: CachedImage(
              //           url: salonModel.salonLogo,
              //           fit: BoxFit.fitHeight,
              //         ),
              //       )
              //     :
              Text(
                salonModel.salonName.toUpperCase(),
                style: theme.textTheme.headline1!.copyWith(
                  color: Colors.white,
                  fontSize: 22.sp,
                  letterSpacing: 0.9,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Spacer(),
              // const Spacer(),
              SvgPicture.asset(
                ThemeIcons.menu,
                height: 20.h,
                color: theme.dividerColor,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            width: double.infinity, // getHorizontalSize(310.00),

            decoration: BoxDecoration(color: theme.bottomAppBarColor),
          ),
        ],
      ),
    );
  }
}
