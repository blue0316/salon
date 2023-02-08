// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/enums/appointment_status.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/calendar/calender_dialogues.dart';
import 'package:bbblient/src/views/registration/authenticate/login.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/dialogues/dialogue_function.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

class ConfirmBooking extends ConsumerStatefulWidget {
  static const route = "/confirmBooking";
  final AppointmentModel appointment;
  const ConfirmBooking({required this.appointment, Key? key}) : super(key: key);

  @override
  _ConfirmBookingState createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends ConsumerState<ConfirmBooking> {
  bool acceptTerms = false;
  @override
  Widget build(BuildContext context) {
    final _auth = ref.watch(authProvider);
    final _createAppointment = ref.watch(createAppointmentProvider);
    AppointmentModel appointment = widget.appointment;
    final AppProvider _appProvider = ref.read(appProvider);
    final String _date = Time().getLocaleDate(
      appointment.appointmentStartTime,
      AppLocalizations.of(context)?.localeName ?? 'en',
    );
    final String _time = Time().getAppointmentStartEndTime(appointment)!;
    const UnderlineInputBorder border = UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppTheme.lightBlack,
        width: 2,
      ),
    );
    final _authProvider = ref.watch(authProvider);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.green,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              ConstrainedContainer(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                  //radius: 15,
                                  // padding: const EdgeInsets.all(8),
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(color: const Color(0xffF4F4F4), borderRadius: BorderRadius.circular(20)),
                                  child: const Center(child: Icon(Icons.arrow_back_ios, size: 10))),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)?.checkAppointmentDetails ?? "Appointment details",
                            style: AppTheme.bodyText1,
                          ),
                          const SizedBox(width: 50),
                          const CancelButtonTopRight(),
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0xffEFEFEF), // shadow color
                                    blurRadius: 2, // shadow radius
                                    offset: Offset(2, 5), // shadow offset
                                    spreadRadius: 0.1, // The amount the box should be inflated prior to applying the blur
                                    blurStyle: BlurStyle.normal // set blur style
                                    ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 44.h,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.lightBlack,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _date,
                                          style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 16, color: Colors.white),
                                        ),
                                        Text(
                                          _time,
                                          style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Space(
                                  height: 12.h,
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 27.sp,
                                            backgroundColor: AppTheme.creamBrownLight,
                                            child: Padding(
                                              padding: EdgeInsets.all(16.r),
                                              child: SvgPicture.asset(
                                                AppIcons.getIconFromCategoryId(
                                                  id: appointment.services.first.categoryId,
                                                ),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 16.0.w),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  for (Service s in appointment.services)
                                                    Text(
                                                      s.translations[AppLocalizations.of(context)?.localeName ?? 'en'],
                                                      style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.textBlack),
                                                      maxLines: 1,
                                                    ),
                                                  Text(
                                                    "${AppLocalizations.of(context)?.services ?? "services"} (${appointment.services.length})",
                                                    style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            radius: 27.sp,
                                            backgroundColor: AppTheme.creamBrownLight,
                                            child: Padding(
                                              padding: EdgeInsets.all(16.r),
                                              child: SvgPicture.asset(AppIcons.priceTagSVG),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 16.0.w),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${appointment.priceAndDuration.price} ${Keys.uah}",
                                                    style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.textBlack),
                                                    maxLines: 1,
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(context)?.price ?? "Price",
                                                    style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    if (appointment.salonOwnerType == OwnerType.salon) ...[
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 27.sp,
                                              backgroundColor: AppTheme.creamBrownLight,
                                              child: Padding(
                                                padding: EdgeInsets.all(16.r),
                                                child: SvgPicture.asset(AppIcons.homeSVG),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 16.0.w),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      appointment.salon.name,
                                                      style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.textBlack),
                                                      maxLines: 1,
                                                    ),
                                                    Text(
                                                      AppLocalizations.of(context)?.salon ?? "Salon",
                                                      style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 27.sp,
                                              backgroundColor: AppTheme.creamBrownLight,
                                              child: Center(
                                                child: Padding(
                                                    padding: EdgeInsets.all(10.r),
                                                    child: const Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 16.0.w),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      appointment.master?.name ?? '',
                                                      style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.textBlack),
                                                    ),
                                                    Text(
                                                      AppLocalizations.of(context)?.master ?? "Master",
                                                      style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                    if (appointment.salonOwnerType == OwnerType.singleMaster) ...[
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 27.sp,
                                              backgroundColor: AppTheme.creamBrownLight,
                                              child: Center(
                                                child: Padding(
                                                    padding: EdgeInsets.all(10.r),
                                                    child: const Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 16.0.w),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      appointment.salon.name,
                                                      style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.textBlack),
                                                    ),
                                                    Text(
                                                      AppLocalizations.of(context)?.master ?? "Master",
                                                      style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 27.sp,
                                            backgroundColor: AppTheme.creamBrownLight,
                                            child: Padding(
                                              padding: EdgeInsets.all(17.r),
                                              child: SvgPicture.asset(AppIcons.locationMarkerWhiteSVG),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 16.0.w),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _createAppointment.chosenSalon?.address ?? '',
                                                    style: Theme.of(context).textTheme.headline4!.copyWith(color: AppTheme.textBlack),
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(context)?.address ?? "Address",
                                                    style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Gap(48.h),
                      Visibility(
                        visible: !_auth.userLoggedIn,
                        child: Padding(
                          padding: EdgeInsets.only(left: 32.0.w, right: 32.w),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), shape: BoxShape.rectangle, boxShadow: const [
                              BoxShadow(
                                  color: Color(0xffF0F0F0), // shadow color
                                  blurRadius: 2, // shadow radius
                                  offset: Offset(2, 5), // shadow offset
                                  spreadRadius: 0.1, // The amount the box should be inflated prior to applying the blur
                                  blurStyle: BlurStyle.normal // set blur style
                                  ),
                            ]),
                            //  height: 60.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 58.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                    //   shape: BoxShape.rectangle
                                    // color: AppTheme.coolGrey,
                                  ),
                                  child: CountryCodePicker(
                                    padding: const EdgeInsets.all(2),
                                    onChanged: (val) {
                                      _auth.countryCode = val.dialCode ?? '';
                                      printIt(_auth.countryCode);
                                    },
                                    onInit: (val) {
                                      _auth.countryCode = val?.dialCode ?? '';
                                      printIt(_auth.countryCode);
                                    },
                                    initialSelection: 'UA',
                                    favorite: const ['+380', 'Uk'],
                                    showCountryOnly: false,
                                    showOnlyCountryWhenClosed: false,
                                    alignLeft: false,
                                    textStyle: const TextStyle(color: Colors.black),
                                    showFlag: false,
                                  ),
                                ),
                                Container(height: 28.h, color: AppTheme.divider2, width: 1),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    // key: ,
                                    controller: _auth.phoneNoController,
                                    autofocus: false,
                                    onChanged: (val) {
                                      _auth.phoneNumber = val;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: border,
                                      //enabledBorder:  border,
                                      focusedBorder: InputBorder.none,
                                      hintText: '(123) 456 - 7890',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Gap(20.h),
                      Visibility(
                        visible: !_auth.userLoggedIn,
                        child: Padding(
                          padding: EdgeInsets.only(left: 32.0.w),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Checkbox(
                                  value: acceptTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      acceptTerms = !acceptTerms;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 11,
                                child: InkWell(
                                    onTap: () async {
                                      Uri uri = Uri.parse("https://bowandbeautiful.com/privacy");
                                      debugPrint("launchingUrl: $uri");
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri);
                                      }
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)?.read_privacy_policy ?? 'I have read and accept privacy policy',
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w400,
                                          wordSpacing: 1,
                                          fontSize: 13,
                                          // height: 2.h,
                                          color: AppTheme.grey1),
                                    )
                                    //  Text.rich(
                                    //   TextSpan(
                                    //     children: [
                                    //       TextSpan(
                                    //         text: tr(Keys.read_privacy_policy),
                                    //         style: TextStyle(
                                    //             fontFamily: "Montserrat",
                                    //             fontWeight: FontWeight.w400,
                                    //             wordSpacing: 1,
                                    //             fontSize: 11,
                                    //             height: 2.h,
                                    //             color: AppTheme.grey1),
                                    //       ),
                                    //     ],
                                    //     // textAlign: TextAlign.center,
                                    //   ),
                                    //   textAlign: TextAlign.left,
                                    // ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gap(102.h),
                      ElevatedButton(
                        onPressed: () async {
                          // if(!_auth.userLoggedIn){

                          // }
                          if (!_auth.userLoggedIn && _auth.phoneNoController.text.isEmpty) {
                            showToast(AppLocalizations.of(context)?.invalid_phone_number ?? 'Input phone No');
                            return;
                          }
                          if (!_auth.userLoggedIn && (_auth.phoneNumber.length < 8 || _auth.phoneNumber.length > 10)) {
                            showToast(AppLocalizations.of(context)?.invalid_phone_number ?? 'Invalid phone No');
                            return;
                          }
                          if (!_auth.userLoggedIn && !acceptTerms) {
                            showToast(
                              AppLocalizations.of(context)?.privacy_policy_accept ?? 'I have read and accepted privacy policy',
                            );
                            return;
                          }
                          if (!_auth.userLoggedIn) {
                            await _auth.verifyPhoneNumber(context: context);
                            showTopSnackBar(
                              context,
                              CustomSnackBar.success(
                                message: AppLocalizations.of(context)?.otpSent ?? "Otp has been sent to your phone",
                                backgroundColor: AppTheme.creamBrown,
                              ),
                            );
                            checkUser(context, ref, () {
                              //_auth.createAppointmentProvider(_createAppointment);
                              // _createAppointment.createAppointment(
                              //     customerModel: _auth.currentCustomer!,
                              //     context: context);
                            }, appointmentModel: appointment);
                          } else {
                            showToast(AppLocalizations.of(context)?.pleaseWait ?? "Please wait");
                            bool moveAhead = _createAppointment.checkSlotsAndMaster(context: context);
                            checkUser(context, ref, () async {
                              if (moveAhead) {
                                _auth.createAppointmentProvider(_createAppointment);
                                _createAppointment.createAppointment(customerModel: _auth.currentCustomer!, context: context);
                                bool _success = await _createAppointment.finishBooking(context: context, customerModel: _authProvider.currentCustomer!);

                                if (_success) {
                                  setState(() {
                                    // _status = Status.success;
                                  });
                                  showMyDialog(
                                    context: context,
                                    child: SizedBox(
                                      height: 300.h,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)?.success ?? "Success",
                                            style: AppTheme.appointmentSubtitle,
                                          ),
                                          const Gap(10),
                                          SizedBox(height: 150.h, width: 150.w, child: Image.asset(AppIcons.bookingConfirmedPNG)),
                                          const Gap(10),
                                          Text(
                                            (_createAppointment.appointmentModel?.status ?? "") == AppointmentStatus.requested ? AppLocalizations.of(context)?.requestConfirmed ?? "Request Confirmed" : AppLocalizations.of(context)?.bookingConfirmed ?? "Your booking has been confirmed",
                                            textAlign: TextAlign.center,
                                            style: AppTheme.appointmentTitleStyle,
                                          ),
                                          const Gap(15),
                                          BnbMaterialButton(
                                            key: const Key("great-key"),
                                            onTap: () {
                                              // print(object)
                                              if (_appProvider.firstRoute != null) {
                                                printIt("Going back to : ${_appProvider.firstRoute}");
                                                // context.pop();
                                                // context.push(
                                                //     '${NavigatorPage.redirect}${_appProvider.firstRoute!}');
                                                html.window.open("https://bowandbeautiful.com${_appProvider.firstRoute}", "_self");
                                              } else {
                                                Navigator.of(context).popUntil((Route<dynamic> route) => route.isFirst);
                                              }
                                            },
                                            title: AppLocalizations.of(context)?.great ?? 'Great',
                                            minWidth: 150.w,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                // print('falseeeee');
                              }
                            }, appointmentModel: appointment);
                          }

                          // _auth.changeFromBooking();
                        },
                        child: (_auth.otpStatus == Status.loading) || _createAppointment.loadingStatus == Status.loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppTheme.white,
                                  ),
                                ))
                            : Text(
                                !_auth.userLoggedIn ? AppLocalizations.of(context)?.continue_word ?? 'Continue' : AppLocalizations.of(context)?.confirm ?? 'Confirm',
                                style: AppTheme.calTextStyle,
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.lightBlack,
                          fixedSize: const Size(311, 48),
                        ),
                      ),
                      Gap(24.h),
                    ],
                  ),
                ),
              ),
              // Positioned(
              //   bottom: 0,
              //   child: SizedBox(
              //     height: 60.h,
              //     width: 1.sw,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Flexible(
              //           flex: 1,
              //           child: Center(
              //             child: TextButton(
              //               onPressed: () {
              //                 Navigator.pop(context);
              //               },
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: [
              //                   const Icon(
              //                     Icons.arrow_back,
              //                     color: AppTheme.black,
              //                   ),
              //                   const SizedBox(
              //                     width: 8,
              //                   ),
              //                   Text(
              //                     AppLocalizations.of(context)?.change ??
              //                         "Change",
              //                     style: const TextStyle(
              //                       color: AppTheme.black,
              //                       fontFamily: 'Montserrat',
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //         Flexible(
              //           flex: 1,
              //           child: GestureDetector(
              //             key: const Key("confirm-key"),
              //             onTap: () async {
              //               // check
              //               //  _createAppointment.createAppointment(
              //               //           customerModel: _auth.currentCustomer!,
              //               //           context: context);
              //               _auth.changeFromBooking();
              //               _auth.createAppointmentProvider(_createAppointment);
              //               bool moveAhead = _createAppointment
              //                   .checkSlotsAndMaster(context: context);
              //               printIt("it will check");
              //               printIt(moveAhead);
              //               if (moveAhead) {
              //                 _auth.changeFromBooking();
              //                 checkUser(context, ref, () {
              //                   _createAppointment.createAppointment(
              //                       customerModel: _auth.currentCustomer!,
              //                       context: context);
              //                   Navigator.of(context).push(MaterialPageRoute(
              //                       builder: (_) =>
              //                           const PaymentBonusConfirmation()));
              //                 });
              //               }
              //               //         checkUser(context, ref, () {
              //               //   _createAppointment.createAppointment(
              //               //       customerModel: _auth.currentCustomer!,
              //               //       context: context);
              //               //    Navigator.of(context).push(MaterialPageRoute(
              //               //   builder: (_) => const PaymentBonusConfirmation()));
              //               // });
              //             },
              //             child: Container(
              //               decoration: const BoxDecoration(
              //                 color: AppTheme.creamBrown,
              //                 borderRadius: BorderRadius.only(
              //                   topLeft: Radius.circular(28),
              //                 ),
              //               ),
              //               child: Center(
              //                 child: Text(
              //                   AppLocalizations.of(context)?.confirm ??
              //                       "Confirm",
              //                   style: Theme.of(context)
              //                       .textTheme
              //                       .subtitle1!
              //                       .copyWith(color: Colors.white),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
