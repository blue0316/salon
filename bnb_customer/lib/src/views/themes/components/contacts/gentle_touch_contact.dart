import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_about.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                ),
                GentleTouchContactCard(
                  icon: Icons.call,
                  cardTitle: 'Call Us',
                  cardDesc: 'Today from 10 am to 7 pm',
                  cardValue: salonModel.phoneNumber,
                ),
                GentleTouchContactCard(
                  icon: Icons.location_pin,
                  cardTitle: 'Visit Us',
                  cardDesc: salonModel.address,
                  cardValue: 'View On The Map',
                ),
                GentleTouchContactCard(
                  isSocial: true,
                  icon: Icons.soap_rounded,
                  cardTitle: 'Social Media',
                  cardDesc: 'Discover more on social',
                  cardValue: '',
                  facebook: salonModel.links?.facebook,
                  tiktok: salonModel.links?.tiktok,
                  insta: salonModel.links?.instagram,
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
  final bool isSocial;
  final String? insta, facebook, tiktok;

  const GentleTouchContactCard({
    Key? key,
    required this.icon,
    required this.cardTitle,
    required this.cardDesc,
    required this.cardValue,
    this.isSocial = false,
    this.insta,
    this.facebook,
    this.tiktok,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Container(
      height: 140.h,
      width: 280.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0XFFD9D9D9)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20.sp),
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
            Text(
              cardDesc,
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.normal),
            ),
            const Spacer(),
            if (!isSocial)
              Text(
                cardValue,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            if (isSocial)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  children: [
                    SocialIcon2(
                      icon: FontAwesomeIcons.instagram,
                      type: 'insta',
                      socialUrl: insta,
                      color: const Color(0XFF868686),
                    ),
                    SizedBox(width: 5.sp),
                    SocialLink2(
                      icon: AppIcons.linkTikTok,
                      type: 'tiktok',
                      socialUrl: tiktok,
                      color: const Color(0XFF868686),
                    ),
                    SizedBox(width: 5.sp),
                    SocialLink2(
                      icon: AppIcons.linkFacebook,
                      type: 'facebook',
                      socialUrl: facebook,
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
