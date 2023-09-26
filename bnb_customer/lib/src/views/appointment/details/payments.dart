import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/appointment/widgets/row.dart';
import 'package:bbblient/src/views/appointment/widgets/theme_colors.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentsInfoDetails extends ConsumerWidget {
  final AppointmentModel appointment;

  const PaymentsInfoDetails({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _appointmentProvider = ref.watch(appointmentProvider);
    ThemeData theme = _appointmentProvider.salonTheme ?? AppTheme.customLightTheme;

    ThemeType themeType = _appointmentProvider.themeType!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context)?.payment ?? 'Payment',
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 18.sp, 24.sp),
                color: confirmationTextColor(themeType, theme),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            // height: 200.h,
            // width: double.infinity,
            decoration: BoxDecoration(
              color: boxColor(themeType, theme),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  RowInfo(
                    title: (AppLocalizations.of(context)?.payAtAppointment ?? 'Pay at Appointment:').toCapitalized(),
                    value: '${appointment.customer?.name}',
                  ),
                  RowInfo(
                    title: (AppLocalizations.of(context)?.depositPaid ?? 'Deposit paid:').toCapitalized(),
                    value: '${appointment.customer?.phoneNumber}',
                    bottom: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
