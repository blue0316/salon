// import 'package:bbblient/src/controller/all_providers/all_providers.dart';
// import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
// import 'package:bbblient/src/models/salon_master/master.dart';
// import 'package:bbblient/src/views/themes/utils/theme_type.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'barbershop_about_view.dart';
// import 'default_about_view.dart';
// import 'glam_light_about_view.dart';
// import 'minimal_about_view.dart';

// class MasterAboutUnique extends ConsumerStatefulWidget {
//   final MasterModel masterModel;

//   const MasterAboutUnique({Key? key, required this.masterModel})
//       : super(key: key);

//   @override
//   ConsumerState<MasterAboutUnique> createState() => _MasterAboutUniqueState();
// }

// class _MasterAboutUniqueState extends ConsumerState<MasterAboutUnique> {
//   @override
//   Widget build(BuildContext context) {
//     final SalonProfileProvider _salonProfileProvider =
//         ref.watch(salonProfileProvider);

//     ThemeType themeType = _salonProfileProvider.themeType;

//     return aboutTheme(themeType, widget.masterModel);
//   }
// }

// Widget aboutTheme(ThemeType themeType, MasterModel masterModel) {
//   switch (themeType) {
//     case ThemeType.Barbershop:
//       return BarbershopAboutUsMaster(masterModel: masterModel);

//     case ThemeType.GentleTouch:
//       return GlamLightAboutUsMaster(masterModel: masterModel);

//     case ThemeType.CityMuseDark:
//       return MinimalAboutViewMaster(masterModel: masterModel);

//     case ThemeType.CityMuseLight:
//       return MinimalAboutViewMaster(masterModel: masterModel);

//     default:
//       return DefaultAboutViewMaster(masterModel: masterModel);
//   }
// }
