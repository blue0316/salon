import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'row.dart';
import 'theme_colors.dart';

class DateTimePrice extends ConsumerWidget {
  final AppointmentModel appointment;
  final SalonModel salonModel;

  const DateTimePrice({Key? key, required this.appointment, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _appointmentProvider = ref.watch(appointmentProvider);
    ThemeData theme = _appointmentProvider.salonTheme ?? AppTheme.customLightTheme;
    ThemeType themeType = _appointmentProvider.themeType!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Container(
        // height: 350.h,
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
                title: 'Date:',
                value: appointment.appointmentDate,
              ),
              RowInfo(
                title: 'Time:',
                value: appointment.appointmentTime,
              ),
              RowInfo(
                title: 'Price:',
                value: '${salonModel.selectedCurrency} ${appointment.priceAndDuration.price}',
              ),
              RowInfo(
                title: 'Duration:',
                value: '${appointment.priceAndDuration.duration} minutes',
                bottom: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
