import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'default_landing.dart';
import 'glam_light_landing.dart';

class LandingHeader extends ConsumerWidget {
  const LandingHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final SalonModel chosenSalon = _salonProfileProvider.chosenSalon;

    ThemeType themeType = _salonProfileProvider.themeType;

    return themeType == ThemeType.GlamLight
        ? GlamLightHeader(
            chosenSalon: chosenSalon,
          )
        : DefaultLandingHeaderView(
            chosenSalon: chosenSalon,
          );
  }
}
