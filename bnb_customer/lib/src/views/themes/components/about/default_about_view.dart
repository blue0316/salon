import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/booking_dialog_2.dart';
import 'package:bbblient/src/views/themes/components/widgets/button.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/components/widgets/oval_button.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DefaultAboutView extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const DefaultAboutView({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<DefaultAboutView> createState() => _DefaultAboutViewState();
}

class _DefaultAboutViewState extends ConsumerState<DefaultAboutView> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    final ThemeType themeType = _salonProfileProvider.themeType;
    final bool isSingleMaster = _salonProfileProvider.isSingleMaster;

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 0, 0),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        top: DeviceConstraints.getResponsiveSize(context, 80.h, 90.h, 100.h),
        bottom: DeviceConstraints.getResponsiveSize(context, 25, 30, 50),
      ),
      child: SizedBox(
        width: double.infinity,
        height: isPortrait ? 700.h : DeviceConstraints.getResponsiveSize(context, 25, 300.h, 450.h),
        child: (!isPortrait)
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    // color: Colors.yellow,
                    // height: 500.h,
                    width: DeviceConstraints.getResponsiveSize(context, 50, 200.w, 200.w),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: SizedBox(
                            // color: Colors.brown,
                            height: 500.h,
                            child: CarouselSlider(
                              carouselController: _controller,
                              options: CarouselOptions(
                                scrollPhysics: const NeverScrollableScrollPhysics(),
                                autoPlay: false,
                                pauseAutoPlayOnTouch: true,
                                viewportFraction: 1,

                                // height: DeviceConstraints.getResponsiveSize(context, 280.h, 320, 350.h),
                              ),
                              items: widget.salonModel.photosOfWork.isNotEmpty
                                  ? widget.salonModel.photosOfWork
                                      .map((item) => CachedImage(
                                            url: item,
                                            fit: BoxFit.cover,
                                            width: DeviceConstraints.getResponsiveSize(context, 50, 200.w, 200.w),
                                          ))
                                      .toList()
                                  : [
                                      Image.asset(ThemeImages.makeup, fit: BoxFit.cover),
                                    ],
                            ),
                          ),
                        ),
                        LeftCarouselButton(controller: _controller, theme: theme),
                        RightCarouselButton(controller: _controller, theme: theme),
                      ],
                    ),
                  ),
                  SizedBox(width: DeviceConstraints.getResponsiveSize(context, 0, 20.w, 25.w)),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isSingleMaster ? (AppLocalizations.of(context)?.aboutMe ?? 'About Me') : (AppLocalizations.of(context)?.aboutUs ?? 'About Us').toUpperCase(),
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontSize: DeviceConstraints.getResponsiveSize(context, 35.sp, 40.sp, 60.sp),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            child: Text(
                              (widget.salonModel.description != '') ? widget.salonModel.description : 'No description yet',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontSize: 15.5.sp,
                              ),
                              maxLines: DeviceConstraints.getResponsiveSize(context, 6, 7, 9).toInt(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          (themeType == ThemeType.GlamBarbershop)
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SquareButton(
                                      text: AppLocalizations.of(context)?.bookNow ?? "Book Now",
                                      onTap: () => const BookingDialogWidget222().show(context),
                                    ),
                                  ],
                                )
                              : OvalButton(
                                  text: AppLocalizations.of(context)?.bookNow ?? "Book Now",
                                  width: 180.h,
                                  height: 60.h,
                                  onTap: () => const BookingDialogWidget222().show(context),
                                ),
                        ],
                      ),
                    ),
                  ),
                  if (DeviceConstraints.getDeviceType(MediaQuery.of(context)) != DeviceScreenType.tab)
                    const Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${AppLocalizations.of(context)?.about} ${isSingleMaster ? "ME" : "US"}".toUpperCase(),
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontSize: 40.sp,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    (widget.salonModel.description != '') ? widget.salonModel.description : 'No description yet',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 15.5.sp,
                    ),
                    maxLines: 6,
                  ),
                  const SizedBox(height: 30),
                  (themeType == ThemeType.GlamBarbershop)
                      ? SquareButton(
                          text: AppLocalizations.of(context)?.bookNow ?? "Book Now",
                          onTap: () => const BookingDialogWidget222().show(context),
                        )
                      : OvalButton(
                          width: 180.h,
                          height: 60.h,
                          textSize: 18.sp,
                          text: AppLocalizations.of(context)?.bookNow ?? "Book Now",
                          onTap: () => const BookingDialogWidget222().show(context),
                        ),
                  const SizedBox(height: 35),
                  SizedBox(
                    height: 360.sp,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 360.sp,
                          width: double.infinity,
                          child: CarouselSlider(
                            carouselController: _controller,
                            options: CarouselOptions(
                              scrollPhysics: const NeverScrollableScrollPhysics(),
                              autoPlay: false,
                              pauseAutoPlayOnTouch: true,

                              viewportFraction: 1,

                              height: 360.sp, //  DeviceConstraints.getResponsiveSize(context, 280.h, 320, 350.h),
                            ),
                            items: widget.salonModel.photosOfWork.isNotEmpty
                                ? widget.salonModel.photosOfWork
                                    .map(
                                      (item) => CachedImage(
                                        url: item,
                                        fit: BoxFit.cover,
                                        height: 300.h,
                                        width: MediaQuery.of(context).size.width,
                                      ),
                                    )
                                    .toList()
                                : [
                                    Image.asset(ThemeImages.makeup, fit: BoxFit.cover),
                                  ],
                          ),
                        ),
                        LeftCarouselButton(controller: _controller, theme: theme),
                        RightCarouselButton(controller: _controller, theme: theme),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class RightCarouselButton extends StatelessWidget {
  const RightCarouselButton({
    Key? key,
    required CarouselController controller,
    required this.theme,
    this.size,
    this.containerSize,
    this.containerColor,
    this.iconColor,
  })  : _controller = controller,
        super(key: key);

  final CarouselController _controller;
  final ThemeData theme;
  final double? size;
  final double? containerSize;
  final Color? containerColor, iconColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: InkWell(
          onTap: () => _controller.nextPage(),
          child: Container(
            height: containerSize ?? DeviceConstraints.getResponsiveSize(context, 30.h, 30.h, 40.h),
            width: containerSize ?? DeviceConstraints.getResponsiveSize(context, 30.h, 30.h, 40.h),
            decoration: BoxDecoration(shape: BoxShape.circle, color: containerColor ?? Colors.black87),
            child: Center(
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: iconColor ?? theme.primaryColorDark,
                size: size ?? DeviceConstraints.getResponsiveSize(context, 16.sp, 16.sp, 20.sp),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LeftCarouselButton extends StatelessWidget {
  const LeftCarouselButton({
    Key? key,
    required CarouselController controller,
    required this.theme,
    this.size,
    this.containerSize,
    this.containerColor,
    this.iconColor,
  })  : _controller = controller,
        super(key: key);

  final CarouselController _controller;
  final ThemeData theme;
  final double? size;
  final double? containerSize;
  final Color? containerColor, iconColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: InkWell(
          onTap: () => _controller.previousPage(),
          child: Container(
            height: containerSize ?? DeviceConstraints.getResponsiveSize(context, 30.h, 30.h, 40.h),
            width: containerSize ?? DeviceConstraints.getResponsiveSize(context, 30.h, 30.h, 40.h),
            decoration: BoxDecoration(shape: BoxShape.circle, color: containerColor ?? Colors.black87),
            child: Center(
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: iconColor ?? theme.primaryColorDark,
                size: size ?? DeviceConstraints.getResponsiveSize(context, 16.sp, 16.sp, 20.sp),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
