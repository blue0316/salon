import 'dart:async';

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Map<String, Color> tagColor = {
//   '1': const Color(0XFFF48B72),
//   '2': Colors.white,
//   '3': Colors.white,
//   '4': Colors.white,
//   '5': Colors.white,
//   'null': Colors.white,
// };

class SalonTags extends ConsumerStatefulWidget {
  final List<String> additionalFeatures;
  const SalonTags({Key? key, required this.additionalFeatures}) : super(key: key);

  @override
  ConsumerState<SalonTags> createState() => _SalonTagsState();
}

class _SalonTagsState extends ConsumerState<SalonTags> {
  final ScrollController _scrollController = ScrollController();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback(
  //     (timeStamp) {
  //       double minScrollExtent = _scrollController.position.minScrollExtent;
  //       double masxScrollExtent = _scrollController.position.maxScrollExtent;

  //       animateToMaxMin(masxScrollExtent, minScrollExtent, masxScrollExtent, 25, _scrollController);
  //     },
  //   );

  //   // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //   //   if (_scrollController.hasClients) {
  //   //     _scrollController.animateTo(
  //   //       _scrollController.position.maxScrollExtent,
  //   //       duration: const Duration(milliseconds: 500),
  //   //       curve: Curves.easeInOut,
  //   //     );
  //   //   }
  //   // });
  // }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  //   animateToMaxMin(double max, double min, double direction, int seconds, ScrollController scrollController) {
  //   scrollController.animateTo(direction, duration: Duration(seconds: seconds), curve: Curves.linear).then((value) {
  //     direction = direction == max ? min : max;
  //     animateToMaxMin(max, min, direction, seconds, scrollController);
  //   });
  // }

  Timer? _timer;
  int _currentPage = 0;

  PageController pageController = PageController();

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    // _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
    //   setState(() {
    //     String item = widget.additionalFeatures.removeAt(_currentPage);

    //     widget.additionalFeatures.add(item);
    //   });

    //   pageController.animateTo(
    //     _currentPage + 1,
    //     duration: Duration(milliseconds: 350),
    //     curve: Curves.easeIn,
    //   );
    // });
    //

    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      _toggleScrolling();
      // setState(() {
      //   _currentPage++;
      // });

      // print(_currentPage);
      // controller.animateTo(
      //   _currentPage.toDouble(),
      //   duration: Duration(milliseconds: 350),
      //   curve: Curves.easeIn,
      // );
    });
  }

  bool scroll = false;
  int speedFactor = 20;

  _scroll() {
    double maxExtent = _scrollController.position.maxScrollExtent;
    double distanceDifference = maxExtent - _scrollController.offset;
    double durationDouble = distanceDifference / speedFactor;

    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(seconds: durationDouble.toInt()), curve: Curves.linear);
  }

  _toggleScrolling() {
    setState(() {
      scroll = !scroll;
    });

    if (scroll) {
      _scroll();
    } else {
      _scrollController.animateTo(_scrollController.offset, duration: Duration(seconds: 1), curve: Curves.linear);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    pageController = PageController(
      viewportFraction: DeviceConstraints.getResponsiveSize(context, 0.5, 0.4, 0.3),
    );

    List<String> aFeatured = [...widget.additionalFeatures, ...widget.additionalFeatures, ...widget.additionalFeatures];

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 50),
      child: Column(
        children: [
          Divider(color: theme.dividerColor, thickness: 2),
          SizedBox(
            height: 60,
            child: NotificationListener(
              onNotification: (notif) {
                if (notif is ScrollEndNotification && scroll) {
                  Timer(Duration(seconds: 1), () {
                    _scroll();
                  });
                }

                return true;
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: Row(
                  children: aFeatured
                      .map((item) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    item,
                                    //  convertLowerCamelCase(widget.additionalFeatures[item]),
                                    style: theme.textTheme.bodyText1?.copyWith(
                                      color: theme.dividerColor,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 8.h,
                                  width: 8.h,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: theme.dividerColor),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            // child: PageView(
            //   scrollDirection: Axis.horizontal,
            //   controller: pageController,
            //   padEnds: false,
            //   children: widget.additionalFeatures
            //       .map((item) => Padding(
            //             padding: const EdgeInsets.symmetric(horizontal: 20),
            //             child: Row(
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Padding(
            //                   padding: const EdgeInsets.only(right: 10),
            //                   child: Text(
            //                     item,
            //                     //  convertLowerCamelCase(widget.additionalFeatures[item]),
            //                     style: theme.textTheme.bodyText1?.copyWith(
            //                       color: theme.dividerColor,
            //                       fontSize: 18.sp,
            //                     ),
            //                   ),
            //                 ),
            //                 Container(
            //                   height: 8.h,
            //                   width: 8.h,
            //                   decoration: BoxDecoration(shape: BoxShape.circle, color: theme.dividerColor),
            //                 ),
            //               ],
            //             ),
            //           ))
            //       .toList(),
            // ),
            // child: ListView.builder(
            //   controller: _scrollController,
            //   scrollDirection: Axis.horizontal,
            //   shrinkWrap: true,
            //   physics: AlwaysScrollableScrollPhysics(),
            //   itemCount: widget.additionalFeatures.length,
            //   itemBuilder: ((context, index) {
            // return Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.only(right: 10),
            //         child: Text(
            //           convertLowerCamelCase(widget.additionalFeatures[index]),
            //           style: theme.textTheme.bodyText1?.copyWith(
            //             color: theme.dividerColor,
            //             fontSize: 18.sp,
            //           ),
            //         ),
            //       ),
            //       Container(
            //         height: 8.h,
            //         width: 8.h,
            //         decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           color: theme.dividerColor,
            //         ),
            //       ),
            //     ],
            //   ),
            //     );
            //   }),
            // ),
          ),
          Divider(color: theme.dividerColor, thickness: 2),
        ],
      ),
    );
  }
}

String convertLowerCamelCase(String input) {
  var output = '';
  for (var i = 0; i < input.length; i++) {
    if (i == 0) {
      output += input[i].toLowerCase();
    } else if (input[i].toUpperCase() == input[i]) {
      output += ' ' + input[i].toLowerCase();
    } else {
      output += input[i];
    }
  }
  return output.toLowerCase();
}

// List<String> tags = [
//   'Coffee/Tea',
//   'Pet friendly',
//   'Parking',
//   'covid-19 vaccinated',
//   'Medical degree',
//   'instruments sterilization',
//   'Disposable materials only',
//   'Pet friendly',
//   'Parking',
//   'covid-19 vaccinated',
//   'Medical degree',
//   'Medical degree',
//   'instruments sterilization',
//   'Disposable materials only',
// ];
// import 'package:bbblient/src/controller/all_providers/all_providers.dart';
// import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// // Map<String, Color> tagColor = {
// //   '1': const Color(0XFFF48B72),
// //   '2': Colors.white,
// //   '3': Colors.white,
// //   '4': Colors.white,
// //   '5': Colors.white,
// //   'null': Colors.white,
// // };

// class SalonTags extends ConsumerStatefulWidget {
//   final List<String> additionalFeatures;
//   const SalonTags({Key? key, required this.additionalFeatures}) : super(key: key);

//   @override
//   ConsumerState<SalonTags> createState() => _SalonTagsState();
// }

// class _SalonTagsState extends ConsumerState<SalonTags> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback(
//       (timeStamp) {
//         double minScrollExtent = _scrollController.position.minScrollExtent;
//         double masxScrollExtent = _scrollController.position.maxScrollExtent;

//         animateToMaxMin(masxScrollExtent, minScrollExtent, masxScrollExtent, 25, _scrollController);
//       },
//     );

//     // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//     //   if (_scrollController.hasClients) {
//     //     _scrollController.animateTo(
//     //       _scrollController.position.maxScrollExtent,
//     //       duration: const Duration(milliseconds: 500),
//     //       curve: Curves.easeInOut,
//     //     );
//     //   }
//     // });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   animateToMaxMin(double max, double min, double direction, int seconds, ScrollController scrollController) {
//     scrollController.animateTo(direction, duration: Duration(seconds: seconds), curve: Curves.linear).then((value) {
//       direction = direction == max ? min : max;
//       animateToMaxMin(max, min, direction, seconds, scrollController);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
//     final ThemeData theme = _salonProfileProvider.salonTheme;

//     return Padding(
//       padding: const EdgeInsets.only(top: 20, bottom: 50),
//       child: Column(
//         children: [
//           Divider(color: theme.dividerColor, thickness: 2),
//           SizedBox(
//             height: 60,
//             child: ListView.builder(
//               controller: _scrollController,
//               scrollDirection: Axis.horizontal,
//               shrinkWrap: true,
//               physics: AlwaysScrollableScrollPhysics(),
//               itemCount: widget.additionalFeatures.length,
//               itemBuilder: ((context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(right: 10),
//                         child: Text(
//                           convertLowerCamelCase(widget.additionalFeatures[index]),
//                           style: theme.textTheme.bodyText1?.copyWith(
//                             color: theme.dividerColor,
//                             fontSize: 18.sp,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         height: 8.h,
//                         width: 8.h,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: theme.dividerColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//             ),
//           ),
//           Divider(color: theme.dividerColor, thickness: 2),
//         ],
//       ),
//     );
//   }
// }

// String convertLowerCamelCase(String input) {
//   var output = '';
//   for (var i = 0; i < input.length; i++) {
//     if (i == 0) {
//       output += input[i].toLowerCase();
//     } else if (input[i].toUpperCase() == input[i]) {
//       output += ' ' + input[i].toLowerCase();
//     } else {
//       output += input[i];
//     }
//   }
//   return output.toLowerCase();
// }

// // List<String> tags = [
// //   'Coffee/Tea',
// //   'Pet friendly',
// //   'Parking',
// //   'covid-19 vaccinated',
// //   'Medical degree',
// //   'instruments sterilization',
// //   'Disposable materials only',
// //   'Pet friendly',
// //   'Parking',
// //   'covid-19 vaccinated',
// //   'Medical degree',
// //   'Medical degree',
// //   'instruments sterilization',
// //   'Disposable materials only',
// // ];
