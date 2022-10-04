import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Art locationFromJson(String str) => Art.fromJson(json.decode(str));

String locationToJson(Art data) => json.encode(data.toJson());

class Art {
  Art({
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.fileType,
    required this.blurHash,
    required this.tags,
    required this.createdOn,
    required this.users,
    required this.sortIndex,
  });

  final String title;
  final String description;
  final String fileUrl;
  final String fileType; // file image gif or video
  final String blurHash;
  final List<String> tags; // like "nailpaint", "tornado hairstyle"
  final Timestamp createdOn;
  final List<String> users; // users connected to photo
  final int sortIndex; //index preference 0 for top 9999 for last

  factory Art.fromJson(Map<String, dynamic> json) => Art(
        title: json["title"],
        description: json["description"],
        fileUrl: json["fileUrl"],
        fileType: json['fileType'],
        blurHash: json["blurHash"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        createdOn: json["createdOn"],
        users: List<String>.from(json["users"].map((x) => x)),
        sortIndex: json["sortIndex"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "fileUrl": fileUrl,
        "fileType": fileType,
        "blurHash": blurHash,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "createdOn": createdOn,
        "users": List<dynamic>.from(users.map((x) => x)),
        "sortIndex": sortIndex,
      };
}
