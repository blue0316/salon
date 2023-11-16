import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/firebase/customer.dart';
import 'package:bbblient/src/models/customer/customer.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/mongodb/db_service.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/colors.dart';
import 'package:bbblient/src/views/salon/booking/widgets/confirmation_tab.dart/widgets.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyOtp extends ConsumerStatefulWidget {
  const VerifyOtp({Key? key}) : super(key: key);

  @override
  ConsumerState<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends ConsumerState<VerifyOtp> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    ref.read(authProvider);
  }

  refreshAccount() async {
    final AuthProviderController _auth = ref.read(authProvider);
    await _auth.getUserInfo(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final DatabaseProvider _dbProvider = ref.watch(dbProvider);
    final AuthProviderController _auth = ref.watch(authProvider);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    // bool defaultTheme = theme == AppTheme.customLightTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)?.confirmNumber ?? 'Confirm number',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
            color: theme.colorScheme.tertiary,
            fontFamily: 'Inter-Medium',
          ),
        ),
        SizedBox(height: 10.sp),
        Text(
          AppLocalizations.of(context)?.pleaseEnterVerificationCode ?? 'Please enter verification code that we just sent you',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
            color: theme.colorScheme.tertiary.withOpacity(0.6),
            fontFamily: 'Inter-Medium',
          ),
        ),
        SizedBox(height: 10.h),
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
                          text: AppLocalizations.of(context)?.didNotReceiveCode ?? 'Didn’t receive a code?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 17.sp, 18.sp),
                            color: theme.colorScheme.tertiary.withOpacity(0.6),
                            fontFamily: 'Inter-Medium',
                          ),
                        ),
                        const TextSpan(text: '   '),
                        TextSpan(
                          text: (AppLocalizations.of(context)?.resend ?? "Resend").toCapitalized(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 17.sp, 18.sp),
                            decoration: TextDecoration.underline,
                            color: theme.primaryColor,
                            fontFamily: 'Inter-Medium',
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            children: [
              DefaultButton(
                borderRadius: 60,
                // isLoading: (_auth.loginStatus == Status.loading),
                // loaderColor: Colors.black,
                onTap: _auth.otp.length < 6
                    ? () {}
                    : () async {
                        /* 
                          1. GET PHONE NUMBER
                          2. SEND OTP CODE TO PHONE NUMBER
                          3. VERIFY OTP
                          4. CHECK IF CUSTOMER DATA (PHONE NUMBER) EXISTS IN DATABASE
                          4a. IF TRUE, GO TO NEXT PAGE
                          4b. IF FALSE, ADD TO CUSTOMER COLLECTION THEN GO TO NEXT PAGE
                        */

                        // VERIFY OTP
                        await _auth.verifyOtpReceived(context, otp: _auth.otp);

                        if (_auth.verifyOTPStatus == Status.success) {
                          setState(() => isLoading = true);

                          // CHECK IF CUSTOMER DATA EXISTS IN DATABASE
                          final CustomerModel? customer = await CustomerApi(mongodbProvider: _dbProvider).findCustomer(
                            '${_auth.countryCode}${_auth.phoneNoController.text.trim()}',
                          );

                          stylePrint(customer);

                          setState(() => isLoading = false);

                          if (customer != null) {
                            printIt('customer exists');

                            _auth.setCurrentCustomer(customer);
                            _createAppointmentProvider.nextPageView(3); // CUSTOMER EXISTS - Go to PageView Order List Screen
                          } else {
                            printIt('customer does not exist');
                            _createAppointmentProvider.nextPageView(2); // Go to pageview that has fields to create customer
                          }
                        } else if (_auth.verifyOTPStatus == Status.failed) {
                          showToast(AppLocalizations.of(context)?.somethingWentWrong ?? "Something went wrong");
                        }
                      },

                color: _auth.otp.length < 6 ? dialogButtonColor(themeType, theme)?.withOpacity(0.4) : dialogButtonColor(themeType, theme),
                textColor: loaderColor(themeType),
                borderColor: _auth.otp.length < 6 ? dialogButtonColor(themeType, theme)?.withOpacity(0.4) : dialogButtonColor(themeType, theme),
                height: 60.h,
                label: (AppLocalizations.of(context)?.confirmNumber ?? 'Confirm number').toCapitalized(),
                isLoading: _auth.verifyOTPStatus == Status.loading || isLoading,
                loaderColor: loaderColor(themeType),
                suffixIcon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: loaderColor(themeType),
                  size: 18.sp,
                ),
                fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 17.sp, 18.sp),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
