class ProductModel {
  // name of product
  String? productName;
  // image of product
  List<String?>? productImageUrlList;

  // saw this in the previous product model
  // String? productEan;
  // String? productAid;
  // String? productAsin;

  // brand id of product
  String? brandId;
  // measure of product
  String? measure;
  // description
  String? productDescription;
  // category ids of product
  List<String?>? categoryIdList;
  // supply price
  String? supplyPrice;

  String? clientPrice;

  // discounted proce
  String? discountedPrice;

  // difference between a product's selling price and cost as a percentage of the cost.
  String? markupPrice;
  // brand name of product
  bool? dispayPrice;
  //quantity of what is available
  String? inventoryQuantity;
  String? lowQuantityLevel;
  // id of salon
  String? salonId;

  // firebase doc id
  String? productId;

  // time it was created
  DateTime? createdAt;

  // product barcode number
  // dynamic productBarcode;
  // dynamic productWidth;
  // dynamic productLength;
  // dynamic productHeight;
  // dynamic productWeight;

  // Map<String, dynamic>? itemDimensions;

  ProductModel({
    this.createdAt,
    // this.itemDimensions,
    // this.productAsin,
    this.brandId,
    this.categoryIdList,
    this.productDescription,
    // this.productId,
    this.productName,
    this.clientPrice,
    this.discountedPrice,
    this.dispayPrice,
    this.inventoryQuantity,
    this.lowQuantityLevel,
    // this.productWeight,
    // this.productHeight,
    // this.productAid,
    // this.productLength,
    // this.productEan,
    this.markupPrice,
    this.measure,
    this.productId,
    this.salonId,
    this.supplyPrice,
    // this.productWidth,
    this.productImageUrlList,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'] ?? '';
    // itemDimensions = json['itemDimensions'] ?? "";
    // productAid = json['aid'] ?? "";
    brandId = json['brandId'] ?? "";
    categoryIdList = json['categoryIdList'] == null ? [] : categoryIdList = json['categoryIdList'].cast<String>();
    // categoryIdList = json["categoryIdList"] ?? [];
    productName = json['productName'] ?? "";
    clientPrice = json['clientPrice'] ?? "";
    discountedPrice = json['discountedPrice'] ?? "";
    dispayPrice = json['dispayPrice'] ?? false;
    createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now();
    // productName = json['algopixValidatedAttributes']['title']??"";
    productName = json['productName'] ?? "";
    inventoryQuantity = json["inventoryQuantity"] ?? "";
    productImageUrlList = json['productImageUrlList'] == null ? [] : productImageUrlList = json['productImageUrlList'].cast<String>();
    // productImageUrlList = json["productImageUrlList"] ?? [];
    // productEan = json['ids'] == null ? 'not available' : json['ids']['EAN'][0];
    // productId = json['ids'] == null ? 'not available' : json['ids']['EAN'][0];

    // productAsin =
    //     json['ids'] == null ? 'not available' : json['ids']['ASIN'][0];

    lowQuantityLevel = json['lowQuantityLevel'] ?? '';
    salonId = json['salonId'];
    productId = json['productId'] ?? "";
    supplyPrice = json['supplyPrice'] ?? "";
    measure = json['measure'] ?? "";
    markupPrice = json['markupPrice'] ?? "";
    // productLength = itemDimensions!['length']['value'] ?? "";
    // productWeight = itemDimensions!['weight']['value'] ?? "";
    // productHeight = itemDimensions!['height']['value'] ?? "";
    // productWidth = itemDimensions!['width']['value'] ?? "";
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      // 'createdAt': DateTime.now(),
      // 'productId': productId,
      // 'productId': productId,
      'salonId': salonId,
      // "itemDetails": {
      // "ids": {
      //   "ASIN": [productAid],
      //   "EAN": [productEan],
      // },
      "brandId": brandId,
      "productName": productName,
      "clientPrice": clientPrice,
      "discountedPrice": discountedPrice,
      "dispayPrice": dispayPrice,
      "description": productDescription,
      "inventoryQuantity": inventoryQuantity,
      "lowQuantityLevel": lowQuantityLevel,
      // "itemDimensions": {
      //   "width": {"value": productWidth, "unit": "INCH"},
      //   "length": {"value": productLength, "unit": "INCH"},
      //   "height": {"value": productHeight, "unit": "INCH"},
      //   "weight": {"value": productWeight, "unit": "INCH"}
      // },
      "markupPrice": markupPrice,
      "measure": measure,

      //    },
    };
    json['createdAt'] = createdAt.toString();
    json['categoryIdList'] = categoryIdList;
    json['productId'] = productId.toString();
    // json['itemDimensions'] = itemDimensions as Map;
    // json['itemDimensions']['length']['value'] = productLength!;
    // json['itemDimensions']['weight']['value'] = productWeight!;
    // json['itemDimensions']['height']['value'] = productHeight!;
    // json['itemDimensions']['width']['value'] = productWidth!;
    // json['algopixValidatedAttributes']['title'] = productName.toString();
    json['productDescription'] = productDescription.toString();
    // json['ids']['ASIN'][0] = productAsin.toString();
    // json['ids']['EAN'][0] = productId.toString();
    // json['productId'] = productId.toString();

    return json;
  }
}

// model for product categories
class ProductCategoryModel {
  String? categoryName = "";
  String? categoryId = "";
  Map? translations = {};
  bool isRoot = true;
  String? salonId = '';

  ProductCategoryModel(
    this.categoryName,
    this.categoryId,
    this.translations,
    this.salonId, {
    this.isRoot = true,
  });

  ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['categoryName'] != null) categoryName = json['categoryName'];
    if (json['categoryId'] != null) categoryId = json['categoryId'];
    if (json['translations'] != null) translations = json['translations'];
    isRoot = json['isRoot'] ?? true;
    salonId = json['salonId'] ?? salonId;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryName'] = categoryName;
    data['categoryId'] = categoryId;
    data['translations'] = translations;
    data['isRoot'] = isRoot;
    data['salonId'] = salonId;
    return data;
  }
}

// model of product brands
class ProductBrandModel {
  String? brandName = "";
  String? brandId = "";
  Map? translations = {};
  bool isRoot = true;
  String? salonId = '';

  ProductBrandModel(
    this.brandName,
    this.brandId,
    this.translations,
    this.salonId, {
    this.isRoot = true,
  });

  ProductBrandModel.fromJson(Map<String, dynamic> json) {
    if (json['brandName'] != null) brandName = json['brandName'];
    if (json['brandId'] != null) brandId = json['brandId'];
    if (json['translations'] != null) translations = json['translations'];
    isRoot = json['isRoot'] ?? true;
    salonId = json['salonId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brandName'] = brandName;
    data['brandId'] = brandId;
    data['translations'] = translations;
    data['isRoot'] = isRoot;
    data['salonId'] = salonId;
    return data;
  }
}

// model for add to cart which will be added to the appointments
class ProductCartModel {
  // product model itself
  ProductModel? product;

  // then the quantity added
  String? quantity;

  ProductCartModel(
    this.product,
    this.quantity,
  );

  ProductCartModel.fromJson(Map<String, dynamic> json) {
    if (json['product'] != null) product = ProductModel.fromJson(json['product']);

    if (json['quantity'] != null) quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (product != null) data['product'] = product!.toJson();
    data['quantity'] = quantity;

    return data;
  }
}
