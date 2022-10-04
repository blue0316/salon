import 'package:flutter/cupertino.dart';

import '../salon_master/salon.dart';

class CustomerModel {
  late String customerId;
  late DateTime createdAt;
  late PersonalInfo personalInfo;
  late int noOfRatings;
  late double avgRating;
  late bool profilePicUploaded;
  late bool profileCompleted;
  late bool quizCompleted;
  late String profilePic;
  late List<String> registeredSalons;
  late List<Position> locations;
  late String preferredGender;
  late List<String> preferredCategories;
  late String fcmToken;
  late String locale;
  late List<String> favSalons;
  late String referralLink;

  CustomerModel({
    required this.customerId,
    required this.personalInfo,
    required this.registeredSalons,
    required this.createdAt,
    required this.avgRating,
    required this.noOfRatings,
    required this.profilePicUploaded,
    required this.profilePic,
    required this.profileCompleted,
    required this.quizCompleted,
    required this.preferredGender,
    required this.preferredCategories,
    required this.locations,
    required this.fcmToken,
    required this.locale,
    required this.favSalons,
    required this.referralLink,
  });

  CustomerModel.fromJson(Map<String, dynamic> json) {
    createdAt =
        json['createdAt'] != null ? json['createdAt'].toDate() : DateTime.now();
    customerId = '';
    personalInfo = PersonalInfo.fromJson(json['personalInfo']);
    registeredSalons = json['registeredSalons'] == null
        ? []
        : json['registeredSalons'].cast<String>();
    avgRating = (json['avgRating'] != null) ? json['avgRating'].toDouble() : 0;
    noOfRatings =
        (json['noOfRatings'] != null) ? json['noOfRatings'].toInt() : 0;
    profileCompleted = json['profileCompleted'] ?? false;
    quizCompleted = json['quizCompleted'] ?? false;
    profilePicUploaded = json['profilePicUploaded'] ?? false;
    profilePic = json['profilePic'] ?? '';
    preferredGender = json['preferredGender'] ?? 'all';
    preferredCategories = json['preferredCategories'] == null
        ? []
        : json['preferredCategories'].cast<String>();
    favSalons =
        json['favSalons'] == null ? [] : json['favSalons'].cast<String>();
    fcmToken = json['fcmToken'] ?? '';
    locations = json['locations'] == null
        ? []
        : locations = json['locations']
            .map<Position>((val) => Position.fromJson(val))
            .toList();
    locale = json['locale'] ?? 'uk';
    referralLink = json['referralLink'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['createdAt'] = createdAt;
    data['personalInfo'] = personalInfo.toJson();
    data['registeredSalons'] = registeredSalons;
    data['avgRating'] = avgRating;
    data['noOfRatings'] = noOfRatings;
    data['profilePic'] = profilePic;
    data['preferredGender'] = preferredGender;
    data['preferredCategories'] = preferredCategories;
    data['locations'] =
        locations.map<Map<String, dynamic>>((loc) => loc.toJson()).toList();
    data['favSalons'] = favSalons;
    data['fcmToken'] = fcmToken;
    data['profileCompleted'] = profileCompleted;
    data['quizCompleted'] = quizCompleted;
    data['profilePicUploaded'] = profilePicUploaded;
    data['referralLink'] = referralLink;
    return data;
  }
}

class PersonalInfo {
  PersonalInfo({
    required this.phone,
    // required this.nameforNotification,
    this.firstName,
    this.lastName,
    this.email,
    this.description,
    this.dob,
    this.sex,
  });
  late String phone;
  String? firstName;
  String? lastName;
  String? email;
  // String? nameforNotification;
  String? description;
  DateTime? dob;
  String? sex;

  PersonalInfo.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    description = json['description'];
    dob = json['dob']?.toDate() ?? DateTime.now();
    sex = json['sex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['phone'] = phone;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['description'] = description;
    data['dob'] = dob;
    data['sex'] = sex;
    return data;
  }
}
