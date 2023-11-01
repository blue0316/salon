import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/booking_dialog_2.dart';
import 'package:bbblient/src/views/themes/components/widgets/multiple_states_button.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GentleTouchAboutUs extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const GentleTouchAboutUs({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<GentleTouchAboutUs> createState() => _GentleTouchAboutUsState();
}

class _GentleTouchAboutUsState extends ConsumerState<GentleTouchAboutUs> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    // CustomerWebSettings? themeSettings = _salonProfileProvider.themeSettings;
    final bool isSingleMaster = _salonProfileProvider.isSingleMaster;
    ThemeType themeType = _salonProfileProvider.themeType;

    return Padding(
      padding: const EdgeInsets.only(
        left: 0,
        // right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        top: 40,
        bottom: 50,
      ),
      child: (!isTab)
          ? PortraitView(salonModel: widget.salonModel)
          : Padding(
              padding: EdgeInsets.only(
                right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 500.h,
                      // width: double.infinity,
                      decoration: BoxDecoration(
                        color: widget.salonModel.profilePics.isNotEmpty ? null : theme.primaryColor,
                      ),
                      child: (widget.salonModel.profilePics.isNotEmpty)
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 500.h,
                                  width: double.infinity,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: CarouselSlider(
                                      carouselController: _controller,
                                      options: CarouselOptions(
                                        height: 500.h,
                                        autoPlay: true,
                                        viewportFraction: 1,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        },
                                      ),
                                      items: widget.salonModel.profilePics
                                          .map(
                                            (item) => CachedImage(
                                              url: item, //  item.image!,
                                              fit: BoxFit.cover,
                                              height: 300.h,
                                              width: MediaQuery.of(context).size.width,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                                // SizedBox(height: 15.sp),
                                Positioned(
                                  bottom: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: widget.salonModel.profilePics.asMap().entries.map((entry) {
                                      return GestureDetector(
                                        onTap: () => _controller.animateToPage(entry.key),
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _current == entry.key
                                                ? Colors.white
                                                : const Color(0XFF8A8A8A).withOpacity(
                                                    _current == entry.key ? 0.9 : 0.4,
                                                  ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Text(
                                (widget.salonModel.salonName.isNotEmpty) ? widget.salonModel.salonName[0].toUpperCase() : '',
                                style: theme.textTheme.displayLarge!.copyWith(
                                  fontSize: DeviceConstraints.getResponsiveSize(context, 60.sp, 80.sp, 100.sp),
                                  color: themeType == ThemeType.GentleTouch ? Colors.white : Colors.black,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    width: DeviceConstraints.getResponsiveSize(context, 30.w, 30.w, 25.w),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isSingleMaster ? (AppLocalizations.of(context)?.aboutMe ?? 'About Me') : (AppLocalizations.of(context)?.aboutUs ?? 'About Us').toUpperCase(),
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                            color: themeType == ThemeType.GentleTouch ? Colors.black : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          (widget.salonModel.description != '') ? widget.salonModel.description : 'No description yet',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: themeType == ThemeType.GentleTouch ? Colors.black : Colors.white,
                            fontSize: 18.sp,
                            fontFamily: 'Inter',
                          ),
                          maxLines: 10,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MultipleStatesButton(
                              borderColor: Colors.transparent,
                              buttonColor: theme.colorScheme.secondary,
                              width: 180.sp,
                              text: (AppLocalizations.of(context)?.bookNow ?? "Book Now"),
                              weight: FontWeight.normal,
                              textColor: themeType == ThemeType.GentleTouch ? const Color(0XFFFFFFFF) : Colors.black,
                              height: 47.h,
                              showSuffix: false,
                              borderRadius: 2,
                              isGradient: _salonProfileProvider.hasThemeGradient,
                              onTap: () => const BookingDialogWidget222().show(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: DeviceConstraints.getResponsiveSize(context, 30.w, 30.w, 25.w),
                  ),
                ],
              ),
            ),
    );
  }
}

class PortraitView extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const PortraitView({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<PortraitView> createState() => _PortraitViewState();
}

class _PortraitViewState extends ConsumerState<PortraitView> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final bool isSingleMaster = _salonProfileProvider.isSingleMaster;
    ThemeType themeType = _salonProfileProvider.themeType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(
              left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
              right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
            ),
            child: Text(
              isSingleMaster ? (AppLocalizations.of(context)?.aboutMe ?? 'About Me') : (AppLocalizations.of(context)?.aboutUs ?? 'About Us').toUpperCase(),
              style: theme.textTheme.displayMedium?.copyWith(
                fontSize: 50.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          flex: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w)),
            child: Container(
              height: 350.h,
              // width: double.infinity,
              decoration: BoxDecoration(
                color: widget.salonModel.profilePics.isNotEmpty ? null : theme.primaryColor,
              ),
              child: (widget.salonModel.profilePics.isNotEmpty)
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 500.h,
                          width: double.infinity,
                          child: SizedBox(
                            width: double.infinity,
                            child: CarouselSlider(
                              carouselController: _controller,
                              options: CarouselOptions(
                                height: 500.h,
                                autoPlay: true,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                },
                              ),
                              items: widget.salonModel.profilePics
                                  .map(
                                    (item) => CachedImage(
                                      url: item, //  item.image!,
                                      fit: BoxFit.cover,
                                      height: 300.h,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                        // SizedBox(height: 15.sp),
                        Positioned(
                          bottom: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: widget.salonModel.profilePics.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () => _controller.animateToPage(entry.key),
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _current == entry.key
                                        ? Colors.white
                                        : const Color(0XFF8A8A8A).withOpacity(
                                            _current == entry.key ? 0.9 : 0.4,
                                          ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        (widget.salonModel.salonName.isNotEmpty) ? widget.salonModel.salonName[0].toUpperCase() : '',
                        style: theme.textTheme.displayLarge!.copyWith(
                          fontSize: DeviceConstraints.getResponsiveSize(context, 80.sp, 80.sp, 100.sp),
                          color: themeType == ThemeType.GentleTouch ? Colors.white : Colors.black,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.only(
            left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
            right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                (widget.salonModel.description != '') ? widget.salonModel.description : 'No description yet',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.primaryColor,
                  fontSize: 17.sp,
                ),
                maxLines: DeviceConstraints.getResponsiveSize(context, 20, 7, 7).toInt(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MultipleStatesButton(
                    borderColor: Colors.transparent,
                    buttonColor: theme.colorScheme.secondary,
                    width: 180.sp,
                    text: (AppLocalizations.of(context)?.bookNow ?? "Book Now"),
                    weight: FontWeight.normal,
                    textColor: themeType == ThemeType.GentleTouch ? const Color(0XFFFFFFFF) : Colors.black,
                    height: 47.h,
                    showSuffix: false,
                    borderRadius: 3,
                    isGradient: _salonProfileProvider.hasThemeGradient,
                    onTap: () => const BookingDialogWidget222().show(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
