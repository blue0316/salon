import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/customer_web_settings.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BarbershopAboutUs extends ConsumerWidget {
  final SalonModel salonModel;

  const BarbershopAboutUs({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    CustomerWebSettings? themeSettings = _salonProfileProvider.themeSettings;
    final bool isSingleMaster = _salonProfileProvider.isSingleMaster;

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
            isSingleMaster ? (AppLocalizations.of(context)?.aboutMe ?? 'About Me') : (AppLocalizations.of(context)?.aboutUs ?? 'About Us').toUpperCase(),
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
                    child: (themeSettings?.aboutSectionImage != null && themeSettings?.aboutSectionImage != '')
                        ? CachedImage(
                            url: themeSettings!.aboutSectionImage!,
                            fit: BoxFit.cover,
                          )
                        : salonModel.photosOfWork.isNotEmpty
                            ? CachedImage(
                                url: salonModel.photosOfWork[0],
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                ThemeImages.makeup,
                                fit: BoxFit.cover,
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
                        child: (themeSettings?.aboutSectionImage != null && themeSettings?.aboutSectionImage != '')
                            ? CachedImage(
                                url: themeSettings!.aboutSectionImage!,
                                fit: BoxFit.cover,
                              )
                            : salonModel.photosOfWork.isNotEmpty
                                ? CachedImage(
                                    url: salonModel.photosOfWork[0],
                                    fit: BoxFit.cover,
                                    // width: DeviceConstraints.getResponsiveSize(
                                    //     context, 50, 200.w, 200.w),
                                  )
                                : Image.asset(
                                    ThemeImages.makeup,
                                    fit: BoxFit.cover,
                                  ),
                      ),
                    ),
                  if (!isPortrait) const SizedBox(width: 30),
                  Flexible(
                    child: Text(
                      (salonModel.description != '') ? salonModel.description : 'No description yet',
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
