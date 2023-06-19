import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/utils/table_calender/table_calender.dart';
import 'package:bbblient/src/views/salon/booking/booking_date_time.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/colors.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/service_tab/service_list.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_horizontal_date_picker/flutter_horizontal_date_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class DayAndTime extends ConsumerStatefulWidget {
  final TabController tabController;

  const DayAndTime({Key? key, required this.tabController}) : super(key: key);

  @override
  ConsumerState<DayAndTime> createState() => _DayAndTimeState();
}

class _DayAndTimeState extends ConsumerState<DayAndTime> {
  @override
  void initState() {
    super.initState();
    debugPrint('INSIDE INIT STATE IN DAY AND TIME WIDGET');
  }

  DateTime date = DateTime.now();

  final DateTime _today = DateTime.now();
  final DateTime _lastDay = DateTime.now().add(const Duration(days: 31 * 3));

  final BoxDecoration _calBoxDecoration = BoxDecoration(
    color: Colors.transparent,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(12),
  );

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = (theme == AppTheme.customLightTheme);
    ThemeType themeType = _salonProfileProvider.themeType;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DeviceConstraints.getResponsiveSize(context, 17.w, 20.w, 20.w),
      ),
      child: (_createAppointmentProvider.salonMasters.isEmpty)
          ? Column(
              children: [
                const Space(),
                Text(
                  "No master is available for your selected services",
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                    color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Change that in your schedule",
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                    color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                DefaultButton(
                  borderRadius: 60,
                  onTap: () {
                    // Go to previous page
                    widget.tabController.animateTo(0);
                  },
                  color: dialogBackButtonColor(themeType, theme),
                  borderColor: theme.primaryColor,
                  textColor: theme.colorScheme.tertiary,
                  height: 60,
                  label: AppLocalizations.of(context)?.back ?? "Back",
                ),
              ],
            )
          : ListView(
              shrinkWrap: true,
              children: [
                Container(
                  height: 150,
                  child: HorizontalDatePicker(
                    selectedColor: Colors.transparent,
                    unSelectedColor: Colors.transparent,
                    itemHeight: 150,
                    begin: date.subtract(const Duration(days: 365)),
                    end: date.add(const Duration(days: 365)),
                    selected: _createAppointmentProvider.chosenDay,
                    onSelected: (item) {
                      date = item;
                      print('-----+++------ HORIZONTAL DATE PICKER DAY -----+++------');
                      print(item);
                      print('-----+++------ HORIZONTAL DATE PICKER DAY -----+++------');

                      _createAppointmentProvider.onDateChange(date);

                      // singleMasterTimeLineController.refreshGraph();
                    },
                    itemBuilder: (DateTime itemValue, DateTime? selected) {
                      var isSelected = selected?.difference(itemValue).inMilliseconds == 0;

                      return Column(
                        children: [
                          Text(
                            DateFormat("EE").format(itemValue).toUpperCase(),
                            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.tertiary),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 15.h),
                          InkWell(
                            onTap: () {
                              date = itemValue;
                              _createAppointmentProvider.onDateChange(date);
                            },
                            child: DateTime(date.year, date.month, date.day) == DateTime(itemValue.year, itemValue.month, itemValue.day)
                                ? Container(
                                    height: 36.h,
                                    width: 36.w,
                                    decoration: const BoxDecoration(
                                      color: AppTheme.red,
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                    ),
                                    // margin: EdgeInsets.all(margin),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${itemValue.day}',
                                        style: const TextStyle(fontSize: 14, color: AppTheme.white),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 36.h,
                                    width: 36.w,
                                    decoration: BoxDecoration(
                                      color: _createAppointmentProvider.checkIfMasterIsWorking(itemValue) ? null : Colors.purple,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: _createAppointmentProvider.checkIfMasterIsWorking(itemValue) ? theme.primaryColor : Colors.black,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${itemValue.day}',
                                        style: const TextStyle(fontSize: 14, color: AppTheme.white2),
                                      ),
                                    ),
                                  ),
                          )
                        ],
                      );
                    },
                    itemCount: 730,
                    itemSpacing: 12,
                  ),
                ),
                // SizedBox(height: 20.sp),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.orange), borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            _createAppointmentProvider.timeOfDayIndexForSlots = 0;
                            _createAppointmentProvider.onDateChange(date);
                          },
                          child: Container(
                            height: 27.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: _createAppointmentProvider.timeOfDayIndexForSlots == 0 ? const Color(0xffFF5419) : Colors.transparent,
                              border: Border.all(color: _createAppointmentProvider.timeOfDayIndexForSlots == 0 ? Colors.black : Colors.transparent),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'morning'.toCapitalized(),
                                maxLines: 2,
                                style: TextStyle(
                                  color: _createAppointmentProvider.timeOfDayIndexForSlots == 0 ? AppTheme.grey2 : AppTheme.grey2,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _createAppointmentProvider.timeOfDayIndexForSlots = 1;
                            _createAppointmentProvider.onDateChange(date);
                          },
                          child: Container(
                            height: 27.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: _createAppointmentProvider.timeOfDayIndexForSlots == 1 ? const Color(0xffFF5419) : Colors.transparent,
                              border: Border.all(color: _createAppointmentProvider.timeOfDayIndexForSlots == 1 ? Colors.black : Colors.transparent),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'afternoon'.toCapitalized(),
                                maxLines: 2,
                                style: TextStyle(
                                  color: _createAppointmentProvider.timeOfDayIndexForSlots == 1 ? AppTheme.grey2 : AppTheme.grey2,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _createAppointmentProvider.timeOfDayIndexForSlots = 2;
                            _createAppointmentProvider.onDateChange(date);
                          },
                          child: Container(
                            height: 27.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: _createAppointmentProvider.timeOfDayIndexForSlots == 2 ? const Color(0xffFF5419) : Colors.transparent,
                              border: Border.all(color: _createAppointmentProvider.timeOfDayIndexForSlots == 2 ? Colors.black : Colors.transparent),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'evening'.toCapitalized(),
                                maxLines: 2,
                                style: TextStyle(
                                  color: _createAppointmentProvider.timeOfDayIndexForSlots == 2 ? AppTheme.grey2 : AppTheme.grey2,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.sp),
                Text(
                  'Select masters !!!',
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                    color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,
                  ),
                ),

                (_createAppointmentProvider.masterViewStatus == Status.loading)
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 10),
                        itemCount: _createAppointmentProvider.serviceableMasters.length,
                        itemBuilder: (context, i) {
                          MasterModel _master = _createAppointmentProvider.serviceableMasters[i];

                          return MasterWithTime(
                            master: _master,
                            price: _createAppointmentProvider.priceAndDuration[_master.masterId]?.price ?? '0',
                            duration: _createAppointmentProvider.priceAndDuration[_master.masterId]?.duration ?? '0',
                            appointments: _createAppointmentProvider.allAppointments[_master.masterId],
                            title: 'NAWA',
                          );
                        },
                      ),

                // Text(
                //   AppLocalizations.of(context)?.serviceAndMaster.toCapitalized() ?? 'Service & Master',
                //   style: theme.textTheme.bodyLarge!.copyWith(
                //     fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                //     color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,
                //   ),
                // ),
                // // SizedBox(height: 5.h),
                // SingleChildScrollView(
                //   // shrinkWrap: true,
                //   scrollDirection: Axis.horizontal,
                //   // itemCount: _createAppointmentProvider.chosenServices.length,
                //   child: Row(
                //     children: _createAppointmentProvider.chosenServices.map(
                //       (service) {
                //         return Padding(
                //           padding: const EdgeInsets.only(right: 15),
                //           child: SizedBox(
                //             width: DeviceConstraints.getResponsiveSize(
                //               context,
                //               MediaQuery.of(context).size.width / 1.2,
                //               MediaQuery.of(context).size.width / 1.7,
                //               MediaQuery.of(context).size.width / 3.5,
                //             ),
                //             child: ServiceCard(
                //               service: service,
                //               pickMasters: true,
                //               isAdded: true,
                //               masters: _createAppointmentProvider.availableMasters,
                //               // pickMasterOnTap: () async {

                //               // },
                //               // selected: _createAppointmentProvider.chosenMaster?.masterId == _createAppointmentProvider.availableMasters[index].masterId,
                //             ),
                //           ),
                //         );
                //       },
                //     ).toList(),
                //   ),
                // ),
                // SizedBox(height: DeviceConstraints.getResponsiveSize(context, 15.h, 20.h, 20.h)),
                // const Divider(color: AppTheme.grey, thickness: 1.4),
                // SizedBox(height: DeviceConstraints.getResponsiveSize(context, 20.h, 20.h, 20.h)),
                // Text(
                //   AppLocalizations.of(context)?.selectDateAndTime ?? 'Select time and date',
                //   style: theme.textTheme.bodyLarge!.copyWith(
                //     fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                //     color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,
                //   ),
                // ),
                // SizedBox(height: DeviceConstraints.getResponsiveSize(context, 20.h, 20.h, 20.h)),
                // TableCalendar(
                //   focusedDay: _createAppointmentProvider.chosenDay,
                //   firstDay: _today,
                //   lastDay: _lastDay,
                //   selectedDayPredicate: (day) => isSameDay(_createAppointmentProvider.chosenDay, day),
                //   calendarFormat: CalendarFormat.week,
                //   startingDayOfWeek: StartingDayOfWeek.monday,
                //   weekendDays: const [],
                //   availableGestures: AvailableGestures.horizontalSwipe,
                //   currentDay: _today,
                //   rangeSelectionMode: RangeSelectionMode.disabled,
                //   locale: AppLocalizations.of(context)?.localeName ?? 'en',
                //   calendarStyle: CalendarStyle(
                //     defaultTextStyle: AppTheme.calTextStyle2.copyWith(
                //       color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,
                //     ),
                //     todayTextStyle: AppTheme.calTextStyle2.copyWith(
                //       color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,
                //     ),
                //     holidayTextStyle: AppTheme.calTextStyle2.copyWith(
                //       color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,
                //     ),
                //     weekendTextStyle: AppTheme.calTextStyle2.copyWith(
                //       color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,
                //     ),
                //     outsideTextStyle: AppTheme.calTextStyle2.copyWith(
                //       color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,
                //     ),
                //     disabledTextStyle: AppTheme.calTextStyle2.copyWith(
                //       color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,
                //     ),
                //     selectedTextStyle: theme.textTheme.displayMedium!.copyWith(
                //       fontSize: 15,
                //       color: isAddedSelectedColor(themeType), // Colors.black,
                //       fontWeight: FontWeight.w600,
                //       fontFamily: "Poppins",
                //     ),
                //     isTodayHighlighted: false,
                //     selectedDecoration: BoxDecoration(
                //       color: defaultTheme ? const Color.fromARGB(255, 239, 239, 239) : theme.primaryColor,
                //       shape: BoxShape.rectangle,
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     markerDecoration: BoxDecoration(
                //       color: Colors.lightBlueAccent, // AppTheme.creamBrownLight,
                //       shape: BoxShape.rectangle,
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     todayDecoration: BoxDecoration(
                //       border: Border.all(
                //         color: const Color.fromARGB(255, 29, 79, 4),
                //       ), // AppTheme.creamBrown),
                //       shape: BoxShape.rectangle,
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     markerSize: 10,
                //     markerMargin: const EdgeInsets.only(
                //       bottom: 0,
                //     ),
                //     defaultDecoration: _calBoxDecoration,
                //     holidayDecoration: _calBoxDecoration,
                //     weekendDecoration: _calBoxDecoration,
                //     outsideDecoration: _calBoxDecoration,
                //     rowDecoration: _calBoxDecoration,
                //     disabledDecoration: _calBoxDecoration,
                //     rangeEndDecoration: _calBoxDecoration,
                //     rangeStartDecoration: _calBoxDecoration,
                //     withinRangeDecoration: _calBoxDecoration,
                //     markersAnchor: 1.2,
                //     cellMargin: const EdgeInsets.all(4),
                //     markersAlignment: Alignment.center,
                //     outsideDaysVisible: false,
                //   ),
                //   onDaySelected: (start, end) {
                //     if ((_createAppointmentProvider.chosenSalon!.bookingRestrictionDays != null
                //         ? (DateTime.now()
                //             .add(Duration(
                //               days: _createAppointmentProvider.chosenSalon!.bookingRestrictionDays!,
                //             ))
                //             .isAfter(start))
                //         : true)) {
                //       setState(
                //         () {
                //           if (_createAppointmentProvider.chosenSalon!.ownerType != OwnerType.singleMaster) {
                //             _createAppointmentProvider.chosenDay = start;
                //             _createAppointmentProvider.chosenSlots.clear();
                //             for (int i = 1; i <= _createAppointmentProvider.chosenServices.length; i++) {
                //               _createAppointmentProvider.chosenSlots.add('');
                //             }
                //             _createAppointmentProvider.calculateAvailableMasters(day: start);
                //             _createAppointmentProvider.refreshSlotsSalonOwner(context);
                //           } else {
                //             _createAppointmentProvider.setUpSlots(day: start, context: context, showNotWorkingToast: true);
                //           }
                //         },
                //       );
                //     } else {
                //       showToast(
                //         AppLocalizations.of(context)?.bookRestricted ?? "Booking is restricted",
                //       );
                //     }
                //   },
                //   headerStyle: HeaderStyle(
                //     headerMargin: const EdgeInsets.symmetric(vertical: 10),
                //     titleTextStyle: AppTheme.calTextStyle2.copyWith(
                //       fontSize: 20.sp,
                //       color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,
                //     ),
                //     formatButtonVisible: false,
                //     leftChevronMargin: EdgeInsets.only(left: 0.2.sw),
                //     rightChevronMargin: EdgeInsets.only(right: 0.2.sw),
                //     titleCentered: true,
                //     leftChevronIcon: Icon(
                //       Icons.arrow_back_ios,
                //       color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,
                //       size: 18,
                //     ),
                //     rightChevronIcon: Icon(
                //       Icons.arrow_forward_ios,
                //       color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,
                //       key: const ValueKey("next"),
                //       size: 18,
                //     ),
                //   ),
                // ),
                // const Space(factor: 0.5),
                // const Padding(
                //   padding: EdgeInsets.all(8.0),
                //   child: Divider(color: AppTheme.grey, thickness: 1.5),
                // ),
                // const Space(factor: 0.6),
                // Column(
                //   children: [
                //     SizedBox(
                //       width: 1.sw,
                //     ),
                //     if (_createAppointmentProvider.slotsStatus == Status.loading) ...[
                //       SizedBox(
                //         height: 100.h,
                //         child: Center(
                //           child: SizedBox(
                //             height: 50.h,
                //             width: 50.w,
                //             child: const Padding(
                //               padding: EdgeInsets.all(4.0),
                //               child: CircularProgressIndicator(),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //     if (_createAppointmentProvider.eveningTimeslots.isEmpty && _createAppointmentProvider.morningTimeslots.isEmpty && _createAppointmentProvider.eveningTimeslots.isEmpty && _createAppointmentProvider.slotsStatus != Status.loading) ...[
                //       SizedBox(
                //         height: 100.h,
                //         width: 1.sw,
                //         child: Center(
                //           child: Padding(
                //             padding: const EdgeInsets.all(16.0),
                //             child: Text(
                //               AppLocalizations.of(
                //                     context,
                //                   )?.noSlotsAvailableTrydifferentDate ??
                //                   'no slots available, try different date',
                //               style: theme.textTheme.bodyLarge!.copyWith(
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.w400,
                //                 color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.creamBrown : Colors.white,
                //               ),
                //             ),
                //           ),
                //         ),
                //       )
                //     ],
                //     if (_createAppointmentProvider.morningTimeslots.isNotEmpty) ...[
                //       SizedBox(height: 28.h),
                //       Align(
                //         alignment: Alignment.centerLeft,
                //         child: Text(
                //           AppLocalizations.of(context)?.morning ?? "Morning",
                //           style: theme.textTheme.bodyLarge?.copyWith(
                //             color: theme.colorScheme.tertiary, //defaultTheme ? AppTheme.creamBrown : Colors.white,
                //           ),
                //         ),
                //       ),
                //       SizedBox(height: 12.h),
                //       Wrap(
                //         spacing: 10.h,
                //         runSpacing: 10.w,
                //         children: [
                //           for (var slot in _createAppointmentProvider.morningTimeslots)
                //             TimeSlotContainer(
                //               time: slot,
                //               valid: _createAppointmentProvider.validSlots.contains(slot),
                //               choosen: _createAppointmentProvider.chosenSlots.contains(slot),
                //               onTap: () async {
                //                 await _createAppointmentProvider.chooseSlot(slot, context);
                //               },
                //             ),
                //         ],
                //       ),
                //     ],
                //     if (_createAppointmentProvider.afternoonTimeslots.isNotEmpty) ...[
                //       SizedBox(height: 28.h),
                //       Align(
                //         alignment: Alignment.centerLeft,
                //         child: Text(
                //           AppLocalizations.of(context)?.afternoon ?? "Afternoon",
                //           style: theme.textTheme.bodyLarge?.copyWith(
                //             color: theme.colorScheme.tertiary, //defaultTheme ? AppTheme.creamBrown : Colors.white,
                //           ),
                //         ),
                //       ),
                //       SizedBox(height: 12.h),
                //       Wrap(
                //         spacing: 10.h,
                //         runSpacing: 10.w,
                //         children: [
                //           for (var slot in _createAppointmentProvider.afternoonTimeslots)
                //             TimeSlotContainer(
                //               time: slot,
                //               valid: _createAppointmentProvider.validSlots.contains(slot),
                //               choosen: _createAppointmentProvider.chosenSlots.contains(slot),
                //               onTap: () async {
                //                 await _createAppointmentProvider.chooseSlot(slot, context);
                //               },
                //             ),
                //         ],
                //       ),
                //     ],
                //     if (_createAppointmentProvider.eveningTimeslots.isNotEmpty) ...[
                //       SizedBox(height: 28.h),
                //       Align(
                //         alignment: Alignment.centerLeft,
                //         child: Text(
                //           AppLocalizations.of(context)?.evening ?? "Evening",
                //           style: theme.textTheme.bodyLarge?.copyWith(
                //             color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.creamBrown : Colors.white,
                //           ),
                //         ),
                //       ),
                //       SizedBox(height: 12.h),
                //       Wrap(
                //         spacing: 10.h,
                //         runSpacing: 10.w,
                //         children: [
                //           for (var slot in _createAppointmentProvider.eveningTimeslots)
                //             TimeSlotContainer(
                //               time: slot,
                //               valid: _createAppointmentProvider.validSlots.contains(slot),
                //               choosen: _createAppointmentProvider.chosenSlots.contains(slot),
                //               onTap: () async {
                //                 await _createAppointmentProvider.chooseSlot(slot, context);
                //               },
                //             ),
                //         ],
                //       ),
                //       SizedBox(height: 50.h),
                //     ],
                //   ],
                // ),
                // SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10.h, left: 2, right: 2),
                    child: Column(
                      children: [
                        DefaultButton(
                          borderRadius: 60,
                          onTap: () {
                            // if (_createAppointmentProvider.slotsStatus == Status.failed) {
                            //   showToast(
                            //     "One of the masters is currently not working, please select another master",
                            //     duration: const Duration(seconds: 3),
                            //   );
                            //   return;
                            // }

                            // if (_createAppointmentProvider.chosenSlots.isEmpty) {
                            //   showToast(AppLocalizations.of(context)?.chooseSlots ?? "choose slots");
                            //   return;
                            // }

                            // Next Page
                            widget.tabController.animateTo(2);
                          },
                          color: dialogButtonColor(themeType, theme), // defaultTheme ? Colors.black : theme.primaryColor,
                          borderColor: theme.primaryColor,
                          textColor: loaderColor(themeType), //  dialogTextColor(themeType, theme), // theme.colorScheme.tertiary, // defaultTheme ? Colors.white : Colors.black,
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
                          color: dialogBackButtonColor(themeType, theme), // defaultTheme ? Colors.white :
                          borderColor: theme.primaryColor, // dialogButtonColor(themeType, theme), // defaultTheme ? Colors.black : theme.primaryColor,
                          textColor: theme.colorScheme.tertiary, // defaultTheme ? Colors.black : theme.primaryColor,
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

class MasterWithTime extends ConsumerStatefulWidget {
  final MasterModel master;
  final String? name, title, price, duration;
  final List<String>? appointments;

  const MasterWithTime({
    Key? key,
    required this.master,
    this.name,
    this.title,
    this.price,
    this.duration,
    this.appointments,
  }) : super(key: key);

  @override
  ConsumerState<MasterWithTime> createState() => _MasterWithTimeState();
}

class _MasterWithTimeState extends ConsumerState<MasterWithTime> {
  final int maxCount = 10;
  late bool slotsGreaterThanMaxCount;

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;

    // if price and duration for a master is 0 return a white space
    //we dont want to create appointments with 0 values as price and duration
    if (widget.price == '\$0' || widget.duration == '0') return const SizedBox();

    //  in-case there is no appointments available then don't show salon in the first case as well
    if (widget.appointments == null || widget.appointments!.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 9, top: 5, right: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.master.personalInfo!.firstName} ${widget.master.personalInfo!.lastName}",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp, color: Colors.white),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      widget.title!,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(width: 5.sp),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.price}",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp, color: Colors.white),
                    ),
                    Text(
                      widget.duration!,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 35.h),
          const Text(
            'tr(Keys.dayOff)',
            style: TextStyle(color: Colors.white),
          ),
        ],
      );
    }

    // slotsGreaterThanMaxCount = (widget.appointments ?? []).length > maxCount;

    int slotCount = widget.appointments?.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 9, top: 15, right: 9),
          child: Container(
            color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.master.personalInfo!.firstName} ${widget.master.personalInfo!.lastName}",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.tertiary),
                    ),
                    SizedBox(height: 10.sp),
                    Text(
                      widget.title!,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.tertiary),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PRICE: ${widget.price}",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.tertiary),
                    ),
                    Text(
                      'DURATION: ${widget.duration!}',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.tertiary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          itemCount: slotCount,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 25),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: DeviceConstraints.getCrossAxisCount(context, small: 5, medium: 8, large: 10),
            childAspectRatio: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            List<String> appointmentString = widget.appointments ?? [];
            final String _appointment = appointmentString[index];
            final bool _isSelected = _createAppointmentProvider.isMasterSelected(
              widget.master.masterId,
              _createAppointmentProvider.chosenDay,
              _appointment,
            );
            final bool _isAvailable = _createAppointmentProvider.availableAppointments[widget.master.masterId]!.contains(_appointment);

            return InkWell(
              onTap: () => _createAppointmentProvider.onAppointmentChange(widget.master, _appointment),
              child: _isSelected && _isAvailable
                  ? Ink(
                      decoration: const BoxDecoration(
                        color: Color(0xffFF5419),
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                      child: Center(
                        child: Text(
                          widget.appointments![index],
                          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.tertiary),
                        ),
                      ),
                    )
                  : !_isAvailable
                      ? Ink(
                          decoration: const BoxDecoration(
                            color: Color(0xff232529),
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                          child: Center(
                            child: Text(
                              widget.appointments![index],
                              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.tertiary),
                            ),
                          ),
                        )
                      : Ink(
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: const BorderRadius.all(Radius.circular(2)),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.appointments![index],
                              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.tertiary),
                            ),
                          ),
                        ),
            );
          },
        ),
      ],
    );
  }
}
