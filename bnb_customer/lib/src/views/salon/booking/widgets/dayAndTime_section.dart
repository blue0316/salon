import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/table_calender/table_calender.dart';
import 'package:bbblient/src/views/salon/booking/booking_date_time.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogDateAndTimeSection extends ConsumerStatefulWidget {
  final CreateAppointmentProvider createAppointment;
  final TabController tabController;
  const DialogDateAndTimeSection({Key? key, required this.tabController, required this.createAppointment}) : super(key: key);

  @override
  ConsumerState<DialogDateAndTimeSection> createState() => _DialogDateAndTimeSectionState();
}

class _DialogDateAndTimeSectionState extends ConsumerState<DialogDateAndTimeSection> {
  final DateTime _today = DateTime.now();
  final DateTime _lastDay = DateTime.now().add(const Duration(days: 31 * 3));

  final BoxDecoration _calBoxDecoration = BoxDecoration(
    color: Colors.transparent,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(12),
  );

  @override
  Widget build(BuildContext context) {
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DeviceConstraints.getResponsiveSize(context, 5, 20.w, 20.w),
        ),
        child: SizedBox(
          width: double.infinity,
          // color: Colors.purple,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TableCalendar(
                          focusedDay: widget.createAppointment.chosenDay,
                          firstDay: _today,
                          lastDay: _lastDay,
                          selectedDayPredicate: (day) => isSameDay(widget.createAppointment.chosenDay, day),
                          calendarFormat: CalendarFormat.week,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          weekendDays: const [],
                          availableGestures: AvailableGestures.horizontalSwipe,
                          currentDay: _today,
                          rangeSelectionMode: RangeSelectionMode.disabled,
                          locale: AppLocalizations.of(context)?.localeName ?? 'en',
                          calendarStyle: CalendarStyle(
                            defaultTextStyle: AppTheme.calTextStyle2,
                            todayTextStyle: AppTheme.calTextStyle2,
                            holidayTextStyle: AppTheme.calTextStyle2,
                            weekendTextStyle: AppTheme.calTextStyle2,
                            outsideTextStyle: AppTheme.calTextStyle2,
                            disabledTextStyle: AppTheme.calTextStyle2,
                            selectedTextStyle: Theme.of(context).textTheme.headline2!.copyWith(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                            isTodayHighlighted: false,
                            selectedDecoration: BoxDecoration(
                              color: const Color.fromARGB(255, 239, 239, 239),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            markerDecoration: BoxDecoration(
                              color: Colors.lightBlueAccent, // AppTheme.creamBrownLight,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            todayDecoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 29, 79, 4),
                              ), // AppTheme.creamBrown),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            markerSize: 10,
                            markerMargin: const EdgeInsets.only(
                              bottom: 0,
                            ),
                            defaultDecoration: _calBoxDecoration,
                            holidayDecoration: _calBoxDecoration,
                            weekendDecoration: _calBoxDecoration,
                            outsideDecoration: _calBoxDecoration,
                            rowDecoration: _calBoxDecoration,
                            disabledDecoration: _calBoxDecoration,
                            rangeEndDecoration: _calBoxDecoration,
                            rangeStartDecoration: _calBoxDecoration,
                            withinRangeDecoration: _calBoxDecoration,
                            markersAnchor: 1.2,
                            cellMargin: const EdgeInsets.all(4),
                            markersAlignment: Alignment.center,
                            outsideDaysVisible: false,
                          ),
                          onDaySelected: (start, end) {
                            if ((widget.createAppointment.chosenSalon!.bookingRestrictionDays != null
                                ? (DateTime.now()
                                    .add(Duration(
                                      days: widget.createAppointment.chosenSalon!.bookingRestrictionDays!,
                                    ))
                                    .isAfter(start))
                                : true)) {
                              setState(() {
                                widget.createAppointment.setUpSlots(day: start, context: context, showNotWorkingToast: true);
                              });
                            } else {
                              showToast(
                                AppLocalizations.of(context)?.bookRestricted ?? "Booking is restricted",
                              );
                            }
                          },
                          headerStyle: HeaderStyle(
                            headerMargin: const EdgeInsets.symmetric(vertical: 10),
                            titleTextStyle: AppTheme.calTextStyle2,
                            formatButtonVisible: false,
                            leftChevronMargin: EdgeInsets.only(left: 0.2.sw),
                            rightChevronMargin: EdgeInsets.only(right: 0.2.sw),
                            titleCentered: true,
                            leftChevronIcon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 18,
                            ),
                            rightChevronIcon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              key: ValueKey("next"),
                              size: 18,
                            ),
                          ),
                        ),
                        const Space(factor: 0.6),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(color: AppTheme.grey, thickness: 1.5),
                        ),
                        const Space(factor: 1),
                        Column(
                          children: [
                            SizedBox(
                              width: 1.sw,
                            ),
                            if (widget.createAppointment.slotsStatus == Status.loading) ...[
                              SizedBox(
                                height: 100.h,
                                child: Center(
                                  child: SizedBox(
                                    height: 50.h,
                                    width: 50.w,
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            if (widget.createAppointment.eveningTimeslots.isEmpty && widget.createAppointment.morningTimeslots.isEmpty && widget.createAppointment.eveningTimeslots.isEmpty && widget.createAppointment.slotsStatus != Status.loading) ...[
                              SizedBox(
                                height: 100.h,
                                width: 1.sw,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      AppLocalizations.of(
                                            context,
                                          )?.noSlotsAvailableTrydifferentDate ??
                                          'no slots available, try different date',
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                            if (widget.createAppointment.morningTimeslots.isNotEmpty) ...[
                              SizedBox(height: 28.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppLocalizations.of(context)?.morning ?? "Morning",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Wrap(
                                spacing: 10.h,
                                runSpacing: 10.w,
                                children: [
                                  for (var slot in widget.createAppointment.morningTimeslots)
                                    TimeSlotContainer(
                                      time: slot,
                                      valid: widget.createAppointment.validSlots.contains(slot),
                                      choosen: widget.createAppointment.chosenSlots.contains(slot),
                                      onTap: () async {
                                        await widget.createAppointment.chooseSlot(slot, context);
                                      },
                                    ),
                                ],
                              ),
                            ],
                            if (widget.createAppointment.afternoonTimeslots.isNotEmpty) ...[
                              SizedBox(height: 28.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppLocalizations.of(context)?.afternoon ?? "Afternoon",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Wrap(
                                spacing: 10.h,
                                runSpacing: 10.w,
                                children: [
                                  for (var slot in widget.createAppointment.afternoonTimeslots)
                                    TimeSlotContainer(
                                      time: slot,
                                      valid: widget.createAppointment.validSlots.contains(slot),
                                      choosen: widget.createAppointment.chosenSlots.contains(slot),
                                      onTap: () async {
                                        await widget.createAppointment.chooseSlot(slot, context);
                                      },
                                    ),
                                ],
                              ),
                            ],
                            if (widget.createAppointment.eveningTimeslots.isNotEmpty) ...[
                              SizedBox(height: 28.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppLocalizations.of(context)?.evening ?? "Evening",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Wrap(
                                spacing: 10.h,
                                runSpacing: 10.w,
                                children: [
                                  for (var slot in widget.createAppointment.eveningTimeslots)
                                    TimeSlotContainer(
                                      time: slot,
                                      valid: widget.createAppointment.validSlots.contains(slot),
                                      choosen: widget.createAppointment.chosenSlots.contains(slot),
                                      onTap: () async {
                                        await widget.createAppointment.chooseSlot(slot, context);
                                      },
                                    ),
                                ],
                              ),
                              SizedBox(height: 50.h),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              DefaultButton(
                borderRadius: 60,
                onTap: () {
                  if (widget.createAppointment.chosenSlots.contains('') || widget.createAppointment.chosenSlots.isEmpty) {
                    showToast(AppLocalizations.of(context)?.chooseSlots ?? "choose slots");
                    return;
                  }

                  debugPrint('Next Step');
                  widget.createAppointment.createAppointment2(context: context);
                  widget.tabController.animateTo(2);
                },
                color: Colors.black,
                height: 60,
                label: 'Next step',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
