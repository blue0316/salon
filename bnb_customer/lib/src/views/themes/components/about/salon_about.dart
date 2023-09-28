import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'barbershop_about_view.dart';
import 'default_about_view.dart';
import 'gentle_touch_about_view.dart';
import 'minimal_about_view.dart';

class SalonAbout2 extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const SalonAbout2({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<SalonAbout2> createState() => _SalonAbout2State();
}

class _SalonAbout2State extends ConsumerState<SalonAbout2> {
  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    ThemeType themeType = _salonProfileProvider.themeType;

    return aboutTheme(themeType, widget.salonModel);
  }
}

Widget aboutTheme(ThemeType themeType, SalonModel salonModel) {
  switch (themeType) {
    case ThemeType.Barbershop:
      return BarbershopAboutUs(salonModel: salonModel);

    case ThemeType.GentleTouch:
      return GentleTouchAboutUs(salonModel: salonModel);

    case ThemeType.GentleTouchDark:
      return GentleTouchAboutUs(salonModel: salonModel);

    case ThemeType.GlamMinimalDark:
      return MinimalAboutView(salonModel: salonModel);

    case ThemeType.GlamMinimalLight:
      return MinimalAboutView(salonModel: salonModel);

    default:
      return DefaultAboutView(salonModel: salonModel);
  }
}
