import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/backend_codings/working_hours.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//handles the time slots
//time slot size is 15 min

class Time {
  static const Duration _timeSlotSize = Duration(minutes: 15);

  Duration timeSlotSize = const Duration(minutes: 15);

  int? toMinutes(TimeOfDay myTime) {
    try {
      return (myTime.hour * 60) + myTime.minute;
    } catch (e) {
      printIt(e);
      return null;
    }
  }

  //rounds of the time in timeSlotSize
  //input   :   3:21
  //output  :   3:15 or 3:30
  TimeOfDay? roundOfTime(TimeOfDay? time, {toFloor = true, Duration step = _timeSlotSize}) {
    if (time == null) return null;
    try {
      int hours = time.hour;
      int minutes = time.minute;
      final int remainder = minutes.remainder(step.inMinutes);

      if (remainder == 0) {
        return time;
      } else {
        if (toFloor) {
          minutes -= remainder;

          if (minutes < 0) minutes = 0;
        } else {
          minutes += (step.inMinutes - remainder);
          if (minutes >= 60) {
            minutes = 0;
            hours++;
          }
        }
        return TimeOfDay(hour: hours, minute: minutes);
      }
    } catch (e) {
      printIt(e);
      return null;
    }
  }

  //returns the working hours on the basis of week day
  Hours? getRegularWorkingHoursFromDate(WorkingHoursModel? workingHours, {int? weekDay, DateTime? date}) {
    if (weekDay == null) {
      DateTime _date = date ?? DateTime.now();
      weekDay = _date.weekday;
    }
    if (workingHours == null) return null;

    try {
      switch (weekDay) {
        case 1:
          return workingHours.mon;
        case 2:
          return workingHours.tue;
        case 3:
          return workingHours.wed;
        case 4:
          return workingHours.thu;
        case 5:
          return workingHours.fri;
        case 6:
          return workingHours.sat;
        case 7:
          return workingHours.sun;
        default:
          return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  //returns true if two list contains same element/slot
  bool listOverLaps(List list1, List list2) {
    if (list1.isEmpty || list2.isEmpty) {
      return false;
    } else {
      for (String element in list1) {
        if (list2.contains(element)) return true;
      }
    }
    return false;
  }

  bool checkForTimeClash(TimeOfDay startA, TimeOfDay endA, TimeOfDay startB, TimeOfDay endB) {
    // [A] ====================||||||||||||||==============
    // [B] ======||||||||||================================
    if (compareTime(endB, startA) == 1) return false;
    // [A] ====================||||||||||||||==============
    // [B] =====================================|||||||||==
    if (compareTime(endA, startB) == 1) return false;
    return true;
  }

  //takes in time slots and removes the duplicate slots in it
  //input : [12:30,12:45,12:30,01:00,12:45]
  //output : [12:30,12:45,01:00]
  List<String> removeDuplicateSlots(List<String>? input) {
    try {
      if (input == null || input.isEmpty) return [];
      return input.toSet().toList();
    } catch (e) {
      printIt(e);
    }
    return [];
  }
  //  returns the time slots between start and end time with gap of [_timeSlotSize]
  ///  sample input getTimeSlots( TimeOfDay(hour:10,minute:05) , TimeOfDay(hour:10,minute:55) )
  ///  if(inclusive = false) output : (10:15, 10:30)
  //  if inclusive is true, then it will return all the bisect time slots also, to make sure no booking overlaps
  ///  if(inclusive = true) output : (10:00, 10:15, 10:30, 10:45)

  Iterable<String> getTimeSlots(TimeOfDay? startTime, TimeOfDay? endTime, {Duration step = _timeSlotSize, inclusive = false}) sync* {
    //if start time greater than end time then break off

    if (startTime == null || endTime == null || compareTime(endTime, startTime) == 1) return;

    if (inclusive) {
      startTime = roundOfTime(startTime, toFloor: true, step: step);
      endTime = roundOfTime(endTime, toFloor: false, step: step);
    } else {
      startTime = roundOfTime(startTime, toFloor: false, step: step);
      endTime = roundOfTime(endTime, toFloor: true, step: step);
    }
    int hour = startTime!.hour;
    int minute = startTime.minute;

    do {
      yield timeToString(TimeOfDay(hour: hour, minute: minute))!;
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime!.hour || (hour == endTime.hour && minute < endTime.minute));
  }

  //  returns the time slots between start and end time with gap of [timeSlotSize]
  ///  sample input getTimeSlots( TimeOfDay(hour:10,minute:05) , TimeOfDay(hour:10,minute:55) )
  ///  if(inclusive = false) output : (10:15, 10:30)
  //  if inclusive is true, then it will return all the bisect time slots also, to make sure no booking overlaps
  ///  if(inclusive = true) output : (10:00, 10:15, 10:30, 10:45)
  Iterable<String> generateTimeSlots(TimeOfDay? startTime, TimeOfDay? endTime, {Duration? step, inclusive = false, int? timeSlotSizeDuration}) sync* {
    timeSlotSize = Duration(minutes: timeSlotSizeDuration ?? 15);
    step ??= timeSlotSize;
    //if start time greater than end time then break off
    if (startTime == null || endTime == null || compareTime(endTime, startTime) == 1) return;

    if (inclusive) {
      startTime = roundOfTime(startTime, toFloor: true);
      endTime = roundOfTime(endTime, toFloor: false);
    } else {
      startTime = roundOfTime(startTime, toFloor: false);
      endTime = roundOfTime(endTime, toFloor: true);
    }
    int hour = startTime!.hour;
    int minute = startTime.minute;

    do {
      yield timeToString(TimeOfDay(hour: hour, minute: minute))!;
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime!.hour || (hour == endTime.hour && minute < endTime.minute));
  }

  Iterable<String> generateTimeSlotsForBlock(TimeOfDay? startTime, TimeOfDay? endTime, {Duration? step, inclusive = false, int? timeSlotSizeDuration}) sync* {
    timeSlotSize = const Duration(minutes: 1);
    step ??= timeSlotSize;
    //if start time greater than end time then break off
    if (startTime == null || endTime == null || compareTime(endTime, startTime) == 1) return;

    if (inclusive) {
      startTime = roundOfTime(startTime, toFloor: true);
      endTime = roundOfTime(endTime, toFloor: false);
    } else {
      startTime = roundOfTime(startTime, toFloor: false);
      endTime = roundOfTime(endTime, toFloor: true);
    }
    int hour = startTime!.hour;
    int minute = startTime.minute;

    do {
      yield timeToString(TimeOfDay(hour: hour, minute: minute))!;
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime!.hour || (hour == endTime.hour && minute < endTime.minute));
  }

  // Iterable<String> generateTimeSlots(TimeOfDay startTime, TimeOfDay endTime, {Duration step = _timeSlotSize, inclusive = false}) sync* {
  //   //if start time greater than end time then break off

  //   if (compareTime(endTime, startTime) == 1) {
  //     return;
  //   } else {
  //     TimeOfDay? _startTime;
  //     TimeOfDay? _endTime;
  //     if (inclusive) {
  //       _startTime = roundOfTime(startTime, toFloor: true, step: step);
  //       _endTime = roundOfTime(endTime, toFloor: false, step: step);
  //     } else {
  //       _startTime = roundOfTime(startTime, toFloor: false, step: step);
  //       _endTime = roundOfTime(endTime, toFloor: true, step: step);
  //     }
  //     if (_startTime != null && _endTime != null) {
  //       int hour = _startTime.hour;
  //       int minute = startTime.minute;
  //       do {
  //         yield timeToString(TimeOfDay(hour: hour, minute: minute)) ?? '';
  //         minute += step.inMinutes;
  //         while (minute >= 60) {
  //           minute -= 60;
  //           hour++;
  //         }
  //       } while (hour < endTime.hour || (hour == endTime.hour && minute < endTime.minute));
  //     }
  //   }
  // }

  //returns the common time/element slots between two lists
  List<String> getCommonSlots(List<String>? list1, List<String>? list2) {
    if (list1 == null || list1.isEmpty || list2 == null || list2.isEmpty) {
      return [];
    }
    List<String> list = [];

    for (String slot in list1) {
      if (list2.contains(slot)) list.add(slot);
    }
    return list;
  }

  //takes in the list of sorted slots and convert them into
  // list of available slots acc to the service
  //so if a service is of 60 min then it will check 60 min of available timing
  checkAvailableSlotsForTheServiceTime(List<String> slotsInString, int minutes) {
    List<TimeOfDay> slots = slotsInString.map((e) => stringToTime(e)).toList();
    List<String> availableSlots = [];

    for (int i = 0; i < slots.length; i++) {
      int slotsReq = (minutes / _timeSlotSize.inMinutes).ceil();
      for (int j = 0; j < slotsReq; j++) {
        if (i + j >= slots.length) break;
        if (slots[i + j] != slots[i].addMinutes((j * _timeSlotSize.inMinutes))) break;
        if (j == slotsReq - 1) availableSlots.add(slotsInString[i]);
      }
    }

    return (availableSlots.isEmpty) ? null : availableSlots;
  }

  String? timeToString(TimeOfDay time) {
    try {
      String hr = time.hour.toString();
      String min = time.minute.toString();

      if (time.hour <= 9) {
        hr = '0' + hr;
      }
      if (time.minute <= 9) {
        min = '0' + min;
      }
      return "$hr:$min";
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

//////////na this time///check here
  TimeOfDay stringToTime(String time) {
    String hr = time.split(':')[0] == "-" ? "0" : time.split(':')[0];
    String min = time.split(':')[1] == "-" ? "0" : time.split(':')[1];

    return TimeOfDay(hour: int.parse(hr), minute: int.parse(min));
  }

  getAppointmentString(String? appointment, int appointmentDurationInMin) {
    try {
      if (appointment == null || appointmentDurationInMin == null) {
        return null;
      }
      return "$appointment  - ${timeToString(stringToTime(appointment).addMinutes(appointmentDurationInMin))}";
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  //returns the DateTime from TimeOfDay
  getDateFromTimeOfDay(TimeOfDay time) {
    DateTime _date = getDate();

    return DateTime(_date.year, _date.month, _date.day, time.hour, time.minute);
  }

  //takes in masterModel and specific date to compare with
  //if master is working then returns true else returns false
  bool isWorking(MasterModel master, {DateTime? date}) {
    try {
      final Hours? workingTIme = Time().getMasterWorkingHour(master, date: date);
      TimeOfDay _now;
      if (date != null) {
        _now = TimeOfDay(hour: date.hour, minute: date.minute);
      } else {
        _now = TimeOfDay.now();
      }

      if (!(workingTIme?.isWorking ?? false)) {
        return false;
      } else {
        final TimeOfDay start = stringToTime(workingTIme!.startTime);
        final TimeOfDay end = stringToTime(workingTIme.endTime);

        if (compareTime(start, _now) == 1 && compareTime(_now, end) == 1) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  //takes in the masterModel  and returns the working status
  Hours? getMasterWorkingHour(MasterModel master, {DateTime? date}) {
    DateTime _date = date ?? DateTime.now();

    switch (_date.weekday) {
      case 1:
        return master.workingHours!.mon;
      case 2:
        return master.workingHours!.tue;
      case 3:
        return master.workingHours!.wed;
      case 4:
        return master.workingHours!.thu;
      case 5:
        return master.workingHours!.fri;
      case 6:
        return master.workingHours!.sat;
      case 7:
        return master.workingHours!.sun;
      default:
        return null;
    }
  }

  String getWeekDay(DateTime date, context, bool long) {
    String day = DateFormat("EEEE", AppLocalizations.of(context)?.localeName ?? 'en').format(date);
    return long ? day : day.substring(0, 3);
    // if (date == getDate()) {
    //   AppLocalizations.of(context)?.today ?? "today";
    // } else if (date == getDate().add(const Duration(days: 1))) {
    //   AppLocalizations.of(context)?.today ?? "today";
    // }
    // try {
    //   return Jiffy(date).EEEE;
    // } catch (e) {
    //   debugPrint(e.toString());
    //   return '';
    // }
  }

  //returns the date only  from DateTime object
  getDate({DateTime? date}) {
    DateTime now = date ?? DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  //creates a DateTime object from date and time (in String)
  generateDateTimeFromString(DateTime date, String time) {
    try {
      TimeOfDay _appointmentTime = Time().stringToTime(time);

      return DateTime(date.year, date.month, date.day, _appointmentTime.hour, _appointmentTime.minute);
    } catch (e) {
      printIt(e);
      return date;
    }
  }

  DateTime? parseDate(String date) {
    try {
      return DateTime.parse(date);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  String getFormattedDateWithWeekDay(DateTime date) {
    try {
      return Jiffy(date).yMMMEd;
      // DateFormat('EEE, d MMM yyyy').format(date);
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  //returns date in format 12 Mar 2020
  String getFormatedDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    try {
      return Jiffy(date).yMMMEd;
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  String getLocaleDate(DateTime? date, String locale) {
    if (date == null) {
      return '';
    }
    try {
      String _date = DateFormat("EE, d MMM, yyyy", locale).format(date);
      return _date.replaceAll('.', '');
      // return Jiffy(date).yMMMEd;
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  String getLocaleDate2(DateTime? date, String locale) {
    if (date == null) {
      return '';
    }
    try {
      String _date = DateFormat("dd MMM yyyy hh:mm", locale).format(date);
      return _date.replaceAll('.', '');
      // return Jiffy(date).yMMMEd;
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  //returns date in format 12.01.20
  String getFormattedDate2(DateTime date) {
    try {
      return Jiffy(date).format('dd.MM.yyyy');
      // DateFormat('dd.MM.yyyy').format(date);
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  String getTimeFromDate(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    try {
      return DateFormat.Hm().format(dateTime);
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  // returns the time slot from the appointment
  // eg. 04:30-05:30
  String? getSlot(AppointmentModel appointment) {
    return "${appointment.appointmentTime} - ${getAppointmentEndTime(appointment)}";
  }

  // returns the appointment end time in string
  // eg. 04:30
  String? getAppointmentEndTime(AppointmentModel appointment) {
    if (appointment.appointmentTime != '' && appointment.priceAndDuration.duration != '0' && appointment.priceAndDuration.duration != '0') {
      TimeOfDay time1 = stringToTime(appointment.appointmentTime);
      TimeOfDay time2 = time1.addMinutes(int.parse(appointment.priceAndDuration.duration!));
      return timeToString(time2);
    } else {
      return appointment.appointmentTime;
    }
  }

  String? getAppointmentStartEndTime(AppointmentModel appointment) {
    if (appointment.appointmentTime != '' && appointment.priceAndDuration.duration != '0' && appointment.priceAndDuration.duration != '0') {
      TimeOfDay time1 = stringToTime(appointment.appointmentTime);
      TimeOfDay time2 = time1.addMinutes(int.parse(appointment.priceAndDuration.duration!));
      String? _time2 = timeToString(time2);
      String? _time1 = timeToString(time1);
      return "$_time1-$_time2";
    } else {
      return appointment.appointmentTime;
    }
  }

  String? getAppointmentStartEndTimeWithTimeFormat(AppointmentModel appointment, SalonModel salonModel) {
    if (appointment.appointmentTime != '' && appointment.priceAndDuration.duration != '0' && appointment.priceAndDuration.duration != '0') {
      TimeOfDay time1 = stringToTime(appointment.appointmentTime);
      TimeOfDay time2 = time1.addMinutes(int.parse(appointment.priceAndDuration.duration!));
      String? _time2 = timeToString(time2);
      String? _time1 = timeToString(time1);

      if (salonModel.timeFormat == TimeFormat.amPM) {
        return "$_time1-$_time2";
      } else {
        // 24 HR

        DateTime fromTime = DateFormat("hh:mma").parse(time1.toString());
        DateTime toTime = DateFormat("hh:mma").parse(time2.toString());

        return "${DateFormat('HH:mm').format(fromTime)}-${DateFormat('HH:mm').format(toTime)}";
      }
    } else {
      return appointment.appointmentTime;
    }
  }

  //takes in min and then generates time in hr and min from it
  //input : 125
  //output : 2 Hr 5 Min
  String convertMinToTime(String minStr) {
    try {
      int min = int.parse(minStr);

      TimeOfDay _time = const TimeOfDay(minute: 0, hour: 0).addMinutes(min);

      if (_time.hour < 1) {
        return "${_time.minute} Min";
      } else {
        return "${_time.hour} Hr ${_time.minute} Min";
      }
    } catch (e) {
      printIt(e);
      return '';
    }
  }

  //  converts datetime into int
  int toInt(TimeOfDay myTime) => (myTime.hour * 60) + myTime.minute;

  /// compare two datetime
  //  returns 1 if startTime is less than end Time, -1 if vice-versa & 0 if same
  int compareTime(TimeOfDay startTime, TimeOfDay endTime) {
    int start = toInt(startTime);
    int end = toInt(endTime);
    if (start == end) return 0;
    if (start > end) return -1;
    return 1;
  }

  // compares two [TimeOfDay] object and returns either max or min of the two
  TimeOfDay getMinMaxTime(TimeOfDay startTime, TimeOfDay endTime, {bool returnMaxTime = true}) {
    if (compareTime(startTime, endTime) == 1) {
      return returnMaxTime ? endTime : startTime;
    } else {
      return returnMaxTime ? startTime : endTime;
    }
  }

  /// compare two DateTime
  // returns true if dates are same else false
  bool compareDate(DateTime? date1, DateTime? date2) {
    try {
      if (date1 == null || date2 == null) {
        return false;
      }
      if (date1.day == date2.day && date1.month == date2.month && date1.year == date2.year) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printIt(e);
      return false;
    }
  }

//converts date into datetime object
  DateTime? getDateFromStr(String dateStr) {
    try {
      final List dateList = dateStr.split('-');
      final int _day = int.parse(dateList[2]);
      final int _month = int.parse(dateList[1]);
      final int _year = int.parse(dateList[0]);
      return DateTime(_year, _month, _day);
    } catch (e) {
      printIt('exception caught while parsing date to DateTime Obj');
      printIt(e);
      return null;
    }
  }

  // returns the standard date format to store as a key in DB
  /// format: yyyy-mm-dd
  getDateInStandardFormat(DateTime date) {
    try {
      final int _year = date.year;
      final int _month = date.month;
      final int _day = date.day;

      String _yearStr = _year.toString();
      String _monthStr = "${_month < 10 ? "0" : ""}$_month";
      String _dayStr = "${_day < 10 ? "0" : ""}$_day";

      return "$_yearStr-$_monthStr-$_dayStr";
    } catch (e) {
      printIt(e);
      return '';
    }
  }

  //returns the working hours on the basis of week day
  Hours? getWorkingHoursFromWeekDay(int day, WorkingHoursModel? workingHours) {
    if (workingHours == null) {
      return null;
    }

    try {
      switch (day) {
        case 1:
          return workingHours.mon;
        case 2:
          return workingHours.tue;
        case 3:
          return workingHours.wed;
        case 4:
          return workingHours.thu;
        case 5:
          return workingHours.fri;
        case 6:
          return workingHours.sat;
        case 7:
          return workingHours.sun;
        default:
          return null;
      }
    } catch (e) {
      printIt(e);
      return null;
    }
  }

  Hours? getIrregularWorkingHours(Map<String, Hours>? irregularHours, {DateTime? date}) {
    DateTime _date = date ?? DateTime.now();

    try {
      final dateKey = getDateInStandardFormat(_date);
      if (irregularHours != null && irregularHours.containsKey(dateKey)) {
        if (irregularHours[dateKey]!.isWorking) return irregularHours[dateKey];
      }
    } catch (e) {
      //(e);
    }
    return null;
  }

  Hours? getMasterIrregularWorkingHours(MasterModel master, {DateTime? date}) {
    DateTime _date = date ?? DateTime.now();

    try {
      final dateKey = getDateInStandardFormat(_date);
      if (master.irregularWorkingHours != null && master.irregularWorkingHours!.containsKey(dateKey)) {
        if (master.irregularWorkingHours![dateKey]!.isWorking) return master.irregularWorkingHours![dateKey];
      }
    } catch (e) {
      //(e);
    }
    return null;
  }

  Iterable<String> generateTimeSlotsBlock(TimeOfDay? startTime, TimeOfDay? endTime, {Duration? step, inclusive = false}) sync* {
    timeSlotSize = const Duration(minutes: 1);
    step ??= timeSlotSize;
    //if start time greater than end time then break off
    if (startTime == null || endTime == null || compareTime(endTime, startTime) == 1) return;

    if (inclusive) {
      startTime = roundOfTime(startTime, toFloor: true);
      endTime = roundOfTime(endTime, toFloor: false);
    } else {
      startTime = roundOfTime(startTime, toFloor: false);
      endTime = roundOfTime(endTime, toFloor: true);
    }
    int hour = startTime!.hour;
    int minute = startTime.minute;

    do {
      yield timeToString(TimeOfDay(hour: hour, minute: minute))!;
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime!.hour || (hour == endTime.hour && minute < endTime.minute));
  }
}

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay addMinutes(int? minutes) {
    if (minutes == 0) {
      return this;
    } else {
      int min = hour * 60 + minute;
      int newMin = ((minutes! % 1440) + min + 1440) % 1440;
      if (min == newMin) {
        return this;
      } else {
        int newHour = newMin ~/ 60;
        int newMinute = newMin % 60;
        return TimeOfDay(hour: newHour, minute: newMinute);
      }
    }
  }

  translateDate({required BuildContext context, required DateTime dateTime}) {}
}
