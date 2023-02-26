import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SalonWorks extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const SalonWorks({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<SalonWorks> createState() => _SalonWorksState();
}

class _SalonWorksState extends ConsumerState<SalonWorks> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    // Check if Salon is a single master
    final bool isSingleMaster = (widget.salonModel.ownerType == OwnerType.singleMaster);

    return Padding(
      padding: EdgeInsets.only(
        top: DeviceConstraints.getResponsiveSize(context, 40, 50, 50),
        bottom: DeviceConstraints.getResponsiveSize(context, 50, 50, 60),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: theme.cardColor), // Color(0XFFFFC692)
        child: Padding(
          padding: EdgeInsets.only(
            left: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
            right: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
            top: DeviceConstraints.getResponsiveSize(context, 80.h, 90.h, 100.h),
            bottom: DeviceConstraints.getResponsiveSize(context, 60.h, 90.h, 100.h),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isSingleMaster ? (AppLocalizations.of(context)?.myWorks ?? 'My Works') : (AppLocalizations.of(context)?.ourWorks ?? 'Our Works').toUpperCase(),
                    style: theme.textTheme.headline2?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 40.sp, 50.sp),
                    ),
                  ),
                  const Spacer(),
                  PrevAndNext(
                    backOnTap: () => _controller.previousPage(),
                    forwardOnTap: () => _controller.nextPage(),
                  ),
                ],
              ),
              SizedBox(height: DeviceConstraints.getResponsiveSize(context, 50, 50, 35)),
              (widget.salonModel.photosOfWork.isNotEmpty)
                  ? SizedBox(
                      height: 260.h,
                      child: CarouselSlider(
                        carouselController: _controller,
                        options: CarouselOptions(
                          scrollPhysics: const AlwaysScrollableScrollPhysics(),
                          autoPlay: true,
                          pauseAutoPlayOnTouch: true,
                          viewportFraction: DeviceConstraints.getResponsiveSize(context, 0.6, 0.6, 0.3),
                          height: 260.h,
                        ),
                        items: widget.salonModel.photosOfWork
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedImage(width: 200.w, url: item, fit: BoxFit.cover),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    )
                  : SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

class PrevAndNext extends ConsumerWidget {
  final VoidCallback backOnTap;
  final VoidCallback forwardOnTap;

  const PrevAndNext({Key? key, required this.backOnTap, required this.forwardOnTap}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Row(
        children: [
          GestureDetector(
            onTap: backOnTap,
            child: ((_salonProfileProvider.theme != '2'))
                ? SvgPicture.asset(
                    ThemeIcons.leftArrow,
                    color: Colors.black,
                    height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                  )
                : Icon(
                    Icons.arrow_back,
                    size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                    color: Colors.white,
                  ),
          ),

          // const SizedBox(width: 20),
          SizedBox(width: DeviceConstraints.getResponsiveSize(context, 15, 30, 40)),

          GestureDetector(
            onTap: forwardOnTap,
            child: ((_salonProfileProvider.theme != '2'))
                ? SvgPicture.asset(
                    ThemeIcons.rightArrow,
                    height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                  )
                : Icon(
                    Icons.arrow_forward,
                    size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                    color: Colors.white,
                  ),
          ),
          // SvgPicture.asset(
          //   ThemeIcons.rightArrow,
          //   color: const Color(0XFF0A0A0A),
          //   height: 35.sp,
          // ),
        ],
      ),
    );
  }
}

// List<String> ladyImages = [
//   ThemeImages.lady1,
//   ThemeImages.lady2,
//   ThemeImages.lady3,
//   ThemeImages.lady4,
//   ThemeImages.lady1,
//   ThemeImages.lady2,
//   ThemeImages.lady3,
//   ThemeImages.lady2,
//   ThemeImages.lady3,
// ];


                      // ListView.separated(
                      //   scrollDirection: Axis.horizontal,
                      //   physics: const BouncingScrollPhysics(),
                      //   separatorBuilder: (context, index) {
                      //     return SizedBox(
                      //       width: DeviceConstraints.getResponsiveSize(context, 10, 10, 25),
                      //     );
                      //   },
                      //   itemCount: widget.salonModel.photosOfWork.length,
                      //   itemBuilder: (context, index) {
                      //     return InkWell(
                      //       onTap: () {
                      //         print(widget.salonModel.photosOfWork[index]);
                      //       },
                      //       child: CachedImage(
                      //         url: widget.salonModel.photosOfWork[index],
                      //         fit: BoxFit.cover,
                      //       ),
                      //     );x
                      //   },
                      // ),