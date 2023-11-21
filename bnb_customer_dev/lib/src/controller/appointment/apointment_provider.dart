import 'dart:convert';
import 'dart:js' as js;

import 'package:bbblient/src/controller/home/salon_search_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/firebase/appointments.dart';
import 'package:bbblient/src/firebase/cancellation_no_show.dart';
import 'package:bbblient/src/firebase/category_services.dart';
import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/firebase/customer_web_settings.dart';
import 'package:bbblient/src/firebase/master.dart';
import 'package:bbblient/src/firebase/salons.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/backend_codings/appointment.dart';
import 'package:bbblient/src/models/cancellation_noShow_policy.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/customer_web_settings.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/mongodb/collection.dart';
import 'package:bbblient/src/mongodb/db_service.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/themes/utils/theme_color.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentProvider with ChangeNotifier {
  AppointmentProvider({required this.mongodbProvider});
  DatabaseProvider mongodbProvider;

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
  Status createNoShowPolicyStatus = Status.init;
  Status appleCalendarStatus = Status.init;

  // CustomerWebSettings? themeSettings;
  ThemeData? salonTheme;
  ThemeType? themeType;
  SalonModel? salon;
  List<MasterModel> allMastersInSalon = [];
  bool isSingleMaster = false;
  String totalDeposit = '0';

  init() {
    selectedDayAppointments.clear();
    getEventsForDay(selectedDay).forEach((element) => selectedDayAppointments.add(element));
    selectedDayAppointments.sort((a, b) => a.appointmentStartTime!.compareTo(b.appointmentStartTime!));
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
      selectedDayAppointments.sort((a, b) => a.appointmentStartTime!.compareTo(b.appointmentStartTime!));
      notifyListeners();
    }
  }

  //generates an appointmentMap, so that calendar can access it
  void _createEvents() {
    appointmentMap.clear();
    for (AppointmentModel appointment in appointments) {
      // // printIt(appointment.appointmentId);
      // // printIt(appointment.appointmentDate);
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
    // // printIt(appointmentMap);
  }

  List<AppointmentModel> getEventsForDay(DateTime _date) {
    DateTime date = Time().getDate(date: _date);
    // // printIt(appointmentMap[date]);
    if (appointmentMap.containsKey(date) && appointmentMap[date] != null && appointmentMap[date]!.isNotEmpty) {
      // // printIt(appointmentMap[date]);
      return appointmentMap[date] ?? [];
    } else {
      return [];
    }
  }

  Future<AppointmentModel?> fetchAppointmentMongo({required String appointmentID}) async {
    appointmentStatus = Status.loading;
    notifyListeners();
    try {
      var appointmentDoc = await mongodbProvider.fetchCollection(CollectionMongo.appointments).findOne(
        filter: {'appointmentId': appointmentID},
      );

      if (appointmentDoc == null) {
        appointmentStatus = Status.init;
        notifyListeners();
        return null;
      }

      Map<String, dynamic> _temp = json.decode(appointmentDoc.toJson()) as Map<String, dynamic>;
      AppointmentModel appointment = AppointmentModel.fromJson(_temp);

      // Get Salon
      salon = await SalonApi(mongodbProvider: mongodbProvider).getSalonFromId(appointment.salon.id);

      // Get Salon Masters
      allMastersInSalon.clear();
      allMastersInSalon = await MastersApi(mongodbProvider: mongodbProvider).getAllSalonMasters(salon!.salonId);
      // Check if single master
      if (allMastersInSalon.length < 2) {
        isSingleMaster = true;
      }

      // Get Salon Theme
      themeType = await getSalonTheme(salon?.salonId);

      // appointmentStatus = Status.success;
      // notifyListeners();

      return appointment;
    } catch (e) {
      // printIt('Error on fetchAppointment() - ${e.toString()}');
      appointmentStatus = Status.failed;
      notifyListeners();
    }

    return null;
  }

  Future<AppointmentModel?> fetchAppointment({required String appointmentID}) async {
    appointmentStatus = Status.loading;
    notifyListeners();
    try {
      DocumentSnapshot appointmentDoc = await Collection.appointments.doc(appointmentID).get();

      if (!appointmentDoc.exists) {
        appointmentStatus = Status.init;
        notifyListeners();
        return null;
      }

      Map<String, dynamic> _temp = appointmentDoc.data() as Map<String, dynamic>;
      AppointmentModel appointment = AppointmentModel.fromJson(_temp);

      // Get Salon
      salon = await SalonApi().getSalonFromId(appointment.salon.id);

      // Get Salon Masters
      allMastersInSalon.clear();
      allMastersInSalon = await MastersApi().getAllSalonMasters(salon!.salonId);
      // Check if single master
      if (allMastersInSalon.length < 2) {
        isSingleMaster = true;
      }

      // Get Salon Theme
      themeType = await getSalonTheme(salon?.salonId);

      // appointmentStatus = Status.success;
      // notifyListeners();

      return appointment;
    } catch (e) {
      // printIt('Error on fetchAppointment() - ${e.toString()}');
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
          'status': 'active',
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
      // printIt('Error on updateAppointmentSubStatus() - ${e.toString()}');
      updateSubStatus = Status.failed;
      notifyListeners();
    }
  }

  void updateAppointmentSubStatusMongo({required String appointmentID, Function? callback}) async {
    updateSubStatus = Status.loading;
    notifyListeners();
    try {
      final selector = {'appointmentId': appointmentID};

      final modifier = UpdateOperator.set({"status": AppointmentStatus.active});
      final modifier3 = UpdateOperator.set({"subStatus": ActiveAppointmentSubStatus.confirmed});

      final modifier2 = UpdateOperator.push({
        "updates": ArrayModifier.each([AppointmentUpdates.confirmedByCustomer]),
        "updatedAt": ArrayModifier.each([DateTime.now()])
      });

      await mongodbProvider.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier);
      await mongodbProvider.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier2);
      await mongodbProvider.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier3);

      // SHOW TOAST
      showToast('YOUR APPOINTMENT HAS BEEN CONFIRMED');

      // REFRESH SCREEN
      callback!();

      updateSubStatus = Status.success;
      notifyListeners();
    } catch (e) {
      printIt('Error on updateAppointmentSubStatusMongo() - ${e.toString()}');
      updateSubStatus = Status.failed;
      notifyListeners();
    }
  }

  void cancelAppointment({
    required String appointmentID,
    Function? callback,
    required bool isSingleMaster,
    required AppointmentModel appointment,
    required SalonModel salon,
    required List<MasterModel> salonMasters,
  }) async {
    cancelAppointmentStatus = Status.loading;
    notifyListeners();
    try {
      //updates the existing appointment

      final selector = {'appointmentId': appointmentID};

      final modifier2 = UpdateOperator.push({
        "updates": ArrayModifier.each([AppointmentUpdates.cancelledBySalon]),
        "updatedAt": ArrayModifier.each([DateTime.now().toIso8601String()])
      });

      final modifier = UpdateOperator.set({
        "status": AppointmentStatus.cancelled,
      });

      await mongodbProvider.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier);
      await mongodbProvider.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier2);

      // UNBLOCK TIME SLOTS
      await AppointmentApi(mongodbProvider: mongodbProvider).updateMultipleAppointment(
        isSingleMaster: isSingleMaster,
        appointmentModel: appointment,
        appointmentSubStatus: ActiveAppointmentSubStatus.cancelledByCustomer,
        appointmentStatus: AppointmentStatus.cancelled,
        salon: salon,
        salonMasters: salonMasters,
      );

      // SHOW TOAST
      showToast('Appointment cancelled succesfully');

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

  void getCategoryDetails(String categoryId) async {}

  Future<ThemeType?> getSalonTheme(salonId) async {
    CustomerWebSettings? themeSettings = await CustomerWebSettingsApi(mongodbProvider: mongodbProvider).getSalonTheme(salonId: salonId);

    return getTheme(themeSettings);
  }

  ThemeType? getTheme(CustomerWebSettings? themeSettings) {
    if (availableThemes.contains(themeSettings?.theme?.id)) {
      switch (themeSettings?.theme?.id) {
        case '1':
          salonTheme = getDefaultDarkTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.DefaultDark;

          notifyListeners();
          return themeType;

        case '0':
          salonTheme = getDefaultLightTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.DefaultLight;

          notifyListeners();
          return themeType;

        case '2':
          salonTheme = getGlamDataTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.Glam;

          notifyListeners();
          return themeType;

        // case '3':
        //   salonTheme = getGlamBarbershopTheme(themeSettings?.theme?.colorCode);
        //   themeType = ThemeType.GlamBarbershop;

        //   notifyListeners();
        //   return themeType;

        // case '4':
        //   salonTheme = getGentleTouchDarkTheme(themeSettings?.theme?.colorCode);
        //   themeType = ThemeType.GentleTouchDark;

        //   notifyListeners();
        //   return themeType;

        // case '5':
        //   salonTheme = getVintageCraftTheme(themeSettings?.theme?.colorCode);
        //   themeType = ThemeType.Barbershop;
        //   notifyListeners();
        //   return themeType;

        // case '6':
        //   salonTheme = getGentleTouchTheme(themeSettings?.theme?.colorCode);
        //   themeType = ThemeType.GentleTouch;
        //   notifyListeners();
        //   return themeType;

        case '7':
          salonTheme = getCityMuseLightTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.CityMuseLight;
          notifyListeners();
          return themeType;

        case '8':
          salonTheme = getCityMuseDarkTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.CityMuseDark;
          notifyListeners();
          return themeType;

        case '10':
          salonTheme = getGentleTouchTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.GentleTouch;

          notifyListeners();
          return themeType;

        case '11':
          salonTheme = getGentleTouchDarkTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.GentleTouchDark;

          notifyListeners();
          return themeType;

        case '12':
          salonTheme = getCityMuseLightTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.CityMuseLight;

          notifyListeners();
          return themeType;

        case '13':
          salonTheme = getCityMuseDarkTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.CityMuseDark;
          notifyListeners();
          return themeType;

        case '789':
          salonTheme = getVintageCraftTheme(themeSettings?.theme?.colorCode);
          themeType = ThemeType.VintageCraft;

          notifyListeners();
          return themeType;
      }
    } else {
      salonTheme = getDefaultLightTheme(themeSettings?.theme?.colorCode);
      themeType = ThemeType.DefaultLight;
      notifyListeners();
      return themeType;
    }
    return null;
  }

  void addToAppleCalendar(
    context, {
    required AppointmentModel appointment,
    required String appointmentId,
    required String startTime,
    required String endTime,
    SalonModel? salon,
  }) async {
    appleCalendarStatus = Status.loading;
    notifyListeners();

    var url = Uri.parse('http://34.23.250.26:3000/api/v1/calendar/appleCalendar');

    final Map<String, String> body = {
      "starttime": startTime,
      "endtime": endTime,
      "salonName": appointment.salon.name,
      "email": (appointment.customer?.email ?? '').toString(),
      "address": appointment.salon.address.toString(),
      "salonPhone": appointment.salon.phoneNo,
      "appointmentId": appointmentId,
      "locale": salon?.locale ?? 'en',
    };

    try {
      var response = await http.post(url, body: body);

      // debugPrint(body.toString());
      // debugPrint('----??------');
      debugPrint('Response: $response');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> parsedResponse = json.decode(response.body);

        if ((parsedResponse["data"]).toString().length >= 9) {
          String launchDownloadLink = 'https://${(parsedResponse["data"]).toString().substring('webcal://'.length)}';
          debugPrint('----ical------');

          print(launchDownloadLink);
          js.context.callMethod('open', [parsedResponse["data"], '_self']);
          // js.context.callMethod('open', [launchDownloadLink, '_self']);

          Uri uri = Uri.parse(launchDownloadLink);

          if (await canLaunchUrl(uri)) {
            await launchUrl(
              uri,
              webOnlyWindowName: '_self',
            );
          } else {
            showToast(AppLocalizations.of(context)?.somethingWentWrongPleaseTryAgain ?? 'Something went wrong, please try again');

            appleCalendarStatus = Status.failed;
            notifyListeners();
          }
        }

        // webcal://storage.googleapis.com/bowandbeautiful-3372d.appspot.com/invites%2F84hWagCdUAURP6BUwNLC

        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: "Invite successfully created, please check your downloads",
            backgroundColor: AppTheme.creamBrown,
            textStyle: AppTheme.customLightTheme.textTheme.bodyLarge!.copyWith(
              fontSize: 20.sp,
              color: Colors.black,
            ),
          ),
        );
      } else {
        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: "Something went wrong please try again",
            backgroundColor: AppTheme.creamBrown,
            textStyle: AppTheme.customLightTheme.textTheme.bodyLarge!.copyWith(
              fontSize: 20.sp,
              color: Colors.black,
            ),
          ),
        );
        appleCalendarStatus = Status.failed;
        notifyListeners();
      }
    } catch (err) {
      printIt('Error on addToAppleCalendar() - $err');
      appleCalendarStatus = Status.failed;
      notifyListeners();
    }
    appleCalendarStatus = Status.init;
    notifyListeners();
  }

  void getTotalDeposit(AppointmentModel appointment) async {
    appointmentStatus = Status.loading;
    notifyListeners();

    int total = 0;

    List<ServiceModel> salonServices = await CategoryServicesApi(mongodbProvider: mongodbProvider).getSalonServices(salonId: salon!.salonId);

    for (var service in appointment.services) {
      for (var salonService in salonServices) {
        if (service.serviceId == salonService.serviceId && salonService.hasDeposit!) {
          total += int.parse(salonService.deposit!);
        }
      }
    }
    totalDeposit = total.toStringAsFixed(2);

    appointmentStatus = Status.success;
    notifyListeners();
  }

  createNoShowPolicy({CancellationNoShowPolicy? policy}) async {
    createNoShowPolicyStatus = Status.loading;
    notifyListeners();

    await Cancelation_NoShowApi().createPolicyDoc(policy);

    createNoShowPolicyStatus = Status.success;
    notifyListeners();
  }
}

// http://localhost:58317/appointments?id=KFobyqnivYiOHNJvWI12
// appointments?id=mvEdvmbMxRjgwFrzIjao

// https://yogasm.firebaseapp.com/appointments?id=V3fTmKLUnNEKFuZFB6BC -> IaUsq9UnKNsQ05bhhUuk