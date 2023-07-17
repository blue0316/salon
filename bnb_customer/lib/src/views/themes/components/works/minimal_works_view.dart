import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/glam_one/master_profile/unique_master_profile.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MinimalWorksView extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  const MinimalWorksView({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<MinimalWorksView> createState() => _MinimalWorksViewState();
}

class _MinimalWorksViewState extends ConsumerState<MinimalWorksView> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    // Check if Salon is a single master
    final bool isSingleMaster = _salonProfileProvider.isSingleMaster;

    return Padding(
      padding: EdgeInsets.only(
        top: DeviceConstraints.getResponsiveSize(context, 90.h, 100.h, 120.h),
        // bottom: DeviceConstraints.getResponsiveSize(context, 20, 20, 10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            (isSingleMaster ? (AppLocalizations.of(context)?.myWorks ?? 'My Works') : (AppLocalizations.of(context)?.ourWorks ?? 'Our Works')).toUpperCase(),
            style: theme.textTheme.displayMedium?.copyWith(
              color: theme.colorScheme.secondary,
              fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 60.sp),
            ),
          ),
          SizedBox(height: DeviceConstraints.getResponsiveSize(context, 50, 50, 80)),
          (widget.salonModel.photosOfWork.isNotEmpty)
              ? SizedBox(
                  // height: 260.h,
                  child: CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                      // scrollPhysics: const AlwaysScrollableScrollPhysics(),
                      autoPlay: true,
                      // pauseAutoPlayOnTouch: true,
                      // enableInfiniteScroll: false,
                      padEnds: false,
                      viewportFraction: DeviceConstraints.getResponsiveSize(context, 0.8, 0.5, 0.333),

                      // viewportFraction: DeviceConstraints.getResponsiveSize(context, 1, 0.5, 0.5),
                      height: DeviceConstraints.getResponsiveSize(context, 280.h, 350.h, 350.h),
                    ),
                    items: widget.salonModel.photosOfWork
                        .map(
                          (item) => CachedImage(
                            width: DeviceConstraints.getResponsiveSize(
                              context,
                              350.w,
                              (size.width / 1.5), // size.width / 2.5, // 380.w,
                              size.width / 3, // 350.w,
                            ),
                            // width: DeviceConstraints.getResponsiveSize(
                            //   context,
                            //   size.width - 20.w,
                            //   size.width - 20.w,
                            //   200.w,
                            // ),
                            url: item,
                            fit: BoxFit.cover,
                          ),
                        )
                        .toList(),
                  ),
                )
              : NoSectionYet(
                  text: AppLocalizations.of(context)?.noWorks ?? 'No photos of works',
                  color: theme.colorScheme.secondary,
                ),
        ],
      ),
    );
  }
}
