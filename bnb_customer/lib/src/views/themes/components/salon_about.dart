import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/booking_dialog_2.dart';
import 'package:bbblient/src/views/themes/components/widgets.dart/button.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/components/widgets.dart/oval_button.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SalonAbout2 extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const SalonAbout2({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<SalonAbout2> createState() => _SalonAbout2State();
}

class _SalonAbout2State extends ConsumerState<SalonAbout2> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final bool isPortrait =
        (DeviceConstraints.getDeviceType(MediaQuery.of(context)) ==
            DeviceScreenType.portrait);
    final bool isSingleMaster =
        (widget.salonModel.ownerType == OwnerType.singleMaster);
    final SalonProfileProvider _salonProfileProvider =
        ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 0, 0),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        top: DeviceConstraints.getResponsiveSize(context, 50, 50, 120),
        bottom: DeviceConstraints.getResponsiveSize(context, 25, 30, 50),
      ),
      child: SizedBox(
        width: double.infinity,
        height: isPortrait
            ? 700.h
            : DeviceConstraints.getResponsiveSize(context, 25, 300.h, 450.h),
        child: (!isPortrait)
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    // height: 500.h,
                    width: DeviceConstraints.getResponsiveSize(
                        context, 50, 200.w, 200.w),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: SizedBox(
                            height: 500.h,
                            child: CarouselSlider(
                              carouselController: _controller,
                              options: CarouselOptions(
                                scrollPhysics:
                                    const AlwaysScrollableScrollPhysics(),
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
                                            width: DeviceConstraints
                                                .getResponsiveSize(
                                                    context, 50, 200.w, 200.w),
                                          ))
                                      .toList()
                                  : [
                                      Image.asset(ThemeImages.makeup,
                                          fit: BoxFit.cover),
                                    ],
                            ),
                          ),
                        ),
                        LeftCarouselButton(
                            controller: _controller, theme: theme),
                        RightCarouselButton(
                            controller: _controller, theme: theme),
                      ],
                    ),
                    // child: ClipRRect(
                    //   // borderRadius: BorderRadius.circular(10),
                    //   child: (widget.salonModel.photosOfWork.isNotEmpty && widget.salonModel.photosOfWork[0] != '')
                    //       ? CachedImage(
                    //           url: widget.salonModel.photosOfWork[0],
                    //           fit: BoxFit.cover,
                    //         )
                    //       : Image.asset(
                    //           ThemeImages.makeup,
                    //           fit: BoxFit.cover,
                    //         ),
                    // ),
                  ),
                  SizedBox(
                      width: DeviceConstraints.getResponsiveSize(
                          context, 0, 20.w, 25.w)),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isSingleMaster
                                ? (AppLocalizations.of(context)?.aboutMe ??
                                    'About Me')
                                : (AppLocalizations.of(context)?.aboutUs ??
                                        'About Us')
                                    .toUpperCase(),
                            style: theme.textTheme.headline2?.copyWith(
                              fontSize: DeviceConstraints.getResponsiveSize(
                                  context, 25.sp, 30.sp, 50.sp),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            child: Text(
                              (widget.salonModel.description != '')
                                  ? widget.salonModel.description
                                  : 'No description yet',
                              style: theme.textTheme.bodyText2?.copyWith(
                                color: Colors.white,
                                fontSize: 15.5.sp,
                              ),
                              maxLines: DeviceConstraints.getResponsiveSize(
                                      context, 6, 7, 9)
                                  .toInt(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          (_salonProfileProvider.theme == '2' ||
                                  _salonProfileProvider.theme == '4')
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SquareButton(
                                      text: AppLocalizations.of(context)
                                              ?.bookNow ??
                                          "Book Now",
                                      onTap: () =>
                                          const BookingDialogWidget222()
                                              .show(context),
                                    ),
                                  ],
                                )
                              : OvalButton(
                                  text: AppLocalizations.of(context)?.bookNow ??
                                      "Book Now",
                                  onTap: () => const BookingDialogWidget222()
                                      .show(context),
                                ),
                        ],
                      ),
                    ),
                  ),
                  if (DeviceConstraints.getDeviceType(MediaQuery.of(context)) !=
                      DeviceScreenType.tab)
                    const Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                ],
              )
            // : (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab)
            //     ? Container(
            //         color: Colors.red,
            //       )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${AppLocalizations.of(context)?.about} ${isSingleMaster ? "ME" : "US"}"
                        .toUpperCase(),
                    style: theme.textTheme.headline2?.copyWith(
                      fontSize: 40.sp,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    (widget.salonModel.description != '')
                        ? widget.salonModel.description
                        : 'No description yet',
                    style: theme.textTheme.bodyText2?.copyWith(
                      color: Colors.white,
                      fontSize: 15.5.sp,
                    ),
                    maxLines: 6,
                  ),
                  const SizedBox(height: 30),
                  (_salonProfileProvider.theme == '2' ||
                          _salonProfileProvider.theme == '4')
                      ? SquareButton(
                          text: AppLocalizations.of(context)?.bookNow ??
                              "Book Now",
                          onTap: () =>
                              const BookingDialogWidget222().show(context),
                        )
                      : OvalButton(
                          width: 180.h,
                          height: 60.h,
                          textSize: 18.sp,
                          text: AppLocalizations.of(context)?.bookNow ??
                              "Book Now",
                          onTap: () =>
                              const BookingDialogWidget222().show(context),
                        ),
                  const SizedBox(height: 35),
                  SizedBox(
                    height: 300.h,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 300.h,
                          child: CarouselSlider(
                            carouselController: _controller,
                            options: CarouselOptions(
                              scrollPhysics:
                                  const AlwaysScrollableScrollPhysics(),
                              autoPlay: false,
                              pauseAutoPlayOnTouch: true,
                              viewportFraction: 1,
                              height: 300
                                  .h, //  DeviceConstraints.getResponsiveSize(context, 280.h, 320, 350.h),
                            ),
                            items: widget.salonModel.photosOfWork.isNotEmpty
                                ? widget.salonModel.photosOfWork
                                    .map(
                                      (item) => CachedImage(
                                        url: item,
                                        fit: BoxFit.cover,
                                        height: 300.h,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20.w,
                                      ),
                                    )
                                    .toList()
                                : [
                                    Image.asset(ThemeImages.makeup,
                                        fit: BoxFit.cover),
                                  ],
                          ),
                        ),
                        LeftCarouselButton(
                            controller: _controller, theme: theme),
                        RightCarouselButton(
                            controller: _controller, theme: theme),
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
  })  : _controller = controller,
        super(key: key);

  final CarouselController _controller;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: InkWell(
          onTap: () => _controller.nextPage(),
          child: Container(
            height:
                DeviceConstraints.getResponsiveSize(context, 40.h, 46.h, 65.h),
            width:
                DeviceConstraints.getResponsiveSize(context, 40.h, 46.h, 65.h),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.black87),
            child: Center(
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: theme.primaryColorDark,
                size: DeviceConstraints.getResponsiveSize(
                    context, 20.sp, 20.sp, 20.sp),
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
  })  : _controller = controller,
        super(key: key);

  final CarouselController _controller;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: InkWell(
          onTap: () => _controller.previousPage(),
          child: Container(
            height:
                DeviceConstraints.getResponsiveSize(context, 30.h, 46.h, 65.h),
            width:
                DeviceConstraints.getResponsiveSize(context, 30.h, 46.h, 65.h),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.black87),
            child: Center(
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: theme.primaryColorDark,
                size: DeviceConstraints.getResponsiveSize(
                    context, 20.sp, 20.sp, 20.sp),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
