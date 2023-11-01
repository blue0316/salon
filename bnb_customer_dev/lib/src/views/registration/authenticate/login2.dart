import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/controller/home/salon_search_provider.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/registration/authenticate/phone/otp.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controller/all_providers/all_providers.dart';
import '../../../controller/appointment/apointment_provider.dart';
import '../../../firebase/dynamic_link.dart';

class Login2 extends ConsumerStatefulWidget {
  const Login2({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Login2State();
}

class _Login2State extends ConsumerState<Login2> {
  late AuthProvider _auth;

  final UnderlineInputBorder border = const UnderlineInputBorder(
    borderSide: BorderSide(
      color: AppTheme.lightBlack,
      width: 2,
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

    await _bnbProvider.initializeApp(customerModel: _auth.currentCustomer, lang: _bnbProvider.getLocale);

    if (_auth.userLoggedIn) {
      await DynamicLinksApi().handleDynamicLink(context: context, bonusSettings: _bnbProvider.bonusSettings);

      await _appointmentProvider.loadAppointments(
        customerId: _auth.currentCustomer?.customerId ?? '',
        salonSearchProvider: _salonSearchProvider,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _auth = ref.watch(authProvider);
    return Scaffold(
        backgroundColor: AppTheme.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(57.h),
              Center(
                  child: SvgPicture.asset(
                AppIcons.appLogo,
                cacheColorFilter: true,
                color: AppTheme.btnColor,
                // currentColor: AppTheme.btnColor,
                colorBlendMode: BlendMode.srcIn,
              )),
              Gap(40.h),
              if (!_auth.otpSent) ...[
                Text(AppLocalizations.of(context)?.login ?? "Login", style: GoogleFonts.epilogue(fontSize: 27.sp, fontWeight: FontWeight.w600, color: AppTheme.black2)),
                Gap(14.h),
                Text(AppLocalizations.of(context)?.inputPhoneNumber ?? 'Welome back, Please Input your \n Phone number below', style: TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.w400, fontSize: 18.sp, height: 2.h, color: AppTheme.grey1), textAlign: TextAlign.center),
                Gap(122.h),
                Padding(
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
                            autofocus: true,
                            onChanged: (val) {
                              _auth.phoneNumber = val;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
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
                Gap(80.h),
                ElevatedButton(
                  onPressed: () async {
                    // if (_auth.otpStatus != Status.loading) {
                    //   await _auth.verifyPhoneNumber(context: context);
                    // } else {
                    //   showToast(AppLocalizations.of(context)?.pleaseWait ?? "Please wait");
                    // }
                  },
                  child: (_auth.otpStatus != Status.loading)
                      ? Text(
                          'Enter',
                          style: TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.w400, fontSize: 16.sp, color: AppTheme.white),
                          textAlign: TextAlign.center,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.btnColor,
                    minimumSize: Size(130.w, 55.h),
                    maximumSize: Size(130.w, 55.h),
                    fixedSize: Size(130.w, 55.h),
                  ),
                ),
                Gap(85.h)
              ],
              if (_auth.otpSent && _auth.loginStatus != Status.success) ...[
                Text(
                  AppLocalizations.of(context)?.verification ?? 'Verification',
                  style: GoogleFonts.epilogue(fontSize: 24.sp, fontWeight: FontWeight.w600, color: AppTheme.black2),
                ),
                Gap(14.h),
                Text(
                  AppLocalizations.of(context)?.inputotp ?? 'Kindly input your OTP',
                  style: TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.w400, fontSize: 16.sp, color: AppTheme.grey1),
                  textAlign: TextAlign.center,
                ),
                Gap(20.h),
                SvgPicture.asset('assets/images/Illustration.svg'),
                Gap(40.h),
                OTPField2(
                  color: Theme.of(context).primaryColor,
                ),
                Gap(18.h),
                ElevatedButton(
                  onPressed: () async {
                    if (_auth.loginStatus != Status.loading) {
                      await _auth.signIn(context: context, ref: ref, callBack: refreshAccount);
                      Navigator.of(context).pop();
                    } else {
                      showToast(AppLocalizations.of(context)?.pleaseWait ?? "Please wait");
                    }
                  },
                  child: (_auth.loginStatus != Status.loading)
                      ? Text(
                          AppLocalizations.of(context)?.verify ?? 'Verify',
                          style: TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.w400, fontSize: 16.sp, color: AppTheme.white),
                          textAlign: TextAlign.center,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.btnColor,
                    minimumSize: Size(130.w, 55.h),
                    maximumSize: Size(130.w, 55.h),
                    fixedSize: Size(130.w, 55.h),
                  ),
                ),
                Gap(85.h),
                GestureDetector(
                  onTap: () async {
                    // _auth.verifyPhoneNumber(context: context).then((value) => showToast2(context));
                    // _auth.otp = '';
                  },
                  child: RichText(
                    text: TextSpan(
                      text: AppLocalizations.of(context)?.nootp ?? 'Didn’t Receive an OTP? ',
                      style: const TextStyle(
                        color: AppTheme.grey1,
                        fontFamily: "Montserrat",
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: AppLocalizations.of(context)?.resend ?? "Resend",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppTheme.btnColor,
                              fontFamily: "Montserrat",
                            )),
                      ],
                    ),
                  ),
                ),
              ],
              if (_auth.otpSent && _auth.loginStatus == Status.success && (_auth.name.isEmpty)) ...[
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context)?.pleasefillInYourName.toCapitalized() ?? 'Please Fill In Your Name ',
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                          color: AppTheme.grey1,
                          fontSize: 16,
                        ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, left: 15),
                  child: SizedBox(
                    height: 60.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: TextFormField(
                            // controller: _auth.firstnamecontroller,
                            autofocus: true,
                            onChanged: (val) {
                              _auth.firstName = val;
                              printIt('This is my FirstName ${_auth.firstName}');
                            },
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              border: border,
                              //enabledBorder:  border,
                              focusedBorder: border,
                              hintText: AppLocalizations.of(context)?.firstName ?? "Enter First Name",
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: TextFormField(
                            // controller: _auth.lastnamecontroller,
                            autofocus: true,
                            onChanged: (val) {
                              _auth.lastName = val;
                              printIt('This is my LastName ${_auth.lastName}');
                            },
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              border: border,
                              //enabledBorder:  border,
                              focusedBorder: border,
                              hintText: AppLocalizations.of(context)?.lastName ?? "Enter Last Name",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                MaterialButton(
                  key: const ValueKey("auth_name_butt"),
                  onPressed: () async {
                    if (_auth.firstName.isEmpty || _auth.lastName.isEmpty) {
                      _auth.firstName.isEmpty ? showToast(AppLocalizations.of(context)?.pleaseEnterFirstName ?? "Please fill in your first name") : showToast(AppLocalizations.of(context)?.pleaseEnterLastName ?? "Please fill in last name");
                    } else {
                      if (_auth.saveNameStatus != Status.loading) {
                        await _auth.addName(
                          context: context,
                          // callBack: refreshAccount
                        );

                        // await _auth.printNewName();
                        Navigator.of(context).pop();
                      } else {
                        showToast(AppLocalizations.of(context)?.pleaseWait ?? "Please wait");
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  color: AppTheme.btnColor,
                  height: 50.h,
                  minWidth: 1.sw - 80,
                  child: (_auth.saveNameStatus != Status.loading)
                      ? Text(
                          AppLocalizations.of(context)?.save ?? "Save",
                          style: Theme.of(context).textTheme.headline2,
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
            ],
          ),
        ));
  }
}
