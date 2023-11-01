import 'dart:convert';

TagModel tagModelFromJson(String str) => TagModel.fromJson(json.decode(str));

String tagModelToJson(TagModel data) => json.encode(data.toJson());

class TagModel {
  TagModel({
    required this.title,
    required this.catId,
  });

  String title;
  String catId;

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
        title: json["title"],
        catId: json["catId"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "catId": catId,
      };
}
