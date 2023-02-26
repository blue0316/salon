// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/integration/yclients/master.dart';
import 'package:bbblient/src/models/integration/yclients/schedule.dart';
import 'package:bbblient/src/models/integration/yclients/yclients.dart';
import 'package:bbblient/src/utils/integration/beauty_pro.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class YClientsApi {
  YClientsApi._privateConstructor();
  static final YClientsApi _instance = YClientsApi._privateConstructor();
  factory YClientsApi() {
    return _instance;
  }
  static const String prod = "https://api.yclients.com/api";
  static const String version = "v1";
  static const token = "ykb86zpt3txb26yrzha3";
  static const bearer = "Bearer $token";
  static const accept = "application/vnd.yclients.v2+json";

  //login into yClients's
  Future<String?> signIn(String? user, String? pass) async {
    if (user == null || pass == null) return null;

    try {
      const String url = '$prod/$version/auth';

      final header = {"Authorization": bearer, "Accept": accept, "Content-Type": "application/json"};

      final _body = jsonEncode({"login": user, "password": pass});

      dynamic response = await http.post(Uri.parse(url), headers: header, body: _body);

      if (response != null && response.statusCode == 201) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));

        if (json != null) {
          if (json['success']) return json['data']['user_token'];
        }
      }
    } catch (e) {
      printIt(e);
    }

    return null;
  }

  //returns the master's schedule
  getYClientsMasterSchedule(final String companyID, final String masterID, final DateTime date) async {
    try {
      final _date = Time().getDateInStandardFormat(date);
      final String url = '$prod/$version/book_times/$companyID/$masterID/$_date';
      printIt(url);
      final header = {"Authorization": bearer, "Accept": accept};

      var response = await http.get(Uri.parse(url), headers: header);

      final json = jsonDecode(utf8.decode(response.bodyBytes));
      printIt(json);
      if (response.statusCode == 200) {
        //success
        final ScheduleModel _schedule = ScheduleModel.fromJson(json);
        if (_schedule.success) return _schedule.schedule;
      }
    } catch (e) {
      printIt(e);
    }
    //failed to fetch
    return null;
  }
  //creates a subCategory

  Future<List<MasterYClients>?> getYClientsMasters(final YClientsModel model) async {
    if (model == null || model.companyId == null) return null;
    try {
      final String url = '$prod/$version/book_staff/${model.companyId}';

      final header = {"Authorization": bearer, "Accept": accept};

      var response = await http.get(Uri.parse(url), headers: header);

      final json = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        //success
        final MastersYClients _masters = MastersYClients.fromJson(json);
        if (_masters.success) return _masters.masters;
      }
    } catch (e) {
      debugPrint('error while fetching companies');
      printIt(e);
    }
    //failed to fetch
    return null;
  }

  //creates a subCategory
  Future<Status> setYClientData(YClientsModel yClients) async {
    try {
      await Collection.yClients.doc(yClients.id).set(yClients.toJson(), SetOptions(merge: true));
      return Status.success;
    } catch (e) {
      debugPrint('error in setYClientData');
      printIt(e);
      return Status.failed;
    }
  }

  //  takes in salonID and returns yclients data
  //  will return null in-case not found or error
  Future<YClientsModel?> getYClientData(final String salonId) async {
    try {
      final QuerySnapshot<Object?> response = await Collection.yClients.where("salonId", isEqualTo: salonId).get();
      if (response.docs.isNotEmpty) {
        if (response.docs.first.data() != null) {
          Map<String, dynamic> doc = response.docs.first.data() as Map<String, dynamic>;

          doc['id'] = response.docs.first.id;
          printIt(doc);
          return YClientsModel.fromJson(doc);
        }
      }
    } catch (e) {
      printIt(e);
    }
    return null;
  }

  /// make appointment in yClients  DB
  /// will return ID in-case of success and returns null if fails
  Future<String?> bookAppointment(String masterId, YClientsModel? config, AppointmentModel? appointment) async {
    if (config == null || config.companyId == null || appointment == null || appointment.appointmentDate == null) return null;

    try {
      final String url = '$prod/$version/records/${config.companyId}';
      final String bearer = "Bearer $token, User ${config.userToken}";

      final header = {"Authorization": bearer, "Accept": accept, "Content-Type": "application/json"};

      final int seconds = int.parse(appointment.priceAndDuration.duration) * 60;
      final _body = {
        "staff_id": int.parse(masterId),
        "services": [],
        "client": {
          "phone": appointment.customer?.phoneNumber ?? "",
          "name": appointment.customer?.name ?? "",
        },
        "attendance": 2,
        "save_if_busy": false,
        "datetime": appointment.appointmentStartTime.toString(),
        "seance_length": seconds,
        "send_sms": true,
        "comment": BeautyProEngine().generateComment(appointment.services),
        "sms_remain_hours": 3,
        "email_remain_hours": 3,
        "api_id": appointment.appointmentId,
        "custom_color": "00FF00"
      };

      var response = await http.post(Uri.parse(url), headers: header, body: jsonEncode(_body));

      if (response != null && response.statusCode == 201) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        printIt(json);
        if (json != null) {
          if (json['success']) return json['data']['id']?.toString() ?? null;
        }
      }
    } catch (e) {
      printIt(e);
    }

    return null;
  }

  /// deletes an appointment
  Future<Status> deleteAppointment(String? appointmentId, YClientsModel? config) async {
    if (appointmentId == null || config == null || config.companyId == null) return Status.failed;

    try {
      final String url = '$prod/$version/record/${config.companyId}/$appointmentId';
      final String bearer = "Bearer $token, User ${config.userToken}";

      final header = {"Authorization": bearer, "Accept": accept, "Content-Type": "application/json"};

      var response = await http.delete(Uri.parse(url), headers: header);

      printIt(response);
      if (response.statusCode == 204) return Status.success;
    } catch (e) {
      printIt(e);
    }

    return Status.failed;
  }
}
