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

class MinimalAppBar extends ConsumerWidget {
  final SalonModel salonModel;
  const MinimalAppBar({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Container(
      color: theme.cardColor,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: DeviceConstraints.getResponsiveSize(context, 5.w, 10.w, 25.w),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isTab) SizedBox(width: 10.w),
            if (isTab)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Socials(
                      socialIcon: ThemeIcons.minimalInstagram,
                      socialUrl: salonModel.links?.instagram,
                    ),
                    const SizedBox(width: 20),
                    Socials(
                      socialIcon: ThemeIcons.minimalFacebook,
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
            Text(
              salonModel.salonName.toUpperCase(),
              style: theme.textTheme.headline1!.copyWith(
                color: Colors.white,
                fontSize: 22.sp,
                letterSpacing: 0.9,
                fontWeight: FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.clip,
            ),
            const Spacer(),
            SvgPicture.asset(
              ThemeIcons.menu,
              height: 20.h,
              color: theme.dividerColor,
            ),
          ],
        ),
      ),
    );
  }
}
