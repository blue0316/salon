import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_about.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FollowMaster extends ConsumerWidget {
  final MasterModel master;

  const FollowMaster({Key? key, required this.master}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    ThemeType themeType = _salonProfileProvider.themeType;

    return Container(
      height: 47.h,
      decoration: BoxDecoration(
        color: (themeType == ThemeType.GentleTouch) ? Colors.white : Colors.black,
        border: Border.all(color: Colors.black, width: 0.4),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Center(
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              if (master.links?.instagram != '' && master.links?.instagram != null)
                SocialIcon2(
                  icon: FontAwesomeIcons.instagram,
                  type: 'insta',
                  socialUrl: master.links?.instagram,
                  color: const Color(0XFF868686),
                ),
              SizedBox(width: 3.sp),
              if (master.links?.tiktok != '' && master.links?.tiktok != null)
                SocialLink2(
                  icon: AppIcons.linkTikTok,
                  type: 'tiktok',
                  socialUrl: master.links?.tiktok,
                  color: const Color(0XFF868686),
                ),
              SizedBox(width: 3.sp),
              if (master.links?.facebook != '' && master.links?.facebook != null)
                SocialLink2(
                  icon: AppIcons.linkFacebook,
                  type: 'facebook',
                  socialUrl: master.links?.facebook,
                  color: const Color(0XFF868686),
                ),
              SizedBox(width: 3.sp),
              if (master.links?.website != '' && master.links?.website != null)
                SocialIcon2(
                  icon: FontAwesomeIcons.globe,
                  type: 'website',
                  socialUrl: master.links?.website,
                  color: const Color(0XFF868686),
                ),
              SizedBox(width: 3.sp),
              if (master.links?.twitter != '' && master.links?.twitter != null)
                SocialIcon2(
                  icon: FontAwesomeIcons.twitter,
                  type: 'twitter',
                  socialUrl: master.links?.twitter,
                  color: const Color(0XFF868686),
                ),
              SizedBox(width: 3.sp),
              if (master.links?.pinterest != '' && master.links?.pinterest != null)
                SocialIcon2(
                  icon: FontAwesomeIcons.pinterest,
                  type: 'pinterest',
                  socialUrl: master.links?.pinterest,
                  color: const Color(0XFF868686),
                ),
              SizedBox(width: 3.sp),
              if (master.links?.yelp != '' && master.links?.yelp != null)
                SocialIcon2(
                  icon: FontAwesomeIcons.yelp,
                  type: 'yelp',
                  socialUrl: master.links?.yelp,
                  color: const Color(0XFF868686),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
