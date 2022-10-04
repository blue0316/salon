import 'dart:convert';

import 'dart:convert';

BannerModel bannerModelFromJson(String str) => BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  BannerModel({
    required this.urls,
    required this.index,
  });

  final Map<String, dynamic> urls;
  final int index;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        urls: json["urls"],
        index: json["index"],
      );

  Map<String, dynamic> toJson() => {
        "urls": urls,
        "index": index,
      };
}
