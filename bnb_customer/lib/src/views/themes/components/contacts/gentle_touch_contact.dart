import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_about.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/contact_maps.dart';

class GentleTouchContactView extends ConsumerWidget {
  final SalonModel salonModel;

  const GentleTouchContactView({Key? key, required this.salonModel}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 30.w),
        right: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 30.w),
        top: 100.h,
        bottom: 20.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            (AppLocalizations.of(context)?.contacts ?? 'Contacts').toUpperCase(),
            style: theme.textTheme.displayMedium!.copyWith(
              fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 60.sp),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7.sp),
          Container(
            width: !isPortrait ? MediaQuery.of(context).size.width / 1.8 : null,
            padding: isPortrait ? EdgeInsets.symmetric(horizontal: 15.w) : null,
            child: Text(
              'Connect with us easily. Whether it\'s questions, collaborations, or just saying hello, we\'re here for you. Reach out via email, find us on social media, give us a call, or visit our address below.',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: DeviceConstraints.getResponsiveSize(context, 17.sp, 17.sp, 18.sp),
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 40.sp),
          SizedBox(
            // height: 200.h,
            width: double.infinity,
            child: Wrap(
              direction: Axis.horizontal,
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              alignment: WrapAlignment.spaceBetween,
              runAlignment: WrapAlignment.spaceBetween,
              runSpacing: 15.sp,
              children: [
                GentleTouchContactCard(
                  icon: Icons.message,
                  cardTitle: 'Write To Us',
                  cardDesc: 'Start a conversations via email',
                  cardValue: salonModel.email,
                  onDescTap: () {},
                ),
                GentleTouchContactCard(
                  icon: Icons.call,
                  cardTitle: 'Call Us',
                  cardDesc: 'Today from 10 am to 7 pm',
                  cardValue: salonModel.phoneNumber,
                  onDescTap: () {
                    Utils().launchCaller(salonModel.phoneNumber.replaceAll("-", ""));
                  },
                ),
                GentleTouchContactCard(
                  isAddress: true,
                  icon: Icons.location_pin,
                  cardTitle: 'Visit Us',
                  cardDesc: salonModel.address,
                  cardValue: 'View On The Map',
                  onDescTap: () {},
                ),
                GentleTouchContactCard(
                  isSocial: true,
                  icon: Icons.soap_rounded,
                  cardTitle: 'Social Media',
                  cardDesc: 'Discover more on social',
                  cardValue: '',
                  salon: salonModel,
                ),
              ],
            ),
          ),
          SizedBox(height: 50.sp),
          SizedBox(
            height: 500.h,
            width: double.infinity,
            child: GoogleMaps(
              salonModel: salonModel,
            ),
          ),
        ],
      ),
    );
  }
}

class GentleTouchContactCard extends ConsumerWidget {
  final IconData icon;
  final String cardTitle, cardDesc, cardValue;
  final bool isSocial, isAddress;
  final SalonModel? salon;
  final VoidCallback? onDescTap;

  const GentleTouchContactCard({
    Key? key,
    required this.icon,
    required this.cardTitle,
    required this.cardDesc,
    required this.cardValue,
    this.isSocial = false,
    this.isAddress = false,
    this.salon,
    this.onDescTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    ThemeType themeType = _salonProfileProvider.themeType;

    return Container(
      height: 140.h,
      width: !isPortrait ? 280.h : double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: (themeType == ThemeType.GentleTouch) ? const Color(0XFFD9D9D9) : const Color(0XFF616161),
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icon, size: 20.sp, color: const Color(0XFF868686)),
                SizedBox(width: 10.sp),
                Text(
                  cardTitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.sp),
            GestureDetector(
              onTap: () async {
                if (isAddress) {
                  String url = "https://maps.google.com/maps?q=${salon!.position?.geoPoint?.latitude ?? 0},${salon!.position?.geoPoint?.longitude ?? 0}&";
                  Uri uri = Uri.parse(url);

                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    showToast("Could not launch");
                  }
                } else {}
              },
              child: Text(
                cardDesc,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                  color: themeType == ThemeType.GentleTouch ? const Color(0XFF282828) : const Color(0XFFDDDDDD),
                ),
              ),
            ),
            const Spacer(),
            if (!isSocial)
              Text(
                cardValue,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  color: themeType == ThemeType.GentleTouch ? const Color(0XFF282828) : const Color(0XFFDDDDDD),
                ),
              ),
            if (isSocial)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    SocialIcon2(
                      icon: FontAwesomeIcons.instagram,
                      type: 'insta',
                      socialUrl: salon!.links?.instagram,
                      color: const Color(0XFF868686),
                    ),
                    // SizedBox(width: 5.sp),
                    SocialLink2(
                      icon: AppIcons.linkTikTok,
                      type: 'tiktok',
                      socialUrl: salon!.links?.tiktok,
                      color: const Color(0XFF868686),
                    ),
                    SizedBox(width: 5.sp),
                    SocialLink2(
                      icon: AppIcons.linkFacebook,
                      type: 'facebook',
                      socialUrl: salon!.links?.facebook,
                      color: const Color(0XFF868686),
                    ),
                    SocialIcon2(
                      icon: FontAwesomeIcons.globe,
                      type: 'website',
                      socialUrl: salon!.links?.website,
                      color: const Color(0XFF868686),
                    ),
                    SocialIcon2(
                      icon: FontAwesomeIcons.twitter,
                      type: 'twitter',
                      socialUrl: salon!.links?.twitter,
                      color: const Color(0XFF868686),
                    ),
                    SocialIcon2(
                      icon: FontAwesomeIcons.pinterest,
                      type: 'pinterest',
                      socialUrl: salon!.links?.pinterest,
                      color: const Color(0XFF868686),
                    ),
                    SocialIcon2(
                      icon: FontAwesomeIcons.yelp,
                      type: 'yelp',
                      socialUrl: salon!.links?.yelp,
                      color: const Color(0XFF868686),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
