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
import 'package:url_launcher/url_launcher.dart';

import 'profile/widgets/minimal_app_bar.dart';

class ThemeAppBar extends ConsumerWidget {
  final SalonModel salonModel;

  const ThemeAppBar({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    ThemeType themeType = _salonProfileProvider.themeType;

    return appBarTheme(themeType, salonModel);
  }
}

Widget appBarTheme(ThemeType themeType, SalonModel salon) {
  switch (themeType) {
    case ThemeType.GlamMinimalDark:
      return MinimalAppBar(salonModel: salon);
    case ThemeType.GlamMinimalLight:
      return MinimalAppBar(salonModel: salon);

    default:
      return DefaultAppBarTheme(salonModel: salon);
  }
}

class Socials extends ConsumerWidget {
  final String socialIcon;
  final String? socialUrl;
  final Color? color;
  final double? height;

  const Socials({Key? key, required this.socialIcon, required this.socialUrl, this.color, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

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
          color: Colors.black, // theme.appBarTheme.iconTheme!.color, // TODO: REVERT
        ),
      ),
    );
  }
}
