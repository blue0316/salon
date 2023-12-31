import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/glam_one/views/app_bar.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MinimalAppBar extends ConsumerWidget {
  final SalonModel salonModel;
  final bool isSalonMaster;

  const MinimalAppBar({
    Key? key,
    required this.salonModel,
    this.isSalonMaster = false,
  }) : super(key: key);

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
            if (isSalonMaster)
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: theme.appBarTheme.iconTheme!.color,
                ),
              ),
            if (!isTab) SizedBox(width: 10.w),
            if (isTab)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Socials(
                      type: 'insta',
                      socialIcon: 'ThemeIcons.minimalInstagram',
                      socialUrl: salonModel.links?.instagram,
                    ),
                    const SizedBox(width: 20),
                    Socials(
                      type: 'facebook',
                      socialIcon: ThemeIcons.minimalFacebook,
                      socialUrl: salonModel.links?.facebook,
                    ),
                    const SizedBox(width: 20),
                    Socials(
                      type: 'insta',
                      socialIcon: ThemeIcons.whatsapp,
                      socialUrl: salonModel.phoneNumber,
                    ),
                  ],
                ),
              ),
            if (isTab) const Spacer(),
            Text(
              salonModel.salonName.toUpperCase(),
              style: theme.textTheme.displayLarge!.copyWith(
                color: theme.dividerColor,
                fontSize: 22.sp,
                letterSpacing: 0.9,
                fontWeight: FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.clip,
            ),
            const Spacer(),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Icon(
                  Icons.menu,
                  size: 35.h,
                  color: theme.appBarTheme.iconTheme!.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
