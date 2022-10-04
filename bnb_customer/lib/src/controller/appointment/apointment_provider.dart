import 'package:bbblient/src/controller/home/salon_search_provider.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../firebase/appointments.dart';
import '../../models/enums/status.dart';
import '../../utils/time.dart';

class AppointmentProvider with ChangeNotifier {
  static final DateTime _today = Time().getDate();

  ///todo change first and last date acc.
  DateTime firstDay = _today.subtract(const Duration(days: 60));
  DateTime lastDay = _today.add(const Duration(days: 60));
  // DateTime focusedDay = _today;
  DateTime selectedDay = _today;

  ///holds the appointment for the specific selected day
  List<AppointmentModel> selectedDayAppointments = [];

  ///initially must be null
  /// assigned only once at initialization
  /// contains all the appointments present of an user
  List<AppointmentModel> appointments = [];
  List<SalonModel> appointmentSalons = [];

  //map where [key] is date of appointment and [value] is AppointmentModelMulti
  Map<DateTime, List<AppointmentModel>> appointmentMap = {};

  Status appointmentStatus = Status.loading;

  init() {
    selectedDayAppointments.clear();
    getEventsForDay(selectedDay).forEach((element) => selectedDayAppointments.add(element));
    selectedDayAppointments.sort((a, b) => a.appointmentStartTime.compareTo(b.appointmentStartTime));
    notifyListeners();
  }

  loadAppointments({required String customerId, required SalonSearchProvider salonSearchProvider}) {
    if (appointments.isEmpty) {
      appointmentStatus = Status.loading;
      appointments = [];
      AppointmentApi().listenAppointments(customerId: customerId).listen((event) async {
        appointmentStatus = Status.loading;
        appointments.clear();
        for (AppointmentModel e in event) {
          appointments.add(e);
        }
        _createEvents();
        await init();
        notifyListeners();
      });
    } else {
      appointmentStatus = Status.success;
      notifyListeners();
    }
  }

  onDayChange(
    DateTime _selectedDay,
  ) {
    if (!isSameDay(selectedDay, _selectedDay)) {
      selectedDay = _selectedDay;
      selectedDayAppointments.clear();
      getEventsForDay(selectedDay).forEach((element) => selectedDayAppointments.add(element));
      selectedDayAppointments.sort((a, b) => a.appointmentStartTime.compareTo(b.appointmentStartTime));
      notifyListeners();
    }
  }

  //generates an appointmentMap, so that calendar can access it
  void _createEvents() {
    appointmentMap.clear();
    for (AppointmentModel appointment in appointments) {
      // printIt(appointment.appointmentId);
      // printIt(appointment.appointmentDate);
      if (appointmentMap[appointment.appointmentDate] == null) {
        DateTime? _dateTime = Time().getDateFromStr(appointment.appointmentDate);
        if (_dateTime != null) {
          if (appointmentMap[_dateTime] != null) {
            appointmentMap[_dateTime]?.add(appointment);
            notifyListeners();
          } else {
            appointmentMap[_dateTime] = [];
            appointmentMap[_dateTime]!.add(appointment);
            notifyListeners();
          }
        }
      }
    }
    // printIt(appointmentMap);
  }

  List<AppointmentModel> getEventsForDay(DateTime _date) {
    DateTime date = Time().getDate(date: _date);
    // printIt(appointmentMap[date]);
    if (appointmentMap.containsKey(date) && appointmentMap[date] != null && appointmentMap[date]!.isNotEmpty) {
      // printIt(appointmentMap[date]);
      return appointmentMap[date] ?? [];
    } else {
      return [];
    }
  }
}
