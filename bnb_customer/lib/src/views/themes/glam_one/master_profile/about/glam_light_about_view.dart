import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/booking_dialog_2.dart';
import 'package:bbblient/src/views/themes/components/widgets/oval_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GlamLightAboutUsMaster extends ConsumerWidget {
  final MasterModel masterModel;
  const GlamLightAboutUsMaster({Key? key, required this.masterModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
        padding: EdgeInsets.only(
          left: 0, // DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          top: 50,
          bottom: 50,
        ),
        child: (!isTab)
            ? PortraitView(masterModel: masterModel)
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 450.h,
                      // width: double.infinity,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.horizontal(right: Radius.elliptical(200, 180)),
                        child: (masterModel.profilePicUrl != null && masterModel.profilePicUrl != '')
                            ? Image.network(
                                masterModel.profilePicUrl!,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(AppIcons.masterDefaultAvtar, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: DeviceConstraints.getResponsiveSize(context, 30.w, 30.w, 30.w),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (AppLocalizations.of(context)?.aboutMe ?? 'About Me').toUpperCase(),
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Text(
                          (masterModel.personalInfo != null && masterModel.personalInfo!.description != null && masterModel.personalInfo!.description != "") ? '${masterModel.personalInfo?.description}' : 'No description yet',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                            fontSize: 20.sp,
                          ),
                          maxLines: 10,
                        ),
                        SizedBox(height: 25.h),
                        OvalButton(
                          text: AppLocalizations.of(context)?.bookNow ?? "Book Now",
                          textSize: 20.sp,
                          width: 160.h,
                          onTap: () => const BookingDialogWidget222().show(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
  }
}

class PortraitView extends ConsumerWidget {
  final MasterModel masterModel;

  const PortraitView({Key? key, required this.masterModel}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w)),
          child: Text(
            (AppLocalizations.of(context)?.aboutMe ?? 'About Me').toUpperCase(),
            style: theme.textTheme.displayMedium?.copyWith(
              fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
            ),
          ),
        ),
        SizedBox(height: 50.h),
        Padding(
          padding: EdgeInsets.only(left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                (masterModel.personalInfo != null && masterModel.personalInfo!.description != null && masterModel.personalInfo!.description != "") ? '${masterModel.personalInfo?.description}' : 'No description yet',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black,
                  fontSize: 15.sp,
                ),
                maxLines: DeviceConstraints.getResponsiveSize(context, 20, 7, 7).toInt(),
              ),
              const SizedBox(height: 25),
              OvalButton(
                text: AppLocalizations.of(context)?.bookNow ?? "Book Now",
                textSize: 15.sp,
                onTap: () => const BookingDialogWidget222().show(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
        Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SizedBox(
              height: DeviceConstraints.getResponsiveSize(context, 250.h, 350.h, 400.h),
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(right: Radius.elliptical(200, 180)),
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
          ),
        ),
      ],
    );
  }
}