import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/chat/image_preview.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/prev_and_next.dart';
import 'package:bbblient/src/views/themes/glam_one/master_profile/unique_master_profile.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DefaultWorksView extends ConsumerStatefulWidget {
  final MasterModel masterModel;
  const DefaultWorksView({Key? key, required this.masterModel}) : super(key: key);

  @override
  ConsumerState<DefaultWorksView> createState() => _DefaultWorksViewState();
}

class _DefaultWorksViewState extends ConsumerState<DefaultWorksView> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final ThemeType themeType = _salonProfileProvider.themeType;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: (themeType == ThemeType.GlamGradient) ? null : theme.cardColor,
        gradient: themeGradient(themeType, theme),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          top: DeviceConstraints.getResponsiveSize(context, 80.h, 90.h, 100.h),
          bottom: DeviceConstraints.getResponsiveSize(context, 80.h, 90.h, 100.h),
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
                  (AppLocalizations.of(context)?.myWorks ?? 'My Works').toUpperCase(),
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 40.sp, 50.sp),
                  ),
                ),
                const Spacer(),
                PrevAndNextButtons(
                  backOnTap: () => _controller.previousPage(),
                  forwardOnTap: () => _controller.nextPage(),
                  backColor: Colors.black,
                  forwardColor: Colors.black,
                ),
              ],
            ),
            SizedBox(height: DeviceConstraints.getResponsiveSize(context, 50, 50, 35)),
            (widget.masterModel.photosOfWork != null && widget.masterModel.photosOfWork!.isNotEmpty)
                ? SizedBox(
                    // height: 260.h,
                    child: CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                        scrollPhysics: const AlwaysScrollableScrollPhysics(),
                        autoPlay: false,
                        pauseAutoPlayOnTouch: true,
                        viewportFraction: DeviceConstraints.getResponsiveSize(context, 1, 0.4, 0.34),
                        height: DeviceConstraints.getResponsiveSize(context, 280.h, 350.h, 350.h),
                      ),
                      items: widget.masterModel.photosOfWork!
                          .map(
                            (item) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImagePreview(
                                      imageUrls: widget.masterModel.photosOfWork,
                                      index: widget.masterModel.photosOfWork!.indexOf(item),
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: CachedImage(
                                  width: DeviceConstraints.getResponsiveSize(
                                    context,
                                    size.width - 20.w,
                                    ((size.width / 2)), // size.width - 20.w,
                                    (size.width / 3) - 20, // 200.w,
                                  ),
                                  url: item,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                : NoSectionYet(
                    text: 'No photos of works', // AppLocalizations.of(context)?.noWorks ?? 'No photos of works',
                    color: theme.colorScheme.secondary,
                  ),
          ],
        ),
      ),
    );
  }
}

Gradient? themeGradient(ThemeType type, ThemeData theme) {
  switch (type) {
    case ThemeType.GlamGradient:
      return LinearGradient(
        colors: [
          theme.colorScheme.surfaceVariant,
          theme.colorScheme.onSurfaceVariant,
          theme.colorScheme.surfaceTint,
        ],
      );

    default:
      return null;
  }
}
