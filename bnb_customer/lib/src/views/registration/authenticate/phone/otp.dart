import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPField extends ConsumerWidget {
  const OTPField({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final _auth = ref.watch(authProvider);
    return Container(
      constraints: const BoxConstraints(maxWidth: 270),
      child: PinCodeTextField(
        autoFocus: true,
        appContext: context,
        length: 6,
        keyboardType: TextInputType.number,
        obscureText: false,
        cursorColor: Theme.of(context).primaryColor,
        animationType: AnimationType.fade,
        textStyle: const TextStyle(fontFamily: "Montserrat", fontSize: 18, fontWeight: FontWeight.w500, color: AppTheme.black),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.underline,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          fieldHeight: 50,
          fieldWidth: 34,
          activeFillColor: Colors.white,
          inactiveColor: Theme.of(context).primaryColor,
          selectedColor: Theme.of(context).primaryColor,
          activeColor: Theme.of(context).primaryColor,
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
      ),
    );
  }
}

class OTPField2 extends ConsumerWidget {
  final Color? color;
  const OTPField2({
    Key? key,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final _auth = ref.watch(authProvider);
    return Container(
      constraints: const BoxConstraints(maxWidth: 270),
      child: PinCodeTextField(
        autoFocus: true,
        appContext: context,
        length: 6,
        keyboardType: TextInputType.number,
        obscureText: false,
        cursorColor: Theme.of(context).primaryColor,
        animationType: AnimationType.fade,
        textStyle: const TextStyle(fontFamily: "Montserrat", fontSize: 18, fontWeight: FontWeight.w500, color: AppTheme.black),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(4),
          fieldHeight: 36,
          fieldWidth: 36,
          activeFillColor: color,
          inactiveColor: color,
          selectedColor: color,
          activeColor: color,
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
      ),
    );
  }
}
// import 'package:bbblient/controller/all_providers/all_providers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import '../../../../theme/app_main_theme.dart';
// import '../../../../utils/device_constraints.dart';
// import '../../../../utils/sizing_information.dart';
// import '../../../widgets/buttons.dart';
// import '../../../widgets/widgets.dart';
// import 'phone.dart';

// class OTPPage extends StatelessWidget {
//   static const route = "/registration/phone/otp";

//   const OTPPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     //sets the default country code of the device
//     return Scaffold(
//         body: SingleChildScrollView(
//       child: Center(
//         child: BaseWidget(
//           builder: (BuildContext context, SizingInformation sizingInformation) => Container(
//             margin: const EdgeInsets.symmetric(horizontal: AppTheme.margin),
//             constraints: const BoxConstraints(maxWidth: DeviceConstraints.breakPointPhone),
//             child: Column(
//               children: [
//                 const Space(
//                   factor: 5,
//                 ),
//                 const Header(
//                   text: "Confirmation",
//                 ),
//                 const Space(
//                   factor: 4,
//                 ),
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: AppTheme.margin),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         constraints: const BoxConstraints(maxWidth: 270),
//                         child: Text(
//                           "Enter the code",
//                           textAlign: TextAlign.center,
//                           style: Theme.of(context).textTheme.bodyText1,
//                         ),
//                       ),
//                       const Space(
//                         factor: 3,
//                       ),
//                       // OTPField(
//                       //   // onChanged: phoneAuthController.onOTPChange,
//                       //   onComplete: (e) {
//                       //     phoneAuthController.submitOTP();
//                       //   },
//                       // ),
//                       const Space(
//                         factor: 3,
//                       ),
//                       Observer(
//                           builder: (_) => DefaultButton(
//                                 label: "Confirm",
//                                 color: Theme.of(context).primaryColor,
//                                 // isLoading: phoneAuthController.otpSubmitButtonLoading,
//                                 // onTap: phoneAuthController.submitOTP,
//                               )),
//                       const Space(
//                         factor: 3,
//                       ),
//                       // Observer(builder: (_) {
//                       //   if (phoneAuthController.enableResendOTP) {
//                       //     return Column(
//                       //       children: [
//                       //         Text(
//                       //           "Didn't receive the OTP ?",
//                       //           style: Theme.of(context).textTheme.bodyText2,
//                       //         ),
//                       //         Space(
//                       //           factor: 0.3,
//                       //         ),
//                       //         InkWell(
//                       //           onTap: phoneAuthController.resendOTP,
//                       //           child: Text(
//                       //             "RESEND OTP",
//                       //             style: Theme.of(context)
//                       //                 .textTheme
//                       //                 .bodyText2!
//                       //                 .copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
//                       //           ),
//                       //         )
//                       //       ],
//                       //     );
//                       //   } else {
//                       //     return Container();
//                       //   }
//                       // })
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ));
//   }
// }
