import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/enums/profile_datails_tabs.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/salon/widgets/additional%20featured.dart';
import 'package:bbblient/src/views/salon/widgets/service_expension_tile.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:extended_wrap/extended_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'about.dart';
import 'salon_profile.dart';

class SalonAbout extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const SalonAbout({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<SalonAbout> createState() => _SalonAboutState();
}

class _SalonAboutState extends ConsumerState<SalonAbout> {
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

  int maxLinesForAdditionalFeature = 1;

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    BnbProvider _bnbProvider = ref.read(bnbProvider);
    // final _salonProfileProvider = ref.watch(salonProfileProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SectionSpacer(
            title: (AppLocalizations.of(context)?.localeName == 'uk') ? saloonDetailsTitlesUK[1] : saloonDetailsTitles[1],
          ),
          Container(
            // height: 1000.h,
            width: double.infinity,
            color: Colors.white.withOpacity(0.7),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 0,
                    child: SizedBox(
                      height: isPortrait ? 500.h : 200.h,
                      child: isPortrait
                          ? PortraitAboutHeader(
                              salonModel: widget.salonModel,
                            )
                          : LandscapeAboutHeader(
                              salonModel: widget.salonModel,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: DeviceConstraints.getResponsiveSize(context, 10, 10, 30),
                  ),

                  Expanded(
                    flex: 0,
                    child: SizedBox(
                      // height: 200.h,
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: ExtendedWrap(
                              spacing: 10,
                              maxLines: maxLinesForAdditionalFeature,
                              runSpacing: 10.h,
                              children: [
                                for (String s in widget.salonModel.additionalFeatures) ...[
                                  if (AppIcons.getIconFromFacilityString(feature: s) != null) ...[
                                    if (_bnbProvider.locale == const Locale('en')) ...[
                                      Container(
                                        color: Colors.white,
                                        height: DeviceConstraints.getResponsiveSize(context, 80.h, 90.h, 100.h),
                                        width: DeviceConstraints.getResponsiveSize(context, 80.h, 90.h, 100.h),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () => showDialog<bool>(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return ShowAdditionaFeatureInfo(_bnbProvider, s);
                                                  }),
                                              child: Container(
                                                height: DeviceConstraints.getResponsiveSize(context, 30.sp, 30.sp, 40.sp),
                                                width: DeviceConstraints.getResponsiveSize(context, 30.sp, 30.sp, 40.sp),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: AppTheme.black, width: 1),
                                                  borderRadius: BorderRadius.circular(50),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.sp),
                                                  child: SvgPicture.asset(AppIcons.getIconFromFacilityString(feature: s)!),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              getFeature(s) ?? '',
                                              style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 13.sp),
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    if (_bnbProvider.locale == const Locale('uk')) ...[
                                      SizedBox(
                                        height: DeviceConstraints.getResponsiveSize(context, 80.h, 90.h, 100.h),
                                        width: DeviceConstraints.getResponsiveSize(context, 80.h, 90.h, 100.h),
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () => showDialog<bool>(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    debugPrint(s);
                                                    return ShowAdditionaFeatureInfo(_bnbProvider, s);
                                                  }),
                                              child: Container(
                                                height: DeviceConstraints.getResponsiveSize(context, 30.sp, 30.sp, 40.sp),
                                                width: DeviceConstraints.getResponsiveSize(context, 30.sp, 30.sp, 40.sp),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: AppTheme.black, width: 1),
                                                  borderRadius: BorderRadius.circular(50),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.sp),
                                                  child: SvgPicture.asset(AppIcons.getIconFromFacilityString(feature: s)!),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              getFeatureUk(s) ?? '',
                                              style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 13.sp),
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]
                                  ]
                                ],
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: GestureDetector(
                              onTap: () {
                                if (maxLinesForAdditionalFeature != widget.salonModel.additionalFeatures.length) {
                                  setState(() {
                                    maxLinesForAdditionalFeature = widget.salonModel.additionalFeatures.length;
                                  });
                                } else {
                                  setState(() {
                                    maxLinesForAdditionalFeature = 1;
                                  });
                                }
                              },
                              child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.black,
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    flex: 0,
                    child: Container(
                      height: 100.h,
                      color: Colors.green,
                    ),
                  ),
                  // const SizedBox(height: 30),
                  // Expanded(
                  //   flex: 0,
                  //   child: Container(
                  //     height: 100.h,
                  //     color: Colors.pink,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
