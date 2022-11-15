import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/cat_sub_service/seat_type.dart';

/// categoryName : "Eyebrows and eyelashes"

class CategoryModel {
  final String categoryName;
  final String categoryId;
  final Map translations;

  CategoryModel({
    required this.categoryName,
    required this.categoryId,
    required this.translations,
  });

  CategoryModel.fromJson(Map<String, dynamic> json)
      : categoryName = json['categoryName']??'',
        categoryId = json['categoryId'],
        translations = json['translations']??{'',''};

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['categoryName'] = categoryName;
    data['translations'] = translations;
    return data;
  }
}

class SubCategoryModel {
  final String subCategoryId;
  final String subCategoryName;
  final Map translations;

  SubCategoryModel({
    required this.subCategoryId,
    required this.subCategoryName,
    required this.translations,

  });


  SubCategoryModel.fromJson(Map<String, dynamic> json)
      : subCategoryId = json['subCategoryId'],
        subCategoryName = json['subCategoryName'],
        translations = json['translations'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['subCategoryName'] = subCategoryName;
    data['translations'] = translations;
    return data;
  }

}
