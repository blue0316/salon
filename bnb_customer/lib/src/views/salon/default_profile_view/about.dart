import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/components/about/default_about_view.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LandscapeAboutHeader extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  const LandscapeAboutHeader({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<LandscapeAboutHeader> createState() => _LandscapeAboutHeaderState();
}

class _LandscapeAboutHeaderState extends ConsumerState<LandscapeAboutHeader> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              border: !isLightTheme ? Border.all(color: Colors.white, width: 1.2) : null,
              color: widget.salonModel.profilePics.isNotEmpty ? null : theme.primaryColor,
            ),
            child: (widget.salonModel.profilePics.isNotEmpty)
                // ? CachedImage(url: salonModel.profilePics[0])
                ? SizedBox(
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

                              // height: 360.sp, //  DeviceConstraints.getResponsiveSize(context, 280.h, 320, 350.h),
                            ),
                            items: widget.salonModel.profilePics
                                .map(
                                  (item) => CachedImage(
                                    url: item,
                                    fit: BoxFit.cover,
                                    height: 300.h,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        LeftCarouselButton(
                          controller: _controller,
                          theme: theme,
                          containerSize: DeviceConstraints.getResponsiveSize(context, 26.h, 26.h, 35.h),
                          size: DeviceConstraints.getResponsiveSize(context, 14.sp, 14.sp, 18.sp),
                          containerColor: const Color.fromARGB(131, 255, 255, 255),
                          iconColor: const Color(0XFF000000),
                        ),
                        RightCarouselButton(
                          controller: _controller,
                          theme: theme,
                          containerSize: DeviceConstraints.getResponsiveSize(context, 26.h, 26.h, 35.h),
                          size: DeviceConstraints.getResponsiveSize(context, 14.sp, 14.sp, 18.sp),
                          containerColor: const Color.fromARGB(131, 255, 255, 255),
                          iconColor: const Color(0XFF000000),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      (widget.salonModel.salonName.isNotEmpty) ? widget.salonModel.salonName[0].toUpperCase() : '',
                      style: theme.textTheme.displayLarge!.copyWith(
                        fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 80.sp, 100.sp),
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 35),
        Expanded(
          flex: 2,
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.salonModel.salonName,
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                      color: isLightTheme ? Colors.black : Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // const Space(factor: 0.7),
                  const SizedBox(height: 15),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.locationDot,
                        size: DeviceConstraints.getResponsiveSize(context, 18.h, 18.h, 15.h),
                        color: isLightTheme ? Colors.black : Colors.white,
                      ),
                      // Image.asset(
                      //   AppIcons.mapPinPNG,
                      //   height: DeviceConstraints.getResponsiveSize(context, 18.h, 18.h, 15.h),
                      //   color: isLightTheme ? Colors.black : Colors.white,
                      // ),
                      const SizedBox(width: 6),
                      Text(
                        widget.salonModel.address,
                        style: theme.textTheme.displayMedium!.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: isLightTheme ? Colors.black : Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
              // const Space(factor: 0.5),
              const SizedBox(height: 10),
              BnbRatings(
                rating: widget.salonModel.rating,
                editable: false,
                starSize: 12,
              ),
              // const Space(factor: 0.5),
              const SizedBox(height: 20),

              if (widget.salonModel.description != '')
                Text(
                  widget.salonModel.description,
                  style: theme.textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 13.sp,
                    color: isLightTheme ? Colors.black : Colors.white,
                  ),
                  // maxLines: 6,
                  // overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class PortraitAboutHeader extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const PortraitAboutHeader({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<PortraitAboutHeader> createState() => _PortraitAboutHeaderState();
}

class _PortraitAboutHeaderState extends ConsumerState<PortraitAboutHeader> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 180.sp,
          width: double.infinity,
          decoration: BoxDecoration(
            border: !isLightTheme ? Border.all(color: Colors.white, width: 1.2) : null,
            color: widget.salonModel.profilePics.isNotEmpty ? null : theme.primaryColor,
          ),
          child: (widget.salonModel.profilePics.isNotEmpty)
              // ? CachedImage(url: salonModel.profilePics[0])
              ? Stack(
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

                          // height: 360.sp, //  DeviceConstraints.getResponsiveSize(context, 280.h, 320, 350.h),
                        ),
                        items: widget.salonModel.profilePics
                            .map(
                              (item) => CachedImage(
                                url: item,
                                fit: BoxFit.cover,
                                height: 300.h,
                                width: MediaQuery.of(context).size.width,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    LeftCarouselButton(
                      controller: _controller,
                      theme: theme,
                      containerSize: DeviceConstraints.getResponsiveSize(context, 26.h, 26.h, 35.h),
                      size: DeviceConstraints.getResponsiveSize(context, 14.sp, 14.sp, 18.sp),
                      containerColor: const Color.fromARGB(131, 255, 255, 255),
                      iconColor: const Color(0XFF000000),
                    ),
                    RightCarouselButton(
                      controller: _controller,
                      theme: theme,
                      containerSize: DeviceConstraints.getResponsiveSize(context, 26.h, 26.h, 35.h),
                      size: DeviceConstraints.getResponsiveSize(context, 14.sp, 14.sp, 18.sp),
                      containerColor: const Color.fromARGB(131, 255, 255, 255),
                      iconColor: const Color(0XFF000000),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    (widget.salonModel.salonName.isNotEmpty) ? widget.salonModel.salonName[0].toUpperCase() : '',
                    style: theme.textTheme.displayLarge!.copyWith(
                      fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 80.sp, 100.sp),
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
        SizedBox(height: 20.sp),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.salonModel.salonName,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    color: isLightTheme ? Colors.black : Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // const Space(factor: 0.7),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.locationDot,
                      size: DeviceConstraints.getResponsiveSize(context, 18.h, 18.h, 15.h),
                      color: isLightTheme ? Colors.black : Colors.white,
                    ),
                    // Image.asset(
                    //   AppIcons.mapPinPNG,
                    // height: DeviceConstraints.getResponsiveSize(context, 18.h, 18.h, 15.h),
                    // color: isLightTheme ? Colors.black : Colors.white,
                    // ),
                    const SizedBox(width: 6),
                    Text(
                      widget.salonModel.address,
                      style: theme.textTheme.displayMedium!.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: isLightTheme ? Colors.black : Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            // const Space(factor: 0.5),
            const SizedBox(height: 15),
            BnbRatings(
              rating: widget.salonModel.rating,
              editable: false,
              starSize: 12,
              color: isLightTheme ? const Color(0XFFF49071) : const Color(0XFFFFA755),
            ),
            // const Space(factor: 1),
            const SizedBox(height: 20),
            if (widget.salonModel.description != '')
              Text(
                widget.salonModel.description,
                style: theme.textTheme.displayMedium!.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: 14.sp,
                  color: isLightTheme ? Colors.black : Colors.white,
                ),
                // maxLines: 8,
                // overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ],
    );
  }
}
