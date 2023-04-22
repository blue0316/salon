import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/appointment/serviceAndMaster.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/enums/status.dart';
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

// ORDER LIST
class OrderDetails extends ConsumerStatefulWidget {
  final TabController tabController;

  const OrderDetails({Key? key, required this.tabController}) : super(key: key);

  @override
  ConsumerState<OrderDetails> createState() => _OrderListState();
}

class _OrderListState extends ConsumerState<OrderDetails> {
  bool acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final AuthProvider _auth = ref.watch(authProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = theme == AppTheme.customLightTheme;

    final String _date = Time().getLocaleDate(
      _createAppointmentProvider.appointmentModel!.appointmentStartTime,
      AppLocalizations.of(context)?.localeName ?? 'en',
    );

    final String _time = Time().getAppointmentStartEndTime(
          _createAppointmentProvider.appointmentModel!,
        ) ??
        '';

    bool isSingleMaster = (_salonProfileProvider.chosenSalon.ownerType == OwnerType.singleMaster);
    final List<ServiceModel> singleMasterServiceList = _createAppointmentProvider.chosenServices;
    final List<ServiceAndMaster> notSingleMasterServiceList = _createAppointmentProvider.serviceAgainstMaster;

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                AppLocalizations.of(context)?.orderList ?? 'Order List'.toString(),
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontSize: 20.sp,
                  color: defaultTheme ? Colors.black : Colors.white,
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                height: DeviceConstraints.getResponsiveSize(context, 90.h, 85.h, 85.h),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: isSingleMaster ? singleMasterServiceList.length : notSingleMasterServiceList.length,
                  itemBuilder: (context, index) {
                    final ServiceModel singleMasterService = singleMasterServiceList[index];
                    final ServiceAndMaster notSingleMasterService = notSingleMasterServiceList[index];

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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: DeviceConstraints.getResponsiveSize(context, 85.w, 75.w, 70.w),
                                    child: Text(
                                      isSingleMaster
                                          ? singleMasterService.translations[AppLocalizations.of(
                                                    context,
                                                  )?.localeName ??
                                                  'en']
                                              .toString()
                                          : notSingleMasterService
                                              .service!
                                              .translations[AppLocalizations.of(
                                                    context,
                                                  )?.localeName ??
                                                  'en']
                                              .toString(),
                                      // 'Eyebrow Tinting',
                                      style: theme.textTheme.bodyLarge!.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 16.sp, 16.sp),
                                        color: defaultTheme ? Colors.black : Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: DeviceConstraints.getResponsiveSize(context, 2, 1, 1).toInt(),
                                    ),
                                  ),
                                  Text(
                                    // single master
                                    isSingleMaster
                                        ? singleMasterService.isFixedPrice
                                            ? "${Keys.dollars}${singleMasterService.priceAndDuration.price}"
                                            : singleMasterService.isPriceRange
                                                ? "${Keys.dollars}${singleMasterService.priceAndDuration.price} - ${Keys.dollars}${singleMasterService.priceAndDurationMax!.price}"
                                                : "${Keys.dollars}${singleMasterService.priceAndDuration.price} - ${Keys.dollars}∞"
                                        // not a single master
                                        : notSingleMasterService.service!.isFixedPrice
                                            ? "${Keys.dollars}${notSingleMasterService.service!.priceAndDuration.price}"
                                            : notSingleMasterService.service!.isPriceRange
                                                ? "${Keys.dollars}${notSingleMasterService.service!.priceAndDuration.price} - ${Keys.dollars}${notSingleMasterService.service!.priceAndDurationMax!.price}"
                                                : "${Keys.dollars}${notSingleMasterService.service!.priceAndDuration.price} - ${Keys.dollars}∞",
                                    style: theme.textTheme.bodyLarge!.copyWith(
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

                                  Text(
                                    // single master
                                    isSingleMaster
                                        ? singleMasterService.isFixedDuration != null
                                            ? singleMasterService.isFixedDuration
                                                ? "${singleMasterService.priceAndDuration.duration} minutes"
                                                : "${singleMasterService.priceAndDuration.duration} minutes - ${singleMasterService.priceAndDurationMax!.duration} minutes"
                                            : "${singleMasterService.priceAndDuration.duration} minutes"

                                        // not a single master
                                        : notSingleMasterService.service?.isFixedDuration != null
                                            ? notSingleMasterService.service!.isFixedDuration
                                                ? "${notSingleMasterService.service?.priceAndDuration.duration} minutes"
                                                : "${notSingleMasterService.service?.priceAndDuration.duration} minutes - ${notSingleMasterService.service?.priceAndDurationMax!.duration} minutes"
                                            : "${notSingleMasterService.service!.priceAndDuration.duration} minutes",
                                    style: theme.textTheme.bodyLarge!.copyWith(
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
                AppLocalizations.of(context)?.youChoosed ?? 'You choosed'.toString(),
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: defaultTheme ? Colors.black : Colors.white,
                  fontSize: 20.sp,
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
                        "${AppLocalizations.of(context)?.service ?? 'Service'} :",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontSize: 20.sp,
                          color: defaultTheme ? Colors.black : Colors.white,
                        ),
                      ),
                      Text(
                        '${isSingleMaster ? _createAppointmentProvider.chosenServices.length : _createAppointmentProvider.serviceAgainstMaster.length} ${AppLocalizations.of(
                              context,
                            )?.services ?? 'services'}',
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 20.sp,
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
                        "${AppLocalizations.of(context)?.date ?? 'Date'} :",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontSize: 20.sp,
                          color: defaultTheme ? Colors.black : Colors.white,
                        ),
                      ),
                      Text(
                        _date,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 20.sp,
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
                        "${AppLocalizations.of(context)?.time ?? 'Time'} :",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontSize: 20.sp,
                          color: defaultTheme ? Colors.black : Colors.white,
                        ),
                      ),
                      Text(
                        _time,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 20.sp,
                          color: defaultTheme ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Text(
                "${AppLocalizations.of(context)?.orderSummary ?? 'Order summary'} :",
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontSize: 22.sp,
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
                      Text(
                        "${AppLocalizations.of(context)?.orderAmount ?? 'Order amount'} :",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontSize: 20.sp,
                          color: defaultTheme ? Colors.black : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${Keys.dollars}${_createAppointmentProvider.totalPrice}",
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 20.sp,
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
                        "${AppLocalizations.of(context)?.discounts.toCapitalized() ?? 'Discount'} 15%:",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontSize: 20.sp,
                          color: defaultTheme ? Colors.black : Colors.white,
                        ),
                      ),
                      Text(
                        "-\$00",
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 20.sp,
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
                    AppLocalizations.of(context)?.total ?? 'Total',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: defaultTheme ? Colors.black : theme.primaryColor,
                    ),
                  ),
                  Text(
                    "${Keys.dollars}${_createAppointmentProvider.totalPrice}",
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontSize: 20.sp,
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
                    "${AppLocalizations.of(context)?.registration_line11} *",
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.normal,
                      color: defaultTheme ? Colors.black : Colors.white,
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
                onTap: () async {
                  bool enabledOTP = _salonProfileProvider.themeSettings?.displaySettings?.enableOTP ?? true;

                  if (!acceptTerms) {
                    // Terms Checkbox is unchecked

                    showToast(AppLocalizations.of(context)?.pleaseAgree ?? "Please agree to the terms and conditions");

                    return;
                  }

                  bool success = await _createAppointmentProvider.finishBooking(
                    context: context,
                    customerModel: enabledOTP ? _auth.currentCustomer! : _auth.currentCustomerWithoutOTP!,
                  );

                  if (success) {
                    // Pop current dialog
                    Navigator.of(context).pop();

                    const ConfirmedDialog().show(context);
                  } else {
                    showToast(AppLocalizations.of(context)?.somethingWentWrong ?? "Something went wrong");
                  }

                  //  for (AppointmentModel? app in _createAppointmentProvider.appointmentModelSalonOwner!) {
                  //   print(app!.priceAndDuration.price);
                  // }

                  // CustomerModel customer = CustomerModel(
                  //   customerId: "00iomPh4TKeE1GFGSNqI",
                  //   personalInfo: PersonalInfo(phone: "08123317957", firstName: "Timmy", lastName: "Banjo", email: "timmybanjo@gmail.com"),
                  //   registeredSalons: [],
                  //   createdAt: DateTime.now(),
                  //   avgRating: 3.0,
                  //   noOfRatings: 6,
                  //   profilePicUploaded: false,
                  //   profilePic: "",
                  //   profileCompleted: false,
                  //   quizCompleted: false,
                  //   preferredGender: "male",
                  //   preferredCategories: [],
                  //   locations: [],
                  //   fcmToken: "",
                  //   locale: "en",
                  //   favSalons: [],
                  //   referralLink: "",
                  // );
                  // if (_createAppointmentProvider.chosenSalon!.ownerType == OwnerType.singleMaster) {
                  //   await _createAppointmentProvider.createAppointment(customerModel: customer, context: context);
                  //   bool _success = await _createAppointmentProvider.finishBooking(context: context, customerModel: customer);
                  // } else {
                  //   await _createAppointmentProvider.creatAppointmentSalonOwner(customerModel: customer, context: context);
                  //   bool _success = await _createAppointmentProvider.finishBooking(context: context, customerModel: customer);
                  // }
                  // _createAppointmentProvider.creatAppointmentSalonOwner();
                  // Pop current dialog
                  // Navigator.of(context).pop();

                  // ConfirmedDialogSalonOwner(
                  //   appointment:
                  //       _createAppointmentProvider.appointmentModelSalonOwner!,
                  // ).show(context);
                },
                color: defaultTheme ? Colors.black : theme.primaryColor,
                textColor: defaultTheme ? Colors.white : Colors.black,
                height: 60,
                label: AppLocalizations.of(context)?.book ?? 'Book',
                isLoading: _createAppointmentProvider.loadingStatus == Status.loading,
                loaderColor: defaultTheme ? Colors.white : Colors.black,
              ),
              SizedBox(height: 15.h),
              DefaultButton(
                borderRadius: 60,
                onTap: () {
                  // Back to Day & Time Tab
                  widget.tabController.animateTo(1);

                  // _createAppointmentProvider.nextPageView(2);
                },
                color: defaultTheme ? Colors.white : Colors.transparent,
                borderColor: defaultTheme ? Colors.black : theme.primaryColor,
                textColor: defaultTheme ? Colors.black : theme.primaryColor,
                height: 60,
                label: AppLocalizations.of(context)?.back ?? 'Back',
              ),
            ],
          ),
        ),
        // SizedBox(height: 20.h),
      ],
    );
  }
}
