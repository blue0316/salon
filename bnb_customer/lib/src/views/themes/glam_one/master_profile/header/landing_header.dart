import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'default_landing.dart';
import 'glam_light_landing.dart';
import 'minimal_header.dart';

class MasterLandingHeader extends ConsumerWidget {
  final MasterModel masterModel;
  const MasterLandingHeader({Key? key, required this.masterModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final SalonModel chosenSalon = _salonProfileProvider.chosenSalon;

    ThemeType themeType = _salonProfileProvider.themeType;

    return headerTheme(themeType, chosenSalon, masterModel);
  }
}

Widget headerTheme(ThemeType themeType, SalonModel salon, MasterModel masterModel) {
  switch (themeType) {
    case ThemeType.GlamLight:
      return GlamLightHeader(chosenSalon: salon, masterModel: masterModel, isSalonMaster: true);

    case ThemeType.GlamMinimalLight:
      return MinimalHeader(salonModel: salon, masterModel: masterModel, isSalonMaster: true);

    case ThemeType.GlamMinimalDark:
      return MinimalHeader(salonModel: salon, masterModel: masterModel, isSalonMaster: true);

    default:
      return DefaultLandingHeaderView(chosenSalon: salon, masterModel: masterModel, isSalonMaster: true);
  }
}
