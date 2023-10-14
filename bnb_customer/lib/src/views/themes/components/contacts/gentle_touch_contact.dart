import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_about.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
              AppLocalizations.of(context)?.connectWithUsDesc ?? 'Connect with us easily. Whether it\'s questions, collaborations, or just saying hello, we\'re here for you. Reach out via email, find us on social media, give us a call, or visit our address below.',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: DeviceConstraints.getResponsiveSize(context, 17.sp, 17.sp, 18.sp),
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 40.sp),
          Padding(
            padding: EdgeInsets.only(
              left: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 10.w),
              right: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 10.w),
            ),
            child: SizedBox(
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
                    cardTitle: (AppLocalizations.of(context)?.writeToUsTitle ?? 'Write To Us').toTitleCase(),
                    cardDesc: AppLocalizations.of(context)?.startConversation1 ?? 'Start a conversations via email',
                    cardValue: salonModel.email,
                    onValueTap: () {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: salonModel.email,
                        queryParameters: {'subject': 'Contact'},
                      );
                      launchUrl(emailLaunchUri);
                    },
                  ),
                  GentleTouchContactCard(
                    icon: Icons.call,
                    cardTitle: AppLocalizations.of(context)?.callUs ?? 'Call Us',
                    cardDesc: AppLocalizations.of(context)?.callUsDesc ?? 'Today from 10 am to 7 pm',
                    cardValue: salonModel.phoneNumber,
                    onValueTap: () {
                      Utils().launchCaller(salonModel.phoneNumber.replaceAll("-", ""));
                    },
                  ),
                  GentleTouchContactCard(
                    isAddress: true,
                    icon: Icons.location_pin,
                    cardTitle: AppLocalizations.of(context)?.visitUs ?? 'Visit Us',
                    cardDesc: salonModel.address,
                    cardValue: (AppLocalizations.of(context)?.viewOnMap ?? 'View On The Map').toTitleCase(),
                    onValueTap: () async {
                      Uri uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeFull(salonModel.address)}');

                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        showToast(AppLocalizations.of(context)?.couldNotLaunch ?? "Could not launch");
                      }
                    },
                  ),
                  GentleTouchContactCard(
                    isSocial: true,
                    svg: ThemeIcons.socialContact,
                    isSvg: true,
                    cardTitle: AppLocalizations.of(context)?.socialMedia ?? 'Social Media',
                    cardDesc: AppLocalizations.of(context)?.discoverMoreOnSocial ?? 'Discover more on social',
                    cardValue: '',
                    salon: salonModel,
                  ),
                ],
              ),
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
  final IconData? icon;
  final String cardTitle, cardDesc, cardValue;
  final bool isSocial, isAddress, isSvg;
  final SalonModel? salon;
  final VoidCallback? onValueTap;
  final String? svg;

  const GentleTouchContactCard({
    Key? key,
    this.icon,
    this.svg,
    required this.cardTitle,
    required this.cardDesc,
    required this.cardValue,
    this.isSocial = false,
    this.isAddress = false,
    this.salon,
    this.onValueTap,
    this.isSvg = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    ThemeType themeType = _salonProfileProvider.themeType;

    return Container(
      height: 145.h,
      width: !isPortrait ? 305.h : double.infinity,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (!isSvg)
                    ? Icon(
                        icon,
                        size: 20.sp,
                        color: const Color(0XFF868686),
                      )
                    : SvgPicture.asset(
                        svg!,
                        height: 20.sp,
                        color: const Color(0XFF868686),
                      ),
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
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
                color: themeType == ThemeType.GentleTouch ? const Color(0XFF282828) : const Color(0XFFDDDDDD),
              ),
            ),
            const Spacer(),
            if (!isSocial)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onValueTap,
                  child: Text(
                    cardValue,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      color: themeType == ThemeType.GentleTouch ? const Color(0XFF282828) : const Color(0XFFDDDDDD),
                    ),
                  ),
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
                    if (salon!.links?.instagram != null && salon!.links!.instagram.isNotEmpty)
                      SocialIcon2(
                        icon: FontAwesomeIcons.instagram,
                        type: 'insta',
                        socialUrl: salon!.links?.instagram,
                        color: const Color(0XFF868686),
                      ),
                    if (salon!.links?.tiktok != null && salon!.links!.tiktok.isNotEmpty)
                      SocialIcon2(
                        icon: FontAwesomeIcons.tiktok,
                        type: 'tiktok',
                        socialUrl: salon!.links?.tiktok,
                        color: const Color(0XFF868686),
                      ),
                    if (salon!.links?.facebook != null && salon!.links!.facebook.isNotEmpty)
                      SocialIcon2(
                        icon: FontAwesomeIcons.facebookF,
                        type: 'facebook',
                        socialUrl: salon!.links?.facebook,
                        color: const Color(0XFF868686),
                      ),
                    if (salon!.links?.website != null && salon!.links!.website.isNotEmpty)
                      SocialIcon2(
                        icon: FontAwesomeIcons.globe,
                        type: 'website',
                        socialUrl: salon!.links?.website,
                        color: const Color(0XFF868686),
                      ),
                    if (salon!.links?.twitter != null && salon!.links!.twitter.isNotEmpty)
                      SocialIcon2(
                        icon: FontAwesomeIcons.twitter,
                        type: 'twitter',
                        socialUrl: salon!.links?.twitter,
                        color: const Color(0XFF868686),
                      ),
                    if (salon!.links?.pinterest != null && salon!.links!.pinterest.isNotEmpty)
                      SocialIcon2(
                        icon: FontAwesomeIcons.pinterest,
                        type: 'pinterest',
                        socialUrl: salon!.links?.pinterest,
                        color: const Color(0XFF868686),
                      ),
                    if (salon!.links?.yelp != null && salon!.links!.yelp.isNotEmpty)
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
