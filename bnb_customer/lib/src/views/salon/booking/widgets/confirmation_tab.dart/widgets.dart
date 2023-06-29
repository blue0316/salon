import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OTPField9 extends ConsumerWidget {
  final Color? color;
  const OTPField9({Key? key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final _auth = ref.watch(authProvider);
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    // bool defaultTheme = theme == AppTheme.customLightTheme;

    return PinCodeTextField(
      autoFocus: true,
      appContext: context,
      length: 6,
      keyboardType: TextInputType.number,
      obscureText: false,
      cursorColor: theme.primaryColor,
      animationType: AnimationType.fade,
      textStyle: TextStyle(
        fontFamily: "Inter",
        fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
        fontWeight: FontWeight.normal,
        color: color ?? theme.colorScheme.tertiary, // (defaultTheme ? AppTheme.black : Colors.white), // AppTheme.black,
      ),
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.underline,
        // borderRadius: BorderRadius.circular(4),
        fieldHeight: 36.sp,

        fieldWidth: 36.sp,
        activeFillColor: color ?? theme.colorScheme.tertiary, // (defaultTheme ? Colors.black : Colors.white),
        inactiveColor: color ?? theme.colorScheme.tertiary, // (defaultTheme ? Colors.black : Colors.white),
        selectedColor: color ?? theme.colorScheme.tertiary, // (defaultTheme ? Colors.black : Colors.white),
        activeColor: color ?? theme.colorScheme.tertiary, //  (defaultTheme ? Colors.black : Colors.white),
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: false,
      onCompleted: (val) {
        _auth.otp = val;
      },
      onChanged: (val) {
        _auth.otp = val;
      },
      beforeTextPaste: (text) {
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        return true;
      },
    );
  }
}

class DashedDivider extends StatelessWidget {
  const DashedDivider({Key? key, this.height = 1, this.color = Colors.black}) : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
