import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/themes/vintage_craft/desktop/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'default_landing.dart';
import 'gentle_touch_header.dart';

class LandingHeader extends ConsumerWidget {
  const LandingHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final SalonModel chosenSalon = _salonProfileProvider.chosenSalon;

    ThemeType themeType = _salonProfileProvider.themeType;

    return headerTheme(themeType, chosenSalon);
  }
}

Widget headerTheme(ThemeType themeType, SalonModel salon) {
  switch (themeType) {
    case ThemeType.GentleTouch:
      return GentleTouchHeader(chosenSalon: salon);

    case ThemeType.GentleTouchDark:
      return GentleTouchHeader(chosenSalon: salon);

    case ThemeType.VintageCraft:
      return VintageHeader(salonModel: salon);

    default:
      return DefaultLandingHeaderView(chosenSalon: salon);
  }
}
