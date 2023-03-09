import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'default_view.dart';

class SalonContact extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const SalonContact({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<SalonContact> createState() => _SalonContactState();
}

class _SalonContactState extends ConsumerState<SalonContact> with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    String? themeNo = _salonProfileProvider.theme;

    return Container(
      decoration: (themeNo == '4')
          ? BoxDecoration(
              image: DecorationImage(
                image: AssetImage(isPortrait ? ThemeImages.footerLongGradientBG : ThemeImages.footerGradientBG),
                fit: BoxFit.cover,
              ),
            )
          : null,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          vertical: 120,
        ),
        child: ContactDefaultView(salonModel: widget.salonModel),
      ),
    );
  }
}

// class BarbershopContactView extends ConsumerWidget {
//   final SalonModel salonModel;

//   const BarbershopContactView({Key? key, required this.salonModel}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
//     final bool isSingleMaster = (salonModel.ownerType == OwnerType.singleMaster);

//     final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
//     final ThemeData theme = _salonProfileProvider.salonTheme;

//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage(
//             isPortrait ? ThemeImages.footerLongGradientBG : ThemeImages.footerGradientBG,
//           ),
//           fit: BoxFit.fill,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Text(
//             // "${isSingleMaster ? "" : "OUR "} CONTACTS",
//             isSingleMaster
//                 ? (AppLocalizations.of(context)?.contacts ?? 'Contacts')
//                 : (AppLocalizations.of(
//                           context,
//                         )?.ourContacts ??
//                         'Our Contacts')
//                     .toUpperCase(),
//             style: theme.textTheme.headline2!.copyWith(
//               fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 50),
//           SizedBox(
//             height: DeviceConstraints.getResponsiveSize(context, 550.h, 310.h, 260.h),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: (!isPortrait) ? 10.w : 0),
//               child: (!isPortrait)
//                   ? Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               ContactSection(salonModel: salonModel),
//                               const SizedBox(height: 10),
//                               VisitUs(salonModel: salonModel),
//                               const SizedBox(height: 10),
//                               SocialNetwork(salonModel: salonModel),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 30),
//                         // Spacer(),

//                         Expanded(
//                           flex: 1,
//                           child: SizedBox(
//                             height: 400.h,
//                             child: GoogleMaps(
//                               salonModel: salonModel,
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   : Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Expanded(
//                             flex: 1,
//                             child: GoogleMaps(
//                               salonModel: salonModel,
//                             )
//                             // Image.asset(ThemeImages.map, fit: BoxFit.cover),
//                             ),
//                         const SizedBox(height: 30),
//                         ContactSection(salonModel: salonModel),
//                         const SizedBox(height: 30),
//                         VisitUs(salonModel: salonModel),
//                         const SizedBox(height: 30),
//                         SocialNetwork(salonModel: salonModel),
//                       ],
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
