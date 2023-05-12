import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class Header extends ConsumerWidget {
  final String? salonLogo, salonAddress, salonPhone;
  final String salonName;

  const Header({Key? key, this.salonLogo, required this.salonName, this.salonAddress, this.salonPhone}) : super(key: key);

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
            horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 20.w, 30.w),
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
                    Container(
                      height: DeviceConstraints.getResponsiveSize(context, 50.h, 50.h, 60.h),
                      width: DeviceConstraints.getResponsiveSize(context, 50.h, 50.h, 60.h),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: salonLogo != '' ? null : theme.primaryColor),
                      child: (salonLogo != null && salonLogo != '')
                          ? CachedImage(url: salonLogo!)
                          : Center(
                              child: Text(
                                salonName[0].toUpperCase(),
                                style: theme.textTheme.displayLarge!.copyWith(
                                  fontSize: DeviceConstraints.getResponsiveSize(context, 25.sp, 30.sp, 30.sp),
                                  color: Colors.white,
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
                            salonName,
                            style: theme.textTheme.displayLarge!.copyWith(
                              fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 20.sp, 20.sp),
                              color: theme.primaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Space(factor: 0.4),
                          GestureDetector(
                            onTap: () {
                              MapsLauncher.launchQuery(salonAddress ?? '');
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.mapPin2WhiteSVG,
                                  height: 15.sp,
                                  color: isLightTheme ? Colors.black : Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    salonAddress ?? '',
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Utils().launchCaller(salonPhone?.replaceAll("-", ""));
                          },
                          child: Container(
                            height: 35.h,
                            width: 35.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: theme.primaryColor, width: 1.3),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0.sp),
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.phone,
                                  color: theme.primaryColor,
                                  size: 15.h,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            final url = Uri.parse('sms:$salonPhone');
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
                            child: Padding(
                              padding: EdgeInsets.all(8.0.sp),
                              child: Center(
                                child: SvgPicture.asset(
                                  AppIcons.send1,
                                  color: theme.primaryColor,
                                  height: DeviceConstraints.getResponsiveSize(context, 40, 50, 70),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
