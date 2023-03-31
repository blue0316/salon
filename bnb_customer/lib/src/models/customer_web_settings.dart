class CustomerWebSettings {
  String? salonId;
  String? docId;
  WebTheme? theme;
  DisplaySettings? displaySettings;
  CustomerWebSettings({this.salonId, this.docId, this.theme, this.displaySettings});

  CustomerWebSettings.fromJson(Map data) {
    if (data["salonId"] != null) salonId = data["salonId"];
    if (data["docId"] != null) docId = data["docId"];
    if (data["theme"] != null) theme = WebTheme.fromJson(data["theme"]);
    if (data["displaySettings"] != null) displaySettings = DisplaySettings.fromJson(data["displaySettings"]);
  }

  toJson() {
    Map data = {};
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
    Map data = {};
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

  factory DisplaySettings.fromJson(Map<String, dynamic> json) => DisplaySettings(
        showSpecialization: (json["showSpecialization"] != null) ? json["showSpecialization"] : true,
        showFeatures: (json["showFeatures"] != null) ? json["showFeatures"] : true,
        showBrands: (json["showBrands"] != null) ? json["showBrands"] : true,
        showPromotions: (json["showPromotions"] != null) ? json["showPromotions"] : true,
        showAbout: (json["showAbout"] != null) ? json["showAbout"] : true,
        showPhotosOfWork: (json["showPhotosOfWork"] != null) ? json["showPhotosOfWork"] : true,
        services: (json["services"] != null) ? Services.fromJson(json["services"]) : Services.fromJson({}),
        product: (json["product"] != null) ? Product.fromJson(json["product"]) : Product.fromJson({}),
        showTeam: (json["showTeam"] != null) ? json["showTeam"] : true,
        reviews: (json["reviews"] != null) ? Reviews.fromJson(json["reviews"]) : Reviews.fromJson({}),
        showRequestForm: (json["showRequestForm"] != null) ? json["showRequestForm"] : true,
        showContact: (json["showContact"] != null) ? json["showContact"] : true,
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
        showProduct: (json["showProduct"] != null) ? json["showProduct"] : true,
        showPrductPrices: (json["showPrductPrices"] != null) ? json["showPrductPrices"] : true,
        showProductOutOfStock: (json["showProductOutOfStock"] != null) ? json["showProductOutOfStock"] : true,
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
        showReviews: (json["showReviews"] != null) ? json["showReviews"] : true,
        showReviewRating: (json["showReviewRating"] != null) ? json["showReviewRating"] : true,
        showLatest: (json["showLatest"] != null) ? json["showLatest"] : true,
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
        showServices: (json["showServices"] != null) ? json["showServices"] : true,
        showServicePrices: (json["showServicePrices"] != null) ? json["showServicePrices"] : true,
        showServicesWithPhotos: (json["showServicesWithPhotos"] != null) ? json["showServicesWithPhotos"] : true,
      );

  Map<String, dynamic> toJson() => {
        "showServices": showServices,
        "showServicePrices": showServicePrices,
        "showServicesWithPhotos": showServicesWithPhotos,
      };
}



// Map<String, dynamic> webS = {
//   "docId": "aaa",
//   "salonId": "aaaa",
//   "theme": {"colorCode": "", "id": "2", "testId": "3"},
//   "displaySettings": {
//     "showSpecialization": null,
//     "showFeatures": null,
//     "showBrands": null,
//     "showPromotions": null,
//     "showAbout": null,
//     "showPhotosOfWork": null,
//     "services": {"showServices": null, "showServicePrices": null, "showServicesWithPhotos": null},
//     "product": {"showProduct": null, "showPrductPrices": null, "showProductOutOfStock": null},
//     "showTeam": null,
//     "reviews": {"showReviews": null, "showReviewRating": null, "showLatest": null},
//     "showRequestForm": null,
//     "showContact": null
//   }
// };
