import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/components/widgets.dart/button.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/components/widgets.dart/oval_button.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SalonAbout2 extends ConsumerWidget {
  final SalonModel salonModel;

  const SalonAbout2({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final bool isSingleMaster = (salonModel.ownerType == OwnerType.singleMaster);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        top: DeviceConstraints.getResponsiveSize(context, 50, 50, 120),
        bottom: DeviceConstraints.getResponsiveSize(context, 25, 30, 50),
      ),
      child: SizedBox(
        width: double.infinity,
        height: isPortrait ? 700.h : 450.h,
        child: (!isPortrait)
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: DeviceConstraints.getResponsiveSize(context, 50, 200.w, 200.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: (salonModel.photosOfWork.isNotEmpty && salonModel.photosOfWork[0] != '')
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
                  SizedBox(width: DeviceConstraints.getResponsiveSize(context, 0, 20.w, 25.w)),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isSingleMaster ? (AppLocalizations.of(context)?.aboutMe ?? 'About Me') : (AppLocalizations.of(context)?.aboutUs ?? 'About Us').toUpperCase(),
                            style: theme.textTheme.headline2?.copyWith(
                              fontSize: DeviceConstraints.getResponsiveSize(context, 25.sp, 30.sp, 50.sp),
                            ),
                          ),
                          const SizedBox(height: 3),
                          SizedBox(
                            child: Text(
                              (salonModel.description != '') ? salonModel.description : 'No description yet',
                              style: theme.textTheme.bodyText2?.copyWith(
                                color: Colors.white,
                                fontSize: 15.5.sp,
                              ),
                              maxLines: DeviceConstraints.getResponsiveSize(context, 6, 7, 9).toInt(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // (_salonProfileProvider.chosenSalon.selectedTheme == 2)
                          //     ? SquareButton(
                          //         text: AppLocalizations.of(context)?.bookNow ?? "Book Now",
                          //         // height: 60.h,
                          //         onTap: () {},
                          //       )
                          //     : OvalButton(
                          //         text: AppLocalizations.of(context)?.bookNow ?? "Book Now",
                          //         onTap: () {},
                          //       ),
                        ],
                      ),
                    ),
                  ),
                  if (DeviceConstraints.getDeviceType(MediaQuery.of(context)) != DeviceScreenType.tab)
                    const Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                ],
              )
            // : (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab)
            //     ? Container(
            //         color: Colors.red,
            //       )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${AppLocalizations.of(context)?.about} ${isSingleMaster ? "ME" : "US"}".toUpperCase(),
                    style: theme.textTheme.headline2?.copyWith(
                      fontSize: 40.sp,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    (salonModel.description != '') ? salonModel.description : 'No description yet',
                    style: theme.textTheme.bodyText2?.copyWith(
                      color: Colors.white,
                      fontSize: 15.5.sp,
                    ),
                    maxLines: 6,
                  ),
                  const SizedBox(height: 30),
                  (_salonProfileProvider.theme == '2')
                      ? SquareButton(
                          text: AppLocalizations.of(context)?.bookNow ?? "Book Now",
                          // height: 60.h,
                          onTap: () {},
                        )
                      : OvalButton(
                          width: 180.h,
                          height: 60.h,
                          textSize: 18.sp,
                          text: AppLocalizations.of(context)?.bookNow ?? "Book Now",
                          onTap: () {
                            // print(DeviceConstraints.getDeviceType(MediaQuery.of(context)));
                          },
                        ),
                  const SizedBox(height: 35),
                  SizedBox(
                    height: 300.h,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: (salonModel.photosOfWork.isNotEmpty && salonModel.photosOfWork[0] != '')
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
                ],
              ),
      ),
    );
  }
}
