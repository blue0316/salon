import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class Header extends ConsumerWidget {
  final SalonModel salonModel;
  final VoidCallback goToLanding;

  const Header({Key? key, required this.salonModel, required this.goToLanding}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Center(
      child: Container(
        height: 100.h,
        color: theme.canvasColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 15.w, 30.w),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: goToLanding,
                        child: Container(
                          height: DeviceConstraints.getResponsiveSize(context, 55.h, 55.h, 65.h),
                          width: DeviceConstraints.getResponsiveSize(context, 55.h, 55.h, 65.h),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: salonModel.salonLogo != '' ? null : theme.primaryColor,
                            border: Border.all(color: theme.primaryColor),
                          ),
                          child: (salonModel.salonLogo != '')
                              ? CachedImage(
                                  url: salonModel.salonLogo,
                                  imageBuilder: (context, imageProvider) => Container(
                                    height: DeviceConstraints.getResponsiveSize(context, 55.h, 55.h, 65.h),
                                    width: DeviceConstraints.getResponsiveSize(context, 55.h, 55.h, 65.h),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    (salonModel.salonName.isNotEmpty) ? salonModel.salonName[0].toUpperCase() : '',
                                    style: theme.textTheme.displayLarge!.copyWith(
                                      fontSize: DeviceConstraints.getResponsiveSize(context, 25.sp, 30.sp, 30.sp),
                                      color: isLightTheme ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SpaceHorizontal(factor: 0.8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            salonModel.salonName.toTitleCase(),
                            style: theme.textTheme.displayLarge!.copyWith(
                              fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 20.sp, 20.sp),
                              color: Colors.purple, // theme.primaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Space(factor: 0.4),
                          GestureDetector(
                            onTap: () {
                              MapsLauncher.launchQuery(salonModel.address);
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.locationDot,
                                  size: 15.sp,
                                  color: isLightTheme ? Colors.black : Colors.white,
                                ),
                                // SvgPicture.asset(
                                //   AppIcons.mapPin2WhiteSVG,
                                //   height: 15.sp,
                                //   color: isLightTheme ? Colors.black : Colors.white,
                                // ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    salonModel.address,
                                    style: theme.textTheme.displayMedium!.copyWith(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: isLightTheme ? Colors.black : Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Utils().launchCaller(salonModel.phoneNumber.replaceAll("-", ""));
                            },
                            child: Container(
                              // height: DeviceConstraints.getResponsiveSize(context, 20, 25, 40),
                              // width: DeviceConstraints.getResponsiveSize(context, 20, 25, 40),
                              height: 35.h,
                              width: 35.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: theme.primaryColor, width: 1.3),
                              ),
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.phone,
                                  color: theme.primaryColor,
                                  size: DeviceConstraints.getResponsiveSize(context, 15.h, 16.h, 18.h),
                                ),
                                // FaIcon(
                                //   FontAwesomeIcons.phone,
                                //   color: theme.primaryColor,
                                //   size: DeviceConstraints.getResponsiveSize(context, 15.h, 16.h, 18.h),
                                // ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () async {
                                final url = Uri.parse('sms:${salonModel.phoneNumber}');
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  await launchUrl(url);
                                  throw 'could not launch';
                                }
                              },
                              child: Container(
                                height: 35.h,
                                width: 35.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(color: theme.primaryColor, width: 1.3),
                                ),
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.paperplane,
                                    color: theme.primaryColor,
                                    size: DeviceConstraints.getResponsiveSize(context, 15.h, 16.h, 18.h),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
