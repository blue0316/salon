import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalonTeam extends ConsumerWidget {
  final SalonModel salonModel;

  const SalonTeam({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: EdgeInsets.only(
        top: DeviceConstraints.getResponsiveSize(context, 40, 60, 70),
        bottom: DeviceConstraints.getResponsiveSize(context, 30, 40, 50),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: theme.cardColor),
        child: Padding(
          padding: EdgeInsets.only(
            left: DeviceConstraints.getResponsiveSize(context, 20.w, 30.w, 30.w),
            right: DeviceConstraints.getResponsiveSize(context, 20.w, 30.w, 30.w),
            top: DeviceConstraints.getResponsiveSize(context, 80.h, 90.h, 100.h),
            bottom: DeviceConstraints.getResponsiveSize(context, 60.h, 90.h, 100.h),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "OUR TEAM",
                  style: theme.textTheme.headline2?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 40.sp, 50.sp),
                  ),
                ),
              ),
              Space(factor: DeviceConstraints.getResponsiveSize(context, 0.8, 1.3, 1.5)),
              Center(
                child: Container(
                  height: 255.h,
                  alignment: Alignment.center,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 20);
                    },
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return const TeamMember(
                        name: "Giana Bergson",
                        service: "Hairdresser",
                        image: ThemeImages.review3,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamMember extends ConsumerWidget {
  final String name, service, image;

  const TeamMember({
    Key? key,
    required this.name,
    required this.service,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Image.asset(image, fit: BoxFit.cover),
        ),
        const SizedBox(height: 15),
        Text(
          name,
          style: theme.textTheme.bodyText1?.copyWith(
            color: theme.colorScheme.secondary,
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          service,
          style: theme.textTheme.subtitle2?.copyWith(
            fontSize: 15.sp,
          ),
        ),
      ],
    );
  }
}
