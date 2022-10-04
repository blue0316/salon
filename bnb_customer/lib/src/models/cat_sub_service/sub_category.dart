class SubCategoryModel {
  final String subCategoryName;
  final String subCategoryId;
  final String categoryId;
  final Map? translations;

  SubCategoryModel({
    required this.subCategoryName,
    required this.subCategoryId,
    required this.categoryId,
    this.translations,
  });

  SubCategoryModel.fromJson(Map<String, dynamic> json)
      : subCategoryName = json['subCategoryName'],
        subCategoryId = json['subCategoryId'],
        categoryId = json['categoryId'],
        translations = json['translations'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['subCategoryName'] = subCategoryName;
    data['categoryId'] = categoryId;
    data['translations'] = translations;
    return data;
  }
}
