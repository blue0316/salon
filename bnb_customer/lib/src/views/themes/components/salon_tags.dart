import 'dart:async';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/salon/widgets/additional%20featured.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalonTags extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  final List<String> additionalFeatures;
  final bool isScrollingNeeded;

  const SalonTags({
    Key? key,
    required this.additionalFeatures,
    required this.salonModel,
    this.isScrollingNeeded = true,
  }) : super(key: key);

  @override
  ConsumerState<SalonTags> createState() => _SalonTagsState();
}

class _SalonTagsState extends ConsumerState<SalonTags> {
  final ScrollController _scrollController = ScrollController();

  Timer? _timer;
  // int _currentPage = 0;

  PageController pageController = PageController();

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    if (widget.isScrollingNeeded) {
      _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
        _toggleScrolling();
      });
    }
  }

  bool scroll = false;
  int speedFactor = 20;

  _scroll() {
    double maxExtent = _scrollController.position.maxScrollExtent;
    double distanceDifference = maxExtent - _scrollController.offset;
    double durationDouble = distanceDifference / speedFactor;

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: durationDouble.toInt()),
      curve: Curves.linear,
    );
  }

  _toggleScrolling() {
    if (mounted) {
      setState(() {
        scroll = !scroll;
      });

      if (scroll) {
        _scroll();
      } else {
        _scrollController.animateTo(
          _scrollController.offset,
          duration: const Duration(seconds: 1),
          curve: Curves.linear,
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    controller.dispose();
  }

  getFeature(String s) {
    final repository = ref.watch(bnbProvider);

    List<Map<String, String>> searchList = getFeaturesList(repository.locale.toString());

    for (Map registeredFeatures in searchList) {
      if (registeredFeatures.containsKey(s)) {
        return registeredFeatures[s];
      }
    }

    return s;
  }

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider =
        ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    pageController = PageController(
        viewportFraction:
            DeviceConstraints.getResponsiveSize(context, 0.5, 0.4, 0.3));

    List<String> aFeatured = [
      ...widget.additionalFeatures,
      ...widget.additionalFeatures,
      ...widget.additionalFeatures
    ];

    return (themeType == ThemeType.GentleTouch || themeType == ThemeType.GentleTouchDark || themeType == ThemeType.VintageCraft)
        ? Padding(
            padding: EdgeInsets.only(
              left: DeviceConstraints.getResponsiveSize(
                  context, 10.w, 10.w, 30.w),
              right: DeviceConstraints.getResponsiveSize(
                  context, 10.w, 10.w, 30.w),
              top: 100.h,
              bottom: 50.h,
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.spaceBetween,
                runSpacing: 15.sp,
                children: widget.additionalFeatures
                    .map(
                      (item) => GentleTouchTagItem(
                        title: getFeature(item),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 50),
            //  RotationTransition(
            // turns: AlwaysStoppedAnimation(themeType == ThemeType.GentleTouch ? 3 / 360 : 0),
            child: Column(
              children: [
                Divider(color: theme.dividerColor, thickness: 2),
                SizedBox(
                  height: 35.h,
                  child: Center(
                    child: NotificationListener(
                      onNotification: (notif) {
                        if (notif is ScrollEndNotification && scroll) {
                          Timer(const Duration(seconds: 1), () {
                            _scroll();
                          });
                        }

                        return true;
                      },
                      child: Center(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          children: [
                            Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: aFeatured
                                    .map(
                                      (item) => Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Text(
                                              getFeature(item),
                                              style: theme.textTheme.bodyLarge
                                                  ?.copyWith(
                                                color: theme.dividerColor,
                                                fontSize: 18.sp,
                                                fontFamily: 'Inter-Medium',
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 8.h,
                                            width: 8.h,
                                            decoration:
                                                tagSeperator(themeType, theme),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(color: theme.dividerColor, thickness: 2),
              ],
            ),
          );
  }

  List<Map<String, String>> getFeaturesList(String locale) {
    switch (locale) {
      case 'uk':
        return ukSalonFeatures;
      case 'es':
        return esSalonFeatures;
      case 'fr':
        return frSalonFeatures;
      case 'pt':
        return ptSalonFeatures;
      case 'ro':
        return roSalonFeatures;
      case 'ar':
        return arSalonFeatures;

      default:
        return salonFeatures;
    }
  }
}

class GentleTouchTagItem extends ConsumerWidget {
  final String title;

  const GentleTouchTagItem({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider =
        ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    final bool isPortrait =
        (DeviceConstraints.getDeviceType(MediaQuery.of(context)) ==
            DeviceScreenType.portrait);

    return SizedBox(
      width: isPortrait ? (MediaQuery.of(context).size.width - 20.w) : 350.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.check_rounded,
            color: theme.colorScheme.secondary,
            size: 30.sp,
          ),
          SizedBox(width: 10.sp),
          SizedBox(
            width: isPortrait ? null : 250.h,
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration tagSeperator(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.CityMuseDark:
      return BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: theme.dividerColor),
        color: Colors.transparent,
      );

    case ThemeType.CityMuseLight:
      return BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: theme.dividerColor),
        color: Colors.transparent,
      );

    default:
      return BoxDecoration(shape: BoxShape.circle, color: theme.dividerColor);
  }
}

String convertLowerCamelCase(String input) {
  var output = '';
  for (var i = 0; i < input.length; i++) {
    if (i == 0) {
      output += input[i].toLowerCase();
    } else if (input[i].toUpperCase() == input[i]) {
      output += ' ' + input[i].toLowerCase();
    } else {
      output += input[i];
    }
  }
  return output.toLowerCase();
}
