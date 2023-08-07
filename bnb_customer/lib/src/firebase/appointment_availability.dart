// ignore_for_file: unnecessary_null_comparison

import 'package:bbblient/src/models/backend_codings/working_hours.dart';
import 'package:bbblient/src/models/cat_sub_service/price_and_duration.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:flutter/material.dart';

class AppointmentAvailability {
  final Time _time = Time();

  // returns the service charge from service and master data
  PriceAndDurationModel getPriceAndDuration(ServiceModel? service, MasterModel master) {
    try {
      if (service != null && master != null && service.serviceId != null && master.servicesPriceAndDuration != null) {
        debugPrint('master price${master.servicesPriceAndDuration![service.serviceId]!.price}');
        return master.servicesPriceAndDuration![service.serviceId] ?? PriceAndDurationModel();
      }
    } catch (e) {
      debugPrint('getPriceAndDuration() - ${e.toString()}');
    }
    return PriceAndDurationModel();
  }

  /// get all slot for the day
  /// note:it is different from getAvailableSlots
  List<String>? getAllSlots(
    Map<String, dynamic>? blockedTime,
    DateTime date, {
    WorkingHoursModel? workingHours,
    Hours? hours,
    MasterModel? master,
    Map<String, Hours>? irregularWorkingHours,
    required bool isSingleMaster,
    required SalonModel salon,
  }) {
    try {
      DateTime currentTime = DateTime.now();
      print(date.isSameDate(currentTime));
      if (!date.isSameDate(currentTime) && !currentTime.isBefore(date)
          //   DateTime(currentTime.day,currentTime.year,currentTime.month)

          ) {
        return null;
      }
      List<String> _availableSlots = [];

      final String _dateKey = _time.getDateInStandardFormat(date);

      Hours? _hours;
      //selecting between WorkingHours and hours option
      final bool _chooseIrregularHours = (irregularWorkingHours != null && irregularWorkingHours.containsKey(_dateKey) && irregularWorkingHours[_dateKey] != null && irregularWorkingHours[_dateKey]!.isWorking);

      if (_chooseIrregularHours) {
        final _dateKey = Time().getDateInStandardFormat(date);
        _hours = irregularWorkingHours[_dateKey];
        (_dateKey);
        (_hours!.toJson());
      } else if (hours == null) {
        _hours = _time.getRegularWorkingHoursFromDate(workingHours, date: date);
      } else {
        _hours = hours;
      }

      if (_hours == null || !_hours.isWorking) return null;

      //computing start and end time acc to different parameters
      TimeOfDay? _startTime;
      TimeOfDay? _endTime;
      if (_chooseIrregularHours) {
        _startTime = _computeStartTime(_hours.startTime, date, master: master, irregular: true, isSingleMaster: isSingleMaster, salon: salon);
      } else {
        _startTime = _computeStartTime(_hours.startTime, date, isSingleMaster: isSingleMaster, salon: salon);
      }

      if (_chooseIrregularHours) {
        _endTime = _computeEndTime(_hours.endTime, date, master: master, irregular: true, isSingleMaster: isSingleMaster, salon: salon);
      } else {
        _endTime = _computeEndTime(_hours.endTime, date, isSingleMaster: isSingleMaster, salon: salon);
      }
      //  retrieving all the available slots
      ('timesss $_startTime $_endTime');
      Iterable<String> _slots = _time.generateTimeSlots(_startTime, _endTime);
      if (_slots.isEmpty) return null;
      ('slotsss$_slots');
      _availableSlots.addAll(_slots);

      return (_availableSlots.isEmpty) ? null : _availableSlots.toList();
    } catch (e) {
      ('Error while generating slots');
      (e);
      return null;
    }
  }

  /// computes the end time
  /// by comparing following parameters : masterEndTime, salonEndTime
  TimeOfDay? _computeEndTime(String? masterEndTime, DateTime date, {MasterModel? master, bool irregular = false, required bool isSingleMaster, required SalonModel salon}) {
    try {
      if (isSingleMaster) return _time.stringToTime(masterEndTime!);

      //getting salon timings
      Hours? selectedSalonHours;
      if (irregular) {
        selectedSalonHours = _time.getMasterIrregularWorkingHours(
          master!,
          date: date,
        )!;
        // if it's still null then we reverted to old version
        if (selectedSalonHours == null) {
          selectedSalonHours = _time.getIrregularWorkingHours(
            salon.irregularWorkingHours,
            date: date,
          );
        }
      } else {
        selectedSalonHours = _time.getRegularWorkingHoursFromDate(
          salon.workingHours,
          weekDay: date.weekday,
        )!;
      }

      if (!selectedSalonHours!.isWorking) return null;

      TimeOfDay _salonEndTime = _time.stringToTime(selectedSalonHours.endTime);

      TimeOfDay _masterEndTime = _time.stringToTime(masterEndTime!);

      // computes the ending time by comparing master and salon starting time [master and salon fused timing]
      return _time.getMinMaxTime(_salonEndTime, _masterEndTime, returnMaxTime: false);
    } catch (e) {
      ('error while generating end time');
      (e);
      return _time.stringToTime(masterEndTime!);
    }
  }

  /// computes the start time
  /// by comparing following parameters :
  /// 1. masterStartTime
  /// 2. salonStartTime
  /// 3. currentTime
  /// it will take which ever is max
  /// in case of single master it will not fuse salonStartTime and masterStartTime, since only 1 is present
  TimeOfDay? _computeStartTime(String? masterStartTime, DateTime date, {MasterModel? master, bool irregular = false, required bool isSingleMaster, required SalonModel salon}) {
    try {
      DateTime _now = DateTime.now();

      late TimeOfDay _masterAndSalonFusedTime;
      // added this on the fly..but it seems to solve the problem
      _masterAndSalonFusedTime = _time.stringToTime(masterStartTime!);
      if (isSingleMaster) {
        _masterAndSalonFusedTime = _time.stringToTime(masterStartTime);
      } else {
        //getting salon timings
        Hours? selectedSalonHours;
        if (irregular) {
          selectedSalonHours = _time.getMasterIrregularWorkingHours(
            master!,
            date: date,
          )!;
          // if it's still null then we reverted to old version
          if (selectedSalonHours == null) {
            selectedSalonHours = _time.getIrregularWorkingHours(
              salon.irregularWorkingHours,
              date: date,
            );
          }
        } else {
          selectedSalonHours = _time.getRegularWorkingHoursFromDate(
            salon.workingHours,
            weekDay: date.weekday,
          )!;
        }
        if (!selectedSalonHours!.isWorking) return null;

        TimeOfDay _salonStartTime = _time.stringToTime(selectedSalonHours.startTime);

        TimeOfDay _masterStartTime = _time.stringToTime(masterStartTime);

        // computes the starting time by comparing master and salon starting time
        TimeOfDay _masterAndSalonFusedTime = _time.getMinMaxTime(_salonStartTime, _masterStartTime, returnMaxTime: true);
      }

      if (_time.compareDate(date, _now)) {
        //dates are same, Then it
        // computes the start time by comparing current time and master working time

        // for the effect of restricted time before appointment
        if (salon.appointmentsLeadTime != null) {
          _now = _now.add(Duration(minutes: salon.appointmentsLeadTime!));
        }
        TimeOfDay _currentTime = TimeOfDay(hour: _now.hour, minute: _now.minute);
        return _time.getMinMaxTime(_currentTime, _masterAndSalonFusedTime, returnMaxTime: true);
      } else {
        return _masterAndSalonFusedTime;
      }
    } catch (e) {
      ('error while generating start time');
      (e);
      return _time.stringToTime(masterStartTime!);
    }
  }

  //can accept either workingHours or hours depending upon the regular and irregular timings
  /// returns list of available slots from the master's schedule of working hours
  List<String>? getAvailableSlots(
    Map<String, dynamic>? blockedTime,
    DateTime date, {
    WorkingHoursModel? workingHours,
    Hours? hours,
    MasterModel? master,
    Map<String, Hours>? irregularWorkingHours,
    required bool isSingleMaster,
    required SalonModel salon,
  }) {
    try {
      DateTime currentTime = DateTime.now();
      if (!date.isSameDate(currentTime) && date.isBefore(currentTime)) return null;

      //if (date.isBefore(DateTime.now())) return null;

      List<String> _availableSlots = [];

      final String _dateKey = _time.getDateInStandardFormat(date);

      Hours? _hours;
      //selecting between WorkingHours and hours option
      final bool _chooseIrregularHours = (irregularWorkingHours != null && irregularWorkingHours.containsKey(_dateKey) && irregularWorkingHours[_dateKey] != null && irregularWorkingHours[_dateKey]!.isWorking);
      if (_chooseIrregularHours) {
        final _dateKey = Time().getDateInStandardFormat(date);
        _hours = irregularWorkingHours[_dateKey];
        (_dateKey);
        (_hours!.toJson().toString());
      } else if (hours == null) {
        _hours = _time.getRegularWorkingHoursFromDate(workingHours, date: date);
      } else {
        _hours = hours;
      }

      if (_hours == null || !_hours.isWorking) return null;

      //computing start and end time acc to different parameters
      TimeOfDay? _startTime;
      TimeOfDay? _endTime;
      if (_chooseIrregularHours) {
        _startTime = _computeStartTime(_hours.startTime, date, master: master, irregular: true, isSingleMaster: isSingleMaster, salon: salon);
      } else {
        _startTime = _computeStartTime(_hours.startTime, date, isSingleMaster: isSingleMaster, salon: salon);
      }

      if (_chooseIrregularHours) {
        _endTime = _computeEndTime(_hours.endTime, date, master: master, irregular: true, isSingleMaster: isSingleMaster, salon: salon);
      } else {
        _endTime = _computeEndTime(_hours.endTime, date, isSingleMaster: isSingleMaster, salon: salon);
      }
      //  retrieving all the available slots

      Iterable<String> _slots = _time.generateTimeSlots(_startTime, _endTime);

      if (_slots.isEmpty) return null;
      _availableSlots.addAll(_slots);

      //removes the break time from the available slots
      if (_hours.isBreakAvailable != null && _hours.isBreakAvailable == true) {
        _time.generateTimeSlots(_time.stringToTime(_hours.breakStartTime), _time.stringToTime(_hours.breakEndTime)).forEach((element) {
          if (_availableSlots.contains(element)) _availableSlots.remove(element);
        });
      }

      //removes all the pre-occupied slots
      if (blockedTime != null && blockedTime.isNotEmpty && blockedTime[_dateKey] != null && blockedTime[_dateKey].isNotEmpty) {
        blockedTime[_dateKey].forEach((slot) {
//blockTimeList.add(slot);
          _availableSlots.remove(slot);
        });
      }

      return (_availableSlots.isEmpty)
          ? null
          :
          // removeTimeRange(_availableSlots.toList(), blockTimeList.first, blockTimeList.last);
          _availableSlots.toList();
    } catch (e) {
      ('Error while generating slots');
      (e);
      return null;
    }
  }
}
