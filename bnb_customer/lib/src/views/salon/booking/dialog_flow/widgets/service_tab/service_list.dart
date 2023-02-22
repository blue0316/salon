import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/views/salon/widgets/service_expension_tile.dart';
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

  const ServiceList({Key? key, required this.services}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final _salonSearchProvider = ref.watch(salonSearchProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = (theme == AppTheme.lightTheme);

    return ListView.builder(
      itemCount: services.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final ServiceModel service = services[index];

        Color selectedColor = defaultTheme ? const Color.fromARGB(255, 239, 239, 239) : const Color(0XFF202020);
        BoxBorder? border = defaultTheme ? Border.all(width: 1.5, color: const Color.fromARGB(255, 239, 239, 239)) : Border.all(width: 2, color: const Color(0XFF202020));
        bool isAdded = _createAppointmentProvider.isAdded(serviceModel: service);
        return GestureDetector(
          onTap: () {
            _createAppointmentProvider.toggleService(
              serviceModel: service,
              clearChosenMaster: false,
              context: context,
            );
          },
          child: Padding(
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
                        vertical: 20,
                        horizontal: DeviceConstraints.getResponsiveSize(context, 15.w, 20.w, 20.w),
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
                                    fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 25.sp, 30.sp),
                                    color: defaultTheme ? AppTheme.textBlack : Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              const Spacer(),
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
                                      fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 25.sp, 30.sp),
                                      color: defaultTheme ? AppTheme.textBlack : Colors.white,
                                    ),
                                overflow: TextOverflow.visible,
                                maxLines: 1,
                              ),
                            ],
                          ),
                          SizedBox(height: 25.h),

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
                                                fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 20.sp, 25.sp),
                                                color: defaultTheme ? AppTheme.textBlack : Colors.white,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        )
                                      : Text(
                                          "${service.priceAndDuration.duration} minutes - ${service.priceAndDurationMax!.duration} minutes",
                                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 20.sp, 25.sp),
                                                color: defaultTheme ? AppTheme.textBlack : Colors.white,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        )
                                  : Text(
                                      "${service.priceAndDuration.duration} minutes",
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                            fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 20.sp, 25.sp),
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
                                            color: defaultTheme ? AppTheme.textBlack : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  // top: -2.h,
                  child: Container(
                    // height: 30.h,
                    // width: 100,
                    decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: Center(
                        child: Text(
                          '5 %',
                          style: theme.textTheme.bodyText1!.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
