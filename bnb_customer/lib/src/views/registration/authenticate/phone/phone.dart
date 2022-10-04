// import 'package:country_codes/country_codes.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import '../../../../models/country.dart';
// import '../../../../theme/app_main_theme.dart';
// import '../../../../utils/country_code.dart';
// import '../../../../utils/device_constraints.dart';
// import '../../../../utils/sizing_information.dart';
// import '../../../widgets/buttons.dart';
// import '../../../widgets/text_fields.dart';
// import '../../../widgets/widgets.dart';

// class PhonePage extends StatelessWidget {
//   static const route = "/registration/phone";

//   const PhonePage({Key? key}) : super(key: key);

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
//                   factor: 4,
//                 ),
//                 const Header(
//                   showBackButton: false,
//                 ),
//                 const Space(
//                   factor: 4,
//                 ),
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: AppTheme.margin),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Check country code and\nenter phone number",
//                         textAlign: TextAlign.center,
//                         style: Theme.of(context).textTheme.bodyText1,
//                       ),
//                       const Space(
//                         factor: 3,
//                       ),
//                       // Fields(
//                       //   onPhoneChange: phoneAuthController.onPhoneChange,
//                       //   onCountryChange: phoneAuthController.onCountryChange,
//                       // ),
//                       const Space(
//                         factor: 3,
//                       ),
//                       // Observer(
//                       //     builder: (_) => DefaultButton(
//                       //           label: "Next",
//                       //           color: AppTheme.creamBrown,
//                       //           isLoading: phoneAuthController.phoneLoading,
//                       //           onTap: phoneAuthController.isPhoneNextButtonEnabled
//                       //               ? () => phoneAuthController.sendMobileNumber()
//                       //               : null,
//                       //         ))
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

// class Header extends StatelessWidget {
//   final String text;
//   final bool showBackButton;
//   const Header({Key? key, this.text = "Phone number", this.showBackButton = true}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         showBackButton ? const Back() : const SizedBox(),
//         const SpaceHorizontal(),
//         Text(
//           text,
//           style: Theme.of(context).textTheme.bodyText1,
//         ),
//       ],
//     );
//   }
// }
