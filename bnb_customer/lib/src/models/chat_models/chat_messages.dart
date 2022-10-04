import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

ChatMessages chatMessagesFromJson(String str) => ChatMessages.fromJson(json.decode(str));

String chatMessagesToJson(ChatMessages data) => json.encode(data.toJson());

class ChatMessages {
  ChatMessages({
    required this.uid, // not uid of firebase but customer document id;
    required this.createdAt,
    required this.type,
    required this.content,
  });

  final String? uid;
  final Timestamp? createdAt;
  final int? type;
  final String? content;

  factory ChatMessages.fromJson(Map<String, dynamic> json) => ChatMessages(
        uid: json["uid"],
        createdAt: json["createdAt"],
        type: json["type"],
        content: json['content'],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "createdAt": createdAt,
        "type": type,
        "content": content,
      };
}
