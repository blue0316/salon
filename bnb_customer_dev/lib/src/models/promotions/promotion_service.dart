// ignore_for_file: prefer_collection_literals, constant_identifier_names

import '../cat_sub_service/services_model.dart';

class PromotionModel {
  // title of promotion
  String? promotionTitle;

  // discount for promotion
  String? promotionDiscount;

  // discount for promotion
  String? discountUnit;

  // Promotion Document Id
  String? promoDocId;

  // type of promotion
  String? promotionType = PromotionType.service;

  //Salon Id
  String? salonId;

  // promotion description
  String? promotionDescription;

  // promotion description
  String? visitStatus;

  // last Minute Booking discount
  String? lastMinuteBookingValue;

  // last Minute Booking unit
  String? lastMinuteBookingUnit;

  //number of available slots for the promotion
  String? numberOfAvailableSlots;

  //number of initial slots for the promotion
  String? numberOfInitialSlots;

  // Starting Date of Promtion
  DateTime? startDate;

  // Ending Date of Promtion
  DateTime? endDate;

  // time it was created
  DateTime? createdAt;

  // //service for service type
  // Service? service;

  // list of Services for the service set type of promotion
  List<ServiceModel>? services = [];

  //This holds translation of promotion
  Map? translation = {};

  // condition for when the promotion is active
  bool? activeStatus = false;

  // Map<String, dynamic>? itemDimensions;

  // promotion description
  String? promotionImage;

  PromotionModel(
      {this.promotionTitle,
      this.promotionDiscount,
      this.discountUnit,
      this.promotionType,
      this.salonId,
      this.promoDocId,
      this.promotionDescription,
      this.visitStatus,
      this.lastMinuteBookingUnit,
      this.lastMinuteBookingValue,
      this.numberOfAvailableSlots,
      this.startDate,
      // this.service,
      this.endDate,
      this.createdAt,
      this.activeStatus,
      this.translation,
      this.services});

  PromotionModel.fromJson(Map<String, dynamic> json) {
    promotionTitle = json['promotionTitle'] ?? '';
    // itemDimensions = json['itemDimensions'] ?? "";
    // productAid = json['aid'] ?? "";
    promotionDiscount = json['promotionDiscount'] ?? 0.0;
    promotionImage = json['promotionImage'] ?? 'assets/themes/glam_one/images/lady_wide.png';
    discountUnit = json['discountUnit'] ?? "";
    promotionType = json["promotionType"] ?? "";
    salonId = json['salonId'] ?? "";
    promoDocId = json['promoDocId'] ?? "";
    promotionDescription = json['promotionDescription'] ?? "";
    visitStatus = json['visitStatus'] ?? "";
    lastMinuteBookingUnit = json['lastMinuteBookingUnit'] ?? "";
    lastMinuteBookingValue = json['lastMinuteBookingValue'] ?? "";
    numberOfAvailableSlots = json['numberOfAvailableSlots'] ?? '0';
    numberOfInitialSlots = json['numberOfInitialSlots'] ?? '0';
    json['createdAt'] != null
        ? json['createdAt'].runtimeType == int
            ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'])
            : createdAt = json['createdAt'].toDate()
        : createdAt = null;
    activeStatus = json['activeStatus'] ?? false;
    json['startDate'] != null
        ? json['startDate'].runtimeType == int
            ? DateTime.fromMillisecondsSinceEpoch(json['startDate'])
            : startDate = json['startDate'].toDate()
        : startDate = null;
    // startDate = json['startDate'] ?? null;
    json['endDate'] != null
        ? json['endDate'].runtimeType == int
            ? DateTime.fromMillisecondsSinceEpoch(json['endDate'])
            : endDate = json['endDate'].toDate()
        : endDate = null;
    // service = json['service'] ?? null;
    if (json["translation"] != null) translation = {...json["translation"]};
    json['services'] == null
        ? services = []
        : services = json['services'].map<ServiceModel>((e) {
            return ServiceModel.fromJson(e);
          }).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['promotionTitle'] = promotionTitle;
    data['promotionDiscount'] = promotionDiscount;
    data['discountUnit'] = discountUnit;
    data['promotionType'] = promotionType;
    data['salonId'] = salonId;
    data['promoDocId'] = promoDocId;
    data['promotionDescription'] = promotionDescription;
    data['lastMinuteBookingUnit'] = lastMinuteBookingUnit;
    data['lastMinuteBookingValue'] = lastMinuteBookingValue;
    data['visitStatus'] = visitStatus;
    data['numberOfAvailableSlots'] = numberOfAvailableSlots;
    data['numberOfInitialSlots'] = numberOfInitialSlots;
    data['createdAt'] = createdAt;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    // data['service'] = this.service!.toJson();

    data['activeStatus'] = activeStatus ?? false;
    if (services != null && services!.isNotEmpty) {
      data['services'] = services!.map((e) => e.toJson()).toList();
    }

    return data;
  }
}

class PromotionType {
  static const String service = 'service';
  static const String service_set = 'service_set';
  static const String visit = 'visit';
  static const String happy_hour = 'happy_hour';
  static const String last_minute = 'last_minute';
  static const String happy_friday = 'happy_friday';
}
