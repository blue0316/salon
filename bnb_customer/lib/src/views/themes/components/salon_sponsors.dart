import 'dart:async';

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SalonSponsors extends ConsumerStatefulWidget {
  const SalonSponsors({Key? key}) : super(key: key);

  @override
  ConsumerState<SalonSponsors> createState() => _SalonSponsorsState();
}

class _SalonSponsorsState extends ConsumerState<SalonSponsors> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (timeStamp) {
    //     double minScrollExtent = _scrollController.position.minScrollExtent;
    //     double masxScrollExtent = _scrollController.position.maxScrollExtent;

    //     animateToMaxMin(masxScrollExtent, minScrollExtent, masxScrollExtent, 25, _scrollController);
    //   },
    // );

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (_scrollController.hasClients) {
    //     _scrollController.animateTo(
    //       _scrollController.position.maxScrollExtent,
    //       duration: const Duration(milliseconds: 500),
    //       curve: Curves.easeInOut,
    //     );
    //   }
    // });

    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      _toggleScrolling();
    });
  }

  // animateToMaxMin(double max, double min, double direction, int seconds, ScrollController scrollController) {
  //   scrollController.animateTo(direction, duration: Duration(seconds: seconds), curve: Curves.linear).then((value) {
  //     direction = direction == max ? min : max;
  //     animateToMaxMin(max, min, direction, seconds, scrollController);
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
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
    if (mounted) {
      setState(() {
        scroll = !scroll;
      });
    }

    if (scroll) {
      _scroll();
    } else {
      _scrollController.animateTo(_scrollController.offset, duration: Duration(seconds: 1), curve: Curves.linear);
    }
  }

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          Divider(color: theme.dividerColor, thickness: 2),
          (_salonProfileProvider.allProductBrands.isEmpty)
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    AppLocalizations.of(context)?.noBrandsForThisProfile ?? "No brands available for this profile",
                    style: theme.textTheme.bodyText1?.copyWith(
                      color: theme.dividerColor,
                      fontSize: 18.sp,
                    ),
                  ),
                )
              : SizedBox(
                  height: 40,

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
                        children: _salonProfileProvider.allProductBrands
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        item.translations![AppLocalizations.of(context)?.localeName ?? 'en'],
                                        style: theme.textTheme.bodyText1?.copyWith(
                                          color: theme.dividerColor,
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 8.h,
                                      width: 8.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: theme.dividerColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  // child: ListView.builder(
                  //   controller: _scrollController,
                  //   scrollDirection: Axis.horizontal,
                  //   shrinkWrap: true,
                  //   itemCount: _salonProfileProvider.allProductBrands.length,
                  //   itemBuilder: ((context, index) {
                  //     final ProductBrandModel brand = _salonProfileProvider.allProductBrands[index];

                  //     return Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 20),
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.only(right: 10),
                  //             child: Text(
                  //               brand.translations![AppLocalizations.of(context)?.localeName ?? 'en'],
                  //               style: theme.textTheme.bodyText1?.copyWith(
                  //                 color: theme.dividerColor,
                  //                 fontSize: 18.sp,
                  //               ),
                  //             ),
                  //           ),
                  //           Container(
                  //             height: 8.h,
                  //             width: 8.h,
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               color: theme.dividerColor,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
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
