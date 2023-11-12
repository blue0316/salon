import 'dart:convert';
import 'package:bbblient/src/models/products.dart';
import 'package:bbblient/src/mongodb/collection.dart';
import 'package:bbblient/src/mongodb/db_service.dart';
import 'package:bbblient/src/utils/utils.dart';

class ProductsApi {
  // ProductsApi._privateConstructor();
  // static final ProductsApi _instance = ProductsApi._privateConstructor();
  // factory ProductsApi() {
  //   return _instance;
  // }

  ProductsApi._privateConstructor(this.mongodbProvider);

  static final ProductsApi _instance = ProductsApi._privateConstructor(null);

  factory ProductsApi({DatabaseProvider? mongodbProvider}) {
    _instance.mongodbProvider = mongodbProvider;
    return _instance;
  }

  DatabaseProvider? mongodbProvider;

  // Product Categories
  Future<List<ProductCategoryModel>> getAllProductCategory({required String salonId}) async {
    try {
      List<ProductCategoryModel> allCategories = [];

      var _response = await mongodbProvider!.fetchCollection(CollectionMongo.allProductCategories).find();

      for (var item in _response) {
        Map<String, dynamic> _temp = json.decode(item.toJson()) as Map<String, dynamic>;
        _temp['categoryId'] = _temp["categoryId"];

        ProductCategoryModel? categoryModel;

        try {
          categoryModel = ProductCategoryModel.fromJson(_temp);
        } catch (e) {
          printIt('Error on getAllProductCategory() : $e');
        }

        if (categoryModel != null) {
          allCategories.add(categoryModel);
        }
      }

      return allCategories;
    } catch (e) {
      printIt('Error on getAllProductCategory() - ${e.toString()}');
    }

    return [];
  }

  // Product Brands
  Future<List<ProductBrandModel>> getAllProductBrands({required String salonId}) async {
    try {
      List<ProductBrandModel> allBrands = [];

      var _response = await mongodbProvider!.fetchCollection(CollectionMongo.allProductBrand).find();

      for (var item in _response) {
        Map<String, dynamic> _temp = json.decode(item.toJson()) as Map<String, dynamic>;

        ProductBrandModel? brandModel;

        try {
          brandModel = ProductBrandModel.fromJson(_temp);
        } catch (e) {
          printIt('Error on getAllProductBrands() : $e');
        }

        if (brandModel != null) {
          allBrands.add(brandModel);
        }
      }

      return allBrands;
    } catch (e) {
      printIt('Error on getAllProductBrands() - ${e.toString()}');
    }
    return [];
  }

  // Salon Products
  Future<List<ProductModel>> getSalonProducts({required String salonId}) async {
    try {
      List<ProductModel> salonProducts = [];

      var _response = await mongodbProvider!.fetchCollection(CollectionMongo.products).find(
        filter: {"salonId": salonId},
      );

      for (var item in _response) {
        Map<String, dynamic> _temp = json.decode(item.toJson()) as Map<String, dynamic>;

        ProductModel? productsModel;

        try {
          productsModel = ProductModel.fromJson(_temp);
        } catch (e) {
          printIt('Catch Error 1 on getSalonProducts() : $e');
          rethrow;
        }

        salonProducts.add(productsModel);
      }
      return salonProducts;
    } catch (e) {
      printIt('Catch Error 2 on getSalonProducts() - ${e.toString()}');
    }

    return [];
  }
}
