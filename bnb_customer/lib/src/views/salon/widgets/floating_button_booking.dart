import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/booking/widgets/bottom_sheet_booking.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FloatingBar extends ConsumerStatefulWidget {
  const FloatingBar({Key? key}) : super(key: key);

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
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return const BookingBottomSheet();
          },
        );
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
                          height: 48.h,
                          decoration: BoxDecoration(
                              color: noOfServices >= 1
                                  ? AppTheme.creamBrownLight
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(24)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: BnbCheckCircle(value: true)),
                                Text(
                                  "$noOfServices ${AppLocalizations.of(context)?.services ?? "services"}",
                                  style: AppTheme.headLine2
                                      .copyWith(fontWeight: FontWeight.normal),
                                ),
                                TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return const BookingBottomSheet();
                                      },
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)?.show ??
                                        "show",
                                    style: AppTheme.headLine2,
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
