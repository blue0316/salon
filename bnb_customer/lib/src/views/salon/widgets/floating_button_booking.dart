import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/booking_dialog_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// SHOW SERVICES FAB
class FloatingBar extends ConsumerStatefulWidget {
  final bool master;
  final MasterModel? masterModel;

  const FloatingBar({Key? key, this.master = false, this.masterModel}) : super(key: key);

  @override
  _FloatingBarState createState() => _FloatingBarState();
}

class _FloatingBarState extends ConsumerState<FloatingBar> {
  @override
  Widget build(BuildContext context) {
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    // int noOfServices = _createAppointmentProvider.chosenServices.length;

    return GestureDetector(
      onTap: () {},
      // => BookingDialogWidget222(
      //   master: widget.master,
      //   masterModel: widget.masterModel,
      // ).show(context),
      child: Padding(
        padding: EdgeInsets.only(bottom: 100.h),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              child: child,
              scale: animation,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {},
                // () => BookingDialogWidget222(
                //   master: widget.master,
                //   masterModel: widget.masterModel,
                // ).show(context),
                child: Container(
                  // key: ValueKey(noOfServices),
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: const Color(0XFF9D9D9D),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Text(
                        AppLocalizations.of(context)?.bookNow ?? "Book ${_createAppointmentProvider.chosenServices.length} Now",
                        style: AppTheme.displayMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
