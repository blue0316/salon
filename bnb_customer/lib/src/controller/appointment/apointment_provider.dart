import 'package:bbblient/src/controller/home/salon_search_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/firebase/appointments.dart';
import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/firebase/customer_web_settings.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/customer_web_settings.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/themes/utils/theme_color.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
  Status updateSubStatus = Status.init;
  Status cancelAppointmentStatus = Status.init;

  // CustomerWebSettings? themeSettings;
  ThemeData? salonTheme;

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

  Future<AppointmentModel?> fetchAppointment({required String appointmentID}) async {
    appointmentStatus = Status.loading;
    notifyListeners();
    try {
      DocumentSnapshot appointmentDoc = await Collection.appointments.doc(appointmentID).get();

      // print('***********************');
      // print(appointmuentDoc);
      // print(appointmentDoc.data());
      // print('***********************');

      if (!appointmentDoc.exists) {
        appointmentStatus = Status.success;
        notifyListeners();
        return null;
      }

      Map<String, dynamic> _temp = appointmentDoc.data() as Map<String, dynamic>;

      AppointmentModel appointment = AppointmentModel.fromJson(_temp);
      appointmentStatus = Status.success;
      notifyListeners();

      return appointment;
    } catch (e) {
      printIt('Error on fetchAppointment() - ${e.toString()}');
      appointmentStatus = Status.failed;
      notifyListeners();
    }

    return null;
  }

  void updateAppointmentSubStatus({required String appointmentID, Function? callback}) async {
    updateSubStatus = Status.loading;
    notifyListeners();
    try {
      await Collection.appointments.doc(appointmentID).set(
        {
          'status': 'confirmed',
          'subStatus': 'confirmed',
          'updates': FieldValue.arrayUnion(['confirmedByCustomer'])
        },
        SetOptions(merge: true),
      );

      // SHOW TOAST
      showToast('YOUR APPOINTMENT HAS BEEN CONFIRMED');

      // REFRESH SCREEN
      callback!();

      updateSubStatus = Status.success;
      notifyListeners();
    } catch (e) {
      printIt('Error on updateAppointmentSubStatus() - ${e.toString()}');
      updateSubStatus = Status.failed;
      notifyListeners();
    }
  }

  void cancelAppointment({required String appointmentID, Function? callback}) async {
    cancelAppointmentStatus = Status.loading;
    notifyListeners();
    try {
      await Collection.appointments.doc(appointmentID).set(
        {
          'status': 'cancelled',
          'subStatus': 'cancelledbyClient',
          'updates': FieldValue.arrayUnion(['cancelledByCustomer'])
        },
        SetOptions(merge: true),
      );

      // SHOW TOAST
      showToast('YOUR APPOINTMENT HAS BEEN CANCELLED');

      // REFRESH SCREEN
      callback!();

      cancelAppointmentStatus = Status.success;
      notifyListeners();
    } catch (e) {
      printIt('Error on cancelAppointment() - ${e.toString()}');
      cancelAppointmentStatus = Status.failed;
      notifyListeners();
    }
  }

  void getSalonTheme(salonId) async {
    print('----------------------------');
    print(salonId);
    print('----------------------------');

    CustomerWebSettings? themeSettings = await CustomerWebSettingsApi().getSalonTheme(salonId: salonId);

    // print('----------------------------');

    // print('----------------------------');

    getTheme(themeSettings);
  }

  void getTheme(CustomerWebSettings? themeSettings) {
    if (availableThemes.contains(themeSettings?.theme?.testId)) {
      switch (themeSettings?.theme?.testId) {
        case '1':
          salonTheme = getDefaultDarkTheme(themeSettings?.theme?.colorCode);
          notifyListeners();
          break;

        case '0':
          salonTheme = getDefaultLightTheme(themeSettings?.theme?.colorCode);
          notifyListeners();
          break;

        case '2':
          salonTheme = getGlamDataTheme(themeSettings?.theme?.colorCode);
          notifyListeners();
          break;

        case '3':
          salonTheme = getGlamBarbershopTheme(themeSettings?.theme?.colorCode);
          notifyListeners();
          break;

        case '4':
          salonTheme = getGlamGradientTheme(themeSettings?.theme?.colorCode);
          notifyListeners();
          break;

        case '5':
          salonTheme = getBarbershopTheme(themeSettings?.theme?.colorCode);
          notifyListeners();
          break;

        case '6':
          salonTheme = getGlamLightTheme(themeSettings?.theme?.colorCode);
          notifyListeners();
          break;

        case '7':
          salonTheme = getGlamMinimalLightTheme(themeSettings?.theme?.colorCode);
          notifyListeners();
          break;

        case '8':
          salonTheme = getGlamMinimalDarkTheme(themeSettings?.theme?.colorCode);
          notifyListeners();
          break;
      }
    } else {
      salonTheme = getDefaultLightTheme(themeSettings?.theme?.colorCode);
      notifyListeners();
    }
  }
}

// http://localhost:58317/appointments?id=KFobyqnivYiOHNJvWI12