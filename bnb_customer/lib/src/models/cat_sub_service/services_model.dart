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
    priceAndDuration = json['priceAndDuration'] != null ? PriceAndDurationModel.fromJson(json['priceAndDuration']) : PriceAndDurationModel(duration: "0", price: "0");
    if (json['priceAndDurationMax'] != null) {
      priceAndDurationMax = PriceAndDurationModel.fromJson(json['priceAndDurationMax']);
    }
    searchTags = json['searchTags'] != null ? json['searchTags'].cast<String>() : [];
    translations = (json["translations"] != null) ? {...json["translations"]} : {};
    subCatTranslations = json["subCatTranslations"] != null ? {...json["subCatTranslations"]} : {};
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
