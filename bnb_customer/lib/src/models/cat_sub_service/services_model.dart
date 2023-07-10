import 'package:bbblient/src/models/backend_codings/categories.dart';
import 'package:bbblient/src/models/cat_sub_service/price_and_duration.dart';
import 'package:flutter/material.dart';

class ServiceModel {
  //service photo
  String? servicePhoto;
  //id of the service
  String? serviceId;
  String? categoryId;
  String? subCategoryId;
  //service id of the parent service originated from (in the master table)
  String? parentServiceId;
  //id of the current salon
  String? salonId;
  // includes processing time duration during apppointment that is opened for booking after start processing
  bool hasProcessingTime = false;
  // if the service will need a deposit
  bool? hasDeposit;
  // if the service will have parallel clients
  // bool? hasParallelClients;
  // //after time for when there are parallel clients
  // int? parallelClientsTime;
  // //deposit for the service
  String? deposit;
  // processing time used to attend to user
  // String? parallelNoOfClients;
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

  Color? colorString;
  //type : women,men etc
  List preferredGender = [Gender.all];
  String? serviceName = '';
  String? description;
  // local var depicts if current service is selected locally or not
  bool? isSelected = false;

  // allow clients book online or not
  bool? allowClientsBookOnline;

  // is service active or not
  bool? isAvailableOnline = true;

  //service icon link
  CategoryIconLinkModel? icon;

  //this categorized to regular or special depending on whether it has processing time or not
  String? serviceProcessType;

  // number of seats available
  // if list is empty then,
  // we will automatically consider availability by number of masters
  SeatTypeModel? seat;

  PriceAndDurationModel? priceAndDuration = PriceAndDurationModel();
  //max price and duration of the service
  PriceAndDurationModel? priceAndDurationMax = PriceAndDurationModel();
  //variable price and duration range will be used if false otherwise, fixed price and duration
  ///  if true, [priceAndDuration] will be used
  ///  if false, [priceAndDuration] - [priceAndDurationMax] will be used
  late bool isFixedPrice;
  late bool isFixedDuration;
  late bool isPriceRange;
  late bool isPriceStartAt;

  //contains all the translations of supported lang
  Map? translations = {};
  Map? subCatTranslations = {};

  Map<String?, PriceAndDurationModel?>? masterPriceAndDurationMap = {};

  //order by which services are arranged in booking page on the customer side
  String? bookOrderId;
  ServiceModel({
    this.salonId,
    this.servicePhoto,
    this.serviceId,
    this.categoryId,
    this.subCategoryId,
    this.parentServiceId,
    this.colorString,
    required this.preferredGender,
    this.serviceName,
    this.description,
    this.isSelected,
    this.isAvailableOnline,
    this.priceAndDuration,
    this.priceAndDurationMax,
    this.bookOrderId,
    this.serviceProcessType,
    this.hasProcessingTime = false,
    this.startProcessingTime,
    this.endProcessingTime,
    this.cleanUpTime,
    this.preparationTime,
    this.processingTime,
    this.isFixedPrice = true,
    this.isFixedDuration = true,
    this.isPriceRange = false,
    this.isPriceStartAt = false,
    this.seat,
    this.translations,
    this.subCatTranslations,
    this.icon,
    this.masterPriceAndDurationMap,
    this.hasDeposit = false,
    this.deposit,
    // this.parallelNoOfClients,
    // this.hasParallelClients = false,
    // this.parallelClientsTime,
    this.allowClientsBookOnline = false,
  });

  //generate a copy of the service
  ServiceModel getCopy() {
    ServiceModel newService = ServiceModel.fromJson(toJson());
    newService.serviceId = serviceId;
    return newService;
  }

  ServiceModel.fromJson(dynamic json) {
    serviceId = json["serviceId"];

    if (json["salonId"] != null) salonId = json["salonId"];
    if (json["servicePhoto"] != null) servicePhoto = json["servicePhoto"];
    if (json["parentServiceId"] != null) parentServiceId = json["parentServiceId"];
    if (json["categoryId"] != null) categoryId = json["categoryId"];
    if (json["subCategoryId"] != null) subCategoryId = json["subCategoryId"];

    // hasParallelClients = json["hasParallelClients"] ?? false;

    allowClientsBookOnline = json["allowClientsBookOnline"] ?? false;

    // if (json["parallelClientsTime"] != null) parallelClientsTime = json["parallelClientsTime"];

    hasProcessingTime = json["hasProcessingTime"] ?? false;
    if (json["startProcessingTime"] != null) startProcessingTime = json["startProcessingTime"];
    if (json["endProcessingTime"] != null) endProcessingTime = json["endProcessingTime"];
    if (json["processingTime"] != null) processingTime = json["processingTime"];
    if (json["deposit"] != null) deposit = json["deposit"];
    if (json["cleanUpTime"] != null) cleanUpTime = json["cleanUpTime"];
    if (json["preparationTime"] != null) preparationTime = json["preparationTime"];
    // if (json["parallelNoOfClients"] != null) parallelNoOfClients = json["parallelNoOfClients"];
    if (json["colorString"] != null) colorString = Color(int.parse(json["colorString"].split('(0x')[1].split(')')[0], radix: 16));
    if (json["bookOrderId"] != null) bookOrderId = json["bookOrderId"];
    if (json["preferredGender"] != null) preferredGender = json["preferredGender"] is List ? json["preferredGender"] : [json["preferredGender"]];

    if (json["serviceName"] != null) serviceName = json["serviceName"];
    if (json["serviceProcessType"] != null) serviceName = json["serviceProcessType"];
    if (json["description"] != null) description = json["description"];
    // if (json["isSelected"] != null)
    isSelected = json["isSelected"] ?? false;
    hasDeposit = json["hasDeposit"] ?? false;
    // if (json["isAvailableOnline"] != null)
    isAvailableOnline = json["isAvailableOnline"] ?? false;
    if (json['priceAndDuration'] != null) priceAndDuration = PriceAndDurationModel.fromJson(json['priceAndDuration']);
    if (json['priceAndDurationMax'] != null) priceAndDurationMax = PriceAndDurationModel.fromJson(json['priceAndDurationMax']);

    isFixedPrice = json["isFixedPrice"] ?? true;
    isFixedDuration = json["isFixedDuration"] ?? true;
    isPriceRange = json["isPriceRange"] ?? false;
    isPriceStartAt = json["isPriceStartAt"] ?? false;

    icon = json['icon'] != null ? CategoryIconLinkModel.fromJson(json['icon']) : null;
    seat = json['seat'] != null ? SeatTypeModel.fromJson(json['seat']) : null;

    if (json["translations"] != null) translations = {...json["translations"]};
    if (json["subCatTranslations"] != null) subCatTranslations = {...json["subCatTranslations"]};

    if (json["masterPriceAndDurationMap"] != null) {
      masterPriceAndDurationMap = mapPriceAndDuration(
        Map<String, dynamic>.from(json['masterPriceAndDurationMap']),
      );
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (servicePhoto != null) map['servicePhoto'] = servicePhoto;
    map["parentServiceId"] = parentServiceId;
    map["salonId"] = salonId;

    map["categoryId"] = categoryId;
    map["subCategoryId"] = subCategoryId;
    map["preferredGender"] = preferredGender;
    map["bookOrderId"] = bookOrderId;
    map["serviceName"] = serviceName;
    map["description"] = description;

    if (icon != null) map['icon'] = icon!.toJson();

    map['hasProcessingTime'] = hasProcessingTime;
    if (allowClientsBookOnline != null) map['allowClientsBookOnline'] = allowClientsBookOnline;
    if (hasDeposit != null) map['hasDeposit'] = hasDeposit;
    if (startProcessingTime != null) map['startProcessingTime'] = startProcessingTime;
    if (endProcessingTime != null) map['endProcessingTime'] = endProcessingTime;
    if (processingTime != null) map['processingTime'] = processingTime;
    if (cleanUpTime != null) map['cleanUpTime'] = cleanUpTime;
    if (preparationTime != null) map['preparationTime'] = preparationTime;
    // if (this.hasParallelClients != null) map['hasParallelClients'] = this.hasParallelClients;
    // if (this.parallelNoOfClients != null) map['parallelNoOfClients'] = this.parallelNoOfClients;
    //
    // if (this.parallelClientsTime != null) map['parallelClientsTime'] = this.parallelClientsTime;
    //don't need to send isSelected parameter to the backend it's for local use only
    //map["isSelected"] = isSelected;
    if (colorString != null) map['colorString'] = colorString!.toString();

    if (deposit != null) map['deposit'] = deposit!.toString();

    map["isAvailableOnline"] = isAvailableOnline;
    if (priceAndDuration != null) map['priceAndDuration'] = priceAndDuration!.toJson();
    if (priceAndDurationMax != null) map['priceAndDurationMax'] = priceAndDurationMax!.toJson();
    map["isFixedPrice"] = isFixedPrice;
    map["isFixedDuration"] = isFixedDuration;
    map["isPriceRange"] = isPriceRange;
    map["isPriceStartAt"] = isPriceStartAt;
    if (serviceProcessType != null) {
      map['serviceProcessType'] = serviceProcessType;
    }
    if (serviceId != null) {
      map['serviceId'] = serviceId;
    }
    if (seat != null) {
      Map<String, dynamic> json = seat!.toJson();
      json['seatTypeId'] = seat!.seatTypeId;
      map['seat'] = json;
    }
    map["translations"] = translations;
    map["subCatTranslations"] = subCatTranslations;
    map["masterPriceAndDurationMap"] = priceAndDurationToJson(masterPriceAndDurationMap);
    return map;
  }
}

//generates a map of PriceAndDuration where key is master id
Map<String?, PriceAndDurationModel> mapPriceAndDuration(Map<String, dynamic>? map) {
  Map<String?, PriceAndDurationModel> mastersPriceAndDurationMap = {};

  try {
    if (map != null) {
      map.forEach((key, value) {
        if (value != null) mastersPriceAndDurationMap[key] = PriceAndDurationModel.fromJson(value as Map<String, dynamic>);
      });
    }

    return mastersPriceAndDurationMap;
  } catch (e) {
    //(e);
    return {};
  }
}

//generates a map of PriceAndDuration where key is master id
Map<String?, dynamic> priceAndDurationToJson(Map<String?, PriceAndDurationModel?>? map) {
  Map<String?, dynamic> priceAndDurationJson = {};

  try {
    if (map != null) {
      map.forEach((key, value) {
        if (value != null) priceAndDurationJson[key] = value.toJson();
      });
    }

    return priceAndDurationJson;
  } catch (e) {
    //(e);
    return {};
  }
}

class ParentServiceModel {
  late String categoryId;
  late String subCategoryId;
  //service id of the parent service originated from (in the master table)
  String? parentServiceId;

  late String serviceName;

  //contains all the translations of supported lang
  late Map translations;
  late Map subCatTranslations;

  ParentServiceModel({
    required this.categoryId,
    required this.subCategoryId,
    required this.parentServiceId,
    required this.serviceName,
    required this.translations,
    required this.subCatTranslations,
  });

  ParentServiceModel.fromJson(dynamic json) {
    parentServiceId = json["parentServiceId"];

    categoryId = json["categoryId"];
    subCategoryId = json["subCategoryId"];

    serviceName = json["serviceName"];
    translations = (json["translations"] != null) ? {...json["translations"]} : {};
    subCatTranslations = json["subCatTranslations"] != null ? {...json["subCatTranslations"]} : {};
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    map["categoryId"] = categoryId;
    map["subCategoryId"] = subCategoryId;
    map["serviceName"] = serviceName;
    map["translations"] = translations;
    map["subCatTranslations"] = subCatTranslations;
    return map;
  }
}

class SeatTypeModel {
  String? seatTypeId;
  // number of seats available
  int? count;
  //name of the seat
  // eg Manicure seat
  String? seatName;

  SeatTypeModel({this.seatTypeId, this.count, this.seatName});

  SeatTypeModel.fromJson(Map<String, dynamic> json) {
    seatTypeId = json['seatTypeId'];
    count = json['count'];
    seatName = json['seatName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['seatName'] = seatName;
    return data;
  }
}

//holds the links for category icons
class CategoryIconLinkModel {
  String? name;
  String? link;

  CategoryIconLinkModel({this.name, this.link});

  CategoryIconLinkModel.fromJson(Map<String, dynamic> json) {
    if (json['name'] != null) name = json['name'];
    if (json['link'] != null) link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['link'] = link;
    return data;
  }
}
