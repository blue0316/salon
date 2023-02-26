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

  late AuthProvider _auth;

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
          style: theme.textTheme.bodyText1!.copyWith(
            fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
            color: defaultTheme ? Colors.black : Colors.white,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          "Please enter verification code",
          style: theme.textTheme.bodyText2!.copyWith(
            fontSize: 16.sp,
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
                          style: theme.textTheme.bodyText2!.copyWith(
                            fontSize: 18.sp,
                            color: defaultTheme ? AppTheme.lightGrey : Colors.white,
                          ),
                        ),
                        const TextSpan(text: '   '),
                        TextSpan(
                          text: "Resend",
                          style: theme.textTheme.bodyText1!.copyWith(
                            fontSize: 18.sp,
                            decoration: TextDecoration.underline,
                            color: defaultTheme ? Colors.black : theme.primaryColor,
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
        DefaultButton(
          borderRadius: 60,
          onTap: () async {
            _createAppointmentProvider.nextPageView(2);
          },
          color: defaultTheme ? Colors.black : theme.primaryColor,
          textColor: defaultTheme ? Colors.white : Colors.black,
          height: 60,
          label: AppLocalizations.of(context)?.next ?? 'Next', //  'Next step',
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
