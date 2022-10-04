import 'package:bbblient/src/firebase/integration/yclients.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/integration/yclients/schedule.dart';
import 'package:bbblient/src/models/integration/yclients/yclients.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:flutter/material.dart';

/// !!!!!!!!!!!!!!! important !!!!!!!!!!!!!!!
/// init must be called before calling any other function
/// init maintains the state of the required token

class YClientsEngine {
  YClientsEngine._privateConstructor();
  static final YClientsEngine _instance = YClientsEngine._privateConstructor();
  factory YClientsEngine() {
    return _instance;
  }
  static final YClientsApi _api = YClientsApi();
  static final Time _time = Time();
  YClientsModel? yClientsConfig;

  ///Must be called initially before calling any other function from this engine
  //returns true if integration is active otherwise false
  Future<bool> init(
    String salonID,
  ) async {
    yClientsConfig = await _api.getYClientData(salonID);
    printIt(yClientsConfig?.toJson());
    return yClientsConfig?.isActive ?? false;
  }

  //returns null incase integration is inactive
  // returns blank slots OR [] in case of error in integration
  Future<List<String>?> getMasterSlots(DateTime date, {required MasterModel master}) async {
    try {
      //in case sync is not active or config is null
      if (!(yClientsConfig?.isActive ?? false)) return null;
      printIt(master.yClientsId);

      final String? masterBeautyProId = master.yClientsId;
      if (masterBeautyProId == null || masterBeautyProId == "") return null;

      return await _getMastersSchedule(masterBeautyProId, date);
    } catch (e) {
      printIt(e);
    }
    return [];
  }

  /// returns all the available slots on a specific day
  /// in the form of {"master-id":[10:30,10:45,11:00]}
  // static Future<Map<String, List<String>>> getMasterSlots(DateTime date,
  //     {List<MasterModel> masters}) async {
  //   //in case sync is not active or config is null
  //   if (!(yClientsConfig?.isActive ?? false)) return null;
  //   Map<String, List<String>> slotsMap = {};
  //   if (masters != null) {
  //     //in-case list of id is provided
  //     for (MasterModel master in masters) {
  //       slotsMap[master?.yClientsId?.toString() ?? ""] =
  //           await _getMastersSchedule(
  //               master?.yClientsId?.toString() ?? "", date);
  //     }
  //     return slotsMap;
  //   } else {
  //     final List<MasterYClients> yClientMasters =
  //         await _api.getYClientsMasters(yClientsConfig);
  //
  //     if (yClientMasters != null)
  //       for (MasterYClients master in yClientMasters) {
  //         slotsMap[master?.id?.toString() ?? ""] =
  //             await _getMastersSchedule(master?.id?.toString() ?? "", date);
  //       }
  //     return slotsMap;
  //   }
  // }

  /// for partners app only
  //  takes in slots available in bnb app and merge it with beauty_pro app
  Future<List<String>> syncSlots(
    List<String>? slots,
    DateTime date,
    yClientsMasterID,
  ) async {
    try {
      if (yClientsMasterID == null || yClientsMasterID == "" || slots == null || slots.isEmpty) return slots ?? [];

      //in case sync is not active or config is null
      if (!(yClientsConfig?.isActive ?? false)) return slots;

      final List<String> _slots = await _getMastersSchedule(yClientsMasterID, date);

      return Time().getCommonSlots(_slots, slots);
    } catch (e) {
      printIt("error while parsing time slots");
      printIt(e);
      return [];
    }
  }

  /// Takes in [AppointmentModel] and tries to make booking in yClients
  /// if yClients integration is not active then returns the appointment model back without the yClientsId's appointment ID
  /// otherwise creates a booking in yClients system and returns back [AppointmentModel] with yClientsId's appointment ID
  /// in case of error will return null and u need to [abort] the booking
  Future<AppointmentModel?> makeAppointment(AppointmentModel app, String? yClientsMasterId) async {
    try {
      if (yClientsConfig == null || yClientsMasterId == null || yClientsMasterId == "") return app;
      //in case sync is not active
      if (!(yClientsConfig?.isActive ?? false)) return app;

      final String? id = await _api.bookAppointment(yClientsMasterId, yClientsConfig, app);

      if (id == null) return null;

      app.yClientsId = id;
      return app;
    } catch (e) {
      printIt(e);
      return null;
    }
  }

  ///deletes an appointment
  Future<Status> cancelAppointment(AppointmentModel appointment) async {
    try {
      yClientsConfig ??= await _api.getYClientData(appointment.salon.id);
      printIt(yClientsConfig?.toJson());
      //in case sync is not active
      if (!(yClientsConfig?.isActive ?? false)) {
        return Status.success;
      }

      printIt(appointment.yClientsId);

      if (yClientsConfig == null || appointment.yClientsId == null) {
        return Status.failed;
      } else {
        //will fetch all the available slots
        return await _api.deleteAppointment(appointment.yClientsId, yClientsConfig);
      }
    } catch (e) {
      printIt(e);
    }
    return Status.failed;
  }

  ///  returns the master slots in format
  //  [12:00,12:15,12:30]
  Future<List<String>> _getMastersSchedule(String masterID, DateTime date) async {
    try {
      if (yClientsConfig!.companyId == null) {
        return [];
      }
      final List<Schedule>? schedule = await _api.getYClientsMasterSchedule(yClientsConfig!.companyId!, masterID, date);
      printIt(schedule);

      List<String> slots = [];
      if (schedule != null) {
        for (Schedule element in schedule) {
          slots.addAll(_parseSlotsFromSchedule(element));
        }
      }

      return _time.removeDuplicateSlots(slots);
    } catch (e) {
      printIt(e);
    }
    return [];
  }

  ///parses the [Schedule]  into [timeslots]
  static Iterable<String> _parseSlotsFromSchedule(Schedule schedule) {
    try {
      final int minutes = schedule.seanceLength ~/ 60;
      final TimeOfDay time1 = TimeOfDay.fromDateTime(schedule.datetime);
      final TimeOfDay time2 = time1.addMinutes(minutes);
      return _time.generateTimeSlots(time1, time2);
    } catch (e) {
      printIt('error in parseSlotsFromSchedule');
      printIt(e);
    }
    return [];
  }
}
