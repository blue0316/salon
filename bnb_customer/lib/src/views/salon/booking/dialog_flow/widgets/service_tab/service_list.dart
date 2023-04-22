import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/widgets/service_expension_tile.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServiceList extends ConsumerWidget {
  final List<ServiceModel> services;
  final bool pickMasters;

  const ServiceList({Key? key, required this.services, this.pickMasters = false}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final SalonProfileProvider _salonProfileProvider =
    //     ref.watch(salonProfileProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    // final _salonSearchProvider = ref.watch(salonSearchProvider);
    // final ThemeData theme = _salonProfileProvider.salonTheme;

    return ListView.builder(
      itemCount: services.length,
      shrinkWrap: true,
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

  const ServiceCard({
    Key? key,
    required this.isAdded,
    required this.service,
    this.pickMasters = false,
    this.pickMasterOnTap,
    this.masters,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = (theme == AppTheme.customLightTheme);
    List<MasterModel> theMasters = _createAppointmentProvider.getMasterProvidingService(service);

    Color selectedColor = defaultTheme ? const Color.fromARGB(255, 239, 239, 239) : const Color(0XFF202020);
    BoxBorder? border = defaultTheme
        ? Border.all(
            width: 1.5,
            color: const Color.fromARGB(255, 239, 239, 239),
          )
        : Border.all(
            width: 2,
            color: const Color(0XFF202020), //theme.highlightColor, //
          );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              decoration: BoxDecoration(
                color: isAdded ? selectedColor : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: isAdded ? null : border,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15,
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
                            service.translations[AppLocalizations.of(context)?.localeName ?? 'en'].toString(), // 'Eyebrow Tinting',
                            style: AppTheme.bodyText1.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                              color: defaultTheme ? AppTheme.textBlack : Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        const Spacer(),

                        // Discount ?
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       service.isFixedPrice
                        //           ? "${Keys.dollars}${service.priceAndDuration.price}"
                        //           : service.isPriceRange
                        //               ? "${Keys.dollars}${service.priceAndDuration.price} - ${Keys.dollars}${service.priceAndDurationMax!.price}"
                        //               : "${Keys.dollars}${service.priceAndDuration.price} - ${Keys.dollars}∞",
                        //       style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        //             fontWeight: FontWeight.w500,
                        //             fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 25.sp, 30.sp),
                        //             color: Colors.red,
                        //           ),
                        //       overflow: TextOverflow.visible,
                        //       maxLines: 1,
                        //     ),
                        //     const SizedBox(height: 5),
                        //     Text(
                        //       service.isFixedPrice
                        //           ? "${Keys.dollars}${service.priceAndDuration.price}"
                        //           : service.isPriceRange
                        //               ? "${Keys.dollars}${service.priceAndDuration.price} - ${Keys.dollars}${service.priceAndDurationMax!.price}"
                        //               : "${Keys.dollars}${service.priceAndDuration.price} - ${Keys.dollars}∞",
                        //       style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        //             fontWeight: FontWeight.w500,
                        //             fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 20.sp, 25.sp),
                        //             color: defaultTheme ? AppTheme.textBlack : Colors.white,
                        //             decoration: TextDecoration.lineThrough,
                        //           ),
                        //       overflow: TextOverflow.visible,
                        //       maxLines: 1,
                        //     ),
                        //   ],
                        // ),
                        Text(
                          service.isFixedPrice
                              ? "${Keys.dollars}${service.priceAndDuration.price}"
                              : service.isPriceRange
                                  ? "${Keys.dollars}${service.priceAndDuration.price} - ${Keys.dollars}${service.priceAndDurationMax!.price}"
                                  : "${Keys.dollars}${service.priceAndDuration.price} - ${Keys.dollars}∞",
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                                color: defaultTheme ? AppTheme.textBlack : Colors.white,
                              ),
                          overflow: TextOverflow.visible,
                          maxLines: 1,
                        ),
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
                            child: SvgPicture.asset(
                              AppIcons.clockSVG,
                              color: defaultTheme ? AppTheme.textBlack : Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        (service.isFixedDuration != null)
                            ? service.isFixedDuration
                                ? Text(
                                    "${service.priceAndDuration.duration} minutes",
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                          fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 20.sp, 20.sp),
                                          color: defaultTheme ? AppTheme.textBlack : Colors.white,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  )
                                : Text(
                                    "${service.priceAndDuration.duration} minutes - ${service.priceAndDurationMax!.duration} minutes",
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                          fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 20.sp, 20.sp),
                                          color: defaultTheme ? AppTheme.textBlack : Colors.white,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  )
                            : Text(
                                "${service.priceAndDuration.duration} minutes",
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 20.sp, 20.sp),
                                      color: defaultTheme ? AppTheme.textBlack : Colors.white,
                                    ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                        const Spacer(),
                        (service.description == null || service.description == "")
                            ? const SizedBox(width: 15)
                            : GestureDetector(
                                onTap: () => showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) => ShowServiceInfo(service),
                                ),
                                child: SizedBox(
                                  height: DeviceConstraints.getResponsiveSize(context, 20, 25, 28),
                                  width: DeviceConstraints.getResponsiveSize(context, 20, 25, 28),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      AppIcons.informationSVG,
                                      height: DeviceConstraints.getResponsiveSize(context, 20, 25, 28),
                                      width: DeviceConstraints.getResponsiveSize(context, 20, 25, 28),
                                      color: defaultTheme ? AppTheme.textBlack : theme.primaryColor,
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
                                        color: (_createAppointmentProvider.serviceAgainstMaster.where((element) => element.service!.serviceId == service.serviceId && element.isRandom!).toList().isNotEmpty) ? theme.primaryColor : Colors.transparent,
                                        borderRadius: BorderRadius.circular(70),
                                        border: (_createAppointmentProvider.serviceAgainstMaster.where((element) => element.service!.serviceId == service.serviceId && element.isRandom!).toList().isNotEmpty) ? null : Border.all(color: Colors.white, width: 1.6),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 25),
                                        child: Center(
                                          child: Text(
                                            'Anyone',
                                            style: theme.textTheme.bodyText1!.copyWith(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: defaultTheme ? Colors.black : Colors.white,
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

                                                // printIt(
                                                //     ' -------- Master selected -------- ');

                                                // String res =
                                                //     await _createAppointmentProvider
                                                //         .chooseMaster(
                                                //   masterModel: master,
                                                //   context: context,
                                                // );

                                                // if (res == "choosen") {
                                                //   showToast(AppLocalizations.of(
                                                //               context)
                                                //           ?.selected ??
                                                //       "selected");
                                                // } else {
                                                //   showToast(AppLocalizations.of(
                                                //               context)
                                                //           ?.notAvailable ??
                                                //       "not available");
                                                // }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: (_createAppointmentProvider.serviceAgainstMaster.where((element) => (element.service!.serviceId == service.serviceId) && element.master!.masterId == master.masterId && !element.isRandom!).toList().isNotEmpty) ? theme.primaryColor : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(70),
                                                  border: (_createAppointmentProvider.serviceAgainstMaster.where((element) => element.service!.serviceId == service.serviceId && element.master!.masterId == master.masterId && !element.isRandom!).toList().isNotEmpty) ? null : Border.all(color: Colors.white, width: 1.6),
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
                                                        style: theme.textTheme.bodyText1!.copyWith(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.bold,
                                                          color: (_createAppointmentProvider.serviceAgainstMaster
                                                                  .where(
                                                                    (element) => element.service!.serviceId == service.serviceId && element.master!.masterId == master.masterId && !element.isRandom!,
                                                                  )
                                                                  .toList()
                                                                  .isNotEmpty)
                                                              ? Colors.black
                                                              : defaultTheme
                                                                  ? Colors.black
                                                                  : Colors.white,
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
                    if (pickMasters && masters!.isEmpty && (_salonProfileProvider.chosenSalon.ownerType != OwnerType.singleMaster))
                      SizedBox(
                        height: 35.h,
                        width: 1.sw,
                        child: Text(
                          '${AppLocalizations.of(context)?.noMastersAvailableOn} ${Time().getDateInStandardFormat(
                            _createAppointmentProvider.chosenDay,
                          )}',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: defaultTheme ? AppTheme.textBlack : Colors.white,
                              ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
