import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/utils/utils.dart';
// import 'package:bbblient/src/views/registration/authenticate/login.dart';
import 'package:bbblient/src/views/salon/booking/confirm_booking.dart';
import 'package:bbblient/src/views/salon/booking/widgets/bottom_sheet_booking.dart';
import 'package:bbblient/src/views/salon/widgets/person_avtar.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../utils/device_constraints.dart';
import '../../widgets/buttons.dart';

class BookingDateTime extends ConsumerStatefulWidget {
  const BookingDateTime({Key? key}) : super(key: key);

  @override
  _BookingDateTimeState createState() => _BookingDateTimeState();
}

class _BookingDateTimeState extends ConsumerState<BookingDateTime> {
  final DateTime _today = DateTime.now();
  final DateTime _lastDay = DateTime.now().add(const Duration(days: 31 * 3));
  final ScrollController _mastresListController = ScrollController();
  late CreateAppointmentProvider createAppointment;
  final BoxDecoration _calBoxDecoration = BoxDecoration(
    color: Colors.transparent,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(12),
  );

  @override
  void initState() {
    super.initState();
    setUpMasterPrice();
  }

  setUpMasterPrice() {
    createAppointment = ref.read(createAppointmentProvider);
    if (createAppointment.chosenMaster != null) {
      Future.delayed(const Duration(milliseconds: 300), () {
        createAppointment.chooseMaster(
            masterModel: createAppointment.chosenMaster!, context: context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    createAppointment = ref.watch(createAppointmentProvider);
    final _auth = ref.watch(authProvider);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [

            SizedBox(
              height: 1.sh,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 214,
                    decoration: const BoxDecoration(color: AppTheme.textBlack),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstrainedContainer(
                            child: TableCalendar(
                              focusedDay: createAppointment.chosenDay,
                              firstDay: _today,
                              lastDay: _lastDay,
                              selectedDayPredicate: (day) =>
                                  isSameDay(createAppointment.chosenDay, day),
                              calendarFormat: CalendarFormat.week,
                              startingDayOfWeek: StartingDayOfWeek.monday,
                              weekendDays: const [],
                              availableGestures:
                                  AvailableGestures.horizontalSwipe,
                              currentDay: _today,
                              rangeSelectionMode: RangeSelectionMode.disabled,
                              locale:
                                  AppLocalizations.of(context)?.localeName ??
                                      'en',
                              calendarStyle: CalendarStyle(
                                defaultTextStyle: AppTheme.calTextStyle,
                                todayTextStyle: AppTheme.calTextStyle,
                                holidayTextStyle: AppTheme.calTextStyle,
                                weekendTextStyle: AppTheme.calTextStyle,
                                outsideTextStyle: AppTheme.calTextStyle,
                                disabledTextStyle: AppTheme.calTextStyle,
                                selectedTextStyle: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                isTodayHighlighted: false,
                                selectedDecoration: BoxDecoration(
                                  color: AppTheme.creamBrownLight,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ),
                                ),
                                markerDecoration: BoxDecoration(
                                  color: AppTheme.creamBrownLight,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ),
                                ),
                                todayDecoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppTheme.creamBrown),
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
                                setState(() {
                                  createAppointment.setUpSlots(
                                      day: start,
                                      context: context,
                                      showNotWorkingToast: true);
                                });
                              },
                              headerStyle: HeaderStyle(
                                titleTextStyle: AppTheme.calTextStyle,
                                formatButtonVisible: false,
                                leftChevronMargin:
                                    EdgeInsets.only(left: 0.2.sw),
                                rightChevronMargin:
                                    EdgeInsets.only(right: 0.2.sw),
                                titleCentered: true,
                                leftChevronIcon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                rightChevronIcon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  key: ValueKey("next"),
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)?.all ?? "All"} ${AppLocalizations.of(context)?.services ?? "services"}",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (createAppointment.chosenMaster != null) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        createAppointment
                                                    .mastersPriceDurationMap[
                                                        createAppointment
                                                            .chosenMaster
                                                            ?.masterId]
                                                    ?.duration ==
                                                createAppointment
                                                    .mastersPriceDurationMapMax[
                                                        createAppointment
                                                            .chosenMaster
                                                            ?.masterId]
                                                    ?.duration
                                            ? "${createAppointment.mastersServicesMap[createAppointment.chosenMaster?.masterId]?.length} ${AppLocalizations.of(context)?.services ?? "services"} (${createAppointment.mastersPriceDurationMap[createAppointment.chosenMaster?.masterId]?.duration} ${AppLocalizations.of(context)?.min ?? "min"})"
                                            : "${createAppointment.mastersServicesMap[createAppointment.chosenMaster?.masterId]?.length} ${AppLocalizations.of(context)?.services ?? "services"} (${createAppointment.mastersPriceDurationMap[createAppointment.chosenMaster?.masterId]?.duration} ${AppLocalizations.of(context)?.min ?? "min"} - ${createAppointment.mastersPriceDurationMapMax[createAppointment.chosenMaster?.masterId]?.duration} ${AppLocalizations.of(context)?.min ?? "min"} )",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                                color: AppTheme.textBlack,
                                                fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        createAppointment
                                                    .mastersPriceDurationMap[
                                                        createAppointment
                                                            .chosenMaster
                                                            ?.masterId]
                                                    ?.price ==
                                                createAppointment
                                                    .mastersPriceDurationMapMax[
                                                        createAppointment
                                                            .chosenMaster
                                                            ?.masterId]
                                                    ?.price
                                            ? "${createAppointment.mastersPriceDurationMap[createAppointment.chosenMaster?.masterId]?.price} ${Keys.uah}"
                                            : "${createAppointment.mastersPriceDurationMap[createAppointment.chosenMaster?.masterId]?.price} ${Keys.uah} - ${createAppointment.mastersPriceDurationMapMax[createAppointment.chosenMaster?.masterId]?.price} ${Keys.uah}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                                color: AppTheme.textBlack,
                                                fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                            if (createAppointment.chosenMaster == null) ...[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    createAppointment.totalMinutes ==
                                            createAppointment
                                                .totalMinutesWithFixed
                                        ? "${createAppointment.chosenServices.length} ${AppLocalizations.of(context)?.services ?? "services"} (${createAppointment.totalMinutes} ${AppLocalizations.of(context)?.min ?? "min"})"
                                        : "${createAppointment.chosenServices.length} ${AppLocalizations.of(context)?.services ?? "services"} (${createAppointment.totalMinutesWithFixed} ${AppLocalizations.of(context)?.min ?? "min"} - ${createAppointment.totalMinutes} ${AppLocalizations.of(context)?.min ?? "min"})",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            color: AppTheme.textBlack,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    createAppointment.totalPrice ==
                                            createAppointment
                                                .totalPricewithFixed
                                        ? "${createAppointment.totalPrice} ${Keys.uah}"
                                        : "${createAppointment.totalPricewithFixed} ${Keys.uah} - ${createAppointment.totalPrice} ${Keys.uah}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            color: AppTheme.textBlack,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                            MaterialButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return const BookingBottomSheetFinal(
                                      showBookButton: false,
                                    );
                                  },
                                );
                              },
                              color: AppTheme.creamBrownLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                AppLocalizations.of(context)?.show ?? "show",
                                style: AppTheme.bodyText1
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        if (createAppointment.chosenSalon?.ownerType !=
                            OwnerType.singleMaster) ...[
                          ExpansionTile(
                            initiallyExpanded: true,
                            title: Text(
                              AppLocalizations.of(context)?.availableMasters ??
                                  'Available masters',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: AppTheme.creamBrown),
                            ),
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  if (createAppointment
                                      .availableMasters.isEmpty) ...[
                                    SizedBox(
                                      height: 100.h,
                                      width: 1.sw,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          '${AppLocalizations.of(context)?.noMastersAvailableOn} ${Time().getDateInStandardFormat(createAppointment.chosenDay)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                      ),
                                    )
                                  ],
                                  if (createAppointment
                                      .availableMasters.isNotEmpty) ...[
                                    SizedBox(
                                      height: (185 + 48).h,
                                      width: 1.sw,
                                      child: ListView.builder(
                                        itemCount: createAppointment
                                            .availableMasters.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        controller: _mastresListController,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 16.0),
                                            child: Column(
                                              children: [
                                                MastersRowContainer(
                                                  name: Utils().getNameMaster(
                                                      createAppointment
                                                          .availableMasters[
                                                              index]
                                                          .personalInfo),
                                                  imageUrl: createAppointment
                                                      .availableMasters[index]
                                                      .profilePicUrl,
                                                  rating: createAppointment
                                                      .availableMasters[index]
                                                      .avgRating,
                                                  onTap: () async {
                                                    String res = await createAppointment
                                                        .chooseMaster(
                                                            masterModel:
                                                                createAppointment
                                                                        .availableMasters[
                                                                    index],
                                                            context: context);
                                                    printIt(res);
                                                    if (res == "choosen") {
                                                      showToast(
                                                          AppLocalizations.of(
                                                                      context)
                                                                  ?.selected ??
                                                              "selected");
                                                    } else {
                                                      showToast(AppLocalizations
                                                                  .of(context)
                                                              ?.notAvailable ??
                                                          "not available");
                                                    }
                                                  },
                                                  selected: createAppointment
                                                          .chosenMaster
                                                          ?.masterId ==
                                                      createAppointment
                                                          .availableMasters[
                                                              index]
                                                          .masterId,
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${createAppointment.mastersServicesMap[createAppointment.availableMasters[index].masterId]?.length} ${AppLocalizations.of(context)?.services ?? "services"}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2!
                                                          .copyWith(
                                                              color: AppTheme
                                                                  .textBlack,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      "${createAppointment.mastersPriceDurationMap[createAppointment.availableMasters[index].masterId]?.price} ${Keys.uah}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2!
                                                          .copyWith(
                                                              color: AppTheme
                                                                  .textBlack,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ],
                              )
                            ],
                          ),
                        ],
                        ExpansionTile(
                          initiallyExpanded: true,
                          title: Text(
                            AppLocalizations.of(context)?.availableTime ??
                                "Available Time",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: AppTheme.creamBrown),
                          ),
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  width: 1.sw,
                                ),
                                if (createAppointment.slotsStatus ==
                                    Status.loading) ...[
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
                                if (createAppointment.eveningTimeslots.isEmpty &&
                                    createAppointment
                                        .morningTimeslots.isEmpty &&
                                    createAppointment
                                        .eveningTimeslots.isEmpty &&
                                    createAppointment.slotsStatus !=
                                        Status.loading) ...[
                                  SizedBox(
                                    height: 100.h,
                                    width: 1.sw,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          AppLocalizations.of(context)
                                                  ?.noSlotsAvailableTrydifferentDate ??
                                              'no slots available, try different date',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                                if (createAppointment
                                    .morningTimeslots.isNotEmpty) ...[
                                  SizedBox(
                                    height: 28.h,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      AppLocalizations.of(context)?.morning ??
                                          "Morning",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Wrap(
                                    spacing: 10.h,
                                    runSpacing: 10.w,
                                    children: [
                                      for (var slot
                                          in createAppointment.morningTimeslots)
                                        TimeSlotContainer(
                                          time: slot,
                                          valid: createAppointment.validSlots
                                              .contains(slot),
                                          choosen: createAppointment.chosenSlots
                                              .contains(slot),
                                          onTap: () async {
                                            await createAppointment.chooseSlot(
                                                slot, context);
                                          },
                                        ),
                                    ],
                                  ),
                                ],
                                if (createAppointment
                                    .afternoonTimeslots.isNotEmpty) ...[
                                  SizedBox(
                                    height: 28.h,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      AppLocalizations.of(context)?.afternoon ??
                                          "Afternoon",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Wrap(
                                    spacing: 10.h,
                                    runSpacing: 10.w,
                                    children: [
                                      for (var slot in createAppointment
                                          .afternoonTimeslots)
                                        TimeSlotContainer(
                                          time: slot,
                                          valid: createAppointment.validSlots
                                              .contains(slot),
                                          choosen: createAppointment.chosenSlots
                                              .contains(slot),
                                          onTap: () async {
                                            await createAppointment.chooseSlot(
                                                slot, context);
                                          },
                                        ),
                                    ],
                                  ),
                                ],
                                if (createAppointment
                                    .eveningTimeslots.isNotEmpty) ...[
                                  SizedBox(
                                    height: 28.h,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      AppLocalizations.of(context)?.evening ??
                                          "Evening",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Wrap(
                                    spacing: 10.h,
                                    runSpacing: 10.w,
                                    children: [
                                      for (var slot
                                          in createAppointment.eveningTimeslots)
                                        TimeSlotContainer(
                                          time: slot,
                                          valid: createAppointment.validSlots
                                              .contains(slot),
                                          choosen: createAppointment.chosenSlots
                                              .contains(slot),
                                          onTap: () async {
                                            await createAppointment.chooseSlot(
                                                slot, context);
                                          },
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 50.h,
                                  ),
                                ],
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 24.0.w, vertical: 16.h),
                    child: Container(
                      height: 16.h,
                    ),
                  )
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //       horizontal: 24.0.w, vertical: 16.h),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Text(
                  //             AppLocalizations.of(context)?.appointmentFor ??
                  //                 "Appointment for",
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .bodyText1!
                  //                 .copyWith(fontSize: 16),
                  //           ),
                  //           Container(
                  //             height: 38,
                  //             decoration: BoxDecoration(
                  //                 color: AppTheme.creamBrownLight,
                  //                 borderRadius: BorderRadius.circular(20)),
                  //             child: DropdownButton<bool>(
                  //               icon: const Padding(
                  //                 padding: EdgeInsets.only(right: 5.0),
                  //                 child: Icon(
                  //                   Icons.arrow_drop_down,
                  //                   color: Colors.white,
                  //                 ),
                  //               ),
                  //               onChanged: (val) {
                  //                 setState(() {
                  //                   createAppointment.toggleBookedForSelf(
                  //                       forMySelf: val ?? true);
                  //                 });
                  //               },
                  //               hint: Padding(
                  //                 padding: const EdgeInsets.only(left: 16.0),
                  //                 child: Text(
                  //                     createAppointment.bookedForSelf
                  //                         ? AppLocalizations.of(context)
                  //                                 ?.myself ??
                  //                             "Myself"
                  //                         : AppLocalizations.of(context)
                  //                                 ?.anotherPerson ??
                  //                             "Another person",
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .headline2
                  //                         ?.copyWith(fontSize: 15)),
                  //               ),
                  //               // value: forMyself,
                  //               items: [
                  //                 DropdownMenuItem(
                  //                   child: Text(
                  //                     AppLocalizations.of(context)?.myself ??
                  //                         "Myself",
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .headline2
                  //                         ?.copyWith(
                  //                           color: AppTheme.textBlack,
                  //                           fontSize: 16,
                  //                         ),
                  //                   ),
                  //                   value: true,
                  //                   onTap: () {},
                  //                 ),
                  //                 DropdownMenuItem(
                  //                   child: Text(
                  //                     AppLocalizations.of(context)
                  //                             ?.anotherPerson ??
                  //                         "Another person",
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .headline2
                  //                         ?.copyWith(
                  //                           color: AppTheme.textBlack,
                  //                           fontSize: 16,
                  //                         ),
                  //                   ),
                  //                   value: false,
                  //                   onTap: () {},
                  //                 )
                  //               ],
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //       if (!createAppointment.bookedForSelf) ...[
                  //         Padding(
                  //           padding: EdgeInsets.symmetric(vertical: 24.h),
                  //           child: Column(
                  //             children: [
                  //               TextFormField(
                  //                 decoration: InputDecoration(
                  //                   border: OutlineInputBorder(
                  //                     borderRadius: BorderRadius.circular(12),
                  //                     borderSide: BorderSide.none,
                  //                   ),
                  //                   filled: true,
                  //                   fillColor: Colors.white,
                  //                   hintText: AppLocalizations.of(context)
                  //                           ?.clientName ??
                  //                       "Client name",
                  //                   hintStyle: Theme.of(context)
                  //                       .textTheme
                  //                       .bodyText1!
                  //                       .copyWith(
                  //                         fontSize: 14,
                  //                         fontWeight: FontWeight.w300,
                  //                       ),
                  //                 ),
                  //                 onChanged: (val) {
                  //                   createAppointment.bookedForName = val;
                  //                 },
                  //               ),
                  //               SizedBox(
                  //                 height: 12.h,
                  //               ),
                  //               TextFormField(
                  //                 decoration: InputDecoration(
                  //                   border: OutlineInputBorder(
                  //                     borderRadius: BorderRadius.circular(12),
                  //                     borderSide: BorderSide.none,
                  //                   ),
                  //                   filled: true,
                  //                   fillColor: Colors.white,
                  //                   hintText: AppLocalizations.of(context)
                  //                           ?.clientNumber ??
                  //                       "Client number",
                  //                   hintStyle: Theme.of(context)
                  //                       .textTheme
                  //                       .bodyText1!
                  //                       .copyWith(
                  //                         fontSize: 14,
                  //                         fontWeight: FontWeight.w300,
                  //                         // fontStyle: FontStyle.italic,
                  //                       ),
                  //                 ),
                  //                 onChanged: (val) {
                  //                   createAppointment.bookedForPhone = val;
                  //                 },
                  //               ),
                  //               SizedBox(
                  //                 height: 50.h,
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //       SizedBox(
                  //         height: 150.h,
                  //       )
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
            Positioned(
              top: DeviceConstraints.getResponsiveSize(
                  context, 10, 20, 30),
              left: DeviceConstraints.getResponsiveSize(
                  context, 10, 20, 30),
              child: const SafeArea(
                child: BackButtonGlassMorphic(),
              ),
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                height: 60.h,
                width: 1.sw,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(flex: 1, child: SizedBox()),
                    Flexible(
                      flex: 1,
                      child: GestureDetector(
                        key: const ValueKey("continue"),
                        onTap: () async {
                          // _auth.changeFromBooking();
                          _auth.createAppointmentProvider(createAppointment);
                          bool moveAhead = createAppointment
                              .checkSlotsAndMaster(context: context);
                          printIt("it will check");
                          printIt(moveAhead);
                          if (moveAhead) {
                            if(kIsWeb){


                            // checkUser2(context, ref, () {
                            createAppointment.createAppointment2(
                                //  customerModel: _auth.currentCustomer!,
                                context: context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                settings: const RouteSettings(
                                    name: ConfirmBooking.route),
                                builder: (context) => ConfirmBooking(
                                  appointment:
                                      createAppointment.appointmentModel!,
                                ),
                              ),
                            );
                            // });
                          }else {
                              createAppointment.createAppointment2(
                                //  customerModel: _auth.currentCustomer!,
                                  context: context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  settings: const RouteSettings(
                                      name: ConfirmBooking.route),
                                  builder: (context) => ConfirmBooking(
                                    appointment:
                                    createAppointment.appointmentModel!,
                                  ),
                                ),
                              );
                            }
                          }
    },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppTheme.creamBrown,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(28),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)?.continue_word ??
                                  "Continue",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TimeSlotContainer extends StatelessWidget {
  final String time;
  final bool choosen;
  final bool valid;
  final Function onTap;
  const TimeSlotContainer({
    Key? key,
    required this.time,
    required this.choosen,
    required this.valid,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (valid) {
          onTap();
        } else {
          showToast(
              AppLocalizations.of(context)?.notAvailable ?? 'Not available');
        }
      },
      child: Container(
        height: 44.h,
        width: 110.h,
        decoration: BoxDecoration(
          color: valid
              ? choosen
                  ? AppTheme.textBlack
                  : Colors.white
              : AppTheme.grey2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
            child: Text(
          time,
          style: Theme.of(context).textTheme.headline3!.copyWith(
                color: choosen ? Colors.white : AppTheme.textBlack,
              ),
        )),
      ),
    );
  }
}

class MastersRowContainer extends StatelessWidget {
  final String? name;
  final String? imageUrl;
  final double? rating;
  final Function onTap;
  final bool selected;
  const MastersRowContainer({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.onTap,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
            color: selected
                ? Colors.white
                : Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppTheme.creamBrownLight : Colors.transparent,
            )),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 16.h),
          child: Center(
            child: PersonAvtar(
              personImageUrl: imageUrl,
              personName: name,
              radius: 35,
              showBorder: false,
              showRating: true,
              rating: rating,
              starSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
