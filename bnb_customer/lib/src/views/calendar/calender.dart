import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../theme/app_main_theme.dart';
import '../../utils/time.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Calender extends ConsumerWidget {
  const Calender({Key? key}) : super(key: key);

  final CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context, ref) {
    final _appointmentProvider = ref.watch(appointmentProvider);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 30.0.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    color: AppTheme.lightBlack,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _appointmentProvider.selectedDay.day.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(fontSize: 24),
                    ),
                    // Text(
                    //   Time().getWeekDay(_appointmentProvider.selectedDay, context, false).toUpperCase(),
                    //   overflow: TextOverflow.ellipsis,
                    //   style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 14.sp),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
              Container(
                height: 60,
                width: 200.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Time().getWeekDay(
                            _appointmentProvider.selectedDay, context, true),
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                            fontSize: DeviceConstraints.getResponsiveSize(
                                context, 14, 15, 16)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${_appointmentProvider.selectedDayAppointments.length} ${AppLocalizations.of(context)?.appointment ?? "Appointments"}",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: DeviceConstraints.getResponsiveSize(
                                context, 16, 17, 18),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        TableCalendar<AppointmentModel>(
          daysOfWeekHeight: 40.h,
          firstDay: _appointmentProvider.firstDay,
          lastDay: _appointmentProvider.lastDay,
          focusedDay: _appointmentProvider.selectedDay,
          selectedDayPredicate: (day) =>
              isSameDay(_appointmentProvider.selectedDay, day),
          headerStyle: const HeaderStyle(
            leftChevronVisible: true,
            titleCentered: true,
            formatButtonVisible: false,
          ),
          calendarFormat: _calendarFormat,
          rangeSelectionMode: RangeSelectionMode.disabled,
          eventLoader: _appointmentProvider.getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          weekendDays: const [],
          locale: AppLocalizations.of(context)?.localeName ?? 'en',
          availableGestures: AvailableGestures.horizontalSwipe,
          calendarStyle: CalendarStyle(
            // Use `CalendarStyle` to customize the UI
            selectedTextStyle: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: AppTheme.textBlack, fontSize: 14.sp),

            todayTextStyle: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: AppTheme.white, fontSize: 15.sp),
            defaultDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0),
            ),
            selectedDecoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.5),
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
            ),
            todayDecoration: BoxDecoration(
              color: AppTheme.creamBrownLight,
              borderRadius: BorderRadius.circular(5),
            ),
            markerDecoration: const BoxDecoration(
              color: AppTheme.creamBrown,
              shape: BoxShape.circle,
            ),
            markerSize: 10,
            markerMargin: const EdgeInsets.only(
              bottom: 0,
            ),
            markersAnchor: 1.2,
            cellMargin: const EdgeInsets.all(2),
            markersAlignment: Alignment.center,
            outsideDaysVisible: false,
          ),
          onDaySelected: (val, val1) {
            _appointmentProvider.onDayChange(val);
          },
          onPageChanged: (focusedDay) {
            _appointmentProvider.onDayChange(focusedDay);
          },
        ),
      ],
    );
  }
}
