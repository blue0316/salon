import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
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

class Verification extends ConsumerStatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  ConsumerState<Verification> createState() => _VerificationState();
}

class _VerificationState extends ConsumerState<Verification> {
  @override
  Widget build(BuildContext context) {
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);

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
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          "Please enter verification code",
          style: AppTheme.bodyText2.copyWith(),
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
                  child: const OTPField9(color: Colors.black),
                ),
                SizedBox(height: 12.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)?.registration_line17.toCapitalized() ?? "Didn't Receive an OTP? ",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: AppTheme.lightGrey,
                            ),
                      ),
                      const TextSpan(text: '   '),
                      TextSpan(
                        text: "Resend",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 15.sp,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ],
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
          onTap: () => _createAppointmentProvider.nextPageView(2),
          color: Colors.black,
          height: 60,
          label: 'Next step',
        ),
        SizedBox(height: 15.h),
        DefaultButton(
          borderRadius: 60,
          onTap: () => _createAppointmentProvider.nextPageView(0),
          color: Colors.white,
          borderColor: Colors.black,
          textColor: Colors.black,
          height: 60,
          label: 'Back',
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
