// import 'package:bbblient/firebase/collections.dart';
// import 'package:bbblient/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_svg/svg.dart';
// import '../../models/appointment/appointment.dart';
// import '../../theme/app_main_theme.dart';
// import '../../utils/icons.dart';
// import '../../utils/time.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class HistoryOfVisits extends StatefulWidget {
//   const HistoryOfVisits({Key? key}) : super(key: key);

//   @override
//   _HistoryOfVisitsState createState() => _HistoryOfVisitsState();
// }

// class _HistoryOfVisitsState extends State<HistoryOfVisits> {
//   DateTime? _tempDate;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(
//             Icons.arrow_back,
//             color: AppTheme.textBlack,
//           ),
//         ),
//         title: Text(
//           AppLocalizations.of(context)?.historyOfVisits ?? "History of visits",
//           style: Theme.of(context).textTheme.bodyText1,
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 20,
//           ),

//           Expanded(
//             child: PaginateFirestore(
//               itemBuilderType: PaginateBuilderType.listView, // listview and gridview
//               itemBuilder: (index, context, documentSnapshot) {
//                 Map _json = documentSnapshot.data() as Map<dynamic, dynamic>;
//                 _json['appointmentId'] = documentSnapshot.id;

//                 AppointmentModel _appointment = AppointmentModel.fromJson(_json as Map<String, dynamic>);

//                 if (Time().compareDate(_tempDate, _appointment.appointmentStartTime)) {
//                   _tempDate = _appointment.appointmentStartTime;
//                   return VisitCard(_appointment);
//                 } else {
//                   _tempDate = _appointment.appointmentStartTime;
//                   return Column(
//                     children: [
//                       Container(
//                         height: 28,
//                         color: Colors.white,
//                         child: Center(
//                           child: Text(Time().getFormattedDate(_appointment.appointmentStartTime)),
//                         ),
//                       ),
//                       VisitCard(_appointment)
//                     ],
//                   );
//                 }
//               },
//               // orderBy is compulsary to enable pagination
//               query: Collection.appointments.orderBy('appointmentDate', descending: true),
//               emptyDisplay: const Center(child: Text('No visits found')),
//               //isLive: true // to fetch real-time data
//             ),
//           ),
//           // VisitCard()
//           // use listView builder and show this below widget
//         ],
//       ),
//     );
//   }
// }

// class VisitCard extends StatelessWidget {
//   final AppointmentModel appointment;

//   const VisitCard(this.appointment, {Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     // final String _serviceName = Translation.translate(appointment.services?.first.translations) ?? '';
//     final String _catIcon = AppIcons.getIconFromCategoryId(id: appointment.services.first.categoryId);
//     final String _date = Time().getFormattedDate(
//       appointment.appointmentStartTime,
//     );
//     final String _timeSlot = Time().getAppointmentEndTime(appointment) ?? "";
//     final String _salon = appointment.salon.id;
//     final String _master = appointment.master!.name;
//     final String _price = appointment.priceAndDuration.price;

//     return ExpansionTile(
//       tilePadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12),
//       title: Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: CircleAvatar(
//               radius: 20,
//               backgroundColor: Colors.white,
//               child: SvgPicture.asset(
//                 _catIcon,
//                 color: AppTheme.textBlack,
//                 height: 16,
//               ),
//             ),
//           ),
//           // Flexible(
//           //     child: Text(
//           //   _serviceName,
//           //   overflow: TextOverflow.ellipsis,
//           // ))
//         ],
//       ),
//       subtitle: Padding(
//         padding: const EdgeInsets.only(left: 80.0, top: 8.0),
//         child: Row(
//           children: [
//             Row(
//               children: [
//                 SizedBox(
//                   height: 16,
//                   width: 16,
//                   child: SvgPicture.asset('assets/icons/calendar_Active.svg'),
//                 ),
//                 const SizedBox(
//                   width: 8,
//                 ),
//                 Text(
//                   _date,
//                   style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 12, color: AppTheme.lightGrey),
//                 )
//               ],
//             ),
//             const SizedBox(
//               width: 30,
//             ),
//             Row(
//               children: [
//                 SizedBox(
//                   height: 16,
//                   width: 16,
//                   child: SvgPicture.asset('assets/icons/clock_grey.svg'),
//                 ),
//                 const SizedBox(
//                   width: 8,
//                 ),
//                 Text(
//                   _timeSlot,
//                   style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 12, color: AppTheme.lightGrey),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 95, top: 16, right: 40, bottom: 4),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 12.0),
//                 child: Row(
//                   children: [
//                     Text(
//                       "Saloon:",
//                       style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14, color: AppTheme.lightGrey),
//                     ),
//                     const SizedBox(
//                       width: 12,
//                     ),
//                     Flexible(
//                       child: Text(
//                         _salon,
//                         overflow: TextOverflow.ellipsis,
//                         style:
//                             Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14, color: AppTheme.creamBrown),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 12.0),
//                 child: Row(
//                   children: [
//                     Text(
//                       "Master:",
//                       style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14, color: AppTheme.lightGrey),
//                     ),
//                     const SizedBox(
//                       width: 12,
//                     ),
//                     Flexible(
//                       child: Text(
//                         _master,
//                         overflow: TextOverflow.ellipsis,
//                         style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                             ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 12.0),
//                 child: Row(
//                   children: [
//                     Text(
//                       "Price:",
//                       style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14, color: AppTheme.lightGrey),
//                     ),
//                     const SizedBox(
//                       width: 12,
//                     ),
//                     Flexible(
//                       child: Text(
//                         _price,
//                         overflow: TextOverflow.ellipsis,
//                         style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                             ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 12.0),
//                 child: Row(
//                   children: [
//                     Text(
//                       "Rating:",
//                       style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14, color: AppTheme.lightGrey),
//                     ),
//                     const SizedBox(
//                       width: 12,
//                     ),
//                     RatingBar.builder(
//                       initialRating: 5,
//                       minRating: 1,
//                       direction: Axis.horizontal,
//                       allowHalfRating: true,
//                       itemCount: 5,
//                       updateOnDrag: false,
//                       tapOnlyMode: false,
//                       itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
//                       itemBuilder: (context, _) {
//                         return SvgPicture.asset('assets/icons/flutterRating.svg');
//                       },
//                       onRatingUpdate: (rating) {
//                         printIt(rating);
//                       },
//                       ignoreGestures: true,
//                       itemSize: 20,
//                       glow: false,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
