import 'dart:convert';
import 'package:bbblient/src/firebase/bonus_referral_api.dart';
import 'package:bbblient/src/firebase/master.dart';
import 'package:bbblient/src/firebase/salons.dart';
import 'package:bbblient/src/models/backend_codings/appointment.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/mongodb/collection.dart';
import 'package:bbblient/src/mongodb/db_service.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';
import '../models/appointment/appointment.dart';
import 'collections.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppointmentApi {
  // AppointmentApi._privateConstructor();
  // static final AppointmentApi _instance = AppointmentApi._privateConstructor();
  // factory AppointmentApi() {
  //   return _instance;
  // }

  AppointmentApi._privateConstructor(this.mongodbProvider);

  static final AppointmentApi _instance = AppointmentApi._privateConstructor(null);

  factory AppointmentApi({DatabaseProvider? mongodbProvider}) {
    _instance.mongodbProvider = mongodbProvider;
    return _instance;
  }

  DatabaseProvider? mongodbProvider;

  final Time _timeUtils = Time();

  void updateAppointmentReviews(String appointmentID) {
    try {
      DocumentReference _docRef = Collection.appointments.doc(appointmentID);
      _docRef.update(
        {'reviewed': true},
      );
    } catch (e) {
      // debugPrint(e.toString());
      return;
    }
  }

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
        // print('entered here 1');
        //updates the existing appointment

        _docRef = Collection.appointments.doc(appointment.appointmentId);
      } else {
        // print('entered here 2');
        //creates a new appointment
        _docRef = Collection.appointments.doc();
      }

      await _docRef.set(appointment.toJson(), SetOptions(merge: true));

      return _docRef.id;
    } catch (e) {
      // debugPrint('error in making appointment');
      // debugPrint(e.toString());
      return null;
    }
  }

  Future createUpdateAppointmentMongo(AppointmentModel appointment) async {
    String returnedId = '';

    try {
      MongoDocument? _docRef;
      if (appointment.appointmentId != null) {
        //updates the existing appointment

        final selector = {'appointmentId': appointment.appointmentId!};
        final modifier = UpdateOperator.set(appointment.toJson());

        returnedId = appointment.appointmentId!;
        await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier);
      } else {
        //creates a new appointment
        final val = await mongodbProvider!.fetchCollection(CollectionMongo.appointments).insertOne(MongoDocument(appointment.toJson()));
        String value = val.toHexString();

        if (value != null) {
          final selector = {"_id": val};
          final modifier = UpdateOperator.set(
            {
              "appointmentId": value,
              "__id__": value,
              "__path__": 'appointments/$value',
            },
          );
          // await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(
          //       filter: selector,
          //       update: modifier,
          //     );
          await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(
                filter: selector,
                update: UpdateOperator.set({"appointmentId": value}),
              );
          await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(
                filter: selector,
                update: UpdateOperator.set({"__id__": value}),
              );
          await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(
                filter: selector,
                update: UpdateOperator.set({"__path__": 'appointments/$value'}),
              );

          returnedId = value;
        }
      }

      // await _docRef.set(appointment.toJson(), SetOptions(merge: true));

      return returnedId;
    } catch (e) {
      debugPrint('Error on createUpdateAppointmentMongo() -$e');
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
      // debugPrint(e.toString());
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
      // debugPrint(e.toString());
      return "Error";
    }
  }

  /// call this function at the beginning of the cancellation process, to make sure it cancels first in integration
  /// cancels appointment and then returns status
  /// if [Status] == [Status.failed] then u must abort cancellation
  Future<Status> cancelAppointmentInIntegration(String salonId, AppointmentModel appointment) async {
    // final bool yClients = await YClientsEngine().init(salonId);
    // final bool beautyPro = await BeautyProEngine().init(salonId);
    // printIt("canceling in y $yClients b $beautyPro");
    // if (yClients) return await YClientsEngine().cancelAppointment(appointment);
    // if (beautyPro) return await BeautyProEngine().cancelAppointment(appointment);
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
          final MasterModel? masterModel = await MastersApi(mongodbProvider: mongodbProvider).getMasterFromId(appointmentModel.master!.id);
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
      // debugPrint(e.toString());
      return "error";
    }
  }

  validateBonusOnAppointmentCancel({required AppointmentModel appointmentModel, required BuildContext context}) async {
    if ((appointmentModel.paymentInfo?.bonusApplied ?? false) && (appointmentModel.paymentInfo?.bonusIds != null)) {
      if (appointmentModel.appointmentStartTime!.isBefore(DateTime.now())) {
        return true;
      } else if (appointmentModel.appointmentStartTime!.difference(DateTime.now()).inHours > 24) {
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

      master.avgRating = 45; // 3

      // print('&&&&------&&&&------');
      // print(master.blockedTime);
      // print('&&&&------&&&&------');
      await MastersApi(mongodbProvider: mongodbProvider).updateMasterBlockTimeMongo(master);
      // await MastersApi(mongodbProvider: mongodbProvider).updateMasterBlockTime(master);
      return 1;
    } catch (e) {
      printIt('Error on blockMastersTime() - $e ');
      return null;
    }
  }

  cancelBlockedTimeMaster({required AppointmentModel appointmentModel, required MasterModel master}) async {
    try {
      master = _removeBlockedSlotsMaster(appointmentModel, master);
      await MastersApi(mongodbProvider: mongodbProvider).updateMasterMongo(master);
      // await MastersApi(mongodbProvider: mongodbProvider).updateMasterBlockTime(master);
      return Status.success;
    } catch (e) {
      printIt(e);
      return Status.failed;
    }
  }

  _removeBlockedSlotsMaster(AppointmentModel appointment, MasterModel master) {
    try {
      final String _date = _timeUtils.getDateInStandardFormat(appointment.appointmentStartTime!);
      TimeOfDay _time1 = TimeOfDay.fromDateTime(appointment.appointmentStartTime!);
      TimeOfDay _time2 = TimeOfDay.fromDateTime(appointment.appointmentEndTime!);
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

  Future blockSalonTime({required SalonModel salon, required DateTime date, required String time, required int minutes}) async {
    try {
      salon.blockedTime = _generateBlockedTimeMap2(blockedTime: salon.blockedTime, date: date, time: time, minutes: minutes);
      await SalonApi().updateSalonMongo(salon);
      return 1;
    } catch (e) {
      printIt('$e - blockSalonTime()');
      return null;
    }
  }

  Future cancelSalonTime({required AppointmentModel appointmentModel, required SalonModel salon}) async {
    try {
      SalonModel _salon = _removeBlockedSlotsSalon(appointmentModel, salon);
      await SalonApi().updateSalonMongo(_salon);
      return 1;
    } catch (e) {
      printIt(e);
      return null;
    }
  }

  _removeBlockedSlotsSalon(AppointmentModel appointment, SalonModel salon) {
    try {
      final String _date = _timeUtils.getDateInStandardFormat(appointment.appointmentStartTime!);
      TimeOfDay _time1 = TimeOfDay.fromDateTime(appointment.appointmentStartTime!);
      TimeOfDay _time2 = TimeOfDay.fromDateTime(appointment.appointmentEndTime!);
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

    appointmentModel!.updates.add(AppointmentUpdates.cancelledByCustomer);

    final updateResult = await updateMultipleAppointmentBlocksMongo(appointmentModel, appointmentStatus, appointmentSubStatus);

    List<MasterModel> masters = salonMasters.where((element) => appointmentModel.master!.id == element.masterId).toList();

    // // debugPrint('apptidetider ${appointmentModel.appointmentIdentifier}');
    // print('-----------------+++++++--------------');
    // print(salonMasters);
    // print('-----------------+++++++--------------');
    // print(masters);
    // print('-----------------+++++++--------------');
    // print(allAppointments);
    // print(isSingleMaster);
    // print('-----------------+++++++--------------');

    List<AppointmentModel?> allAppointments = await AppointmentApi(
      mongodbProvider: mongodbProvider,
    ).getAppointmentFromIdentifierMongo(appointmentModel.appointmentIdentifier);

    if (appointmentStatus == AppointmentStatus.cancelled && appointmentSubStatus == ActiveAppointmentSubStatus.cancelledBySalon) {
      for (var currentAppt in allAppointments) {
        if (isSingleMaster) {
          //unblock salon
          await cancelBlockedTimeSingleMaster(currentAppt!, salon);
        }
        //unblock master
        await unBlockSlots(currentAppt!, masters[0]);
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
      final Status? status = await removeAppointmentMongo(app.appointmentId);
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
      await SalonApi().updateSalonMongo(salon);
      return Status.success;
    } catch (e) {
      //(e);
      return Status.failed;
    }
  }

  //removes the blocked time from master model and returns master's model
  _removeBlockedSlotsSingleMaster(AppointmentModel appointment, SalonModel salon) {
    try {
      final String _date = _timeUtils.getDateInStandardFormat(appointment.appointmentStartTime!);

      TimeOfDay _time1 = TimeOfDay.fromDateTime(appointment.appointmentStartTime!);
      TimeOfDay _time2 = TimeOfDay.fromDateTime(appointment.appointmentEndTime!);

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
      // debugPrint(e.toString());
      return null;
    }
  }

  Future<Status?> removeAppointmentMongo(String? appointmentId) async {
    if (appointmentId == null) return Status.failed;
    try {
      Status status = Status.success;
      await mongodbProvider!.fetchCollection(CollectionMongo.appointments).deleteOne(
        {'appointmentId': appointmentId},
      ).onError((dynamic error, stackTrace) async {
        status = Status.failed;
        throw error.cause ?? error;
      });
      return status;
    } catch (e) {
      debugPrint('Error on removeAppointmentMongo() - $e');
      return null;
    }
  }

  //unblocks the master's locked time
  unBlockSlots(AppointmentModel app, MasterModel master) async {
    try {
      //remove blocked time from master's schedule
      master = _removeBlockedSlots(app, master);
      await MastersApi(mongodbProvider: mongodbProvider).updateMasterMongo(master);
      // await MastersApi(mongodbProvider: mongodbProvider).updateMaster(master);
      return Status.success;
    } catch (e) {
      //(e);
      return Status.failed;
    }
  }

  //removes the blocked time from master model and returns master's model
  _removeBlockedSlots(AppointmentModel appointment, MasterModel master) {
    try {
      final String _date = _timeUtils.getDateInStandardFormat(appointment.appointmentStartTime!);

      TimeOfDay _time1 = TimeOfDay.fromDateTime(appointment.appointmentStartTime!);
      TimeOfDay _time2 = TimeOfDay.fromDateTime(appointment.appointmentEndTime!);

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
      // debugPrint('error in making appointment');
      // debugPrint(e.toString());
      return null;
    }
  }

  Future updateMultipleAppointmentBlocksMongo(AppointmentModel appointment, String? appointmentStatus, String? appointmentSubStatus) async {
    try {
      DocumentReference _docRef;
      if (appointment.appointmentIdentifier != null) {
        //updates the existing appointment

        List<MongoDocument> allFind = await mongodbProvider!.fetchCollection(CollectionMongo.appointments).find(
          filter: {'appointmentIdentifier': appointment.appointmentIdentifier},
        );

        if (allFind.isEmpty) {
          return null;
        }

        allFind.forEach((doc) async {
          if (appointment.status == AppointmentStatus.cancelled && appointment.subStatus == ActiveAppointmentSubStatus.cancelledBySalon) {
            final selector = {'appointmentIdentifier': appointment.appointmentIdentifier};
            final modifier = UpdateOperator.set({"status": appointment.status});
            final modifier2 = UpdateOperator.set({"subStatus": appointment.subStatus});

            final modifierPush = UpdateOperator.push({
              "updatedAt": ArrayModifier.each([DateTime.now().toIso8601String()]),
              "updates": ArrayModifier.each([AppointmentUpdates.cancelledBySalon])
            });

            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier);
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier2);
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifierPush);
          } else if (appointment.status == AppointmentStatus.active && appointment.subStatus == ActiveAppointmentSubStatus.confirmed) {
            // Map<String, dynamic> _temp = json.decode(doc.toJson()) as Map<String, dynamic>;

            final selector = {'appointmentIdentifier': appointment.appointmentIdentifier};

            final modifier = UpdateOperator.set({"status": appointment.status});
            final modifier2 = UpdateOperator.set({"subStatus": appointment.subStatus});

            final modifierPush = UpdateOperator.push({
              "updatedAt": ArrayModifier.each([DateTime.now().toIso8601String()]),
              "updates": ArrayModifier.each([AppointmentUpdates.approvedBySalon])
            });

            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier);
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier2);
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifierPush);
          } else if (appointment.status == AppointmentStatus.active && appointment.subStatus == ActiveAppointmentSubStatus.unConfirmed) {
            final selector = {'appointmentIdentifier': appointment.appointmentIdentifier};
            final modifier = UpdateOperator.set({"status": appointment.status});
            final modifier2 = UpdateOperator.set({"subStatus": appointment.subStatus});

            final modifierPush = UpdateOperator.push({
              "updatedAt": ArrayModifier.each([DateTime.now().toIso8601String()]),
              "updates": ArrayModifier.each([AppointmentUpdates.approvedBySalon])
            });

            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier);
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier2);
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifierPush);
          } else if (appointment.status == AppointmentStatus.noShow) {
            final selector = {'appointmentIdentifier': appointment.appointmentIdentifier};
            final modifier = UpdateOperator.set({"status": appointment.status});
            final modifier2 = UpdateOperator.set({"subStatus": appointment.subStatus});

            final modifierPush = UpdateOperator.push({
              "updatedAt": ArrayModifier.each([DateTime.now().toIso8601String()]),
              "updates": ArrayModifier.each([AppointmentUpdates.noShowBySalon])
            });

            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier);
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier2);
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifierPush);
          } else if (appointment.status == AppointmentStatus.completed && appointment.subStatus == ActiveAppointmentSubStatus.unConfirmed) {
            final selector = {'appointmentIdentifier': appointment.appointmentIdentifier};
            final modifier = UpdateOperator.set({"status": appointment.status});
            final modifier2 = UpdateOperator.set({"subStatus": appointment.subStatus});

            final modifierPush = UpdateOperator.push({
              "updatedAt": ArrayModifier.each([DateTime.now().toIso8601String()]),
              "updates": ArrayModifier.each([AppointmentUpdates.completed])
            });

            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier);
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier2);
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifierPush);
          } else if (appointment.status == AppointmentStatus.completed && appointment.subStatus == ActiveAppointmentSubStatus.unConfirmed) {
            final selector = {'appointmentIdentifier': appointment.appointmentIdentifier};
            final modifier = UpdateOperator.set({"status": appointment.status});
            final modifier2 = UpdateOperator.set({"subStatus": appointment.subStatus});

            final modifierPush = UpdateOperator.push({
              "updatedAt": ArrayModifier.each([DateTime.now().toIso8601String()]),
              "updates": ArrayModifier.each([AppointmentUpdates.completed])
            });

            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier);
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier2);
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifierPush);
          } else if (appointment.status == AppointmentStatus.completed && appointment.subStatus == ActiveAppointmentSubStatus.confirmed) {
            final selector = {'appointmentIdentifier': appointment.appointmentIdentifier};
            final modifier = UpdateOperator.set({"status": appointment.status});
            final modifier2 = UpdateOperator.set({"subStatus": appointment.subStatus});

            final modifierPush = UpdateOperator.push({
              "updatedAt": ArrayModifier.each([DateTime.now().toIso8601String()]),
              "updates": ArrayModifier.each([AppointmentUpdates.completed])
            });

            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier);
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier2);
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifierPush);
          } else if (appointment.status == AppointmentStatus.completed && appointment.subStatus == ActiveAppointmentSubStatus.reviewed) {
            final selector = {'appointmentIdentifier': appointment.appointmentIdentifier};
            final modifier = UpdateOperator.set({"status": appointment.status});
            final modifier2 = UpdateOperator.set({"subStatus": appointment.subStatus});

            final modifierPush = UpdateOperator.push({
              "updatedAt": ArrayModifier.each([DateTime.now().toIso8601String()]),
              "updates": ArrayModifier.each([AppointmentUpdates.completed])
            });

            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier);
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier2);
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifierPush);
          } else {
            final selector = {'appointmentIdentifier': appointment.appointmentIdentifier};
            final modifier = UpdateOperator.set({"status": appointment.status});
            final modifier2 = UpdateOperator.set({"subStatus": appointment.subStatus});

            final modifierPush = UpdateOperator.push({
              "updatedAt": ArrayModifier.each([DateTime.now().toIso8601String()]),
              "updates": ArrayModifier.each([AppointmentUpdates.changedBySalon])
            });
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier);
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifier2);
            await mongodbProvider!.fetchCollection(CollectionMongo.appointments).updateOne(filter: selector, update: modifierPush);
          }
        });
        return true;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error on updateMultipleAppointmentBlocksMongo() - $e');
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

  Future<List<AppointmentModel?>> getAppointmentFromIdentifierMongo(String? appointmentIdentifier) async {
    try {
      if (appointmentIdentifier != null && appointmentIdentifier != "") {
        List<MongoDocument> _response;

        _response = await mongodbProvider!.fetchCollection(CollectionMongo.appointments).find(
          filter: {"appointmentIdentifier": appointmentIdentifier},
        );

        if (_response.isEmpty) return [];
        return _response.map<AppointmentModel>((e) {
          Map<String, dynamic> _temp = json.decode(e.toJson()) as Map<String, dynamic>;
          _temp['appointmentId'] = (json.decode(e.toJson()) as Map<String, dynamic>)["__id__"];

          return AppointmentModel.fromJson(_temp);
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error on getAppointmentFromIdentifierMongo() -$e");
      //(e);
      return [];
    }
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




           // MasterModel? masterModel = await MastersApi(mongodbProvider: mongodbProvider).getMasterFromId(appointmentModel.master?.id ?? '');
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
          //       await MastersApi(mongodbProvider: mongodbProvider).updateMasterBlockTime(masterModel);
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