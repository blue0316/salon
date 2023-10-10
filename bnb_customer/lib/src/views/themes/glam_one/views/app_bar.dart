import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/views/themes/components/header/app_bar/default_appbar_view.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profile/widgets/minimal_app_bar.dart';

class ThemeAppBar extends ConsumerWidget {
  final SalonModel salonModel;
  final bool isSalonMaster;

  const ThemeAppBar({
    Key? key,
    required this.salonModel,
    this.isSalonMaster = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    ThemeType themeType = _salonProfileProvider.themeType;

    return appBarTheme(themeType, salonModel, isSalonMaster);
  }
}

Widget appBarTheme(ThemeType themeType, SalonModel salon, bool isSalonMaster) {
  switch (themeType) {
    case ThemeType.GlamMinimalDark:
      return MinimalAppBar(salonModel: salon, isSalonMaster: isSalonMaster);
    case ThemeType.GlamMinimalLight:
      return MinimalAppBar(salonModel: salon, isSalonMaster: isSalonMaster);

    default:
      return DefaultAppBarTheme(salonModel: salon, isSalonMaster: isSalonMaster);
  }
}

class Socials extends ConsumerWidget {
  final String type;
  final String socialIcon;
  final String? socialUrl;
  final Color? color;
  final double? height;

  const Socials({
    Key? key,
    required this.socialIcon,
    required this.socialUrl,
    this.color,
    this.height,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          Uri uri = Uri.parse(socialLinks(type, socialUrl ?? ''));

          // debugPrint("launching Url: $uri");

          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            showToast("No social page for this profile");
          }
        },
        child: (socialIcon != 'ThemeIcons.minimalInstagram')
            ? SvgPicture.asset(
                socialIcon,
                height: height ?? 25.h,
                color: theme.appBarTheme.iconTheme!.color,
              )
            : FaIcon(
                FontAwesomeIcons.squareInstagram,
                size: height ?? 25.h,
                color: theme.appBarTheme.iconTheme!.color,
              ),
      ),
    );
  }
}

String socialLinks(String type, String username) {
  switch (type) {
    case 'insta':
      return 'https://www.instagram.com/$username/';

    case 'twitter':
      return 'https://twitter.com/$username';

    case 'pinterest':
      return 'https://www.pinterest.com/$username/';

    case 'yelp':
      return 'https://www.yelp.com/biz/$username/';

    case 'tiktok':
      return 'https://www.tiktok.com/@$username';

    case 'facebook':
      return 'https://web.facebook.com/$username/';

    case 'whatsapp':
      return 'https://wa.me/$username';

    case 'website':
      return 'https://$username';

    default:
      return '';
  }
}

// Widget socialIcon(String type) {
//   switch (type) {
//     case 'insta':
//       return SvgPicture.asset('assets/social_media/insta.svg');
//     case 'twitter':
//       return const FaIcon(FontAwesomeIcons.twitter);
//     case 'pinterest':
//       return const FaIcon(FontAwesomeIcons.pinterest);
//     case 'yelp':
//       return const FaIcon(FontAwesomeIcons.yelp);
//     case 'tiktok':
//       return const FaIcon(FontAwesomeIcons.tiktok);
//     case 'facebook':
//       return SvgPicture.asset('assets/social_media/facebook_messenger.svg');
//     case 'website':
//       return const FaIcon(FontAwesomeIcons.globe);

//     default:
//       return const SizedBox();
//   }
// }