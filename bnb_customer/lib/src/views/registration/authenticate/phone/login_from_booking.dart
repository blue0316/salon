import 'package:bbblient/main.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/controller/appointment/apointment_provider.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/controller/home/salon_search_provider.dart';
import 'package:bbblient/src/firebase/dynamic_link.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/enums/appointment_status.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/registration/authenticate/phone/otp.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/dialogues/dialogue_function.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'dart:html' as html;

class LoginFromBooking extends ConsumerStatefulWidget {
  final AppointmentModel? appointment;
  const LoginFromBooking({Key? key, this.appointment}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Login2State();
}

class _Login2State extends ConsumerState<LoginFromBooking> {
  late AuthProvider _auth;
  final UnderlineInputBorder border = const UnderlineInputBorder(
    borderSide: BorderSide(
      color: AppTheme.lightGrey2,
    ),
  );
  @override
  void dispose() {
    super.dispose();
    _auth.disposeFields();
  }

  refreshAccount() async {
    BnbProvider _bnbProvider = ref.read(bnbProvider);

    SalonSearchProvider _salonSearchProvider = ref.read(salonSearchProvider);

    AppointmentProvider _appointmentProvider = ref.read(appointmentProvider);

    await _auth.getUserInfo(context: context);

    //await _salonSearchProvider.initialize();
    await _bnbProvider.initializeApp(
        customerModel: _auth.currentCustomer, lang: _bnbProvider.getLocale);

    if (_auth.userLoggedIn) {
      await DynamicLinksApi().handleDynamicLink(
          context: context, bonusSettings: _bnbProvider.bonusSettings);

      await _appointmentProvider.loadAppointments(
        customerId: _auth.currentCustomer?.customerId ?? '',
        salonSearchProvider: _salonSearchProvider,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider = ref.watch(authProvider);
    final AppProvider _appProvider = ref.read(appProvider);
    _auth = ref.watch(authProvider);
    AppointmentModel? appointment = widget.appointment;
    final _createAppointment = ref.watch(createAppointmentProvider);
    final String _date = Time().getLocaleDate(
      appointment!.appointmentStartTime,
      AppLocalizations.of(context)?.localeName ?? 'en',
    );
    final String _time = Time().getAppointmentStartEndTime(appointment)!;
    return Scaffold(
        backgroundColor: AppTheme.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(57.h),
              Center(child: Image.asset(AppIcons.appLogo)
                  //     SvgPicture.asset(
                  //   AppIcons.appLogo,
                  //   cacheColorFilter: true,
                  //   color: AppTheme.btnColor,
                  //   currentColor: AppTheme.btnColor,
                  //   colorBlendMode: BlendMode.srcIn,
                  // )
                  ),

              Visibility(
                visible: !_auth.isNewUser,
                child: Text(
                  "${AppLocalizations.of(context)?.repetetiveBooking}",
                  style: AppTheme.appointmentTitleStyle,
                ),
              ),

              Gap(40.h),
              Visibility(
                visible: _auth.isNewUser,
                child: Container(
                  height: 180.h,
                  width: 327,

                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      shape: BoxShape.rectangle,
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0xffF0F0F0), // shadow color
                            blurRadius: 2, // shadow radius
                            offset: Offset(2, 5), // shadow offset
                            spreadRadius:
                                0.1, // The amount the box should be inflated prior to applying the blur
                            blurStyle: BlurStyle.normal // set blur style
                            ),
                      ]),
                  // color: AppTheme.white,
                  child: Column(children: [
                    const Gap(10),
                    Text(
                      "${AppLocalizations.of(context)?.firstTimeBooking}",
                      style: AppTheme.appointmentTitleStyle,
                    ),
                    const Gap(20),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                                height: 40.h,
                                width: 148.w,
                                padding: const EdgeInsets.all(5),
                                child: TextFormField(
                                  // controller: _auth.lastnamecontroller,
                                  autofocus: false,
                                  onChanged: (val) {
                                    _auth.firstName = val;
                                    printIt(
                                        'This is my firstName ${_auth.lastName}');
                                  },
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    border: border,
                                    enabledBorder: border,
                                    focusedBorder: border,
                                    hintText: AppLocalizations.of(context)
                                            ?.firstName ??
                                        "Enter First Name",
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: AppTheme.lightGrey2,
                                    border: Border.all(color: AppTheme.grey))),
                          ),
                          const Spacer(),
                          Expanded(
                            child: Container(
                                height: 40.h,
                                width: 148.w,
                                padding: const EdgeInsets.all(5),
                                child: TextFormField(
                                  // controller: _auth.lastnamecontroller,
                                  autofocus: false,
                                  onChanged: (val) {
                                    _auth.lastName = val;
                                    printIt(
                                        'This is my lastName ${_auth.lastName}');
                                  },
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    border: border,
                                    enabledBorder: border,
                                    focusedBorder: border,
                                    hintText: AppLocalizations.of(context)
                                            ?.lastName ??
                                        "Enter Last Name",
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: AppTheme.lightGrey2,
                                    border: Border.all(color: AppTheme.grey))),
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(width: 265.w, color: AppTheme.midGrey, height: 1),
                    const Gap(10),
                    Text(
                        AppLocalizations.of(context)?.fillDetails ??
                            'Please fill in your details here...',
                        style: AppTheme.bodyText2),
                    const Gap(10),
                  ]),
                ),
              ),
              Gap(40.h),
              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 35),
                child: Column(
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${AppLocalizations.of(context)?.services ?? "services"} (${appointment.services.length})",
                            style: AppTheme.appointmentTitleStyle,
                          ),
                        ),
                        for (Service s in appointment.services)
                          Expanded(
                            child: Text(
                              s.translations[
                                  AppLocalizations.of(context)?.localeName ??
                                      'en'],
                              style: AppTheme.appointmentSubtitle,
                              maxLines: 1,
                            ),
                          ),
                      ],
                    ),
                    Gap(24.h),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)?.price ?? "Price",
                            style: AppTheme.appointmentTitleStyle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${appointment.priceAndDuration.price} ${Keys.uah}",
                            style: AppTheme.appointmentSubtitle,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    Gap(24.h),
                    if (appointment.salonOwnerType == OwnerType.salon) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)?.salon ?? "Salon",
                              style: AppTheme.appointmentTitleStyle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              appointment.salon.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(color: AppTheme.textBlack),
                              maxLines: 1,
                            ),
                          )
                        ],
                      ),
                      Gap(24.h),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(context)?.master ??
                                        "Master",
                                    style: AppTheme.appointmentTitleStyle,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    appointment.master?.name ?? '',
                                    style: AppTheme.appointmentSubtitle,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                    if (appointment.salonOwnerType ==
                        OwnerType.singleMaster) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                                AppLocalizations.of(context)?.master ??
                                    "Master",
                                style: AppTheme.appointmentTitleStyle),
                          ),
                          Expanded(
                            child: Text(
                              appointment.salon.name,
                              style: AppTheme.appointmentSubtitle,
                            ),
                          ),
                        ],
                      ),
                      Gap(24.h),
                    ]
                  ],
                ),
              ),
              Gap(50.h),
              const OTPField2(
                color: AppTheme.lightBlack,
              ),
              Gap(24.h),
              ElevatedButton(
                onPressed: () async {
                  if (_auth.isNewUser) {
                    if (_auth.firstName.isEmpty || _auth.lastName.isEmpty) {
                      showToast('Input your name');
                      return;
                    }
                  }

                  if (_auth.loginStatus != Status.loading) {
                    await _auth
                        .signIn(
                            context: context,
                            ref: ref,
                            callBack: refreshAccount)
                        .then((value) async {
                      _auth.getUserInfo(context:context);
                      _auth.createAppointmentProvider(_createAppointment);
                      await _createAppointment.createAppointment(
                          customerModel: _auth.currentCustomer!,
                          context: context);
                      bool _success = await _createAppointment.finishBooking(
                          context: context,
                          customerModel: _auth.currentCustomer!);


                      if (_success) {
                        showMyDialog(
                          context: context,
                          child: SizedBox(
                            height: 300.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  AppLocalizations.of(context)?.success ??
                                      "Success",
                                  style: AppTheme.appointmentSubtitle,
                                ),
                                const Gap(10),
                                SizedBox(
                                    height: 150.h,
                                    width: 150.w,
                                    child: Image.asset(
                                        AppIcons.bookingConfirmedPNG)),
                                const Gap(10),
                                Text(
                                  (_createAppointment
                                                  .appointmentModel?.status ??
                                              "") ==
                                          AppointmentStatus.requested
                                      ? AppLocalizations.of(context)
                                              ?.requestConfirmed ??
                                          "Request Confirmed"
                                      : AppLocalizations.of(context)
                                              ?.bookingConfirmed ??
                                          "Your booking has been confirmed",
                                  textAlign: TextAlign.center,
                                  style: AppTheme.appointmentTitleStyle,
                                ),
                                const Gap(15),
                                BnbMaterialButton(
                                  key: const Key("great-key"),
                                  onTap: () {
                                    // print(object)
                                    if (_appProvider.firstRoute != null) {
                                      // printIt("loginBook");
                                      printIt(
                                          "Going back to : ${_appProvider.firstRoute}");

                                      // context.pop();
                                      // Navigator.popUntil(
                                      //     context, ModalRoute.withName("Foo1"));
                                      // if (kIsWeb) {
                                      html.window.open(
                                          "https://bowandbeautiful.com${_appProvider.firstRoute}",
                                          "_self");
                                      // } else {
                                      //   context.pop();
                                      //   context.push(
                                      //       '${NavigatorPage.redirect}${_appProvider.firstRoute!}');
                                      // }
                                    } else {
                                      Navigator.of(context).popUntil(
                                          (Route<dynamic> route) =>
                                              route.isFirst);
                                    }
                                  },
                                  title: AppLocalizations.of(context)?.great ??
                                      'Great',
                                  minWidth: 150.w,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    });

                    //if (_auth.name.isNotEmpty) {

                    // } else {
                    //   Navigator.of(context).pop();
                    //}
                    // } else {
                    //   null;
                    // }
                  } else {
                    // showToast(AppLocalizations.of(context)?.pleaseWait ??
                    //     "Please wait");
                  }
                },
                child: (_auth.loginStatus == Status.loading)
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
                        AppLocalizations.of(context)?.verifyAndBook ??
                            'Verify and book',
                        style: AppTheme.calTextStyle),
                style: ElevatedButton.styleFrom(
                    primary: AppTheme.lightBlack,
                    fixedSize: const Size(311, 48)),
              ),
              Gap(24.h),
              GestureDetector(
                onTap: () async {
                  await _auth.verifyPhoneNumber(context: context);
                  showTopSnackBar(
                    context,
                    const CustomSnackBar.success(
                      message: "New code has been sent",
                      backgroundColor: AppTheme.creamBrown,
                    ),
                  );
                  _auth.otp = '';
                },
                child: RichText(
                  text: TextSpan(
                    text: AppLocalizations.of(context)?.nootp ??
                        'Didn’t Receive an OTP? ',
                    style: const TextStyle(
                      color: AppTheme.grey1,
                      fontFamily: "Montserrat",
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              AppLocalizations.of(context)?.resend ?? "Resend",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppTheme.btnColor,
                            fontFamily: "Montserrat",
                          )),
                    ],
                  ),
                ),
              ),

              // if (!_auth.otpSent) ...[
              //   Text(AppLocalizations.of(context)?.login ?? "Login",
              //       style: GoogleFonts.epilogue(
              //           fontSize: 27.sp,
              //           fontWeight: FontWeight.w600,
              //           color: AppTheme.black2)),
              //   Gap(14.h),
              //   Text(
              //       AppLocalizations.of(context)?.inputPhoneNumber ??
              //           'Welome back, Please Input your \n Phone number below',
              //       style: TextStyle(
              //           fontFamily: "Montserrat",
              //           fontWeight: FontWeight.w400,
              //           fontSize: 18.sp,
              //           height: 2.h,
              //           color: AppTheme.grey1),
              //       textAlign: TextAlign.center),
              //   Gap(122.h),
              //   Padding(
              //     padding: EdgeInsets.only(left: 32.0.w, right: 32.w),
              //     child: Container(
              //       decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(4),
              //           shape: BoxShape.rectangle,
              //           boxShadow: const [
              //             BoxShadow(
              //                 color: Color(0xffF0F0F0), // shadow color
              //                 blurRadius: 2, // shadow radius
              //                 offset: Offset(2, 5), // shadow offset
              //                 spreadRadius:
              //                     0.1, // The amount the box should be inflated prior to applying the blur
              //                 blurStyle: BlurStyle.normal // set blur style
              //                 ),
              //           ]),
              //       //  height: 60.h,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Container(
              //             height: 58.h,
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(
              //                 8,
              //               ),
              //               //   shape: BoxShape.rectangle
              //               // color: AppTheme.coolGrey,
              //             ),
              //             child: CountryCodePicker(
              //               padding: const EdgeInsets.all(2),
              //               onChanged: (val) {
              //                 _auth.countryCode = val.dialCode ?? '';
              //                 printIt(_auth.countryCode);
              //               },
              //               onInit: (val) {
              //                 _auth.countryCode = val?.dialCode ?? '';
              //                 printIt(_auth.countryCode);
              //               },
              //               initialSelection: 'UA',
              //               favorite: const ['+380', 'Uk'],
              //               showCountryOnly: false,
              //               showOnlyCountryWhenClosed: false,
              //               alignLeft: false,
              //               textStyle: const TextStyle(color: Colors.black),
              //               showFlag: false,
              //             ),
              //           ),
              //           Container(
              //               height: 28.h, color: AppTheme.divider2, width: 1),
              //           const SizedBox(
              //             width: 8,
              //           ),
              //           Expanded(
              //             child: TextFormField(
              //               autofocus: true,
              //               onChanged: (val) {
              //                 _auth.phoneNumber = val;
              //               },
              //               keyboardType: TextInputType.number,
              //               decoration: InputDecoration(
              //                 border: border,
              //                 //enabledBorder:  border,
              //                 focusedBorder: InputBorder.none,
              //                 hintText: '(123) 456 - 7890',
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              //   Gap(80.h),
              //   ElevatedButton(
              //     onPressed: () async {
              //       if (_auth.otpStatus != Status.loading) {
              //         await _auth.verifyPhoneNumber(context: context);
              //       } else {
              //         showToast(AppLocalizations.of(context)?.pleaseWait ??
              //             "Please wait");
              //       }
              //     },
              //     child: (_auth.otpStatus != Status.loading)
              //         ? Text('Enter',
              //             style: TextStyle(
              //                 fontFamily: "Montserrat",
              //                 fontWeight: FontWeight.w400,
              //                 fontSize: 16.sp,
              //                 color: AppTheme.white),
              //             textAlign: TextAlign.center)
              //         : const SizedBox(
              //             height: 20,
              //             width: 20,
              //             child: Center(
              //               child: CircularProgressIndicator(
              //                 strokeWidth: 2,
              //                 color: AppTheme.white,
              //               ),
              //             )),
              //     style: ElevatedButton.styleFrom(
              //         primary: AppTheme.btnColor,
              //         minimumSize: Size(130.w, 55.h),
              //         maximumSize: Size(130.w, 55.h),
              //         fixedSize: Size(130.w, 55.h)),
              //   ),
              //   Gap(85.h)
              // ],
            ],
          ),
        ));
  }
}
