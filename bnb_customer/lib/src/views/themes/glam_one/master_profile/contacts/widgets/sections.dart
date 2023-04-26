import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/glam_one/views/app_bar.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactSection extends ConsumerWidget {
  final SalonModel salonModel;

  const ContactSection({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          (themeType == ThemeType.GlamMinimalLight || themeType == ThemeType.GlamMinimalDark) ? AppLocalizations.of(context)?.contacts ?? 'Contacts' : (AppLocalizations.of(context)?.contacts ?? 'Contacts').toUpperCase(),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: theme.textTheme.bodyText1?.copyWith(
            fontSize: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 20.sp),
          ),
        ),
        const SizedBox(height: 10),
        if (salonModel.phoneNumber != '')
          ContactCard(
            icon: (themeType == ThemeType.GlamMinimalLight) ? ThemeIcons.minimalPhone : ThemeIcons.phone,
            value: salonModel.phoneNumber,
          ),
        if (salonModel.email != '')
          ContactCard(
            icon: (themeType == ThemeType.GlamMinimalLight) ? ThemeIcons.minimalMail : ThemeIcons.mail,
            value: salonModel.email,
          ),
      ],
    );
  }
}

class ContactCard extends ConsumerWidget {
  final String icon, value;
  const ContactCard({Key? key, required this.icon, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            icon,
            height: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
            color: theme.primaryColorDark,
          ),
          const SizedBox(width: 15),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyText1?.copyWith(
                color: iconColor(themeType), // (themeType == ThemeType.GlamLight) ? Colors.black : Colors.white,
                fontSize: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color iconColor(ThemeType themeType) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Colors.black;

    case ThemeType.GlamMinimalDark:
      return Colors.white;

    default:
      return (themeType == ThemeType.GlamLight) ? Colors.black : Colors.white;
  }
}

class VisitUs extends ConsumerWidget {
  final SalonModel salonModel;

  const VisitUs({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          // "VISIT US",
          (themeType == ThemeType.GlamMinimalLight || themeType == ThemeType.GlamMinimalDark) ? AppLocalizations.of(context)?.visit ?? 'Visit' : (AppLocalizations.of(context)?.visit ?? 'Visit').toUpperCase(),

          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: theme.textTheme.bodyText1?.copyWith(
            fontSize: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 20.sp),
          ),
        ),
        const SizedBox(height: 10),
        ContactCard(
          icon: (themeType == ThemeType.GlamMinimalLight || themeType == ThemeType.GlamMinimalDark) ? ThemeIcons.minimalLocation : ThemeIcons.location,
          value: salonModel.address,
        ),
      ],
    );
  }
}

class SocialNetwork extends ConsumerWidget {
  final SalonModel salonModel;

  const SocialNetwork({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          // "SOCIAL NETWORK",
          (themeType == ThemeType.GlamMinimalLight || themeType == ThemeType.GlamMinimalDark)
              ? AppLocalizations.of(context)?.socialNetwork ?? 'Social Network'
              : (AppLocalizations.of(
                        context,
                      )?.socialNetwork ??
                      'Social Network')
                  .toUpperCase(),

          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: theme.textTheme.bodyText1?.copyWith(
            fontSize: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 20.sp),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Socials(
              socialIcon: (themeType == ThemeType.GlamMinimalLight) ? ThemeIcons.minimalInstagram : ThemeIcons.insta,
              socialUrl: salonModel.links?.instagram,
              height: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 26.sp),
              color: theme.primaryColorDark,
            ),
            const SizedBox(width: 20),
            Socials(
              socialIcon: (themeType == ThemeType.GlamMinimalLight) ? ThemeIcons.minimalFacebook : ThemeIcons.tiktok,
              socialUrl: salonModel.links?.facebookMessenger,
              height: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 26.sp),
              color: theme.primaryColorDark,
            ),
            const SizedBox(width: 20),
            Socials(
              socialIcon: (themeType == ThemeType.GlamMinimalLight) ? ThemeIcons.whatsapp : ThemeIcons.whatsapp,
              socialUrl: salonModel.links?.whatsapp,
              height: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 26.sp),
              color: theme.primaryColorDark,
            ),
          ],
        ),
      ],
    );
  }
}
