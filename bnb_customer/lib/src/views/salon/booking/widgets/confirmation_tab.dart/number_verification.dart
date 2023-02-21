import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/appointment/apointment_provider.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/home/salon_search_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/firebase/dynamic_link.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/salon/booking/widgets/confirmation_tab.dart/widgets.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'confirmed_dialog.dart';

class Verification extends ConsumerStatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  ConsumerState<Verification> createState() => _VerificationState();
}

class _VerificationState extends ConsumerState<Verification> {
  @override
  void initState() {
    super.initState();

    ref.read(authProvider);
  }

  late AuthProvider _auth;

  refreshAccount() async {
    BnbProvider _bnbProvider = ref.read(bnbProvider);

    SalonSearchProvider _salonSearchProvider = ref.read(salonSearchProvider);

    AppointmentProvider _appointmentProvider = ref.read(appointmentProvider);

    await _auth.getUserInfo(context: context);

    //await _salonSearchProvider.initialize();
    await _bnbProvider.initializeApp(customerModel: _auth.currentCustomer, lang: _bnbProvider.getLocale);

    if (_auth.userLoggedIn) {
      await DynamicLinksApi().handleDynamicLink(
        context: context,
        bonusSettings: _bnbProvider.bonusSettings,
      );

      await _appointmentProvider.loadAppointments(
        customerId: _auth.currentCustomer?.customerId ?? '',
        salonSearchProvider: _salonSearchProvider,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final AuthProvider _auth = ref.watch(authProvider);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = theme == AppTheme.lightTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Space(factor: 2),
        Text(
          "${AppLocalizations.of(context)?.registration_line16.toCapitalized() ?? "Confirm"} ${AppLocalizations.of(
                context,
              )?.phoneNumber.toCapitalized() ?? "Phone number"}",
          style: AppTheme.bodyText1.copyWith(
            fontSize: 17.sp,
            color: defaultTheme ? Colors.black : Colors.white,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          "Please enter verification code",
          style: AppTheme.bodyText2.copyWith(
            color: defaultTheme ? Colors.black : Colors.white,
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: DeviceConstraints.getResponsiveSize(context, 10, 25.w, 40.w).toDouble(),
                  ),
                  child: const OTPField9(),
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: () {
                    // _auth.otp = '';
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)?.registration_line17.toCapitalized() ?? "Didn't Receive an OTP? ",
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                color: defaultTheme ? AppTheme.lightGrey : Colors.white,
                              ),
                        ),
                        const TextSpan(text: '   '),
                        TextSpan(
                          text: "Resend",
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                fontSize: 15.sp,
                                decoration: TextDecoration.underline,
                                color: defaultTheme ? Colors.black : Colors.white,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        const Spacer(),
        (_auth.loginStatus == Status.loading)
            ? const SizedBox(
                height: 20,
                width: 20,
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.white),
                ),
              )
            : DefaultButton(
                borderRadius: 60,
                onTap: () async {
                  // await _auth.checkOtp(_createAppointmentProvider.otp);

                  // // if otp fails
                  // if (_auth.loginStatus == Status.failed) {
                  //   showToast(AppLocalizations.of(context)?.errorOccurred ?? 'error occurred');
                  // }

                  if (_auth.loginStatus != Status.loading) {
                    print('again here');
                    await _auth.signIn(context: context, ref: ref, callBack: refreshAccount).then(
                      (value) async {
                        print('here 1');
                        _auth.getUserInfo(context: context);
                        print('here 2');
                        _auth.createAppointmentProvider(_createAppointmentProvider);
                        print('here 3');
                        await _createAppointmentProvider.createAppointment(customerModel: _auth.currentCustomer!, context: context);
                        print('here 4');
                        bool _success = await _createAppointmentProvider.finishBooking(context: context, customerModel: _auth.currentCustomer!);

                        if (_success) {
                          // Pop current dialog
                          Navigator.of(context).pop();

                          ConfirmedDialog(
                            appointment: _createAppointmentProvider.appointmentModel!,
                          ).show(context);
                        }
                      },
                    );
                  }
                },
                color: defaultTheme ? Colors.black : theme.primaryColor,
                textColor: defaultTheme ? Colors.white : Colors.black,
                height: 60,
                label: AppLocalizations.of(context)?.verifyAndBook ?? 'Verify and book', //  'Next step',
              ),
        SizedBox(height: 15.h),
        DefaultButton(
          borderRadius: 60,
          onTap: () => _createAppointmentProvider.nextPageView(0),
          color: defaultTheme ? Colors.white : Colors.transparent,
          borderColor: defaultTheme ? Colors.black : theme.primaryColor,
          textColor: defaultTheme ? Colors.black : theme.primaryColor,
          height: 60,
          label: AppLocalizations.of(context)?.back ?? 'Back',
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
