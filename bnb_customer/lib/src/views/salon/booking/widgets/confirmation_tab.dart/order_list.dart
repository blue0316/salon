import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/views/salon/booking/widgets/confirmation_tab.dart/confirmed_dialog.dart';
import 'package:bbblient/src/views/salon/booking/widgets/confirmation_tab.dart/widgets.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderList extends ConsumerStatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  ConsumerState<OrderList> createState() => _OrderListState();
}

class _OrderListState extends ConsumerState<OrderList> {
  bool acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    final CreateAppointmentProvider appointment = ref.watch(createAppointmentProvider);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = theme == AppTheme.lightTheme;

    final String _date = Time().getLocaleDate(
      appointment.appointmentModel!.appointmentStartTime,
      AppLocalizations.of(context)?.localeName ?? 'en',
    );

    final String _time = Time().getAppointmentStartEndTime(
          appointment.appointmentModel!,
        ) ??
        '';

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                "Order List",
                style: AppTheme.bodyText1.copyWith(
                  fontSize: 20.sp,
                  color: defaultTheme ? Colors.black : Colors.white,
                ),
              ),
              SizedBox(height: 10.h),
              // Text(
              //   "${AppLocalizations.of(context)?.services ?? "services"} (${appointment.appointmentModel!.services.length})",
              //   style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14),
              // ),
              // Container(
              //   height: 200,
              //   width: 200,
              //   color: Colors.green,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: 3,
              //     itemBuilder: (context, i) {
              //       return Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Container(
              //           height: 50,
              //           width: 100,
              //           color: Colors.brown,
              //         ),
              //       );
              //     },
              //   ),
              // ),
              SizedBox(
                width: double.infinity,
                height: DeviceConstraints.getResponsiveSize(context, 90.h, 85.h, 85.h),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: appointment.appointmentModel!.services.length,
                  itemBuilder: (context, index) {
                    final service = appointment.appointmentModel!.services[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.h),
                      child: Container(
                        width: DeviceConstraints.getResponsiveSize(context, 175.w, 160.w, 105.w),
                        decoration: BoxDecoration(
                          color: defaultTheme ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1.5,
                            color: defaultTheme ? Colors.black : theme.primaryColor,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: DeviceConstraints.getResponsiveSize(context, 10, 15, 25),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // -- SERVICE TITLE AND PRICE
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: DeviceConstraints.getResponsiveSize(context, 85.w, 75.w, 70.w),
                                    child: Text(
                                      service.translations[AppLocalizations.of(context)?.localeName ?? 'en'].toString(), // 'Eyebrow Tinting',
                                      style: AppTheme.bodyText1.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 16.sp, 16.sp),
                                        color: defaultTheme ? Colors.black : Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: DeviceConstraints.getResponsiveSize(context, 2, 1, 1).toInt(),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${Keys.dollars}${service.priceAndDuration.price}",
                                    // service.isFixedPrice ? "${Keys.dollars}${service.priceAndDuration.price}" : "${Keys.dollars}${service.priceAndDuration.price} - ${Keys.dollars}${service.priceAndDurationMax!.price}",
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                          color: defaultTheme ? Colors.black : Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 16.sp, 16.sp),
                                        ),
                                    overflow: TextOverflow.visible,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              SizedBox(height: 7.h),

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
                                        color: defaultTheme ? Colors.black : theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  // service.isFixedPrice
                                  //     ? Text(
                                  //         "${service.priceAndDuration.duration} minutes",
                                  //         style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.sp),
                                  //         overflow: TextOverflow.ellipsis,
                                  //         maxLines: 1,
                                  //       )
                                  //     :
                                  Text(
                                    "${service.priceAndDuration.duration} minutes",
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                          fontSize: 14.sp,
                                          color: defaultTheme ? Colors.black : Colors.white,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  // const Spacer(),
                                  // (service.description == null || service.description == "")
                                  //     ? const SizedBox(width: 15)
                                  //     : GestureDetector(
                                  //         onTap: () => showDialog<bool>(
                                  //           context: context,
                                  //           builder: (BuildContext context) => ShowServiceInfo(service),
                                  //         ),
                                  //         child: SizedBox(
                                  //           height: DeviceConstraints.getResponsiveSize(context, 12, 18, 18),
                                  //           width: DeviceConstraints.getResponsiveSize(context, 12, 18, 18),
                                  //           child: Center(
                                  //             child: SvgPicture.asset(
                                  //               AppIcons.informationSVG,
                                  //               height: DeviceConstraints.getResponsiveSize(context, 12, 18, 18),
                                  //               width: DeviceConstraints.getResponsiveSize(context, 12, 18, 18),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Space(factor: DeviceConstraints.getResponsiveSize(context, 1, 0.3, 0.3).toDouble()),
              const Divider(
                color: Color.fromARGB(71, 137, 149, 159),
                thickness: 1,
              ),
              Space(factor: DeviceConstraints.getResponsiveSize(context, 1, 0.3, 0.3).toDouble()),
              Text(
                "You choosed:",
                style: AppTheme.bodyText1.copyWith(
                  color: defaultTheme ? Colors.black : Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Service:",
                        style: AppTheme.bodyText1.copyWith(
                          color: defaultTheme ? Colors.black : Colors.white,
                        ),
                      ),
                      Text(
                        "${appointment.appointmentModel!.services.length} ${AppLocalizations.of(context)?.services.toCapitalized() ?? "services"}",
                        style: AppTheme.bodyText2.copyWith(
                          fontSize: 15.sp,
                          color: defaultTheme ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date:",
                        style: AppTheme.bodyText1.copyWith(
                          color: defaultTheme ? Colors.black : Colors.white,
                        ),
                      ),
                      Text(
                        _date,
                        style: AppTheme.bodyText2.copyWith(
                          fontSize: 15.sp,
                          color: defaultTheme ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Time:",
                        style: AppTheme.bodyText1.copyWith(
                          color: defaultTheme ? Colors.black : Colors.white,
                        ),
                      ),
                      Text(
                        _time,
                        style: AppTheme.bodyText2.copyWith(
                          fontSize: 15.sp,
                          color: defaultTheme ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Text(
                "Order summary:",
                style: AppTheme.bodyText1.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: defaultTheme ? Colors.black : Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Order amount:",
                          style: AppTheme.bodyText1.copyWith(
                            color: defaultTheme ? Colors.black : Colors.white,
                          )),
                      const SizedBox(height: 2),
                      Text(

                        "${appointment.appointmentModel!.priceAndDuration.price} ${Keys.uah}",
                        style: AppTheme.bodyText2.copyWith(
                          fontSize: 15.sp,
                          color: defaultTheme ? Colors.black : Colors.white,
                        )),

                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Discount 15%:",
                          style: AppTheme.bodyText1.copyWith(
                            color: defaultTheme ? Colors.black : Colors.white,
                          )),
                      Text(
                        "-\$00",
                        style: AppTheme.bodyText2.copyWith(
                          fontSize: 15.sp,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Space(factor: DeviceConstraints.getResponsiveSize(context, 1, 0.3, 0.3).toDouble()),
              const Divider(
                color: Color.fromARGB(71, 137, 149, 159),
                thickness: 1,
              ),
              Space(factor: DeviceConstraints.getResponsiveSize(context, 1, 0.3, 0.3).toDouble()),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total:",
                    style: AppTheme.bodyText1.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: defaultTheme ? Colors.black : theme.primaryColor,
                    ),
                  ),
                  Text(
                    "${Keys.dollars}${appointment.appointmentModel!.priceAndDuration.price}",
                    style: AppTheme.bodyText1.copyWith(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: defaultTheme ? Colors.black : theme.primaryColor,
                    ),
                  ),
                ],
              ),
              const Space(factor: 1),
              Container(
                // height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: defaultTheme ? Colors.grey[100] : const Color(0XFF202020),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  child: TermsOfServiceText(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: defaultTheme ? Colors.black : Colors.white,
                    ),
                    child: Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.all(theme.primaryColor),
                      value: acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          acceptTerms = !acceptTerms;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${AppLocalizations.of(context)?.registration_line11}*",
                    style: AppTheme.headLine1.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.normal,
                      color: defaultTheme ? AppTheme.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        Expanded(
          flex: 0,
          child: Column(
            children: [
              DefaultButton(
                borderRadius: 60,
                onTap: () {
                  if (!acceptTerms) {
                    // Terms Checkbox is unchecked
                    showToast("Please agree to the terms and conditions");
                    return;
                  }

                  // Pop current dialog
                  Navigator.of(context).pop();

                  ConfirmedDialog(
                    appointment: appointment.appointmentModel!,
                  ).show(context);
                },
                color: defaultTheme ? Colors.black : theme.primaryColor,
                textColor: defaultTheme ? Colors.white : Colors.black,
                height: 60,
                label: 'Book',
              ),
              SizedBox(height: 15.h),
              DefaultButton(
                borderRadius: 60,
                onTap: () => appointment.nextPageView(1),
                color: defaultTheme ? Colors.white : Colors.transparent,
                borderColor: defaultTheme ? Colors.black : theme.primaryColor,
                textColor: defaultTheme ? Colors.black : theme.primaryColor,
                height: 60,
                label: 'Back',
              ),
            ],
          ),
        ),
        // SizedBox(height: 20.h),
      ],
    );
  }
}
