// // Copyright 2019 Aleksander Woźniak
// // SPDX-License-Identifier: Apache-2.0

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class CalendarPage extends StatelessWidget {
//   final Widget Function(BuildContext context, DateTime day)? dowBuilder;
//   final Widget Function(BuildContext context, DateTime day) dayBuilder;
//   final List<DateTime> visibleDays;
//   final Decoration? dowDecoration;
//   final Decoration? rowDecoration;
//   final TableBorder? tableBorder;
//   final bool dowVisible;

//   const CalendarPage({
//     Key? key,
//     required this.visibleDays,
//     this.dowBuilder,
//     required this.dayBuilder,
//     this.dowDecoration,
//     this.rowDecoration,
//     this.tableBorder,
//     this.dowVisible = true,
//   })  : assert(!dowVisible || dowBuilder != null),
//         super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(15),
//       child: Table(
//         border: tableBorder,
//         children: [
//           if (dowVisible) _buildDaysOfWeek(context),
//           // ..._buildCalendarDays(context),
//         ],
//       ),
//     );
//   }

//   TableRow _buildDaysOfWeek(BuildContext context) {
//     return TableRow(
//       decoration: dowDecoration,
//       // children: List.generate(
//       //   7,
//       //   (index) => Padding(
//       //     padding: const EdgeInsets.symmetric(horizontal: 15),
//       //     child: dowBuilder!(context, visibleDays[index]),
//       //   ),
//       // ).toList(),
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: List.generate(
//             7,
//             (index) => Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Container(
//                   decoration: const BoxDecoration(
//                     border: Border(
//                       top: BorderSide(color: Colors.black, width: 1.5),
//                       left: BorderSide(color: Colors.black, width: 1.5),
//                       right: BorderSide(color: Colors.black, width: 1.5),
//                     ),
//                   ),
//                   child: dowBuilder!(context, visibleDays[index]),
//                 ),
//                 Container(
//                   height: 90,
//                   width: 10,
//                   color: Colors.black,
//                 ),
//               ],
//             ),
//           ).toList(),
//         ),
//         // Row(
//         //   children: List.generate(
//         //     7,
//         //     (id) => Padding(
//         //       padding: const EdgeInsets.symmetric(horizontal: 10),
//         //       child: Container(
//         //         height: 30,
//         //         width: 50,
//         //         color: Colors.black,
//         //       ),
//         //     ),
//         //   ).toList(),
//         // ),
//       ],
//     );
//   }

//   List<TableRow> _buildCalendarDays(BuildContext context) {
//     final rowAmount = visibleDays.length ~/ 7;

//     return List.generate(rowAmount, (index) => index * 7)
//         .map((index) => TableRow(
//               decoration: rowDecoration,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: List.generate(
//                     7,
//                     (id) => Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Container(
//                           decoration: const BoxDecoration(
//                             border: Border(
//                               bottom: BorderSide(color: Colors.black, width: 1.5),
//                               left: BorderSide(color: Colors.black, width: 1.5),
//                               right: BorderSide(color: Colors.black, width: 1.5),
//                             ),
//                           ),
//                           child: dayBuilder(context, visibleDays[index + id]),
//                         ),
//                         Container(
//                           height: 1,
//                           width: 10,
//                           color: Colors.black,
//                         ),
//                       ],
//                     ),
//                   ).toList(),
//                 ),
//               ],
//             ))
//         .toList();
//   }
// }

// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/widgets.dart';

class CalendarPage extends StatelessWidget {
  final Widget Function(BuildContext context, DateTime day)? dowBuilder;
  final Widget Function(BuildContext context, DateTime day) dayBuilder;
  final List<DateTime> visibleDays;
  final Decoration? dowDecoration;
  final Decoration? rowDecoration;
  final TableBorder? tableBorder;
  final bool dowVisible;

  const CalendarPage({
    Key? key,
    required this.visibleDays,
    this.dowBuilder,
    required this.dayBuilder,
    this.dowDecoration,
    this.rowDecoration,
    this.tableBorder,
    this.dowVisible = true,
  })  : assert(!dowVisible || dowBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: tableBorder,
      children: [
        if (dowVisible) _buildDaysOfWeek(context),
        ..._buildCalendarDays(context),
      ],
    );
  }

  TableRow _buildDaysOfWeek(BuildContext context) {
    return TableRow(
      decoration: dowDecoration,
      children: List.generate(
        7,
        (index) => dowBuilder!(context, visibleDays[index]),
      ).toList(),
    );
  }

  List<TableRow> _buildCalendarDays(BuildContext context) {
    final rowAmount = visibleDays.length ~/ 7;

    return List.generate(rowAmount, (index) => index * 7)
        .map((index) => TableRow(
              decoration: rowDecoration,
              children: List.generate(
                7,
                (id) => dayBuilder(context, visibleDays[index + id]),
              ),
            ))
        .toList();
  }
}
