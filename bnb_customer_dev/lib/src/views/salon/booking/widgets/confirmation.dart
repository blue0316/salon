// import 'package:bbblient/src/controller/all_providers/all_providers.dart';
// import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
// import 'package:bbblient/src/utils/device_constraints.dart';
// import 'package:bbblient/src/views/salon/booking/widgets/confirmation_tab.dart/number_verification.dart';
// import 'package:bbblient/src/views/salon/booking/widgets/confirmation_tab.dart/order_list.dart';
// import 'package:bbblient/src/views/salon/booking/widgets/confirmation_tab.dart/user_details_verification.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class ConfirmationSection extends ConsumerWidget {
//   const ConfirmationSection({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);

//     return SizedBox(
//       width: double.infinity,
//       // color: Colors.lightGreen,
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: DeviceConstraints.getResponsiveSize(context, 7.w, 15.w, 20.w),
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               child: PageView(
//                 physics: const NeverScrollableScrollPhysics(),
//                 controller: _createAppointmentProvider.confirmationPageController,
//                 children: const [
//                   OrderList(),
//                   UserDetailsVerification(),
//                   Verification(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
