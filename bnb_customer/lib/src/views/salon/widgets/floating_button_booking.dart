import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/salon/booking/booking_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// SHOW SERVICES FAB
class FloatingBar extends ConsumerStatefulWidget {
  final bool master;
  const FloatingBar({Key? key, this.master = false}) : super(key: key);

  @override
  _FloatingBarState createState() => _FloatingBarState();
}

class _FloatingBarState extends ConsumerState<FloatingBar> {
  @override
  Widget build(BuildContext context) {
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    int noOfServices = _createAppointmentProvider.chosenServices.length;
    return GestureDetector(
      onTap: () {
        // showModalBottomSheet(
        //   context: context,
        //   builder: (context) {
        //     return const BookingBottomSheet();
        //   },
        // );
        BookingDialogWidget(master: widget.master).show(context);
      },
      child: Padding(
          padding: EdgeInsets.only(bottom: 100.h),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(child: child, scale: animation);
            },
            child: noOfServices != 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          key: ValueKey(noOfServices),
                          height: 45.h,
                          decoration: BoxDecoration(
                            color: noOfServices >= 1
                                ? const Color(0XFF9D9D9D) // AppTheme.creamBrownLight
                                : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: BnbCheckCircle(value: true)),
                                Text(
                                  "Book $noOfServices ${noOfServices == 1 ? 'service' : AppLocalizations.of(context)?.services.toLowerCase() ?? "services"}",
                                  style: AppTheme.headLine2.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                TextButton(
                                  onPressed: () {
                                    // showModalBottomSheet(
                                    //   context: context,
                                    //   builder: (context) {
                                    //     return const BookingBottomSheet();
                                    //   },
                                    // );
                                    BookingDialogWidget(master: widget.master).show(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 1),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Colors.white, width: 1.0),
                                      ),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)?.show.toCapitalized() ?? "show",
                                      style: AppTheme.headLine2.copyWith(fontSize: 15.sp),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                    ],
                  )
                : const SizedBox(),
          )),
    );
  }
}
