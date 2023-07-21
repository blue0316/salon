import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/glam_one/master_profile/unique_master_profile.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MinimalWorksView extends ConsumerStatefulWidget {
  final MasterModel masterModel;
  const MinimalWorksView({Key? key, required this.masterModel}) : super(key: key);

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
            (AppLocalizations.of(context)?.myWorks ?? 'My Works').toUpperCase(),
            style: theme.textTheme.displayMedium?.copyWith(
              color: theme.colorScheme.secondary,
              fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 40.sp, 50.sp),
            ),
          ),
          SizedBox(height: DeviceConstraints.getResponsiveSize(context, 50, 50, 80)),
          (widget.masterModel.photosOfWork != null && widget.masterModel.photosOfWork!.isNotEmpty)
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
                    items: widget.masterModel.photosOfWork!
                        .map(
                          (item) => CachedImage(
                            width: DeviceConstraints.getResponsiveSize(
                              context,
                              350.w,
                              (size.width / 1.5), // size.width / 2.5, // 380.w,
                              size.width / 3, // 350.w,
                            ),
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
