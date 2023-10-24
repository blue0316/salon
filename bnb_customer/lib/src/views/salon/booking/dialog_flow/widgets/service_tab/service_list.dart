import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/currency/currency.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/colors.dart';
import 'package:bbblient/src/views/salon/widgets/service_expension_tile.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServiceList extends ConsumerWidget {
  final List<ServiceModel> services;
  final bool pickMasters;

  const ServiceList({Key? key, required this.services, this.pickMasters = false}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    return ListView.builder(
      itemCount: services.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final ServiceModel service = services[index];
        bool isAdded = _createAppointmentProvider.isAdded(serviceModel: service);

        return GestureDetector(
          onTap: () {
            _createAppointmentProvider.toggleService(
              serviceModel: service,
              clearChosenMaster: false,
              context: context,
            );
          },
          child: ServiceCard(
            isAdded: isAdded,
            service: service,
          ),
        );
      },
    );
  }
}

class ServiceCard extends ConsumerWidget {
  final ServiceModel service;
  final bool isAdded;

  // Masters Display Optional Parameters
  final bool pickMasters;
  final VoidCallback? pickMasterOnTap;
  final List<MasterModel>? masters;
  final bool selected;
  final bool disabled;

  const ServiceCard({
    Key? key,
    required this.isAdded,
    required this.service,
    this.pickMasters = false,
    this.pickMasterOnTap,
    this.masters,
    this.selected = false,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);
    SalonModel salonModel = _salonProfileProvider.chosenSalon;

    final ThemeData theme = _salonProfileProvider.salonTheme;
    List<MasterModel> theMasters = _createAppointmentProvider.getMasterProvidingService(service);
    ThemeType themeType = _salonProfileProvider.themeType;
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: Container(
        decoration: BoxDecoration(
          color: disabled ? const Color(0XFF4A4A4A) : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
          border: isAdded
              ? Border.all(width: 2, color: theme.colorScheme.secondary) //  theme.primaryColor)
              : Border.all(
                  width: 1,
                  color: disabled ? const Color(0XFF4A4A4A) : const Color(0XFF4A4A4A),
                ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 17.sp,
            horizontal: DeviceConstraints.getResponsiveSize(context, 15.w, 7.w, 7.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // -- SERVICE TITLE AND PRICE
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: Text(
                      service.translations?[AppLocalizations.of(context)?.localeName ?? 'en'] ?? service.translations?['en'] ?? '', // 'Eyebrow Tinting',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                        color: isAddedSelectedColor(themeType), // isAdded ? isAddedSelectedColor(themeType) : theme.colorScheme.tertiary,
                        fontFamily: 'Inter',
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: 5.sp),
                  Text(
                    (service.isPriceRange)
                        ? "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price ?? '0'}-${getCurrency(salonModel.countryCode!)}${service.priceAndDurationMax!.price ?? '0'}"
                        : (service.isPriceStartAt)
                            ? "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price ?? '0'}+"
                            : "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price ?? '0'}",
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                      color: isAddedSelectedColor(themeType), // isAdded ? isAddedSelectedColor(themeType) : theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,,
                      fontFamily: 'Inter',
                    ),
                    overflow: TextOverflow.visible,
                    maxLines: 1,
                  ),
                  // Text(
                  //   service.isFixedPrice
                  //       ? "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price}"
                  //       : service.isPriceRange
                  //           ? "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price} - ${getCurrency(salonModel.countryCode!)}${service.priceAndDurationMax!.price}"
                  //           : "${getCurrency(salonModel.countryCode!)}${service.priceAndDuration!.price} - ${getCurrency(salonModel.countryCode!)}∞",
                  //   style: theme.textTheme.bodyLarge!.copyWith(
                  //     fontWeight: FontWeight.w500,
                  //     fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                  //     color: isAdded ? isAddedSelectedColor(themeType) : theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,,
                  //   ),
                  //   overflow: TextOverflow.visible,
                  //   maxLines: 1,
                  // ),
                ],
              ),
              SizedBox(
                height: DeviceConstraints.getResponsiveSize(context, 20.h, 17.h, 17.h),
              ),

              // SERVICE DURATION
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                    width: 20.h,
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.clock,
                        color: isAddedSelectedColor(themeType),
                        size: 15.h,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.sp),
                  (service.isFixedDuration != null)
                      ? service.isFixedDuration
                          ? Text(
                              "${service.priceAndDuration!.duration} ${AppLocalizations.of(context)?.minutes ?? "minutes"}",
                              style: theme.textTheme.bodyLarge!.copyWith(
                                fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                                color: isAddedSelectedColor(themeType),
                                fontFamily: 'Inter',
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )
                          : Text(
                              "${service.priceAndDuration!.duration} ${AppLocalizations.of(context)?.minutes ?? "minutes"} - ${service.priceAndDurationMax!.duration} ${AppLocalizations.of(context)?.minutes ?? "minutes"}",
                              style: theme.textTheme.bodyLarge!.copyWith(
                                fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                                color: isAddedSelectedColor(themeType),
                                fontFamily: 'Inter',
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )
                      : Text(
                          "${service.priceAndDuration!.duration} ${AppLocalizations.of(context)?.minutes ?? "minutes"}",
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
                            color: isAddedSelectedColor(themeType),
                            fontFamily: 'Inter',
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                  const Spacer(),
                  (service.description == null || service.description == "")
                      ? const SizedBox(width: 15)
                      : Tooltip(
                          richMessage: WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              constraints: BoxConstraints(maxWidth: 220.sp),
                              child: Text(
                                '${service.description}',
                                style: theme.textTheme.displayMedium!.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                  fontFamily: "Inter",
                                ),
                              ),
                            ),
                          ),
                          decoration: const BoxDecoration(color: Color(0XFF0D0C0C)),
                          child: GestureDetector(
                            onTap: isPortrait
                                ? () => showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) => ShowServiceInfo(service),
                                    )
                                : null,
                            child: SizedBox(
                              height: DeviceConstraints.getResponsiveSize(context, 20, 25, 28),
                              width: DeviceConstraints.getResponsiveSize(context, 20, 25, 28),
                              child: Center(
                                child: SvgPicture.asset(
                                  AppIcons.informationSVG,
                                  height: DeviceConstraints.getResponsiveSize(context, 20, 25, 28),
                                  width: DeviceConstraints.getResponsiveSize(context, 20, 25, 28),
                                  color: isAddedSelectedColor(themeType), //  isAdded ? isAddedSelectedColor(themeType) : theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),

              // MASTERS
              if (pickMasters && masters!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Column(
                    children: [
                      const Divider(color: Color(0XFF474747), thickness: 1.5),
                      SizedBox(height: DeviceConstraints.getResponsiveSize(context, 10.h, 5.h, 5.h)),
                      SizedBox(
                        // color: Colors.blue,
                        height: 45.h,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            GestureDetector(
                              onTap: () => _createAppointmentProvider.removeServiceMaster(service, context),
                              child: Container(
                                height: 45.h,
                                decoration: BoxDecoration(
                                  color: (_createAppointmentProvider.serviceAgainstMaster
                                          .where(
                                            (element) => element.service!.serviceId == service.serviceId && element.isRandom!,
                                          )
                                          .toList()
                                          .isNotEmpty)
                                      ? selectMasterContainerColor(themeType, theme)
                                      : Colors.transparent, // theme.primaryColor : Colors.transparent,
                                  borderRadius: BorderRadius.circular(70),

                                  border: Border.all(color: theme.dialogBackgroundColor, width: 1.2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25),
                                  child: Center(
                                    child: Text(
                                      'Anyone',
                                      style: theme.textTheme.bodyLarge!.copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        // color: defaultTheme ? Colors.black : Colors.white,
                                        color: (_createAppointmentProvider.serviceAgainstMaster
                                                .where(
                                                  (element) => element.service!.serviceId == service.serviceId && element.isRandom!,
                                                )
                                                .toList()
                                                .isNotEmpty)
                                            ? selectMasterColor(themeType)
                                            : unSelectedMasterColor(themeType),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              // color: Colors.lightBlueAccent,
                              height: 45.h,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: theMasters.length,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final MasterModel master = theMasters[index];

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () async {
                                          _createAppointmentProvider.addServiceMaster(service, master, context);

                                          if (_createAppointmentProvider.slotsStatus == Status.failed) {
                                            showToast(
                                              '${master.personalInfo?.firstName} is not working',
                                              duration: const Duration(seconds: 5),
                                            );
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: (_createAppointmentProvider.serviceAgainstMaster
                                                    .where(
                                                      (element) => (element.service!.serviceId == service.serviceId) && element.master!.masterId == master.masterId && !element.isRandom!,
                                                    )
                                                    .toList()
                                                    .isNotEmpty)
                                                ? selectMasterContainerColor(themeType, theme)
                                                : Colors.transparent, // ? theme.primaryColor: Colors.transparent,
                                            borderRadius: BorderRadius.circular(70),
                                            // border: (_createAppointmentProvider.serviceAgainstMaster
                                            //         .where(
                                            //           (element) => element.service!.serviceId == service.serviceId && element.master!.masterId == master.masterId && !element.isRandom!,
                                            //         )
                                            //         .toList()
                                            //         .isNotEmpty)
                                            //     ? Border.all(color: Colors.white, width: 1.6)
                                            //     : null, //  ? null : Border.all(color: Colors.white, width: 1.6),
                                            border: Border.all(color: theme.dialogBackgroundColor, width: 1.2),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 3, bottom: 3, right: 20, left: 10),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 30.h,
                                                  width: 30.h,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(100),
                                                    child: (master.profilePicUrl != null && master.profilePicUrl != '')
                                                        ? CachedImage(
                                                            url: master.profilePicUrl!,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.asset(
                                                            AppIcons.masterDefaultAvtar,
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  Utils().getNameMaster(master.personalInfo),
                                                  style: theme.textTheme.bodyLarge!.copyWith(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: (_createAppointmentProvider.serviceAgainstMaster
                                                            .where(
                                                              (element) => element.service!.serviceId == service.serviceId && element.master!.masterId == master.masterId && !element.isRandom!,
                                                            )
                                                            .toList()
                                                            .isNotEmpty)
                                                        ? selectMasterColor(themeType)
                                                        : unSelectedMasterColor(themeType),
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // IF THERE ARE NO AVAILABLE MASTERS
              if (pickMasters && masters!.isEmpty && (_salonProfileProvider.isSingleMaster == false))
                SizedBox(
                  height: 35.h,
                  width: 1.sw,
                  child: Text(
                    '${AppLocalizations.of(context)?.noMastersAvailableOn} ${Time().getDateInStandardFormat(
                      _createAppointmentProvider.chosenDay,
                    )}',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,
                      fontFamily: 'Inter',
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
