import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BarbershopAboutUsMaster extends ConsumerWidget {
  final MasterModel masterModel;

  const BarbershopAboutUsMaster({Key? key, required this.masterModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        top: 50,
        bottom: 50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            (AppLocalizations.of(context)?.aboutMe ?? 'About Me').toUpperCase(),
            style: theme.textTheme.displayMedium?.copyWith(
              fontSize: DeviceConstraints.getResponsiveSize(context, 25.sp, 30.sp, 50.sp),
            ),
          ),
          SizedBox(height: 50.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (isPortrait)
                Expanded(
                  flex: 0,
                  child: SizedBox(
                    height: 200.h,
                    width: double.infinity,
                    child: (masterModel.profilePicUrl != null && masterModel.profilePicUrl != '')
                        ? Image.network(
                            masterModel.profilePicUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Image.asset(
                            AppIcons.masterDefaultAvtar,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                  ),
                ),
              if (isPortrait) const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (!isPortrait)
                    Expanded(
                      flex: 0,
                      child: SizedBox(
                        height: DeviceConstraints.getResponsiveSize(context, 0, 150.h, 180.h),
                        width: DeviceConstraints.getResponsiveSize(context, 0, 150.w, 100.w),
                        child: (masterModel.profilePicUrl != null && masterModel.profilePicUrl != '')
                            ? Image.network(
                                masterModel.profilePicUrl!,
                                fit: BoxFit.cover,
                                width: DeviceConstraints.getResponsiveSize(context, 0, 150.w, 100.w),
                              )
                            : Image.asset(
                                AppIcons.masterDefaultAvtar,
                                fit: BoxFit.cover,
                                width: DeviceConstraints.getResponsiveSize(context, 0, 150.w, 100.w),
                              ),
                      ),
                    ),
                  if (!isPortrait) const SizedBox(width: 30),
                  Flexible(
                    child: Text(
                      (masterModel.personalInfo != null && masterModel.personalInfo!.description != null && masterModel.personalInfo!.description != "") ? '${masterModel.personalInfo?.description}' : 'No description yet',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 15.5.sp,
                      ),
                      maxLines: DeviceConstraints.getResponsiveSize(context, 20, 7, 7).toInt(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
