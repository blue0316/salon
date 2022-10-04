// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'dart:ui';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/appointment/apointment_provider.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/controller/home/salon_search_provider.dart';
import 'package:bbblient/src/firebase/dynamic_link.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/registration/authenticate/login2.dart';
import 'package:bbblient/src/views/registration/authenticate/phone/login_from_booking.dart';
import 'package:bbblient/src/views/registration/authenticate/phone/otp.dart';
import 'package:bbblient/src/views/registration/quiz/register_quiz.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../theme/app_main_theme.dart';
import '../../widgets/widgets.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const double radius = 32;

checkUser(BuildContext context, WidgetRef ref, Function onTap,
    {AppointmentModel? appointmentModel}) {
  AuthProvider _auth = ref.read(authProvider);
  if (_auth.userLoggedIn) {
    // openSignInSheet(context);
    onTap();
  } else {
    
    openSignInSheet(context, appointmentModel);
  }
}

checkUser2(BuildContext context, WidgetRef ref, Function onTap) {
  AuthProvider _auth = ref.read(authProvider);
  if (!_auth.userLoggedIn) {
    // openSignInSheet(context);
    onTap();
  }
}

openSignInSheet(context, AppointmentModel? appointmentModel) {
  showCupertinoModalBottomSheet(
    context: context,
    isDismissible: false,
    builder: (context) => appointmentModel != null ? LoginFromBooking(appointment: appointmentModel,): Login2(
     
    ),
    //const LoginIntro(),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    topRadius: const Radius.circular(radius),
  );
}


class LoginIntro extends ConsumerStatefulWidget {
  const LoginIntro({Key? key}) : super(key: key);
  @override
  _LoginIntroState createState() => _LoginIntroState();
}

class _LoginIntroState extends ConsumerState<LoginIntro> {
  late AuthProvider _auth;

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

  final UnderlineInputBorder border = const UnderlineInputBorder(
    borderSide: BorderSide(
      color: AppTheme.lightBlack,
      width: 2,
    ),
  );
  @override
  Widget build(BuildContext context) {
    _auth = ref.watch(authProvider);
    return Material(
      child: SizedBox(
        height: 400.h + MediaQuery.of(context).viewInsets.bottom,
        child: Stack(
          children: [
            Image.asset(
              AppIcons.loginBgPNG,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 0,
              height: 70.h,
              width: 1.sw,
              child: Container(
                color: AppTheme.textBlack,
              ),
            ),
            BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  width: 1.sw,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 35, right: 35, bottom: 40.h, top: 20.h),
                    child: ConstrainedContainer(
                      maxWidth: 600,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 24),
                                Text(
                                  "bnb",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.white,
                                  ),
                                ),
                                _auth.loginStatus == Status.loading
                                    ? const SizedBox(width: 24)
                                    : InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Icon(
                                          CupertinoIcons.clear,
                                          size: 24,
                                          color: AppTheme.white,
                                        ))
                              ],
                            ),
                            Space(factor: 4.h),
                            if (!_auth.otpSent) ...[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  AppLocalizations.of(context)?.phoneNumber ??
                                      "Enter phone no",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                        fontSize: 16,
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              SizedBox(
                                height: 60.h,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 58.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          8,
                                        ),
                                        // color: AppTheme.coolGrey,
                                      ),
                                      child: CountryCodePicker(
                                        onChanged: (val) {
                                          _auth.countryCode =
                                              val.dialCode ?? '';
                                          printIt(_auth.countryCode);
                                        },
                                        onInit: (val) {
                                          _auth.countryCode =
                                              val?.dialCode ?? '';
                                          printIt(_auth.countryCode);
                                        },
                                        initialSelection: 'UA',
                                        favorite: const ['+380', 'Uk'],
                                        showCountryOnly: false,
                                        showOnlyCountryWhenClosed: false,
                                        alignLeft: false,
                                        textStyle: const TextStyle(
                                            color: Colors.black),
                                        showFlag: false,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        autofocus: true,
                                        onChanged: (val) {
                                          _auth.phoneNumber = val;
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: border,
                                          //enabledBorder:  border,
                                          focusedBorder: border,
                                          hintText: AppLocalizations.of(context)
                                                  ?.phoneNumber ??
                                              "Enter phone no",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 32.h,
                              ),
                              MaterialButton(
                                key: const ValueKey("phone-but"),
                                onPressed: () async {
                                  if (_auth.otpStatus != Status.loading) {
                                    await _auth.verifyPhoneNumber(
                                        context: context);
                                  } else {
                                    showToast(AppLocalizations.of(context)
                                            ?.pleaseWait ??
                                        "Please wait");
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                color: AppTheme.textBlack,
                                height: 50.h,
                                minWidth: 1.sw - 80,
                                child: (_auth.otpStatus != Status.loading)
                                    ? Text(
                                        AppLocalizations.of(context)?.login ??
                                            "Login",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      )
                                    : const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppTheme.white,
                                          ),
                                        )),
                              )
                            ],
                            if (_auth.otpSent &&
                                _auth.loginStatus != Status.success) ...[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "${_auth.countryCode}${_auth.phoneNumber}",
                                              style: const TextStyle(
                                                color: AppTheme.lightBlack,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _auth.setOtpSent(false);
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)
                                                        ?.change ??
                                                    " change",
                                                style: const TextStyle(
                                                  color: AppTheme.lightBlack,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (_auth.otpSent &&
                                            _auth.start != 0) ...[
                                          Text("${_auth.start}"),
                                        ],
                                        if (_auth.otpSent &&
                                            _auth.start == 0) ...[
                                          GestureDetector(
                                            onTap: () {
                                              _auth.verifyPhoneNumber(
                                                  context: context);
                                              _auth.otp = '';
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)
                                                      ?.resendOTP ??
                                                  " Resend OTP",
                                              style: const TextStyle(
                                                color: AppTheme.lightBlack,
                                              ),
                                            ),
                                          ),
                                        ]
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16.h,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)?.enterOTP ??
                                          "Enter OTP",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .copyWith(
                                            fontSize: 16,
                                            color: AppTheme.lightBlack,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              const OTPField(
                                key: ValueKey("otp"),
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              MaterialButton(
                                key: const ValueKey("otp-but"),
                                onPressed: () async {
                                  if (_auth.loginStatus != Status.loading) {
                                    await _auth.signIn(
                                        context: context,
                                        ref: ref,
                                        callBack: refreshAccount);
                                    _auth.name.isNotEmpty
                                        ? Navigator.of(context).pop()
                                        : null;
                                  } else {
                                    showToast(AppLocalizations.of(context)
                                            ?.pleaseWait ??
                                        "Please wait");
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                color: AppTheme.lightBlack,
                                height: 50.h,
                                minWidth: 1.sw - 80,
                                child: (_auth.loginStatus != Status.loading)
                                    ? Text(
                                        AppLocalizations.of(context)?.login ??
                                            "Login",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      )
                                    : const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppTheme.white,
                                          ),
                                        )),
                              )
                            ],
                            if (_auth.otpSent &&
                                _auth.loginStatus == Status.success &&
                                (_auth.name.isEmpty)) ...[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  AppLocalizations.of(context)
                                          ?.pleasefillInYourName
                                          .toCapitalized() ??
                                      'Please Fill In Your Name ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                        fontSize: 16,
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              SizedBox(
                                height: 60.h,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      child: TextFormField(
                                        autofocus: true,
                                        onChanged: (val) {
                                          _auth.firstName = val;
                                          printIt(
                                              'This is my ${_auth.firstName}');
                                        },
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          border: border,
                                          //enabledBorder:  border,
                                          focusedBorder: border,
                                          hintText: AppLocalizations.of(context)
                                                  ?.firstName ??
                                              "Enter First Name",
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      child: TextFormField(
                                        autofocus: true,
                                        onChanged: (val) {
                                          _auth.lastName = val;
                                          printIt(
                                              'This is my ${_auth.lastName}');
                                        },
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          border: border,
                                          //enabledBorder:  border,
                                          focusedBorder: border,
                                          hintText: AppLocalizations.of(context)
                                                  ?.lastName ??
                                              "Enter Last Name",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              MaterialButton(
                                key: const ValueKey("auth_name_butt"),
                                onPressed: () async {
                                  if (_auth.saveNameStatus != Status.loading) {
                                    await _auth.addName(
                                      context: context,
                                      // callBack: refreshAccount
                                    );

                                    // await _auth.printNewName();
                                    Navigator.of(context).pop();
                                  } else {
                                    showToast(AppLocalizations.of(context)
                                            ?.pleaseWait ??
                                        "Please wait");
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                color: AppTheme.lightBlack,
                                height: 50.h,
                                minWidth: 1.sw - 80,
                                child: (_auth.saveNameStatus != Status.loading)
                                    ? Text(
                                        AppLocalizations.of(context)?.save ??
                                            "Save",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      )
                                    : const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppTheme.white,
                                          ),
                                        )),
                              )
                            ],
                            if (_auth.userLoggedIn &&
                                _auth.loginStatus == Status.success &&
                                _auth.nameSent == true) ...[
                              Text(
                                AppLocalizations.of(context)?.loginSuccess ??
                                    "You have successfully joined bnb!",
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: AppTheme.textBlack,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                              Space(
                                factor: 1.h,
                              ),
                              Text(
                                AppLocalizations.of(context)
                                        ?.startBookingSalons ??
                                    "",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black54),
                                textAlign: TextAlign.center,
                              ),
                              Space(
                                factor: 4.h,
                              ),
                              MaterialButton(
                                  key: const ValueKey("done-but"),
                                  onPressed: () async {
                                    if (_auth.currentCustomer != null &&
                                        !_auth.currentCustomer!.quizCompleted) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const RegisterQuiz()));
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  color: AppTheme.lightBlack,
                                  height: 50.h,
                                  minWidth: 1.sw - 80,
                                  child: Text(
                                    AppLocalizations.of(context)?.done ??
                                        "Done !",
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ))
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
