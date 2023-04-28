import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/customer_web_settings.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/booking_dialog_2.dart';
import 'package:bbblient/src/views/themes/components/widgets/button.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MinimalAboutView extends ConsumerWidget {
  final SalonModel salonModel;

  const MinimalAboutView({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);
    final bool isSingleMaster = (salonModel.ownerType == OwnerType.singleMaster);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    CustomerWebSettings? themeSettings = _salonProfileProvider.themeSettings;

    return Padding(
      padding: const EdgeInsets.only(
        left: 0,
        // right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        top: 100,
        bottom: 50,
      ),
      child: (!isTab)
          ? PortraitView(salonModel: salonModel)
          : Padding(
              padding: EdgeInsets.only(
                right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 470.h,
                      // width: double.infinity,
                      child: (themeSettings?.aboutSectionImage != null || themeSettings?.aboutSectionImage != '')
                          ? CachedImage(
                              url: themeSettings!.aboutSectionImage!,
                              fit: BoxFit.cover,
                            )
                          : salonModel.photosOfWork.isNotEmpty
                              ? CachedImage(
                                  url: salonModel.photosOfWork[0],
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(ThemeImages.makeup, fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    width: DeviceConstraints.getResponsiveSize(context, 30.w, 30.w, 25.w),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isSingleMaster ? (AppLocalizations.of(context)?.aboutMe ?? 'About Me') : (AppLocalizations.of(context)?.aboutUs ?? 'About Us').toUpperCase(),
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          (salonModel.description != '') ? salonModel.description : 'No description yet',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.primaryColor,
                            fontSize: 20.sp,
                          ),
                          maxLines: 10,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SquareButton(
                              text: (AppLocalizations.of(context)?.bookNow ?? "Book Now").toUpperCase(),
                              buttonColor: theme.cardColor,
                              textColor: theme.primaryColor,
                              borderColor: theme.primaryColor,
                              textSize: 16.5.sp,
                              showSuffix: false,
                              onTap: () => const BookingDialogWidget222().show(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class PortraitView extends ConsumerWidget {
  final SalonModel salonModel;

  const PortraitView({Key? key, required this.salonModel}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isSingleMaster = (salonModel.ownerType == OwnerType.singleMaster);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    CustomerWebSettings? themeSettings = _salonProfileProvider.themeSettings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 0,
          child: SizedBox(
            height: DeviceConstraints.getResponsiveSize(context, 250.h, 350.h, 400.h),
            width: double.infinity,
            child: (themeSettings?.aboutSectionImage != null || themeSettings?.aboutSectionImage != '')
                ? CachedImage(
                    url: themeSettings!.aboutSectionImage!,
                    fit: BoxFit.cover,
                  )
                : salonModel.photosOfWork.isNotEmpty
                    ? CachedImage(
                        url: salonModel.photosOfWork[0],
                        fit: BoxFit.cover,
                      )
                    : Image.asset(ThemeImages.makeup, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.only(
            left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
            right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          ),
          child: Text(
            isSingleMaster ? (AppLocalizations.of(context)?.aboutMe ?? 'About Me') : (AppLocalizations.of(context)?.aboutUs ?? 'About Us').toUpperCase(),
            style: theme.textTheme.displayMedium?.copyWith(
              fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.only(
            left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
            right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                (salonModel.description != '') ? salonModel.description : 'No description yet',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.primaryColor,
                  fontSize: 15.sp,
                ),
                maxLines: DeviceConstraints.getResponsiveSize(context, 20, 7, 7).toInt(),
              ),
              const SizedBox(height: 25),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SquareButton(
                    text: (AppLocalizations.of(context)?.bookNow ?? "Book Now").toUpperCase(),
                    buttonColor: theme.cardColor,
                    textColor: theme.primaryColor,
                    borderColor: theme.primaryColor,
                    textSize: 16.sp,
                    showSuffix: false,
                    onTap: () => const BookingDialogWidget222().show(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
