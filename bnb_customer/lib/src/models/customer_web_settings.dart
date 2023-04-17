class CustomerWebSettings {
  String? salonId;
  String? docId;
  WebTheme? theme;
  String? backgroundImage;
  DisplaySettings? displaySettings;

  CustomerWebSettings({this.salonId, this.docId, this.theme, this.displaySettings, this.backgroundImage});

  CustomerWebSettings.fromJson(Map data) {
    if (data["salonId"] != null) salonId = data["salonId"];
    if (data["docId"] != null) docId = data["docId"];
    if (data["backgroundImage"] != null) backgroundImage = data["backgroundImage"];
    if (data["theme"] != null) theme = WebTheme.fromJson(data["theme"]);
    displaySettings = (data["displaySettings"] != null)
        ? DisplaySettings.fromJson(
            data["displaySettings"],
          )
        : DisplaySettings.fromJson({});
  }

  toJson() {
    Map<String, dynamic> data = {};
    data["salonId"] = salonId;
    data["docId"] = docId;
    data["theme"] = theme?.toJson();
    return data;
  }
}

class WebTheme {
  String? id;
  String? colorCode;
  String? testId;

  WebTheme({this.id, this.colorCode, this.testId});

  WebTheme.fromJson(Map data) {
    if (data["id"] != null) id = data["id"];
    if (data["colorCode"] != null) colorCode = data["colorCode"];
    if (data["testId"] != null) testId = data["testId"];
  }

  toJson() {
    Map<String, dynamic> data = {};
    data["id"] = id;
    data["colorCode"] = colorCode;
    data["testId"] = testId;
    return data;
  }
}

class DisplaySettings {
  DisplaySettings({
    required this.showSpecialization,
    required this.showFeatures,
    required this.showBrands,
    required this.showPromotions,
    required this.showAbout,
    required this.showPhotosOfWork,
    required this.services,
    required this.product,
    required this.showTeam,
    required this.reviews,
    required this.showRequestForm,
    required this.showContact,
    required this.enableOTP,
  });

  final bool showSpecialization;
  final bool showFeatures;
  final bool showBrands;
  final bool showPromotions;
  final bool showAbout;
  final bool showPhotosOfWork;
  final Services services;
  final Product product;
  final bool showTeam;
  final Reviews reviews;
  final bool showRequestForm;
  final bool showContact;
  final dynamic enableOTP;

  factory DisplaySettings.fromJson(Map<String, dynamic> json) => DisplaySettings(
        showSpecialization: (json["showSpecialization"] == null) ? true : json["showSpecialization"],
        showFeatures: (json["showFeatures"] == null) ? true : json["showFeatures"],
        showBrands: (json["showBrands"] == null) ? true : json["showBrands"],
        showPromotions: (json["showPromotions"] == null) ? true : json["showPromotions"],
        showAbout: (json["showAbout"] == null) ? true : json["showAbout"],
        showPhotosOfWork: (json["showPhotosOfWork"] == null) ? true : json["showPhotosOfWork"],
        services: (json["services"] == null) ? Services.fromJson({}) : Services.fromJson(json["services"]),
        product: (json["product"] == null) ? Product.fromJson({}) : Product.fromJson(json["product"]),
        showTeam: (json["showTeam"] == null) ? true : json["showTeam"],
        reviews: (json["reviews"] == null) ? Reviews.fromJson({}) : Reviews.fromJson(json["reviews"]),
        showRequestForm: (json["showRequestForm"] == null) ? true : json["showRequestForm"],
        showContact: (json["showContact"] == null) ? true : json["showContact"],
        enableOTP: (json["enableOTP"] == null) ? true : json["enableOTP"],
      );

  Map<String, dynamic> toJson() => {
        "showSpecialization": showSpecialization,
        "showFeatures": showFeatures,
        "showBrands": showBrands,
        "showPromotions": showPromotions,
        "showAbout": showAbout,
        "showPhotosOfWork": showPhotosOfWork,
        "services": services.toJson(),
        "product": product.toJson(),
        "showTeam": showTeam,
        "reviews": reviews.toJson(),
        "showRequestForm": showRequestForm,
        "showContact": showContact,
        "enableOTP": enableOTP,
      };
}

class Product {
  Product({
    required this.showProduct,
    required this.showPrductPrices,
    required this.showProductOutOfStock,
  });

  final bool showProduct;
  final bool showPrductPrices;
  final bool showProductOutOfStock;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        showProduct: (json["showProduct"] == null) ? true : json["showProduct"],
        showPrductPrices: (json["showPrductPrices"] == null) ? true : json["showPrductPrices"],
        showProductOutOfStock: (json["showProductOutOfStock"] == null) ? true : json["showProductOutOfStock"],
      );

  Map<String, dynamic> toJson() => {
        "showProduct": showProduct,
        "showPrductPrices": showPrductPrices,
        "showProductOutOfStock": showProductOutOfStock,
      };
}

class Reviews {
  Reviews({
    required this.showReviews,
    required this.showReviewRating,
    required this.showLatest,
  });

  final bool showReviews;
  final bool showReviewRating;
  final bool showLatest;

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
        showReviews: (json["showReviews"] == null) ? true : json["showReviews"],
        showReviewRating: (json["showReviewRating"] == null) ? true : json["showReviewRating"],
        showLatest: (json["showLatest"] == null) ? true : json["showLatest"],
      );

  Map<String, dynamic> toJson() => {
        "showReviews": showReviews,
        "showReviewRating": showReviewRating,
        "showLatest": showLatest,
      };
}

class Services {
  Services({
    required this.showServices,
    required this.showServicePrices,
    required this.showServicesWithPhotos,
  });

  final bool showServices;
  final bool showServicePrices;
  final bool showServicesWithPhotos;

  factory Services.fromJson(Map<String, dynamic> json) => Services(
        showServices: (json["showServices"] == null) ? true : json["showServices"],
        showServicePrices: (json["showServicePrices"] == null) ? true : json["showServicePrices"],
        showServicesWithPhotos: (json["showServicesWithPhotos"] == null) ? true : json["showServicesWithPhotos"],
      );

  Map<String, dynamic> toJson() => {
        "showServices": showServices,
        "showServicePrices": showServicePrices,
        "showServicesWithPhotos": showServicesWithPhotos,
      };
}
