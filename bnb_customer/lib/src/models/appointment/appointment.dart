import 'package:bbblient/src/models/cat_sub_service/price_and_duration.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../backend_codings/appointment.dart';
import '../backend_codings/owner_type.dart';

class AppointmentModel {
  late String type = AppointmentType.reservation;

  /// pass for customer app .where(type= [AppointmentType.reservation])
  late DateTime createdAt;
  late DateTime appointmentStartTime;
  late DateTime appointmentEndTime;
  late String appointmentTime;
  late String appointmentDate;
  String? appointmentId;
  late Salon salon;
  Master? master;
  Customer? customer;
  late String createdBy = CreatedBy.customer;
  String? note;
  String? chatId;
  late String salonOwnerType;
  String? locale;

  /// [OwnerType.]
  bool? bookedForSelf = true;
  String? bookedForName;
  String? bookedForPhoneNo;
  late String status;
  late String subStatus;

  late PaymentInfo? paymentInfo;

  /// status of the appointment can be active, cancelled etc see [AppointmentStatus]
  /// list of the all the updates
  late List<String> updates;

  /// all the  updates [AppointmentUpdates] last index will be the latest update
  List<DateTime>? updatedAt;

  late List<Service> services;
  late PriceAndDurationModel priceAndDuration;
  late bool? masterReviewed = false;
  late bool? salonReviewed = false;

  ///Client's names to be shown while booking an appointment
  String? firstName;
  String? lastName;

  String? beautyProId;
  String? yClientsId;

  ///for identifing the 3 appointments created (prep ,clean up and all)
  String? appointmentIdentifier;

  // id of appointment transaction
  String? transactionId;

  AppointmentModel({
    required this.appointmentStartTime,
    required this.appointmentEndTime,
    required this.createdAt,
    required this.appointmentTime,
    required this.appointmentDate,
    this.appointmentId,
    required this.priceAndDuration,
    required this.updates,
    required this.status,
    this.subStatus = ActiveAppointmentSubStatus.unConfirmed,
    required this.services,
    required this.createdBy,
    this.bookedForSelf,
    this.masterReviewed,
    this.salonReviewed,
    required this.paymentInfo,
    this.type = AppointmentType.reservation,
    this.updatedAt,
    required this.salon,
    this.master,
    this.customer,
    this.chatId,
    this.bookedForName,
    this.locale,
    this.firstName,
    this.lastName,
    this.bookedForPhoneNo,
    this.salonOwnerType = OwnerType.salon,
    this.note,
    this.beautyProId,
    this.yClientsId,
    this.transactionId,
  });

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    printIt(json['updatedAt']);
    type = json['type'] ?? AppointmentType.reservation;
    appointmentStartTime = json['appointmentStartTime'].toDate();
    appointmentIdentifier = json['appointmentIdentifier'] ?? "";

    createdAt = json['createdAt'].toDate();
    appointmentEndTime = json['appointmentEndTime'].toDate();
    if (json['updatedAt'] != null && json['updatedAt'].isNotEmpty) {
      List<DateTime> _updates = [];
      for (Timestamp t in json['updatedAt']) {
        printIt(t.runtimeType);
        var x = DateTime.parse(t.toDate().toString());
        _updates.add(x);
      }
      updatedAt = _updates;
    } else {
      updatedAt = [];
    }
    paymentInfo = json['paymentInfo'] != null ? PaymentInfo.fromJson(json['paymentInfo']) : null;

    appointmentTime = json['appointmentTime'];
    if (json['appointmentDate'] is String) {
      appointmentDate = json['appointmentDate'];
    }
    appointmentId = json['appointmentId'] ?? '';
    if (json['salon'] != null) salon = Salon.fromJson(json['salon']);
    if (json['master'] != null) master = Master.fromJson(json['master']);
    if (json['customer'] != null) {
      customer = Customer.fromJson(json['customer']);
    }
    createdBy = json['createdBy'];
    chatId = json['chatId'];
    bookedForSelf = json['bookedForSelf'] ?? true;
    locale = json['locale'] ?? 'eng';
    firstName = json['firstName'];
    lastName = json['lastName'];
    bookedForName = json['bookedForName'] ?? '';
    bookedForPhoneNo = json['bookedForPhoneNo'] ?? '';
    salonOwnerType = json['salonOwnerType'];
    note = json['note'] ?? '';
    if (json['priceAndDuration'] != null) {
      priceAndDuration = PriceAndDurationModel.fromJson(json['priceAndDuration']);
    }
    updates = json['updates'] == null ? [] : json['updates'].cast<String>();
    status = json['status'];
    subStatus = json['subStatus'] ?? ActiveAppointmentSubStatus.unConfirmed;
    services = json['services'] != null ? json['services'].map<Service>((e) => Service.fromJson(e)).toList() : [];
    masterReviewed = json['masterReviewed'] ?? false;
    salonReviewed = json['salonReviewed'] ?? false;
    beautyProId = json['beautyProId'];
    yClientsId = json['yClientsId'];
    transactionId = json['transactionId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['appointmentStartTime'] = appointmentStartTime;
    data['createdAt'] = createdAt;
    data['appointmentIdentifier'] = appointmentIdentifier;
    data['appointmentEndTime'] = appointmentEndTime;
    data['updatedAt'] = updatedAt;
    data['appointmentTime'] = appointmentTime;
    data['appointmentDate'] = appointmentDate;
    data['salon'] = salon.toJson();
    data['paymentInfo'] = paymentInfo?.toJson();
    if (master != null) {
      data['master'] = master!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    data['createdBy'] = createdBy;
    data['chatId'] = chatId;
    data['bookedForSelf'] = bookedForSelf;
    data['bookedForName'] = bookedForName ?? '';
    data["bookedForPhoneNo"] = bookedForPhoneNo;
    data['salonOwnerType'] = salonOwnerType;
    data['locale'] = locale;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    // ??  AppLocalizations.of(context)?.localeName.toString().toLowerCase();
    data['note'] = note;
    data['priceAndDuration'] = priceAndDuration.toJson();
    data['updates'] = updates;
    data['status'] = status;
    data['subStatus'] = subStatus;
    data['services'] = services.map((e) => e.toJson()).toList();
    data['masterReviewed'] = masterReviewed;
    data['salonReviewed'] = salonReviewed;
    data['beautyProId'] = beautyProId;
    data['yClientsId'] = yClientsId;
    data['transactionId'] = transactionId;

    return data;
  }
}

///holds the service details

class Service {
  //id of the service
  late String serviceId;
  late String categoryId;
  late String subCategoryId;
  late String serviceName;
  late PriceAndDurationModel priceAndDuration;
  late PriceAndDurationModel? priceAndDurationMax;
  late Map translations;
  // includes processing time duration during apppointment that is opened for booking after start processing
  bool hasProcessingTime = false;
  // start of processing for special services
  int? startProcessingTime;
  // processing time used to finish appoitment with user
  int? endProcessingTime;
  // clean up time for salon after an appointment
  int? cleanUpTime;
  // preparation time before an appointment
  int? preparationTime;
  //processing time
  int? processingTime;

  Service({
    required this.serviceId,
    required this.categoryId,
    required this.subCategoryId,
    required this.serviceName,
    required this.priceAndDuration,
    this.priceAndDurationMax,
    required this.translations,
    this.hasProcessingTime = false,
    this.startProcessingTime,
    this.endProcessingTime,
    this.cleanUpTime,
    this.preparationTime,
    this.processingTime,
  });

  Service.fromJson(dynamic json) {
    serviceId = json["serviceId"] ?? '';
    categoryId = json["categoryId"];
    subCategoryId = json["subCategoryId"];
    serviceName = json["serviceName"];
    if (json['priceAndDuration'] != null) {
      priceAndDuration = PriceAndDurationModel.fromJson(json['priceAndDuration']);
    }
    if (json['priceAndDurationMax'] != null) {
      priceAndDurationMax = PriceAndDurationModel.fromJson(json['priceAndDurationMax']);
    }
    if (json["translations"] != null) translations = {...json["translations"]};

    hasProcessingTime = json["hasProcessingTime"] ?? false;
    if (json["startProcessingTime"] != null) startProcessingTime = json["startProcessingTime"];
    if (json["endProcessingTime"] != null) endProcessingTime = json["endProcessingTime"];
    if (json["processingTime"] != null) processingTime = json["processingTime"];
    if (json["cleanUpTime"] != null) cleanUpTime = json["cleanUpTime"];
    if (json["preparationTime"] != null) preparationTime = json["preparationTime"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['serviceId'] = serviceId;
    map["categoryId"] = categoryId;
    map["subCategoryId"] = subCategoryId;
    map["serviceName"] = serviceName;
    map['priceAndDuration'] = priceAndDuration.toJson();
    map["translations"] = translations;
    map['hasProcessingTime'] = hasProcessingTime;
    if (startProcessingTime != null) map['startProcessingTime'] = startProcessingTime;
    if (endProcessingTime != null) map['endProcessingTime'] = endProcessingTime;
    if (processingTime != null) map['processingTime'] = processingTime;
    if (cleanUpTime != null) map['cleanUpTime'] = cleanUpTime;
    if (preparationTime != null) map['preparationTime'] = preparationTime;

    return map;
  }

  Service.fromService({required ServiceModel serviceModel, PriceAndDurationModel? masterPriceAndDuration}) {
    serviceId = serviceModel.serviceId;
    categoryId = serviceModel.categoryId;
    subCategoryId = serviceModel.subCategoryId;
    serviceName = serviceModel.serviceName;
    priceAndDuration = masterPriceAndDuration ?? serviceModel.priceAndDuration;
    if (serviceModel.priceAndDurationMax != null) {
      priceAndDurationMax = serviceModel.priceAndDurationMax;
    }

    translations = serviceModel.translations;
    startProcessingTime = serviceModel.startProcessingTime;
    endProcessingTime = serviceModel.endProcessingTime;
    processingTime = serviceModel.processingTime;
    cleanUpTime = serviceModel.cleanUpTime;
    preparationTime = serviceModel.preparationTime;
  }
}

class Master {
  //id of the service
  late String id;
  late String name;

  Master({required this.id, required this.name});

  Master.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;

    return map;
  }
}

class Salon {
  //id of the service
  late String id;
  late String name;
  late String phoneNo;
  // Position? location;
  late String address;

  Salon({
    required this.id,
    required this.name,
    // this.location,
    required this.phoneNo,
    required this.address,
  });

  Salon.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    // todo default location for salons
    // location = json['location'] != null
    //     ? Position.fromJson(json['location'])
    //     : Position(geoHash: '', geoPoint: const GeoPoint(0, 0));
    phoneNo = json['phoneNo'] ?? '';
    address = json['address'] ?? '';
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    // map['location'] = location!.toJson();
    map['phoneNo'] = phoneNo;
    map['address'] = address;
    return map;
  }
}

class Customer {
  //id of the service
  late String id;
  late String name;
  late String? pic;
  late String phoneNumber;
  late String email;

  Customer({
    required this.id,
    required this.name,
    required this.pic,
    required this.phoneNumber,
    required this.email,
  });

  Customer.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    pic = json["pic"];
    phoneNumber = json["phoneNumber"];
    email = json["email"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["pic"] = pic;
    map["phoneNumber"] = phoneNumber;
    map["email"] = email;
    return map;
  }
}

class PaymentInfo {
  PaymentInfo({
    required this.bonusApplied,
    required this.bonusAmount,
    required this.actualAmount,
    required this.bonusIds,
    required this.paymentDone,
    required this.onlinePayment,
    required this.paymentMethod,
    this.payedAt,
    this.isFirstBooking,
    this.referralId,
    this.paymentTransectionId,
  });

  bool bonusApplied;
  num bonusAmount;
  num actualAmount;
  List<String> bonusIds;
  bool? isFirstBooking;
  bool paymentDone;
  bool onlinePayment;
  String? referralId;
  String? paymentMethod;
  String? paymentTransectionId;
  DateTime? payedAt;

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
        bonusApplied: json["bonusApplied"] ?? false,
        bonusAmount: json["bonusAmount"] ?? 0,
        actualAmount: json['actualAmount'] ?? 0,
        bonusIds: List<String>.from(json["bonusIds"].map((x) => x)),
        isFirstBooking: json["isFirstBooking"],
        paymentDone: json["paymentDone"],
        onlinePayment: json["onlinePayment"],
        referralId: json["referralId"],
        paymentMethod: json["paymentMethod"],
        paymentTransectionId: json["paymentTransectionId"],
        payedAt: json["payedAt"],
      );

  Map<String, dynamic> toJson() => {
        "bonusApplied": bonusApplied,
        "bonusAmount": bonusAmount,
        "actualAmount": actualAmount,
        "bonusIds": List<dynamic>.from(bonusIds.map((x) => x)),
        "isFirstBooking": isFirstBooking,
        "paymentDone": paymentDone,
        "onlinePayment": onlinePayment,
        "referralId": referralId,
        "paymentMethod": paymentMethod,
        "paymentTransectionId": paymentTransectionId,
        "payedAt": payedAt,
      };
}
