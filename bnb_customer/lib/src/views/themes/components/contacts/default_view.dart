import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/contact_maps.dart';
import 'widgets/sections.dart';

class ContactDefaultView extends ConsumerWidget {
  final SalonModel salonModel;

  const ContactDefaultView({Key? key, required this.salonModel}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final bool isSingleMaster = (salonModel.ownerType == OwnerType.singleMaster);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            print(salonModel.position?.geoPoint?.latitude);
            print(salonModel.position?.geoPoint?.longitude);
          },
          child: Text(
            isSingleMaster
                ? (AppLocalizations.of(context)?.contacts ?? 'Contacts')
                : (AppLocalizations.of(
                          context,
                        )?.contactUs ??
                        'Contact Us')
                    .toUpperCase(),
            style: theme.textTheme.displayMedium!.copyWith(
              fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 45.sp, 65.sp),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 50),
        SizedBox(
          height: DeviceConstraints.getResponsiveSize(context, 550.h, 310.h, 300.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: (!isPortrait) ? 10.w : 0),
            child: (!isPortrait)
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ContactSection(salonModel: salonModel),
                            const SizedBox(height: 10),
                            VisitUs(salonModel: salonModel),
                            const SizedBox(height: 10),
                            SocialNetwork(salonModel: salonModel),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      // Spacer(),

                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 400.h,
                          child: GoogleMaps(
                            salonModel: salonModel,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: GoogleMaps(
                            salonModel: salonModel,
                          )
                          // Image.asset(ThemeImages.map, fit: BoxFit.cover),
                          ),
                      const SizedBox(height: 30),
                      ContactSection(salonModel: salonModel),
                      const SizedBox(height: 30),
                      VisitUs(salonModel: salonModel),
                      const SizedBox(height: 30),
                      SocialNetwork(salonModel: salonModel),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
