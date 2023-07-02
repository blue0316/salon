import 'package:bbblient/src/models/cat_sub_service/price_and_duration.dart';

class ServiceModel {
  //id of the service
  late String serviceId;
  late String categoryId;
  late String subCategoryId;
  //service id of the parent service originated from (in the master table)
  late String parentServiceId;
  //id of the current salon
  late String salonId;
  late String serviceName;
  late bool isAvailableOnline;
  //type : women,men etc
  late String preferredGender;
  String? description;
  late PriceAndDurationModel priceAndDuration;
  //contains all the translations of supported lang
  late Map translations;
  late Map subCatTranslations;

  //max price and duration of the service
  PriceAndDurationModel? priceAndDurationMax = PriceAndDurationModel();
  List<String>? searchTags;
  //order by which services are arranged in booking page on the customer side
  String? bookOrderId;

  // if true, [priceAndDuration] will be used
  // if false, [priceAndDuration] - [priceAndDurationMax] will be used
  late bool isFixedPrice;
  late bool isPriceRange;
  late bool isFixedDuration;
  late bool isPriceStartAt;
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

  Map<String?, PriceAndDurationModel?>? masterPriceAndDurationMap = {};

  ServiceModel({
    required this.salonId,
    required this.serviceId,
    required this.categoryId,
    required this.subCategoryId,
    required this.parentServiceId,
    required this.isAvailableOnline,
    required this.priceAndDuration,
    required this.serviceName,
    required this.translations,
    this.priceAndDurationMax,
    this.isFixedPrice = true,
    this.isFixedDuration = true,
    this.isPriceRange = false,
    this.isPriceStartAt = false,
    required this.subCatTranslations,
    required this.preferredGender,
    this.description,
    this.bookOrderId,
    this.searchTags,
    this.hasProcessingTime = false,
    this.startProcessingTime,
    this.endProcessingTime,
    this.cleanUpTime,
    this.preparationTime,
    this.processingTime,
    this.masterPriceAndDurationMap,
  });

  //creates a copy of the current service instead of passing the ref
  ServiceModel getCopy() {
    ServiceModel newService = ServiceModel.fromJson(toJson());
    newService.serviceId = serviceId;
    return newService;
  }

  ServiceModel.fromJson(dynamic json) {
    salonId = json["salonId"].runtimeType.toString() == "String" ? json["salonId"] : "";
    parentServiceId = json["parentServiceId"].runtimeType.toString() == "String" ? json["parentServiceId"] : "";
    serviceId = json["serviceId"].runtimeType.toString() == "String" ? json["serviceId"] ?? "" : "";
    categoryId = json["categoryId"].runtimeType.toString() == "String" ? json["categoryId"] : "";
    bookOrderId = json["bookOrderId"].runtimeType.toString() == "String" ? json["bookOrderId"] : "";
    subCategoryId = json["subCategoryId"].runtimeType.toString() == "String" ? json["subCategoryId"] : "";
    preferredGender = json["preferredGender"].runtimeType.toString() == "String" ? json["preferredGender"] : "";
    serviceName = json["serviceName"].runtimeType.toString() == "String" ? json["serviceName"] : "";
    description = json["description"].runtimeType.toString() == "String" ? json["description"] ?? '' : "";
    isFixedPrice = json["isFixedPrice"] ?? true;
    isFixedDuration = json["isFixedDuration"] ?? true;
    isPriceRange = json["isPriceRange"] ?? false;
    isPriceStartAt = json["isPriceStartAt"] ?? false;
    isAvailableOnline = json["isAvailableOnline"] ?? true;
    if (json['priceAndDuration'] != null) priceAndDuration = PriceAndDurationModel.fromJson(json['priceAndDuration']);
    if (json['priceAndDurationMax'] != null) {
      priceAndDurationMax = PriceAndDurationModel.fromJson(json['priceAndDurationMax']);
    }
    searchTags = json['searchTags'] != null ? json['searchTags'].cast<String>() : [];
    translations = (json["translations"] != null) ? {...json["translations"]} : {};
    subCatTranslations = json["subCatTranslations"] != null ? {...json["subCatTranslations"]} : {};
    hasProcessingTime = json["hasProcessingTime"] ?? false;
    if (json["startProcessingTime"] != null) startProcessingTime = json["startProcessingTime"];
    if (json["endProcessingTime"] != null) endProcessingTime = json["endProcessingTime"];
    if (json["processingTime"] != null) processingTime = json["processingTime"];
    if (json["cleanUpTime"] != null) cleanUpTime = json["cleanUpTime"];
    if (json["preparationTime"] != null) preparationTime = json["preparationTime"];

    if (json["masterPriceAndDurationMap"] != null) {
      masterPriceAndDurationMap = json['masterPriceAndDurationMap'] != null
          ? mapPriceAndDuration(
              json['masterPriceAndDurationMap'],
            )
          : null;
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["parentServiceId"] = parentServiceId;
    map["serviceId"] = serviceId;
    map["salonId"] = salonId;
    map["categoryId"] = categoryId;
    map["subCategoryId"] = subCategoryId;
    map["preferredGender"] = preferredGender;
    map["serviceName"] = serviceName;
    map["bookOrderId"] = bookOrderId;
    map["description"] = description;
    map["isAvailableOnline"] = isAvailableOnline;
    map['priceAndDuration'] = priceAndDuration.toJson();
    map["translations"] = translations;
    map["subCatTranslations"] = subCatTranslations;
    map['searchTags'] = searchTags;
    map['hasProcessingTime'] = hasProcessingTime;
    if (startProcessingTime != null) map['startProcessingTime'] = startProcessingTime;
    if (endProcessingTime != null) map['endProcessingTime'] = endProcessingTime;
    if (processingTime != null) map['processingTime'] = processingTime;
    if (cleanUpTime != null) map['cleanUpTime'] = cleanUpTime;
    if (preparationTime != null) map['preparationTime'] = preparationTime;
    map["masterPriceAndDurationMap"] = priceAndDurationToJson(masterPriceAndDurationMap);

    return map;
  }
  //don't need to send isSelected parameter to the backend it's for local use only
  //map["isSelected"] = isSelected;

  Map<String, dynamic> toAppointmentJson() {
    var map = <String, dynamic>{};
    map["parentServiceId"] = parentServiceId;
    map["salonId"] = salonId;
    map["categoryId"] = categoryId;
    map["subCategoryId"] = subCategoryId;
    map["serviceName"] = serviceName;
    map['priceAndDuration'] = priceAndDuration.toJson();
    return map;
  }
}

//generates a map of PriceAndDuration where key is master id
Map<String?, PriceAndDurationModel> mapPriceAndDuration(Map<String, dynamic>? map) {
  Map<String?, PriceAndDurationModel> mastersPriceAndDurationMap = {};

  try {
    if (map != null) {
      map.forEach((key, value) {
        if (value != null) mastersPriceAndDurationMap[key] = PriceAndDurationModel.fromJson(value);
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
