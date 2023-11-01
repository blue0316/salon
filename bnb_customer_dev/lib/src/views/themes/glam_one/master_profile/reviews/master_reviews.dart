// import 'package:bbblient/src/controller/all_providers/all_providers.dart';
// import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
// import 'package:bbblient/src/models/salon_master/master.dart';
// import 'package:bbblient/src/utils/device_constraints.dart';
// import 'package:bbblient/src/views/themes/images.dart';
// import 'package:bbblient/src/views/themes/utils/theme_type.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'default_review_view.dart';
// import 'minimal_review.dart';

// class MasterReviewsUnique extends ConsumerStatefulWidget {
//   final MasterModel masterModel;

//   const MasterReviewsUnique({Key? key, required this.masterModel}) : super(key: key);

//   @override
//   ConsumerState<MasterReviewsUnique> createState() => _MasterReviewsUniqueState();
// }

// class _MasterReviewsUniqueState extends ConsumerState<MasterReviewsUnique> {
//   final CarouselController _controller = CarouselController();

//   @override
//   Widget build(BuildContext context) {
//     final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

//     ThemeType themeType = _salonProfileProvider.themeType;

//     return reviewsSectionTheme(
//       context,
//       themeType: themeType,
//       master: widget.masterModel,
//       controller: _controller,
//     );
//   }
// }

// Widget reviewsSectionTheme(context, {required ThemeType themeType, required MasterModel master, required CarouselController controller}) {
//   switch (themeType) {
//     case ThemeType.GentleTouch:
//       return Stack(
//         children: [
//           Positioned(
//             bottom: 20,
//             right: DeviceConstraints.getResponsiveSize(context, -50, -150, -150),
//             child: SizedBox(
//               height: 350.h,
//               width: DeviceConstraints.getResponsiveSize(context, 300.w, 300.w, 200.w),
//               child: SvgPicture.asset(ThemeImages.glamLightEllipse),
//             ),
//           ),
//           DefaultReviewsView(masterModel: master, controller: controller),
//         ],
//       );

//     case ThemeType.GlamMinimalLight:
//       return MinimalReviewView(masterModel: master, controller: controller);

//     case ThemeType.GlamMinimalDark:
//       return MinimalReviewView(masterModel: master, controller: controller);

//     default:
//       return DefaultReviewsView(masterModel: master, controller: controller);
//   }
// }
