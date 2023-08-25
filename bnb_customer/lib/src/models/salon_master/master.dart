import 'package:bbblient/src/models/cat_sub_service/price_and_duration.dart';
import 'package:bbblient/src/utils/utils.dart';
import '../backend_codings/working_hours.dart';

class MasterModel {
  DateTime? createdAt;

  bool availableOnline = false;
  late String masterId;
  late String salonId;
  String? beautyProId;
  String? yClientsId;
  PersonalInfoMaster? personalInfo;
  WorkingHoursModel? workingHours;
  Map<String, Hours>? irregularWorkingHours;
  List<String>? categoryIds;
  List<String>? serviceIds;
  List<String>? reviewIds;
  //types of master
  List<String>? masterTags;
  List<String>? photosOfWork;
  String? profilePicUrl;

  // contains all the reserved slots
  Map<String, dynamic>? blockedTime;

  // for local use only (not require to push over backend)
  // random number assigned between 1 to 10 (all inclusive), which decides the color of the frame
  int? colorCode;

  // contains the price and duration of all service assigned to a master
  Map<String, PriceAndDurationModel>? servicesPriceAndDuration;
  Map<String, PriceAndDurationModel>? originalServicesPriceAndDuration; // untouched

  Map<String, PriceAndDurationModel>? servicesPriceAndDurationMax;
  Map<String, PriceAndDurationModel>? originalServicesPriceAndDurationMax;
  String? title;

  double? avgRating;
  double? reviewCount;
  List<String>? searchTags;

  MasterModel({
    this.createdAt,
    required this.masterId,
    required this.salonId,
    this.beautyProId,
    this.yClientsId,
    required this.availableOnline,
    this.personalInfo,
    this.workingHours,
    this.categoryIds,
    this.serviceIds,
    this.reviewIds,
    this.masterTags,
    this.photosOfWork,
    this.profilePicUrl,
    this.irregularWorkingHours,
    this.blockedTime,
    this.servicesPriceAndDuration,
    this.originalServicesPriceAndDuration,
    this.servicesPriceAndDurationMax,
    this.originalServicesPriceAndDurationMax,
    this.colorCode,
    this.reviewCount,
    this.avgRating,
    this.searchTags,
    this.title,
  });

  MasterModel.fromJson(Map<String, dynamic> json) {
    if (json['createdAt'] != null) createdAt = json['createdAt'].toDate();

    masterId = json['masterId'];
    salonId = json['salonId'];
    beautyProId = json['beautyProId'];
    yClientsId = json['yClientsId'];
    personalInfo = json['personalInfo'] != null ? PersonalInfoMaster.fromJson(json['personalInfo']) : null;
    workingHours = json['workingHours'] != null ? WorkingHoursModel.fromJson(json['workingHours']) : null;
    categoryIds = json['categoryIds']?.cast<String>() ?? [];
    serviceIds = json['serviceIds']?.cast<String>() ?? [];
    reviewIds = json['reviewIds']?.cast<String>() ?? [];
    masterTags = json['masterTags']?.cast<String>() ?? [];
    photosOfWork = json['photosOfWork']?.cast<String>() ?? [];
    profilePicUrl = json['profilePicUrl'] ?? '';
    availableOnline = json['availableOnline'] ?? false;
    blockedTime = json['blockedTime'] ?? {};
    servicesPriceAndDuration = json['servicesPriceAndDuration'] != null ? mapPriceAndDuration(json['servicesPriceAndDuration']) : {};
    originalServicesPriceAndDuration = json['servicesPriceAndDuration'] != null ? mapPriceAndDuration(json['servicesPriceAndDuration']) : {};
    if (json['servicesPriceAndDurationMax'] != null) {
      servicesPriceAndDurationMax = mapPriceAndDuration(json['servicesPriceAndDurationMax']);
      originalServicesPriceAndDurationMax = mapPriceAndDuration(json['servicesPriceAndDurationMax']);
    }
    irregularWorkingHours = json['irregularWorkingHours'] != null ? mapIrregularHours(json['irregularWorkingHours']) : null;
    colorCode = Utils().assignColorCode();
    if (json['avgRating'] != null) avgRating = json['avgRating'].toDouble();
    if (json['reviewCount'] != null) {
      reviewCount = json['reviewCount'].toDouble();
    }
    if (json['searchTags'] != null) {
      searchTags = json['searchTags'].cast<String>();
    }
    title = json['title'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (createdAt != null) data['createdAt'] = createdAt;

    data['salonId'] = salonId;
    data['masterId'] = masterId;
    data['beautyProId'] = beautyProId;
    if (personalInfo != null) {
      data['personalInfo'] = personalInfo!.toJson();
    }
    if (workingHours != null) {
      data['workingHours'] = workingHours!.toJson();
    }
    data['categoryIds'] = categoryIds;
    data['serviceIds'] = serviceIds;
    data['reviewIds'] = reviewIds;
    data['masterTags'] = masterTags;
    data['photosOfWork'] = photosOfWork;
    data['profilePicUrl'] = profilePicUrl;
    data['availableOnline'] = availableOnline;
    data['blockedTime'] = blockedTime;
    data['servicesPriceAndDuration'] = priceAndDurationToJson(servicesPriceAndDuration);
    data['searchTags'] = searchTags;
    if (avgRating != null) data['avgRating'] = avgRating;
    if (reviewCount != null) data['reviewCount'] = reviewCount;
    data['title'] = title;

    return data;
  }

  //generates a map of PriceAndDuration where key is service id
  Map<String, PriceAndDurationModel> mapPriceAndDuration(Map<String, dynamic>? map) {
    Map<String, PriceAndDurationModel> servicesPriceAndDurationMap = {};

    try {
      if (map != null) {
        map.forEach((key, value) {
          if (value != null) {
            servicesPriceAndDurationMap[key] = PriceAndDurationModel.fromJson(value);
          }
        });
      }

      return servicesPriceAndDurationMap;
    } catch (e) {
      printIt(e);
      return {};
    }
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
      printIt(e);
      return {};
    }
  }

  //generates a map of PriceAndDuration where key is service id
  Map<String, dynamic> priceAndDurationToJson(Map<String, PriceAndDurationModel>? map) {
    Map<String, dynamic> priceAndDurationJson = {};

    try {
      if (map != null) {
        map.forEach((key, value) {
          priceAndDurationJson[key] = value.toJson();
        });
      }

      return priceAndDurationJson;
    } catch (e) {
      printIt(e);
      return {};
    }
  }
}

class PersonalInfoMaster {
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? description;

  PersonalInfoMaster({this.firstName, this.lastName, this.phone, this.email, this.description});

  PersonalInfoMaster.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    phone = json['phone'];
    email = json['email'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phone'] = phone;
    data['email'] = email;
    data['description'] = description;
    return data;
  }
}
