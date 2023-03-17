import 'dart:async';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
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
  const SalonTags(
      {Key? key, required this.additionalFeatures, required this.salonModel})
      : super(key: key);

  @override
  ConsumerState<SalonTags> createState() => _SalonTagsState();
}

class _SalonTagsState extends ConsumerState<SalonTags> {
  final ScrollController _scrollController = ScrollController();

  Timer? _timer;
  int _currentPage = 0;

  PageController pageController = PageController();

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      _toggleScrolling();
    });
  }

  bool scroll = false;
  int speedFactor = 20;

  _scroll() {
    double maxExtent = _scrollController.position.maxScrollExtent;
    double distanceDifference = maxExtent - _scrollController.offset;
    double durationDouble = distanceDifference / speedFactor;

    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: durationDouble.toInt()),
        curve: Curves.linear);
  }

  _toggleScrolling() {
    if (mounted) {
      setState(() {
        scroll = !scroll;
      });

      if (scroll) {
        _scroll();
      } else {
        _scrollController.animateTo(_scrollController.offset,
            duration: const Duration(seconds: 1), curve: Curves.linear);
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
    debugPrint(widget.salonModel.ownerType);
    if (widget.salonModel.ownerType == 'singleMaster') {
      for (Map registeredFeatures in masterFeatures) {
        if (registeredFeatures.containsKey(s)) {
          return registeredFeatures[s];
        }
      }
    }

    if (widget.salonModel.ownerType == 'salon') {
      for (Map registeredFeatures in salonFeatures) {
        if (registeredFeatures.containsKey(s)) {
          return registeredFeatures[s];
        }
      }
    }
  }

  getFeatureUk(String s) {
    debugPrint(widget.salonModel.ownerType);
    for (Map registeredFeatures in ukMasterFeatures) {
      if (registeredFeatures.containsKey(s)) {
        return registeredFeatures[s];
      }
    }

    if (widget.salonModel.ownerType == 'salon') {
      for (Map registeredFeatures in ukSalonFeatures) {
        if (registeredFeatures.containsKey(s)) {
          return registeredFeatures[s];
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    BnbProvider _bnbProvider = ref.read(bnbProvider);

    final SalonProfileProvider _salonProfileProvider =
        ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    pageController = PageController(
      viewportFraction:
          DeviceConstraints.getResponsiveSize(context, 0.5, 0.4, 0.3),
    );

    List<String> aFeatured = [
      ...widget.additionalFeatures,
      ...widget.additionalFeatures,
      ...widget.additionalFeatures
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 50),
      child: RotationTransition(
        turns: AlwaysStoppedAnimation(
            themeType == ThemeType.GlamLight ? 3 / 360 : 0),
        child: Column(
          children: [
            Divider(color: theme.dividerColor, thickness: 2),
            SizedBox(
              height: 60,
              child: NotificationListener(
                onNotification: (notif) {
                  if (notif is ScrollEndNotification && scroll) {
                    Timer(const Duration(seconds: 1), () {
                      _scroll();
                    });
                  }

                  return true;
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: Row(
                    children: aFeatured
                        .map((item) => Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    // TODO: HANDLE FOR OTHER LOCALIZATIONS
                                    (_bnbProvider.locale == const Locale('en'))
                                        ? getFeature(item)
                                        : (_bnbProvider.locale ==
                                                const Locale('uk'))
                                            ? getFeatureUk(item)
                                            : item,
                                    //  convertLowerCamelCase(widget.additionalFeatures[item]),
                                    style: theme.textTheme.bodyText1?.copyWith(
                                      color: theme.dividerColor,
                                      fontSize: 18.sp,
                                      fontFamily: 'Poppins-Light',
                                    ),
                                  ),
                                ),
                                Container(
                                    height: 8.h,
                                    width: 8.h,
                                    decoration: tagSeperator(themeType, theme)),
                              ],
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
            Divider(color: theme.dividerColor, thickness: 2),
          ],
        ),
      ),
    );
  }
}

BoxDecoration tagSeperator(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GlamMinimalDark:
      return BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: theme.dividerColor),
        color: Colors.transparent,
      );

    case ThemeType.GlamMinimalLight:
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
