import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ThemeAppBar extends StatelessWidget {
  final SalonModel salonModel;

  const ThemeAppBar({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isPortrait) const Spacer(),
              if (!isPortrait)
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
              if (!isPortrait) const Spacer(),
              (salonModel.salonLogo != '')
                  ? SizedBox(
                      // color: Colors.red ,
                      height: DeviceConstraints.getResponsiveSize(context, 70.h, 70.h, 70.h),
                      width: DeviceConstraints.getResponsiveSize(context, 100.w, 100.w, 100.w),
                      child: CachedImage(
                        url: salonModel.salonLogo,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Text(
                      salonModel.salonName.toUpperCase(),
                      style: GlamOneTheme.headLine1.copyWith(
                        color: Colors.white,
                        fontSize: 22.sp,
                        letterSpacing: 0.9,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
              const Spacer(),
              // SvgPicture.asset(ThemeIcons.menu, height: 25.h),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            width: double.infinity, // getHorizontalSize(310.00),

            decoration: const BoxDecoration(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class Socials extends StatelessWidget {
  final String socialIcon;
  final String? socialUrl;
  final Color? color;
  final double? height;

  const Socials({Key? key, required this.socialIcon, required this.socialUrl, this.color, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          String instaUrl = socialUrl ?? '';

          Uri uri = Uri.parse(instaUrl);
          debugPrint("launching Insta Url: $uri");
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            showToast("No social page for this profile");
          }
        },
        child: SvgPicture.asset(
          socialIcon,
          height: height ?? 25.h,
          color: color,
        ),
      ),
    );
  }
}
