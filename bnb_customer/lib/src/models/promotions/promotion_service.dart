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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['promotionTitle'] = this.promotionTitle;
    data['promotionDiscount'] = this.promotionDiscount;
    data['discountUnit'] = this.discountUnit;
    data['promotionType'] = this.promotionType;
    data['salonId'] = this.salonId;
    data['promoDocId'] = this.promoDocId;
    data['promotionDescription'] = this.promotionDescription;
    data['lastMinuteBookingUnit'] = this.lastMinuteBookingUnit;
    data['lastMinuteBookingValue'] = this.lastMinuteBookingValue;
    data['visitStatus'] = this.visitStatus;
    data['numberOfAvailableSlots'] = this.numberOfAvailableSlots;
    data['numberOfInitialSlots'] = this.numberOfInitialSlots;
    data['createdAt'] = this.createdAt;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    // data['service'] = this.service!.toJson();

    data['activeStatus'] = this.activeStatus ?? false;
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
}
