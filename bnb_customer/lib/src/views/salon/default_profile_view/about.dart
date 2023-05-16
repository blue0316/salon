import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LandscapeAboutHeader extends ConsumerWidget {
  final SalonModel salonModel;
  const LandscapeAboutHeader({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              color: salonModel.profilePics.isNotEmpty ? null : theme.primaryColor,
            ),
            child: (salonModel.profilePics.isNotEmpty)
                ? CachedImage(url: salonModel.profilePics[0])
                : Center(
                    child: Text(
                      salonModel.salonName[0].toUpperCase(),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    salonModel.salonName,
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
                      Image.asset(
                        AppIcons.mapPinPNG,
                        height: DeviceConstraints.getResponsiveSize(context, 18.h, 18.h, 15.h),
                        color: isLightTheme ? Colors.black : Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        salonModel.address,
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
                rating: salonModel.rating,
                editable: false,
                starSize: 12,
              ),
              // const Space(factor: 0.5),
              const SizedBox(height: 20),

              if (salonModel.description != '')
                Text(
                  salonModel.description,
                  style: theme.textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                    color: isLightTheme ? Colors.black : Colors.white,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class PortraitAboutHeader extends ConsumerWidget {
  final SalonModel salonModel;

  const PortraitAboutHeader({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 180.h,
          width: double.infinity,
          decoration: BoxDecoration(
            border: !isLightTheme ? Border.all(color: Colors.white, width: 1.2) : null,
            color: salonModel.profilePics.isNotEmpty ? null : theme.primaryColor,
          ),
          child: (salonModel.profilePics.isNotEmpty)
              ? CachedImage(url: salonModel.profilePics[0])
              : Center(
                  child: Text(
                    salonModel.salonName[0].toUpperCase(),
                    style: theme.textTheme.displayLarge!.copyWith(
                      fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 80.sp, 100.sp),
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
        // const Space(factor: 1.5),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  salonModel.salonName,
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
                    Image.asset(
                      AppIcons.mapPinPNG,
                      height: DeviceConstraints.getResponsiveSize(context, 18.h, 18.h, 15.h),
                      color: isLightTheme ? Colors.black : Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      salonModel.address,
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
              rating: salonModel.rating,
              editable: false,
              starSize: 12,
              color: isLightTheme ? const Color(0XFFF49071) : const Color(0XFFFFA755),
            ),
            // const Space(factor: 1),
            const SizedBox(height: 20),
            if (salonModel.description != '')
              Text(
                salonModel.description,
                style: theme.textTheme.displayMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: isLightTheme ? Colors.black : Colors.white,
                ),
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ],
    );
  }
}
