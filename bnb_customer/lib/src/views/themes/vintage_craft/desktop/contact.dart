import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/themes/components/contacts/gentle_touch_contact.dart';
import 'package:bbblient/src/views/themes/components/contacts/widgets/contact_maps.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class VintageSalonContact extends ConsumerWidget {
  final SalonModel salonModel;
  const VintageSalonContact({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 15.w, 15.w, 30.w),
        right: DeviceConstraints.getResponsiveSize(context, 15.w, 15.w, 30.w),
        top: 100.h,
        bottom: 20.h,
      ),
      child: SizedBox(
        height: !isPortrait ? 550.h : null,
        width: double.infinity,
        child: Row(
          children: [
            if (!isPortrait)
              Expanded(
                // child: SizedBox(),
                child: ClipRect(
                  child: GoogleMaps(salonModel: salonModel),
                ),
              ),
            if (!isPortrait) SizedBox(width: 30.w),
            !isPortrait
                ? Expanded(
                    child: ListView(
                      physics: isPortrait ? const NeverScrollableScrollPhysics() : null,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          (AppLocalizations.of(context)?.contacts ?? 'Contacts').toTitleCase(),
                          style: theme.textTheme.displayMedium!.copyWith(
                            fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 50.sp),
                          ),
                        ),
                        SizedBox(height: 20.sp),
                        Text(
                          AppLocalizations.of(context)?.connectWithUsDesc ?? 'Connect with us easily. Whether it\'s questions, collaborations, or just saying hello, we\'re here for you. Reach out via email, find us on social media, give us a call, or visit our address below.',
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontSize: 17.sp, // DeviceConstraints.getResponsiveSize(context, 17.sp, 17.sp, 18.sp),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 30.sp),
                        // const Spacer(),
                        Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.spaceBetween,
                          runAlignment: WrapAlignment.spaceBetween,
                          runSpacing: 15.sp,
                          spacing: 20.sp,
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
                        SizedBox(height: 30.sp),
                      ],
                    ),
                  )
                : Portrait(
                    salonModel: salonModel,
                  )
          ],
        ),
      ),
    );
  }
}

class Portrait extends ConsumerWidget {
  final SalonModel salonModel;

  const Portrait({super.key, required this.salonModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            (AppLocalizations.of(context)?.contacts ?? 'Contacts').toTitleCase(),
            style: theme.textTheme.displayMedium!.copyWith(
              fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 50.sp),
            ),
          ),
          SizedBox(height: 20.sp),
          Text(
            AppLocalizations.of(context)?.connectWithUsDesc ?? 'Connect with us easily. Whether it\'s questions, collaborations, or just saying hello, we\'re here for you. Reach out via email, find us on social media, give us a call, or visit our address below.',
            style: theme.textTheme.displayMedium?.copyWith(
              fontSize: 17.sp,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 30.sp),
          // const Spacer(),
          Wrap(
            direction: Axis.horizontal,
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
          SizedBox(height: 30.sp),
        ],
      ),
    );
  }
}
