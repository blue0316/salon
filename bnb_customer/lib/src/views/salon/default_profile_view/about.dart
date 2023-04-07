import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LandscapeAboutHeader extends StatelessWidget {
  final SalonModel salonModel;
  const LandscapeAboutHeader({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Image.asset(AppIcons.onboardingFirstPNG, fit: BoxFit.cover),
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
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Space(factor: 0.7),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        AppIcons.mapPinPNG,
                        height: DeviceConstraints.getResponsiveSize(context, 18.h, 18.h, 15.h),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        salonModel.address,
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
              const Space(factor: 0.5),
              BnbRatings(
                rating: salonModel.rating,
                editable: false,
                starSize: 12,
              ),
              const Space(factor: 0.5),
              if (salonModel.description != '')
                Text(
                  '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.''',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
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

class PortraitAboutHeader extends StatelessWidget {
  final SalonModel salonModel;

  const PortraitAboutHeader({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 150.h,
          width: double.infinity,
          child: Image.asset(
            AppIcons.onboardingFirstPNG,
            fit: BoxFit.contain,
          ),
        ),
        const Space(factor: 1.5),
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
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Space(factor: 0.7),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      AppIcons.mapPinPNG,
                      height: DeviceConstraints.getResponsiveSize(context, 18.h, 18.h, 15.h),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      salonModel.address,
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            const Space(factor: 0.5),
            BnbRatings(
              rating: salonModel.rating,
              editable: false,
              starSize: 12,
            ),
            const Space(factor: 1),
            if (salonModel.description != '')
              Text(
                salonModel.description,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
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
