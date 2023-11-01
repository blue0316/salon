// ignore_for_file: unnecessary_type_check, unused_local_variable

import 'dart:convert';

import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/integration/beauty_pro/beauty_pro.dart';
import 'package:bbblient/src/models/integration/beauty_pro/master.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../collections.dart';

class BeautyProApi {
  BeautyProApi._privateConstructor();
  static final BeautyProApi _instance = BeautyProApi._privateConstructor();
  factory BeautyProApi() {
    return _instance;
  }

  ///all the api constraints
  static const prod = "https://api.aihelps.com";
  static const version = "v1";
  static const applicationId = "d1daf594-14bf-44b7-840b-e9f0a30534e1";
  static const applicationSecret = "5ae46b16-3683-406e-82e6-34d5cb6f7ced";

  /// returns null in-case of failure integration
  /// will return BeautyProModel in case of success
  Future<BeautyProConfig?> integrate(String salonId) async {
    BeautyProConfig? beautyProConfig = await getSalonConfig(salonId);

    beautyProConfig = await beautyProComputeToken(beautyProConfig);
    return beautyProConfig;
  }

  /// first try to refresh token
  /// if it fails then will try to generate a new one
  /// then returns new [BeautyProConfig]
  /// if it also fails then it means salon is not linked and will return [null]
  // it also updates the token over firebase
  Future<BeautyProConfig?> beautyProComputeToken(BeautyProConfig? config, {bool forceRefresh = false}) async {
    if (config == null) return null;
    final oldToken = config.accessToken;

    BeautyProConfig? newConfig = await refreshToken(config, forceRefresh: forceRefresh);

    //in-case refresh fails
    newConfig ??= await generateNewToken(config);

    if (newConfig != null && oldToken != newConfig.accessToken) {
      //token needs to be updated on the server
      await updateSalonConfig(newConfig);
    }

    return newConfig;
  }

  /// generates a brand new token from the scratch
  /// returns null in-case of error
  Future<BeautyProConfig?> generateNewToken(BeautyProConfig? config) async {
    if (config == null || config.databaseCode == null) return null;
    try {
      final String url = '$prod/$version/auth/database?application_id=$applicationId&application_secret=$applicationSecret&database_code=${config.databaseCode}';
      final response = await http.get(Uri.parse(url), headers: {});

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        final String? accessToken = json['access_token'];
        final String? ttl = json['expire_at'];
        final String? refreshToken = json['refresh_token'];
        final String locationCode = json['location'];
        if (accessToken != null || ttl != null || refreshToken != null) {
          config.accessToken = accessToken;
          config.ttl = DateTime.parse(ttl!);
          config.refreshToken = refreshToken;
          config.locationId = locationCode;
          //success
          return config;
        }
      }
    } catch (e) {
      //in case of wrong DB code it usually returns
      //Failed to parse header value
      printIt('error while generating new token');
      printIt(e);
    }
    //failed to fetch token
    return null;
  }

  ///  returns false if token is valid
  isTokenValid(DateTime? ttl) {
    if (ttl == null || ttl is! DateTime) return false;
    final DateTime _now = DateTime.now();

    if (ttl.compareTo(_now) == 1) return true;
    return false;
  }

  ///takes in [BeautyProConfig] and refreshes it only if ttl exceeds current time
  /// returns null in-case of error or refresh failed
  Future<BeautyProConfig?> refreshToken(BeautyProConfig? config, {bool forceRefresh = false}) async {
    if (config == null || config.databaseCode == null || config.refreshToken == null) return null;

    if (isTokenValid(config.ttl) && !forceRefresh) {
      ///returns the token back since it has not expired
      printIt('token has not expired');
      return config;
    }
    try {
      final String url = '$prod/$version/auth/refresh?application_id=$applicationId&refresh_token=${config.refreshToken}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        final String? accessToken = json['access_token'];
        final String? ttl = json['expire_at'];
        final String? refreshToken = json['refresh_token'];
        final String locationCode = json['location'];

        if (accessToken != null || ttl != null || refreshToken != null) {
          config.accessToken = accessToken;
          config.ttl = DateTime.parse(ttl!);
          config.refreshToken = refreshToken;
          config.locationId = locationCode;
        }
      }
    } catch (e) {
      printIt('failed to fetch/refresh token');

      printIt(e);
    }
    //failed to fetch/refresh token
    return null;
  }

  //  returns the beauty pro doc on the basis of salon id
  Future<BeautyProConfig?> getSalonConfig(String salonId) async {
    try {
      // salonId ??= homeController.currentSalon.salonId;
      QuerySnapshot<Map<String, dynamic>> response = await Collection.beautyPro.where("salonId", isEqualTo: salonId).get() as QuerySnapshot<Map<String, dynamic>>;

      if (response.docs.isNotEmpty) {
        var e = response.docs.first;
        Map<String, dynamic> data = e.data();
        data['beautyProDocId'] = e.id;
        return BeautyProConfig.fromJson(data);
      }
    } catch (e) {
      printIt('error while getSalonConfig');

      printIt(e);
    }
    return null;
  }

  // takes in BeautyProModel, updates it and returns model on success
  Future<BeautyProConfig?> updateSalonConfig(BeautyProConfig config) async {
    try {
      //will assign date time in-case it's null
      config.createdAt ??= DateTime.now();

      final DocumentReference<Map<String, dynamic>> doc = Collection.beautyPro.doc(config.beautyProDocId) as DocumentReference<Map<String, dynamic>>;

      await doc.set(config.toJson(), SetOptions(merge: true));
      config.beautyProDocId = doc.id;
      return config;
    } catch (e) {
      printIt(e);
      return null;
    }
  }

  ///takes in [BeautyProConfig] and fetches the masters
  Future<List<MasterBeautyPro>?> getBeautyProMasters(BeautyProConfig? config) async {
    if (config == null || config.accessToken == null) return null;
    const String url = '$prod/$version/employees?fields=name,positions&role=professional&archive=false&public=true';
    final header = {"Authorization": "Bearer ${config.accessToken}"};

    bool error = false;

    dynamic response = await http.get(Uri.parse(url), headers: header).catchError((e) {
      error = true;
    });

    if (error) {
      //trying once more by generating new token
      final newConfig = await beautyProComputeToken(config, forceRefresh: true);
      final header = {"Authorization": "Bearer ${newConfig?.accessToken}"};
      response = await http.get(Uri.parse(url), headers: header);
    }

    if (response != null && response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json != null && json.isNotEmpty) {
        return json.map<MasterBeautyPro>((e) => MasterBeautyPro.fromJson(e)).toList();
      }
    }
    try {} catch (e) {
      printIt('error while getting beauty-pro masters');
      printIt(e);
    }
    //failed to fetch/refresh token
    return null;
  }

  //accepted format for API :2021-10-14T00:04:35.464
  String getDateInBeautyProFormat(DateTime date) => date.toIso8601String().substring(0, 23);

  /// fetches free time from beauty pro
  // will return all the free time slots available, for a specific day only
  /// returns
  // null : failure
  // {} : no slots available
  // {"master-id":[10:30,10:45,11:00]} : slots are there
  Future<Map<String, List<String>>?> getBeautyProAvailableTime(DateTime? date, BeautyProConfig? config) async {
    if (date == null || config == null) {
      return {};
    }

    try {
      //computing dates, accepted format for API :2021-10-14T00:04:35.464
      final DateTime _startDate = DateTime(date.year, date.month, date.day);
      final DateTime _endDate = DateTime(date.year, date.month, date.day + 1);
      final String _startDateStr = getDateInBeautyProFormat(_startDate);
      final String _endDateStr = getDateInBeautyProFormat(_endDate);

      final String url = '$prod/$version/employees/free_time?from=$_startDateStr&to=$_endDateStr&duration=15&step=15m&location=${config.locationId}';

      final header = {"Authorization": "Bearer ${config.accessToken}"};

      bool error = false;
      dynamic response;
      try {
        response = await http.get(Uri.parse(url), headers: header);
      } catch (e) {
        response = null;
        printIt(e);
      }

      if (response == null) {
        final newConfig = await beautyProComputeToken(config, forceRefresh: true);
        final header = {"Authorization": "Bearer ${newConfig?.accessToken}"};
        response = await http.get(Uri.parse(url), headers: header);
      }

      printIt(jsonDecode(response.body));

      Map<String, List<String>> _map = {};

      if (response != null && response.statusCode == 200) {
        //success
        final json = jsonDecode(response.body);
        if (json['error'] != null) return null;
        if (json != null && json.isNotEmpty) {
          final String dateKey = Time().getDateInStandardFormat(_startDate);

          for (String masterId in json.keys) {
            final List<String>? timeSlots = (json[masterId][dateKey] as List?)?.map((e) => e as String).toList() ?? [];
            if (timeSlots != null && timeSlots.isNotEmpty) {
              _map[masterId] = timeSlots;
            }
          }
        }
        return _map;
      }
    } catch (e) {
      printIt(e);
      return {};
    }
    //failed to fetch/refresh token
    return {};
  }

  /// make appointment in beauty pro DB
  /// will return ID in-case of success and returns null if fails
  /// abort the current booking if paused
  Future<String?>? bookAppointment(DateTime? date, String? masterId, int duration, BeautyProConfig? config, {String? comment}) async {
    if (config == null || config.accessToken == null || date == null || masterId == null) return null;

    try {
      const String url = '$prod/$version/appointments';

      final header = {"Authorization": "Bearer ${config.accessToken}"};

      final _dateStr = getDateInBeautyProFormat(DateTime(date.year, date.month, date.day));
      final startStr = getDateInBeautyProFormat(date);

      final _body = jsonEncode({
        "date": _dateStr,
        "location": config.locationId,
        "comments": comment ?? "",
        "services": [
          {"start": startStr, "duration": duration, "professional": masterId}
        ]
      });

      bool error = false;
      dynamic response = await http.post(Uri.parse(url), headers: header, body: _body).catchError((e) {
        error = true;
      });
      if (error) {
        final newConfig = await beautyProComputeToken(config, forceRefresh: true);
        final header = {"Authorization": "Bearer ${newConfig!.accessToken}"};
        response = await http.post(Uri.parse(url), headers: header, body: _body);
      }
      if (response != null && response.statusCode == 201) {
        final json = jsonDecode(response.body);

        if (json != null) {
          if (json['error'] != null) return null;

          return json['id'];
        }
      }
    } catch (e) {
      printIt(e);
    }
    //failed to fetch/refresh token
    return null;
  }

  Future<Status> cancelAppointment(String? appId, BeautyProConfig? config) async {
    if (config == null || config.accessToken == null || appId == null) {
      return Status.failed;
    }

    try {
      final String url = '$prod/$version/appointments/$appId';

      final header = {"Authorization": "Bearer ${config.accessToken}"};

      final _body = jsonEncode({"state": "cancelled"});

      bool error = false;
      dynamic response = await http.put(Uri.parse(url), headers: header, body: _body).catchError((e) {
        error = true;
      });
      if (error) {
        //retrying again with new token
        final newConfig = await beautyProComputeToken(config, forceRefresh: true);
        final header = {"Authorization": "Bearer ${newConfig!.accessToken}"};
        response = await http.put(Uri.parse(url), headers: header, body: _body);
      }

      if (response != null && response.statusCode == 204) return Status.success;
    } catch (e) {
      printIt(e);
    }
    //failed to fetch/refresh token
    return Status.failed;
  }
}
