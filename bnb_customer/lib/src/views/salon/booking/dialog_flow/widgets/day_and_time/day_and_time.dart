import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/table_calender/table_calender.dart';
import 'package:bbblient/src/views/salon/booking/booking_date_time.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/service_tab/service_list.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DayAndTime extends ConsumerStatefulWidget {
  final TabController tabController;

  const DayAndTime({Key? key, required this.tabController}) : super(key: key);

  @override
  ConsumerState<DayAndTime> createState() => _DayAndTimeState();
}

class _DayAndTimeState extends ConsumerState<DayAndTime> {
  final DateTime _today = DateTime.now();
  final DateTime _lastDay = DateTime.now().add(const Duration(days: 31 * 3));

  final BoxDecoration _calBoxDecoration = BoxDecoration(
    color: Colors.transparent,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(12),
  );

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider =
        ref.watch(salonProfileProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final _salonSearchProvider = ref.watch(salonSearchProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = (theme == AppTheme.lightTheme);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            DeviceConstraints.getResponsiveSize(context, 17.w, 20.w, 20.w),
      ),
      child: ListView(
        shrinkWrap: true,

        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            // AppLocalizations.of(context)?.availableMasters.toCapitalized() ?? 'Available masters',
            'Service & Master',
            style: theme.textTheme.bodyText1!.copyWith(
              fontSize: DeviceConstraints.getResponsiveSize(
                  context, 20.sp, 20.sp, 20.sp),
              color: defaultTheme ? AppTheme.textBlack : Colors.white,
            ),
          ),
          SizedBox(height: 5.h),
          SizedBox(
            // flex: 1,

            height: DeviceConstraints.getResponsiveSize(
                context, 225.h, 220.h, 220.h),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _createAppointmentProvider.chosenServices.length,
              itemBuilder: (context, index) {
                final ServiceModel service =
                    _createAppointmentProvider.chosenServices[index];
                List<MasterModel> masters =
                    _createAppointmentProvider.availableMasters;

                return Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: SizedBox(
                    width: DeviceConstraints.getResponsiveSize(
                      context,
                      MediaQuery.of(context).size.width / 1.2,
                      MediaQuery.of(context).size.width / 1.7,
                      MediaQuery.of(context).size.width / 3.5,
                    ),
                    child: ServiceCard(
                      service: service,
                      pickMasters: true,
                      isAdded: true,
                      masters: masters,
                      // pickMasterOnTap: () async {

                      // },
                      // selected: _createAppointmentProvider.chosenMaster?.masterId == _createAppointmentProvider.availableMasters[index].masterId,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
              height: DeviceConstraints.getResponsiveSize(
                  context, 15.h, 20.h, 20.h)),
          const Divider(color: AppTheme.grey, thickness: 1.4),
          SizedBox(
              height: DeviceConstraints.getResponsiveSize(
                  context, 20.h, 20.h, 20.h)),
          Text(
            // AppLocalizations.of(context)?.availableMasters.toCapitalized() ?? 'Available masters',
            'Select time and date',
            style: theme.textTheme.bodyText1!.copyWith(
              fontSize: DeviceConstraints.getResponsiveSize(
                  context, 20.sp, 20.sp, 20.sp),
              color: defaultTheme ? AppTheme.textBlack : Colors.white,
            ),
          ),
          SizedBox(
              height: DeviceConstraints.getResponsiveSize(
                  context, 20.h, 20.h, 20.h)),
          TableCalendar(
            focusedDay: _createAppointmentProvider.chosenDay,
            firstDay: _today,
            lastDay: _lastDay,
            selectedDayPredicate: (day) =>
                isSameDay(_createAppointmentProvider.chosenDay, day),
            calendarFormat: CalendarFormat.week,
            startingDayOfWeek: StartingDayOfWeek.monday,
            weekendDays: const [],
            availableGestures: AvailableGestures.horizontalSwipe,
            currentDay: _today,
            rangeSelectionMode: RangeSelectionMode.disabled,
            locale: AppLocalizations.of(context)?.localeName ?? 'en',
            calendarStyle: CalendarStyle(
              defaultTextStyle: AppTheme.calTextStyle2.copyWith(
                color: defaultTheme ? Colors.black : Colors.white,
              ),
              todayTextStyle: AppTheme.calTextStyle2.copyWith(
                color: defaultTheme ? Colors.black : Colors.white,
              ),
              holidayTextStyle: AppTheme.calTextStyle2.copyWith(
                color: defaultTheme ? Colors.black : Colors.white,
              ),
              weekendTextStyle: AppTheme.calTextStyle2.copyWith(
                color: defaultTheme ? Colors.black : Colors.white,
              ),
              outsideTextStyle: AppTheme.calTextStyle2.copyWith(
                color: defaultTheme ? Colors.black : Colors.white,
              ),
              disabledTextStyle: AppTheme.calTextStyle2.copyWith(
                color: defaultTheme ? Colors.black : Colors.white,
              ),
              selectedTextStyle:
                  Theme.of(context).textTheme.headline2!.copyWith(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
              isTodayHighlighted: false,
              selectedDecoration: BoxDecoration(
                color: defaultTheme
                    ? const Color.fromARGB(255, 239, 239, 239)
                    : theme.primaryColor,
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
              if ((_createAppointmentProvider
                          .chosenSalon!.bookingRestrictionDays !=
                      null
                  ? (DateTime.now()
                      .add(Duration(
                        days: _createAppointmentProvider
                            .chosenSalon!.bookingRestrictionDays!,
                      ))
                      .isAfter(start))
                  : true)) {
                setState(() {
                  if (_createAppointmentProvider.chosenSalon!.ownerType !=
                      OwnerType.singleMaster) {
                    _createAppointmentProvider.chosenDay = start;
                    _createAppointmentProvider.chosenSlots.clear();
                    for (int i = 1;
                        i <= _createAppointmentProvider.chosenServices.length;
                        i++) {
                      _createAppointmentProvider.chosenSlots.add('');
                    }
                    _createAppointmentProvider.calculateAvailableMasters(
                        day: start);
                    _createAppointmentProvider.refreshSlotsSalonOwner(context);
                  } else {
                    _createAppointmentProvider.setUpSlots(
                        day: start,
                        context: context,
                        showNotWorkingToast: true);
                  }
                });
              } else {
                showToast(
                  AppLocalizations.of(context)?.bookRestricted ??
                      "Booking is restricted",
                );
              }
            },
            headerStyle: HeaderStyle(
              headerMargin: const EdgeInsets.symmetric(vertical: 10),
              titleTextStyle: AppTheme.calTextStyle2.copyWith(
                fontSize: 20.sp,
                color: defaultTheme ? Colors.black : Colors.white,
              ),
              formatButtonVisible: false,
              leftChevronMargin: EdgeInsets.only(left: 0.2.sw),
              rightChevronMargin: EdgeInsets.only(right: 0.2.sw),
              titleCentered: true,
              leftChevronIcon: Icon(
                Icons.arrow_back_ios,
                color: defaultTheme ? Colors.black : Colors.white,
                size: 18,
              ),
              rightChevronIcon: Icon(
                Icons.arrow_forward_ios,
                color: defaultTheme ? Colors.black : Colors.white,
                key: const ValueKey("next"),
                size: 18,
              ),
            ),
          ),
          const Space(factor: 0.5),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(color: AppTheme.grey, thickness: 1.5),
          ),
          const Space(factor: 0.6),
          Column(
            children: [
              SizedBox(
                width: 1.sw,
              ),
              if (_createAppointmentProvider.slotsStatus == Status.loading) ...[
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
              if (_createAppointmentProvider.eveningTimeslots.isEmpty &&
                  _createAppointmentProvider.morningTimeslots.isEmpty &&
                  _createAppointmentProvider.eveningTimeslots.isEmpty &&
                  _createAppointmentProvider.slotsStatus != Status.loading) ...[
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
                              color: defaultTheme
                                  ? AppTheme.creamBrown
                                  : Colors.white,
                            ),
                      ),
                    ),
                  ),
                )
              ],
              if (_createAppointmentProvider.morningTimeslots.isNotEmpty) ...[
                SizedBox(height: 28.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)?.morning ?? "Morning",
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color:
                              defaultTheme ? AppTheme.creamBrown : Colors.white,
                        ),
                  ),
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 10.h,
                  runSpacing: 10.w,
                  children: [
                    for (var slot
                        in _createAppointmentProvider.morningTimeslots)
                      TimeSlotContainer(
                        time: slot,
                        valid: _createAppointmentProvider.validSlots
                            .contains(slot),
                        choosen: _createAppointmentProvider.chosenSlots
                            .contains(slot),
                        onTap: () async {
                          await _createAppointmentProvider.chooseSlot(
                              slot, context);
                        },
                      ),
                  ],
                ),
              ],
              if (_createAppointmentProvider.afternoonTimeslots.isNotEmpty) ...[
                SizedBox(height: 28.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)?.afternoon ?? "Afternoon",
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color:
                              defaultTheme ? AppTheme.creamBrown : Colors.white,
                        ),
                  ),
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 10.h,
                  runSpacing: 10.w,
                  children: [
                    for (var slot
                        in _createAppointmentProvider.afternoonTimeslots)
                      TimeSlotContainer(
                        time: slot,
                        valid: _createAppointmentProvider.validSlots
                            .contains(slot),
                        choosen: _createAppointmentProvider.chosenSlots
                            .contains(slot),
                        onTap: () async {
                          await _createAppointmentProvider.chooseSlot(
                              slot, context);
                        },
                      ),
                  ],
                ),
              ],
              if (_createAppointmentProvider.eveningTimeslots.isNotEmpty) ...[
                SizedBox(height: 28.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)?.evening ?? "Evening",
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color:
                              defaultTheme ? AppTheme.creamBrown : Colors.white,
                        ),
                  ),
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 10.h,
                  runSpacing: 10.w,
                  children: [
                    for (var slot
                        in _createAppointmentProvider.eveningTimeslots)
                      TimeSlotContainer(
                        time: slot,
                        valid: _createAppointmentProvider.validSlots
                            .contains(slot),
                        choosen: _createAppointmentProvider.chosenSlots
                            .contains(slot),
                        onTap: () async {
                          await _createAppointmentProvider.chooseSlot(
                              slot, context);
                        },
                      ),
                  ],
                ),
                SizedBox(height: 50.h),
              ],
            ],
          ),
          SizedBox(height: 20.h),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Column(
                children: [
                  DefaultButton(
                    borderRadius: 60,
                    onTap: () {
                      // Next Page
                      widget.tabController.animateTo(2);
                    },
                    color: defaultTheme ? Colors.black : theme.primaryColor,
                    textColor: defaultTheme ? Colors.white : Colors.black,
                    height: 60,
                    label: AppLocalizations.of(context)?.next ?? "Next",
                  ),
                  const SizedBox(height: 10),
                  DefaultButton(
                    borderRadius: 60,
                    onTap: () {
                      // Next Page
                      widget.tabController.animateTo(0);
                    },
                    color: defaultTheme ? Colors.black : theme.primaryColor,
                    textColor: defaultTheme ? Colors.white : Colors.black,
                    height: 60,
                    label: AppLocalizations.of(context)?.back ?? "Back",
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
