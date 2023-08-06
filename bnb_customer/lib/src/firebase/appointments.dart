import 'package:bbblient/src/firebase/bonus_referral_api.dart';
import 'package:bbblient/src/firebase/master.dart';
import 'package:bbblient/src/firebase/salons.dart';
import 'package:bbblient/src/models/backend_codings/appointment.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/integration/beauty_pro.dart';
import 'package:bbblient/src/utils/integration/yclients.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/appointment/appointment.dart';
import 'collections.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppointmentApi {
  AppointmentApi._privateConstructor();
  static final AppointmentApi _instance = AppointmentApi._privateConstructor();
  factory AppointmentApi() {
    return _instance;
  }

  final Time _timeUtils = Time();

  Stream<List<AppointmentModel>> listenAppointments({required String customerId}) {
    printIt('customer $customerId');
    return Collection.appointments.limit(20).where('customer.id', isEqualTo: customerId).snapshots().map((snapShot) {
      List<AppointmentModel> allAppointments = [];
      for (QueryDocumentSnapshot snap in snapShot.docs) {
        late AppointmentModel? appointmentModel;
        try {
          appointmentModel = AppointmentModel.fromJson(snap.data() as Map<String, dynamic>);
          appointmentModel.appointmentId = snap.id;
        } catch (e) {
          printIt(e);
          rethrow;
        }
        // ignore: unnecessary_null_comparison
        if (appointmentModel != null) {
          allAppointments.add(appointmentModel);
        }
      }
      return allAppointments;
    });
  }

  /// creates a new appointment

  Future createUpdateAppointment(AppointmentModel appointment) async {
    try {
      DocumentReference _docRef;
      if (appointment.appointmentId != null) {
        //updates the existing appointment

        _docRef = Collection.appointments.doc(appointment.appointmentId);
      } else {
        //creates a new appointment
        _docRef = Collection.appointments.doc();
      }

      await _docRef.set(appointment.toJson(), SetOptions(merge: true));

      return _docRef.id;
    } catch (e) {
      debugPrint('error in making appointment');
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> createAppointment(AppointmentModel appointment) async {
    try {
      DocumentReference _docRef;
      _docRef = Collection.appointments.doc();
      await _docRef.set(appointment.toJson());
      return _docRef.id;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// returns a specific appointment from appointmentId
  Future<AppointmentModel?> getAppointmentFromId(String appointmentId) async {
    try {
      final DocumentSnapshot _response = await Collection.appointments.doc(appointmentId).get();
      if (_response.data() != null) {
        AppointmentModel appointmentModel = AppointmentModel.fromJson(_response.data() as Map<String, dynamic>);
        appointmentModel.appointmentId = _response.id;
        return appointmentModel;
      } else {
        return null;
      }
    } catch (e) {
      printIt("error in appointment api $e");
      return null;
    }
  }

  Future<String> reviewAppointment({
    required String appointmentId,
    required bool masterReviewed,
    required bool salonReviewed,
  }) async {
    try {
      DocumentReference _docRef;
      _docRef = Collection.appointments.doc(appointmentId);
      _docRef.set(
        {
          'masterReviewed': masterReviewed,
          'salonReviewed': salonReviewed,
        },
        SetOptions(
          merge: true,
        ),
      );
      return 'reviewed';
    } catch (e) {
      debugPrint(e.toString());
      return "Error";
    }
  }

  /// call this function at the beginning of the cancellation process, to make sure it cancels first in integration
  /// cancels appointment and then returns status
  /// if [Status] == [Status.failed] then u must abort cancellation
  Future<Status> cancelAppointmentInIntegration(String salonId, AppointmentModel appointment) async {
    final bool yClients = await YClientsEngine().init(salonId);
    final bool beautyPro = await BeautyProEngine().init(salonId);
    printIt("canceling in y $yClients b $beautyPro");
    if (yClients) return await YClientsEngine().cancelAppointment(appointment);
    if (beautyPro) return await BeautyProEngine().cancelAppointment(appointment);
    return Status.success;
  }

  Future<String> cancelAppointment({required AppointmentModel appointmentModel, required BuildContext context}) async {
    try {
      DocumentReference _docRef;
      _docRef = Collection.appointments.doc(appointmentModel.appointmentId);
      _docRef.set(
        {
          'status': AppointmentStatus.cancelled,
          'updates': FieldValue.arrayUnion([AppointmentUpdates.cancelledByCustomer]),
          "updatedAt": FieldValue.arrayUnion([DateTime.now()])
        },
        SetOptions(
          merge: true,
        ),
      );

      Status cancelStatus = await cancelAppointmentInIntegration(appointmentModel.salon.id, appointmentModel);
      printIt(cancelStatus);
      if (cancelStatus == Status.success) {
        if (appointmentModel.salonOwnerType == OwnerType.singleMaster) {
          final SalonModel? salonModel = await SalonApi().getSalonFromId(appointmentModel.salon.id);
          if (salonModel != null) {
            int? success = await cancelSalonTime(
              appointmentModel: appointmentModel,
              salon: salonModel,
            );
            if (success == 1) {
              await validateBonusOnAppointmentCancel(appointmentModel: appointmentModel, context: context);
              return 'cancelled';
            } else {
              return "error";
            }
          }
        } else {
          final MasterModel? masterModel = await MastersApi().getMasterFromId(appointmentModel.master!.id);
          if (masterModel != null) {
            Status cancel = await cancelBlockedTimeMaster(
              appointmentModel: appointmentModel,
              master: masterModel,
            );
            if (cancel == Status.success) {
              await validateBonusOnAppointmentCancel(appointmentModel: appointmentModel, context: context);
              return 'cancelled';
            } else {
              return "error";
            }
          }
        }
        return "error";
      } else {
        return "error";
      }
    } catch (e) {
      debugPrint(e.toString());
      return "error";
    }
  }

  validateBonusOnAppointmentCancel({required AppointmentModel appointmentModel, required BuildContext context}) async {
    if ((appointmentModel.paymentInfo?.bonusApplied ?? false) && (appointmentModel.paymentInfo?.bonusIds != null)) {
      if (appointmentModel.appointmentStartTime.isBefore(DateTime.now())) {
        return true;
      } else if (appointmentModel.appointmentStartTime.difference(DateTime.now()).inHours > 24) {
        bool validated = await BonusReferralApi().validateBonus(bonusId: appointmentModel.paymentInfo?.bonusIds[0] ?? '');
        if (validated) {
          showToast(AppLocalizations.of(context)?.bonusRestored ?? 'Bonus restored');
          return true;
        } else {
          return false;
        }
      }
    }
  }

  //blocks the master time
  Future blockMastersTime({required MasterModel master, required DateTime date, required String time, required int minutes}) async {
    try {
      master.blockedTime = _generateBlockedTimeMap2(
        blockedTime: master.blockedTime ?? {},
        date: date,
        time: time,
        minutes: minutes,
      );
      await MastersApi().updateMasterBlockTime(master);
      return 1;
    } catch (e) {
      printIt('error while generating blocked time ');
      printIt(e);
      return null;
    }
  }

  cancelBlockedTimeMaster({required AppointmentModel appointmentModel, required MasterModel master}) async {
    try {
      master = _removeBlockedSlotsMaster(appointmentModel, master);
      await MastersApi().updateMasterBlockTime(master);
      return Status.success;
    } catch (e) {
      printIt(e);
      return Status.failed;
    }
  }

  _removeBlockedSlotsMaster(AppointmentModel appointment, MasterModel master) {
    try {
      final String _date = _timeUtils.getDateInStandardFormat(appointment.appointmentStartTime);
      TimeOfDay _time1 = TimeOfDay.fromDateTime(appointment.appointmentStartTime);
      TimeOfDay _time2 = TimeOfDay.fromDateTime(appointment.appointmentEndTime);
      List<String?> blockedSlots = _timeUtils.generateTimeSlots(_time1, _time2, inclusive: true).toList();
      if (master.blockedTime != null && master.blockedTime?[_date] != null && master.blockedTime?[_date].isNotEmpty) {
        final tempList = master.blockedTime?[_date];
        for (String? slots in blockedSlots) {
          tempList.remove(slots);
        }
        master.blockedTime?[_date] = tempList;
      }
      return master;
    } catch (e) {
      printIt(e);
    }
  }

  // in case of single master use this to block bcz single master is stored as salon in firebase
  Future blockSalonTime({required SalonModel salon, required DateTime date, required String time, required int minutes}) async {
    try {
      salon.blockedTime = _generateBlockedTimeMap2(blockedTime: salon.blockedTime, date: date, time: time, minutes: minutes);
      await SalonApi().updateSalonBlockedTime(salon);
      return 1;
    } catch (e) {
      printIt('$e - blockSalonTime()');
      return null;
    }
  }

  Future cancelSalonTime({required AppointmentModel appointmentModel, required SalonModel salon}) async {
    try {
      SalonModel _salon = _removeBlockedSlotsSalon(appointmentModel, salon);
      await SalonApi().updateSalonBlockedTime(_salon);
      return 1;
    } catch (e) {
      printIt(e);
      return null;
    }
  }

  _removeBlockedSlotsSalon(AppointmentModel appointment, SalonModel salon) {
    try {
      final String _date = _timeUtils.getDateInStandardFormat(appointment.appointmentStartTime);
      TimeOfDay _time1 = TimeOfDay.fromDateTime(appointment.appointmentStartTime);
      TimeOfDay _time2 = TimeOfDay.fromDateTime(appointment.appointmentEndTime);
      List<String?> blockedSlots = _timeUtils.generateTimeSlots(_time1, _time2, inclusive: true).toList();
      if (salon.blockedTime[_date] != null && salon.blockedTime[_date].isNotEmpty) {
        final tempList = salon.blockedTime[_date];
        for (String? slots in blockedSlots) {
          tempList.remove(slots);
        }
        salon.blockedTime[_date] = tempList;
        printIt(tempList);
        printIt(salon.blockedTime[_date]);
      }
      return salon;
    } catch (e) {
      printIt(e);
    }
  }

  Map<String, dynamic> _generateBlockedTimeMap({
    required Map<String, dynamic> blockedTime,
    required DateTime date,
    required String time,
    required int minutes,
  }) {
    try {
      final String _date = _timeUtils.getDateInStandardFormat(date);
      TimeOfDay _time1 = _timeUtils.stringToTime(time);
      TimeOfDay _time2 = _time1.addMinutes(minutes);
      List<String?> blockedSlots = [];
      blockedSlots.addAll(_timeUtils.generateTimeSlots(_time1, _time2, inclusive: true));
      if (blockedTime.containsKey(_date)) {
        if (blockedTime[_date] == null) blockedTime[_date] = [];
        blockedTime[_date].addAll(blockedSlots);
      } else {
        blockedTime[_date] = blockedSlots;
      }
      printIt(blockedTime);
      return blockedTime;
    } catch (e) {
      printIt(e);
      return blockedTime;
    }
  }

  Map<String, dynamic> _generateBlockedTimeMap2({
    required Map<String, dynamic> blockedTime,
    required DateTime date,
    required String time,
    required int minutes,
  }) {
    try {
      final String _date = _timeUtils.getDateInStandardFormat(date);
      TimeOfDay _time1 = _timeUtils.stringToTime(time);
      TimeOfDay _time2 = _time1.addMinutes(minutes);
      List<String?> blockedSlots = [];
      blockedSlots.addAll(_timeUtils.generateTimeSlotsForBlock(_time1, _time2, inclusive: true));
      if (blockedTime.containsKey(_date)) {
        if (blockedTime[_date] == null) blockedTime[_date] = [];
        blockedTime[_date].addAll(blockedSlots);
      } else {
        blockedTime[_date] = blockedSlots;
      }
      printIt(blockedTime);
      return blockedTime;
    } catch (e) {
      printIt(e);
      return blockedTime;
    }
  }

  updateMultipleAppointment({
    AppointmentModel? appointmentModel,
    String? appointmentStatus,
    String? appointmentSubStatus,
    required bool isSingleMaster,
    required SalonModel salon,
    required List<MasterModel> salonMasters,
  }) async {
    if (appointmentStatus != null) {
      appointmentModel!.status = appointmentStatus;
    }
    if (appointmentSubStatus != null) {
      appointmentModel!.subStatus = appointmentSubStatus;
    }

    appointmentModel!.updates.add(
      AppointmentUpdates.cancelledByCustomer,
    );

    final updateResult = await updateMultipleAppointmentBlocks(appointmentModel, appointmentStatus, appointmentSubStatus);

    List<MasterModel> masters = salonMasters.where((element) => appointmentModel.master!.id == element.masterId).toList();

    debugPrint('apptidetider ${appointmentModel.appointmentIdentifier}');

    List<AppointmentModel?> allAppointments = await AppointmentApi().getAppointmentFromIdentifier(appointmentModel.appointmentIdentifier);

    if (appointmentStatus == AppointmentStatus.cancelled && appointmentSubStatus == ActiveAppointmentSubStatus.cancelledBySalon) {
      for (var currentAppt in allAppointments) {
        if (isSingleMaster) {
          //unblock salon
          await AppointmentApi().cancelBlockedTimeSingleMaster(currentAppt!, salon);
        }
        //unblock master
        await AppointmentApi().unBlockSlots(currentAppt!, masters[0]);
      }
    }

    // await refreshAppointment(appointmentModel.appointmentStartTime);

    if (updateResult != null) {
      showToast("status updated successfully");
    }
  }

  // deletes the appointment model from the DB
  // and then removes the blocked time from master's calendar
  cancelBlockedTimeSingleMaster(AppointmentModel app, SalonModel salon) async {
    try {
      final Status? status = await removeAppointment(app.appointmentId);
      if (status == Status.success) {
        //remove blocked time from master's schedule
        return unBlockSlotsSingleMaster(app, salon);
      }
    } catch (e) {
      //(e);
      return Status.failed;
    }
  }

  unBlockSlotsSingleMaster(AppointmentModel app, SalonModel salon) async {
    try {
      //remove blocked time from master's schedule
      salon = _removeBlockedSlotsSingleMaster(app, salon);
      await SalonApi().updateSalon(salon);
      return Status.success;
    } catch (e) {
      //(e);
      return Status.failed;
    }
  }

  //removes the blocked time from master model and returns master's model
  _removeBlockedSlotsSingleMaster(AppointmentModel appointment, SalonModel salon) {
    try {
      final String _date = _timeUtils.getDateInStandardFormat(appointment.appointmentStartTime);

      TimeOfDay _time1 = TimeOfDay.fromDateTime(appointment.appointmentStartTime);
      TimeOfDay _time2 = TimeOfDay.fromDateTime(appointment.appointmentEndTime);

      List<String> blockedSlots = _timeUtils.generateTimeSlotsBlock(_time1, _time2, inclusive: true).toList();

      if (salon.blockedTime != null && salon.blockedTime[_date] != null && salon.blockedTime[_date].isNotEmpty) {
        final tempList = salon.blockedTime[_date];

        for (String slots in blockedSlots) {
          tempList.remove(slots);
        }
        salon.blockedTime[_date] = tempList;
      }

      return salon;
    } catch (e) {
      //(e);
    }
  }

  //removes the entire appointment module
  Future<Status?> removeAppointment(String? appointmentId) async {
    if (appointmentId == null) return Status.failed;
    try {
      Status status = Status.success;
      await Collection.appointments.doc(appointmentId).delete().onError((dynamic error, stackTrace) => status = Status.failed);
      return status;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  //unblocks the master's locked time
  unBlockSlots(AppointmentModel app, MasterModel master) async {
    try {
      //remove blocked time from master's schedule
      master = _removeBlockedSlots(app, master);
      await MastersApi().updateMaster(master);
      return Status.success;
    } catch (e) {
      //(e);
      return Status.failed;
    }
  }

  //removes the blocked time from master model and returns master's model
  _removeBlockedSlots(AppointmentModel appointment, MasterModel master) {
    try {
      final String _date = _timeUtils.getDateInStandardFormat(appointment.appointmentStartTime);

      TimeOfDay _time1 = TimeOfDay.fromDateTime(appointment.appointmentStartTime);
      TimeOfDay _time2 = TimeOfDay.fromDateTime(appointment.appointmentEndTime);

      List<String> blockedSlots = _timeUtils.generateTimeSlotsBlock(_time1, _time2, inclusive: true).toList();

      if (master.blockedTime != null && master.blockedTime![_date] != null && master.blockedTime![_date].isNotEmpty) {
        final tempList = master.blockedTime![_date];

        //(_date);

        for (String slots in blockedSlots) {
          tempList.remove(slots);
        }
        master.blockedTime![_date] = tempList;
      }

      return master;
    } catch (e) {
      //(e);
    }
  }

  ///update multiple appointments blocks
  Future updateMultipleAppointmentBlocks(AppointmentModel appointment, String? appointmentStatus, String? appointmentSubStatus) async {
    try {
      DocumentReference _docRef;
      if (appointment.appointmentIdentifier != null) {
        //updates the existing appointment
        final querySnapshot = await Collection.appointments.where('appointmentIdentifier', isEqualTo: appointment.appointmentIdentifier).get();
        final batch = FirebaseFirestore.instance.batch();
        querySnapshot.docs.forEach((doc) {
          if (appointment.status == AppointmentStatus.cancelled && appointment.subStatus == ActiveAppointmentSubStatus.cancelledBySalon) {
            batch.update(doc.reference, {
              "status": appointment.status,
              "subStatus": appointment.subStatus,
              "updatedAt": FieldValue.arrayUnion([DateTime.now()]),
              "updates": FieldValue.arrayUnion([AppointmentUpdates.cancelledBySalon]),
            });
          } else if (appointment.status == AppointmentStatus.active && appointment.subStatus == ActiveAppointmentSubStatus.confirmed) {
            batch.update(doc.reference, {
              "status": appointment.status,
              "subStatus": appointment.subStatus,
              "updatedAt": FieldValue.arrayUnion([DateTime.now()]),
              "updates": FieldValue.arrayUnion([AppointmentUpdates.approvedBySalon]),
            });
          } else if (appointment.status == AppointmentStatus.active && appointment.subStatus == ActiveAppointmentSubStatus.unConfirmed) {
            batch.update(doc.reference, {
              "status": appointment.status,
              "subStatus": appointment.subStatus,
              "updatedAt": FieldValue.arrayUnion([DateTime.now()]),
              "updates": FieldValue.arrayUnion([AppointmentUpdates.approvedBySalon]),
            });
          } else if (appointment.status == AppointmentStatus.noShow) {
            batch.update(doc.reference, {
              "status": appointment.status,
              "subStatus": appointment.subStatus,
              "updatedAt": FieldValue.arrayUnion([DateTime.now()]),
              "updates": FieldValue.arrayUnion([
                AppointmentUpdates.noShowBySalon,
              ]),
            });
          } else {
            batch.update(doc.reference, {
              "status": appointment.status,
              "subStatus": appointment.subStatus,
              "updatedAt": FieldValue.arrayUnion([DateTime.now()]),
              "updates": FieldValue.arrayUnion([AppointmentUpdates.changedBySalon]),
            });
          }
        });

        await batch.commit();
        return true;
      } else {
        //creates a new appointment
        return null;
      }
    } catch (e) {
      debugPrint('error in making appointment');
      debugPrint(e.toString());
      return null;
    }
  }

  ///get appointment with same identifier
  Future<List<AppointmentModel?>> getAppointmentFromIdentifier(String? appointmentIdentifier) async {
    //try {
    if (appointmentIdentifier != null && appointmentIdentifier != "") {
      final QuerySnapshot _response = await Collection.appointments.where("appointmentIdentifier", isEqualTo: appointmentIdentifier).get();

      if (_response.docs.isEmpty) return [];
      return _response.docs.map((e) {
        Map<String, dynamic> _temp = e.data() as Map<String, dynamic>;
        _temp['appointmentId'] = e.id;
        if (kIsWeb) {
          _temp['appointmentStartTime'] = {"_seconds": _temp['appointmentStartTime'].seconds, "_nanoseconds": _temp['appointmentStartTime'].nanoseconds};
          _temp['appointmentEndTime'] = {"_seconds": _temp['appointmentEndTime'].seconds, "_nanoseconds": _temp['appointmentEndTime'].nanoseconds};
          _temp['createdAt'] = {"_seconds": _temp['createdAt'].seconds, "_nanoseconds": _temp['createdAt'].nanoseconds};

          if (_temp['notes'] != null) {
            _temp['notes']['createdAt'] = {"_seconds": _temp['notes']['createdAt'].seconds, "_nanoseconds": _temp['notes']['createdAt'].nanoseconds};
          }
          return AppointmentModel.fromJson(_temp);
        }

        return AppointmentModel.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    }
    return [];
  }
}

 //checks if any appointment lies, if you want to cancel working-hours
  //only checks if is there any appointment present on that day (not time)
  // Future<bool> checkAppointmentClash({required Hours hours, required DateTime date, required String masterId}) async {
  //   final String dateKey = Time().getDateInStandardFormat(date);
  //   QuerySnapshot<Object?> response =
  //       await Collection.appointments.where("masterId", isEqualTo: masterId).where("appointmentDate", isEqualTo: dateKey).get();

  //   List<AppointmentModel> appointments = response.docs.map<AppointmentModel>((e) {
  //     AppointmentModel appointModel = AppointmentModel.fromJson(e.data() as Map<String, dynamic>);
  //     appointModel.appointmentId = e.id;
  //     return appointModel;
  //   }).toList();

  //   for (AppointmentModel appointment in appointments) {
  //     if (appointment.status == AppointmentStatus.active) {
  //       final TimeOfDay appointmentStartTime = TimeOfDay.fromDateTime(appointment.appointmentStartTime);
  //       final TimeOfDay appointmentEndTime = TimeOfDay.fromDateTime(appointment.appointmentEndTime);

  //       final TimeOfDay startTime = Time().stringToTime(hours.startTime);
  //       final TimeOfDay endTime = Time().stringToTime(hours.endTime);

  //       bool clashed = Time().checkForTimeClash(startTime, endTime, appointmentStartTime, appointmentEndTime);
  //       //return true on clashed time frame
  //       if (clashed) return true;
  //     }
  //   }
  //   return false;
  // }



// removeBlockedSlots(appointment, master)
          // SalonModel? salonModel = await SalonApi().getSalonFromId(appointmentModel.salon.id);
          // if (salonModel != null) {
          //   Map<String, dynamic> blockedTimes = salonModel.blockedTime;
          //   printIt(blockedTimes);
          //   if (blockedTimes[appointmentModel.appointmentDate] != null) {
          //     List<String> appointmentSlots = _timeUtils
          //         .getTimeSlots(TimeOfDay.fromDateTime(appointmentModel.appointmentStartTime),
          //             TimeOfDay.fromDateTime(appointmentModel.appointmentEndTime))
          //         .toList();
          //     for (String slot in appointmentSlots) {
          //       blockedTimes[appointmentModel.appointmentDate].remove(slot);
          //     }
          //     printIt(blockedTimes);
          //     salonModel.blockedTime = blockedTimes;
          //     await SalonApi().updateSalonBlockedTime(salonModel);
          //   }
          // }




           // MasterModel? masterModel = await MastersApi().getMasterFromId(appointmentModel.master?.id ?? '');
          // printIt(masterModel?.toJson());
          // if (masterModel != null) {
          //   Map<String, dynamic>? blockedTimes = masterModel.blockedTime;
          //   if (blockedTimes != null) {
          //     printIt(blockedTimes);
          //     if (blockedTimes[appointmentModel.appointmentDate] != null) {
          //       List<String> appointmentSlots = _timeUtils
          //           .getTimeSlots(TimeOfDay.fromDateTime(appointmentModel.appointmentStartTime),
          //               TimeOfDay.fromDateTime(appointmentModel.appointmentEndTime),
          //               inclusive: true)
          //           .toList();
          //       for (String slot in appointmentSlots) {
          //         blockedTimes[appointmentModel.appointmentDate].remove(slot);
          //       }
          //       printIt(blockedTimes);
          //       masterModel.blockedTime = blockedTimes;
          //       await MastersApi().updateMasterBlockTime(masterModel);
          //     }
          //   }
          // }



            //returns stream of appointments
  // Stream<List<AppointmentModel>> listenAppointments(String salonId) {
  //   return Collection.appointments
  //       .where('salon.id', isEqualTo: salonId)
  //       .where("status", isEqualTo: AppointmentStatus.active)
  //       .snapshots()
  //       .map((snapShot) => snapShot.docs.map<AppointmentModel>((e) {
  //             Map _temp = e.data();
  //             _temp['appointmentId'] = e.id;
  //             return AppointmentModel.fromJson(_temp);
  //           }).toList());
  // }