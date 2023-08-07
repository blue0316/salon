import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/promotions/promotion_service.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/prev_and_next.dart';
import 'package:bbblient/src/views/themes/glam_one/master_profile/unique_master_profile.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'portrait_view.dart';

class GlamLightPromotions extends ConsumerStatefulWidget {
  final List<PromotionModel> salonPromotionsList;

  const GlamLightPromotions({Key? key, required this.salonPromotionsList}) : super(key: key);

  @override
  ConsumerState<GlamLightPromotions> createState() => _GlamLightPromotionsState();
}

class _GlamLightPromotionsState extends ConsumerState<GlamLightPromotions> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: isTab ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (AppLocalizations.of(context)?.promotions ?? 'Promotions').toUpperCase(),
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 60.sp),
                ),
              ),
              if (!isTab)
                PrevAndNextButtons(
                  backOnTap: () => _controller.previousPage(),
                  forwardOnTap: () => _controller.nextPage(),
                  backColor: const Color(0XFF767676),
                  forwardColor: Colors.black,
                ),
            ],
          ),
        ),
        SizedBox(height: DeviceConstraints.getResponsiveSize(context, 55.h, 60.h, 80.h)),
        (widget.salonPromotionsList.isNotEmpty)
            ? SizedBox(
                height: DeviceConstraints.getResponsiveSize(
                  context,
                  500.h,
                  600.h,
                  350.h,
                ),
                width: double.infinity,
                child: (!isTab)
                    ? PortraitCarousel(
                        controller: _controller,
                        salonPromotionsList: widget.salonPromotionsList,
                      )
                    : Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 250.h,
                                  width: double.infinity,
                                  child: GlamLightPromotionCarousel(
                                    controller: _controller,
                                    salonPromotionsList: widget.salonPromotionsList,
                                    viewportFraction: 0.55,
                                  ),
                                ),
                                // SizedBox(height: 30),
                                const Spacer(),
                                Row(
                                  children: [
                                    const Spacer(),
                                    PrevAndNextButtons(
                                      backOnTap: () => _controller.previousPage(),
                                      forwardOnTap: () => _controller.nextPage(),
                                      backColor: const Color(0XFF767676),
                                      forwardColor: Colors.black,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30.w),
                          if (widget.salonPromotionsList[0].promotionImage != '' || widget.salonPromotionsList[0].promotionImage != null)
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  width: 200.w,
                                  child: OvalImage(
                                    image: '${widget.salonPromotionsList[0].promotionImage}',
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ) // NO PROMOTIONS
            : NoSectionYet(
                text: AppLocalizations.of(context)?.noPromotions ?? 'No promotions at the moment',
                color: theme.colorScheme.secondary,
              ),
        SizedBox(height: DeviceConstraints.getResponsiveSize(context, 40.h, 40.h, 80.h)),
        Padding(
          padding: EdgeInsets.only(
            right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          ),
          child: const Divider(color: Colors.black, thickness: 1),
        ),
      ],
    );
  }
}
