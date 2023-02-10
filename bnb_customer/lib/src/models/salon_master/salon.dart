import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/enums/gender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../backend_codings/working_hours.dart';

class SalonModel {
  late String salonId = '';
  late String salonName;
  late DateTime createdAt;
  late String ownerType;
  late String? workStation;
  late Links? links;
  late Position? position;
  late String? salonWebSite;
  late String phoneNumber;
  late String? email;
  late String description = '';
  late String preferredGender = PreferredGender.all;
  late double rating = 0.0;
  late double avgRating = 0.0;
  late double reviewCount = 0;
  late String locale;
  late bool isAvailableOnline = false;
  late bool isProfileImage = false;
  late String address;
  int? timeSlotsInterval;
  int? bookingRestrictionDays;
  // the amount of time between each appointments
  int? appointmentsLeadTime;
  late List<String> categoryId = [];
  late List<String> parentServiceId = [];
  late List<String> additionalFeatures = [];
  late WorkingHoursModel? workingHours;
  Map<String, Hours>? irregularWorkingHours;
  late List<String> profilePics = [];
  late List<String> photosOfWork = [];
  double? distanceFromCenter;
  late String? fcmToken;
  late Map<String, dynamic> blockedTime = {};
  late List<String> searchTags = [];
  late bool requestSalon;
  late int? selectedTheme; // THEME SELECTED BY SALON OWNER

  SalonModel({
    required this.salonId,
    required this.salonName,
    required this.createdAt,
    required this.address,
    required this.ownerType,
    this.workStation,
    required this.position,
    this.links,
    this.timeSlotsInterval,
    this.isAvailableOnline = false,
    this.isProfileImage = false,
    this.salonWebSite,
    required this.phoneNumber,
    this.email,
    required this.categoryId,
    required this.parentServiceId,
    required this.description,
    required this.profilePics,
    required this.photosOfWork,
    required this.rating,
    required this.preferredGender,
    required this.reviewCount,
    required this.avgRating,
    this.distanceFromCenter,
    this.appointmentsLeadTime,
    this.irregularWorkingHours,
    this.bookingRestrictionDays,
    this.fcmToken,
    required this.workingHours,
    required this.additionalFeatures,
    required this.locale,
    required this.blockedTime,
    required this.searchTags,
    this.requestSalon = false,
    this.selectedTheme = 11,
  });

  SalonModel.fromJson(Map<String, dynamic> json) {
    salonId = json['salonId'];
    salonName = json['salonName'] ?? '';
    appointmentsLeadTime = json['appointmentsLeadTime'];
    categoryId = json['categoryId'] == null ? [] : categoryId = json['categoryId'].cast<String>();

    parentServiceId = json['parentServiceId'] == null ? [] : parentServiceId = json['parentServiceId'].cast<String>();
    timeSlotsInterval = json['timeSlotsInterval'];
    bookingRestrictionDays = json['bookingRestrictionDays'];
    createdAt = json['createdAt'] != null ? json['createdAt'].toDate() : DateTime(1990);
    address = json['address'] ?? '';
    ownerType = json['ownerType'] ?? OwnerType.salon;
    workStation = json['workStation'];
    isAvailableOnline = json['isAvailableOnline'] ?? false;
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    position = json['position'] != null ? Position.fromJson(json['position']) : null;
    workingHours = WorkingHoursModel.fromJson(json['workingHours']);
    irregularWorkingHours = json['irregularWorkingHours'] != null ? mapIrregularHours(json['irregularWorkingHours']) : null;
    salonWebSite = json['salonWebSite'] ?? '';
    phoneNumber = json['phoneNumber'];
    email = json['email'] ?? '';
    locale = json['locale'] ?? 'UK';
    description = json['description'] ?? '';
    if (json['profilePics'] != null) {
      profilePics = json['profilePics'].cast<String>();
      if (json['profilePics'].isNotEmpty && json['profilePics'][0] != null) {
        isProfileImage = true;
      }
    } else {
      profilePics = [];
      isProfileImage = false;
    }
    if (json['photosOfWork'] != null) {
      photosOfWork = json['photosOfWork'].cast<String>();
    }
    preferredGender = json['preferredGender'];
    rating = json['rating'] != null ? double.parse(json['rating'].toString()) : 0;
    avgRating = json['avgRating'] != null ? double.parse(json['avgRating'].toString()) : 0;
    reviewCount = json['reviewCount'] != null ? double.parse(json['reviewCount'].toString()) : 0;
    distanceFromCenter = json['distanceFromCenter'];
    fcmToken = json['fcmToken'] ?? '';
    blockedTime = json['blockedTime'] ?? {};
    searchTags = json['searchTags'] != null ? json['searchTags'].cast<String>() : [];
    additionalFeatures = json['additionalFeatures'] != null ? json['additionalFeatures'].cast<String>() : [];
    requestSalon = json['requestSalon'] ?? false;
    selectedTheme = 11; // json['selectedTheme'] ?? 0; // 0 - the default theme
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    // data['salonId'] = this.salonId;
    data['salonName'] = salonName;
    data['salonName'] = salonName;
    createdAt = data['createdAt'] != null ? data['createdAt']?.toDate() : DateTime.now();
    data['categoryId'] = categoryId;
    data['appointmentsLeadTime'] = appointmentsLeadTime;
    data['parentServiceId'] = parentServiceId;
    data['ownerType'] = ownerType;
    data['workStation'] = workStation;
    data['address'] = address;
    data['isAvailableOnline'] = isAvailableOnline;
    data['bookingRestrictionDays'] = bookingRestrictionDays;
    if (links != null) {
      data['links'] = links!.toJson();
    }
    if (position != null) {
      data['position'] = position!.toJson();
    }
    data['workingHours'] = workingHours?.toJson();
    data['timeSlotsInterval'] = timeSlotsInterval;
    data['salonWebSite'] = salonWebSite;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['description'] = description;
    data['profilePics'] = profilePics;
    data['photosOfWork'] = photosOfWork;
    data['rating'] = rating;
    data['preferredGender'] = preferredGender;
    data['avgRating'] = avgRating;
    data['reviewCount'] = reviewCount;
    data['distanceFromCenter'] = distanceFromCenter;
    data['fcmToken'] = fcmToken;
    data['blockedTime'] = blockedTime;
    data['searchTags'] = searchTags;
    data['additionalFeatures'] = additionalFeatures;
    data['requestSalon'] = requestSalon;
    data['selectedTheme'] = selectedTheme;
    return data;
  }

  Map<String, Hours> mapIrregularHours(Map<String, dynamic>? map) {
    Map<String, Hours> irregularWorkingHours = {};

    try {
      if (map != null) {
        map.forEach((key, value) {
          if (value != null) {
            irregularWorkingHours[key] = Hours.fromJson(value);
          }
        });
      }

      return irregularWorkingHours;
    } catch (e) {
      return {};
    }
  }
}

class Position {
  String? geoHash;
  GeoPoint? geoPoint;

  Position({this.geoHash, this.geoPoint});

  Position.fromJson(Map<String, dynamic> json) {
    geoHash = json['geohash'] ?? '';
    geoPoint = json['geopoint'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['geohash'] = geoHash;
    data['geopoint'] = geoPoint;
    return data;
  }

  Position getDefaultPosition() => Position(
        geoHash: 'u8vxn8bw',
        geoPoint: const GeoPoint(50.45445, 30.52088),
      );

  LatLng getDefaultLatLng() => const LatLng(40.71427, -74.00597);

  //main backup => LatLng(50.45445, 30.52088);
  // test salon coordinates=> LatLng( 40.71427, -74.00597);
  // ukraine second test const LatLng( 50.450001, 30.523333);

}

class Links {
  String? facebookMessenger;
  String? viber;
  String? telegram;
  String? whatsapp;
  String? instagram;

  Links(Map map, {this.facebookMessenger, this.viber, this.telegram, this.whatsapp, this.instagram});

  Links.fromJson(Map<String, dynamic> json) {
    facebookMessenger = json['facebookMessenger'];
    viber = json['viber'];
    telegram = json['telegram'];
    whatsapp = json['whatsapp'];
    instagram = json['instagram'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['facebookMessenger'] = facebookMessenger;
    data['viber'] = viber;
    data['telegram'] = telegram;
    data['whatsapp'] = whatsapp;
    data['instagram'] = instagram;
    return data;
  }
}
