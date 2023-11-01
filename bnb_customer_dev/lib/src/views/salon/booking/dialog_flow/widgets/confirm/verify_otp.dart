import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/customer/customer.dart';
import 'package:bbblient/src/models/enums/status.dart';
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
  @override
  void initState() {
    super.initState();

    ref.read(authProvider);
  }

  refreshAccount() async {
    final AuthProvider _auth = ref.read(authProvider);
    await _auth.getUserInfo(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final AuthProvider _auth = ref.watch(authProvider);
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
                        if (_auth.loginStatus != Status.loading) {
                          await _auth.signIn(context: context, ref: ref, callBack: refreshAccount).then(
                            (value) async {
                              if (value == Status.success) {
                                CustomerModel? currentCustomer = _auth.currentCustomer;

                                // print('___++++____@@@@_____');
                                // print(currentCustomer?.personalInfo.phone);
                                // print(currentCustomer?.personalInfo.firstName);
                                // print(currentCustomer?.personalInfo.lastName);
                                // print(currentCustomer?.personalInfo.email);
                                // print('___++++____@@@@_____');

                                if (currentCustomer != null) {
                                  if (currentCustomer.personalInfo.firstName == '' || currentCustomer.personalInfo.email == null) {
                                    // Customer Personal Info is missing name and email

                                    // Go to pageview that has fields to update personal info
                                    _createAppointmentProvider.nextPageView(2); // PageView screen that contains name and email fields
                                  } else {
                                    // Go to PageView Order List Screen
                                    _createAppointmentProvider.nextPageView(3);

                                    // CustomerModel customer = CustomerModel(
                                    //   customerId: currentCustomer.customerId,
                                    //   personalInfo: currentCustomer.personalInfo,
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
                                    // } else {

                                    //   await _createAppointmentProvider.creatAppointmentSalonOwner(customerModel: customer, context: context);
                                    // }

                                    // if mastes list is 1, block time of salon and master, phone number
                                  }
                                }

                                return;
                              } else if (value == Status.failed) {
                                showToast(AppLocalizations.of(context)?.somethingWentWrong ?? "Something went wrong");
                              } else {
                                printIt('wahala dey here');
                              } // /salon?id=IaUsq9UnKNsQ05bhhUuk
                            },
                          );
                        } else {
                          showToast(AppLocalizations.of(context)?.pleaseWait ?? "Please wait");
                        }
                      },
                // color: defaultTheme ? Colors.black : theme.primaryColor,
                // textColor: defaultTheme ? Colors.white : Colors.black,
                color: _auth.otp.length < 6 ? dialogButtonColor(themeType, theme)?.withOpacity(0.4) : dialogButtonColor(themeType, theme),
                textColor: loaderColor(themeType),
                borderColor: _auth.otp.length < 6 ? dialogButtonColor(themeType, theme)?.withOpacity(0.4) : dialogButtonColor(themeType, theme),

                height: 60.h,
                label: (AppLocalizations.of(context)?.confirmNumber ?? 'Confirm number').toCapitalized(),
                isLoading: _auth.loginStatus == Status.loading,
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
