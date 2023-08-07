// import 'package:bbblient/models/appointment/appointment.dart';
// import 'package:bbblient/models/backend_codings/owner_type.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class ReviewQuestions extends StatefulWidget {
//   final AppointmentModel appointmentModel;
//   final List<String> masterTags;
//   final List<String> salonTags;
//   final double masterRating;
//   final double salonRating;
//   const ReviewQuestions({
//     Key? key,
//     required this.appointmentModel,
//     required this.masterTags,
//     required this.salonTags,
//     required this.masterRating,
//     required this.salonRating,
//   }) : super(key: key);

//   @override
//   _ReviewQuestionsState createState() => _ReviewQuestionsState();
// }

// class _ReviewQuestionsState extends State<ReviewQuestions> {
//   TextEditingController _masterReview = TextEditingController();
//   TextEditingController _salonReview = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 32.sp, vertical: 32.sp),
//           child: Column(
//             children: [
//               Text(
//                 "Your wishes or comments for Master",
//                 style: Theme.of(context).textTheme.displaySmall,
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(
//                 height: 8.h,
//               ),
//               SizedBox(
//                 height: 32.h,
//               ),
//               TextFormField(
//                 maxLines: 4,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
//                   focusColor: Colors.white,
//                   fillColor: Colors.white,
//                   filled: true,
//                   hintText: "Tell us a bit more about master",
//                 ),
//               ),
//               if (widget.appointmentModel.salonOwnerType == OwnerType.salon) ...[
//                 SizedBox(
//                   height: 32.h,
//                 ),
//                 Text(
//                   "Your wishes or comments for the salon",
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.displaySmall,
//                 ),
//                 SizedBox(
//                   height: 32.h,
//                 ),
//                 TextFormField(
//                   maxLines: 4,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
//                     focusColor: Colors.white,
//                     fillColor: Colors.white,
//                     filled: true,
//                     hintText: "Tell us a bit more about salon",
//                   ),
//                 ),
//               ]
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
