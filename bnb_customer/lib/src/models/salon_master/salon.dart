import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/enums/gender.dart';
import 'package:bbblient/src/utils/currency/currency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../backend_codings/working_hours.dart';

enum TimeFormat { amPM, twentyFourHr }

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
  late String email;
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
  late List<PhotosOfWorks>? photosOfWorks = [];
  double? distanceFromCenter;
  late String? fcmToken;
  late Map<String, dynamic> blockedTime = {};
  late List<String> searchTags = [];
  late bool requestSalon;
  late String salonLogo;
  String? countryCode;
  bool? isAutomaticBookingConfirmation;
  late TimeFormat timeFormat;
  late List<String> customerWebLanguages = [];
  CancellationAndNoShow cancellationAndNoShowPolicy = CancellationAndNoShow.fromJson({});

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
    required this.email,
    required this.categoryId,
    required this.parentServiceId,
    required this.description,
    required this.profilePics,
    required this.photosOfWork,
    required this.photosOfWorks,
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
    required this.salonLogo,
    this.isAutomaticBookingConfirmation = false,
    this.timeFormat = TimeFormat.amPM,
    required this.customerWebLanguages,
    required this.cancellationAndNoShowPolicy,
    this.countryCode,
  });

  SalonModel.fromJson(Map<String, dynamic> json) {
    salonId = json['salonId'];
    salonName = json['salonName'] ?? '';
    appointmentsLeadTime = json['appointmentsLeadTime'];
    categoryId = json['categoryId'] == null ? [] : categoryId = json['categoryId'].cast<String>();

    parentServiceId = json['parentServiceId'] == null ? [] : parentServiceId = json['parentServiceId'].cast<String>();
    timeSlotsInterval = json['timeSlotsInterval'] ?? 15;
    bookingRestrictionDays = json['bookingRestrictionDays'];
    createdAt = json['createdAt'] != null ? json['createdAt'].toDate() : DateTime(1990);
    address = json['address'] ?? '';
    ownerType = json['ownerType'] ?? OwnerType.salon;
    workStation = json['workStation'] ?? '';
    isAvailableOnline = json['isAvailableOnline'] ?? false;
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    position = json['position'] != null ? Position.fromJson(json['position']) : null;
    workingHours = WorkingHoursModel.fromJson(json['workingHours']);
    irregularWorkingHours = json['irregularWorkingHours'] != null ? mapIrregularHours(json['irregularWorkingHours']) : null;
    salonWebSite = json['salonWebSite'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    email = json['email'] ?? '';
    locale = json['locale'] ?? 'en';
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

    if (json['photosOfWorks'] != null) {
      photosOfWorks = List<PhotosOfWorks>.from(
        json["photosOfWorks"].map((x) => PhotosOfWorks.fromJson(x)),
      );
    }

    preferredGender = json['preferredGender'] ?? '';
    rating = json['rating'] != null ? double.parse(json['rating'].toString()) : 0;
    avgRating = json['avgRating'] != null ? double.parse(json['avgRating'].toString()) : 0;
    reviewCount = json['reviewCount'] != null ? double.parse(json['reviewCount'].toString()) : 0;
    distanceFromCenter = json['distanceFromCenter'];
    fcmToken = json['fcmToken'] ?? '';
    blockedTime = json['blockedTime'] ?? {};
    searchTags = json['searchTags'] != null ? json['searchTags'].cast<String>() : [];
    additionalFeatures = json['additionalFeatures'] != null ? json['additionalFeatures'].cast<String>() : [];
    requestSalon = json['requestSalon'] ?? false;
    salonLogo = json['salonLogo'] ?? '';
    selectedCurrency = (json['selectedCurrency'] != null) ? getCurrency(json['countryCode']) : '\$';
    countryCode = json['countryCode'] ?? "";
    isAutomaticBookingConfirmation = json['isAutomaticBookingConfirmation'] ?? false;
    timeFormat = (json['timeFormat'] == '24H') ? timeFormat = TimeFormat.twentyFourHr : timeFormat = TimeFormat.amPM;
    customerWebLanguages = json['customerWebLanguages'] ?? ['en'];
    cancellationAndNoShowPolicy = json['cancellationAndNoShowPolicy'] != null
        ? CancellationAndNoShow.fromJson(json['cancellationAndNoShowPolicy'])
        : CancellationAndNoShow.fromJson(
            {},
          );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    // data['salonId'] = this.salonId;
    data['salonName'] = salonName;
    data['salonName'] = salonName;
    data['salonLogo'] = salonLogo;
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
    data['timeFormat'] = timeFormat;
    data['customerWebLanguages'] = customerWebLanguages;

    // data['selectedTheme'] = selectedTheme;
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

class PhotosOfWorks {
  dynamic createdAt;
  String? image;
  String? description;

  PhotosOfWorks({
    this.createdAt,
    this.image,
    this.description,
  });

  PhotosOfWorks.fromJson(Map<String, dynamic> json) {
    createdAt = json["createdAt"];
    image = json['image'];
    description = json['imageDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['createdAt'] = createdAt!.toIso8601String();
    data['image'] = image ?? '';
    data['description'] = description ?? '';

    return data;
  }
}

class Links {
  late String facebook;
  late String instagram;
  late String twitter;
  late String pinterest;
  late String yelp;
  late String tiktok;
  late String website;

  Links(
    Map map, {
    required this.facebook,
    required this.instagram,
    required this.twitter,
    required this.pinterest,
    required this.yelp,
    required this.tiktok,
    required this.website,
  });

  Links.fromJson(Map<String, dynamic> json) {
    facebook = json['facebook'] ?? '';
    instagram = json['instagram'] ?? '';
    twitter = json['twitter'] ?? '';
    pinterest = json['pinterest'] ?? '';
    yelp = json['yelp'] ?? '';
    tiktok = json['tiktok'] ?? '';
    website = json['website'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['facebook'] = facebook;
    data['instagram'] = instagram;
    data['twitter'] = twitter;
    data['pinterest'] = pinterest;
    data['yelp'] = yelp;
    data['tiktok'] = tiktok;
    data['website'] = website;
    return data;
  }
}

class CancellationAndNoShow {
  String requireCardToBookOnline;
  bool allowOnlineCancellation;
  String cancellationWindow;
  bool setCancellationAndNoShowPolicy;
  String chargeWhenNoShow;
  String chargeWhenNoShowPercent;

  CancellationAndNoShow({
    required this.requireCardToBookOnline,
    required this.allowOnlineCancellation,
    required this.cancellationWindow,
    required this.setCancellationAndNoShowPolicy,
    required this.chargeWhenNoShow,
    required this.chargeWhenNoShowPercent,
  });

  factory CancellationAndNoShow.fromJson(Map<String, dynamic> json) => CancellationAndNoShow(
        requireCardToBookOnline: json['requireCardToBookOnline'] ?? 'OFF',
        allowOnlineCancellation: json['allowOnlineCancellation'] ?? false,
        cancellationWindow: json['cancellationWindow'] ?? '',
        setCancellationAndNoShowPolicy: json['setCancellationAndNoShowPolicy'] ?? false,
        chargeWhenNoShow: json['chargeWhenNoShow'] ?? '',
        chargeWhenNoShowPercent: json['chargeWhenNoShowPercent'] ?? '',
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requireCardToBookOnline'] = requireCardToBookOnline;
    data['allowOnlineCancellation'] = allowOnlineCancellation;
    data['cancellationWindow'] = cancellationWindow;
    data['setCancellationAndNoShowPolicy'] = setCancellationAndNoShowPolicy;
    data['chargeWhenNoShow'] = chargeWhenNoShow;
    data['chargeWhenNoShowPercent'] = chargeWhenNoShowPercent;

    return data;
  }
}
