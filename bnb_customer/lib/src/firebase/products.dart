// import 'package:bbblient/src/models/products.dart';
import 'package:bbblient/src/models/products.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'collections.dart';

class ProductsApi {
  ProductsApi._privateConstructor();
  static final ProductsApi _instance = ProductsApi._privateConstructor();
  factory ProductsApi() {
    return _instance;
  }

  // Product Categories
  Future<List<ProductCategoryModel>> getAllProductCategory({required String salonId}) async {
    try {
      QuerySnapshot _response = await Collection.allProductCategories.get();

      List<ProductCategoryModel> allCategories = [];

      for (DocumentSnapshot doc in _response.docs) {
        Map<String, dynamic> _temp = doc.data() as Map<String, dynamic>;
        _temp['categoryId'] = doc.id;

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
      QuerySnapshot _response = await Collection.allProductBrand.where('salonId', isEqualTo: salonId).get();

      List<ProductBrandModel> allBrands = [];

      for (DocumentSnapshot doc in _response.docs) {
        Map<String, dynamic> _temp = doc.data() as Map<String, dynamic>;

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
      QuerySnapshot _response = await Collection.products.where('salonId', isEqualTo: salonId).get();

      List<ProductModel> salonProducts = [];

      for (DocumentSnapshot doc in _response.docs) {
        Map<String, dynamic> _temp = doc.data() as Map<String, dynamic>;
        ProductModel? productsModel;

        try {
          productsModel = ProductModel.fromJson(_temp);
        } catch (e) {
          printIt('Error on getSalonProducts() : $e');
          rethrow;
        }

        salonProducts.add(productsModel);
      }
      return salonProducts;
    } catch (e) {
      printIt('Error on getSalonProducts() - ${e.toString()}');
    }

    return [];
  }
}
