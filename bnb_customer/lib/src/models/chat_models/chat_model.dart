import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  ChatModel({
    required this.customerId,
    required this.customerName,
    required this.customerAvtar,
    required this.salonId,
    required this.salonName,
    required this.salonAvtar,
    required this.createdAt,
    required this.messages,
    required this.appointmentId,
    required this.salonDeleted,
    required this.customerDeleted,
    required this.lastMessage,
    required this.lastSeenCustomer,
    required this.lastSeenSalon,
  });

  final String? customerId;
  final String? customerName;
  final String? customerAvtar;
  final String? salonId;
  final String? salonName;
  final String? salonAvtar;
  final Timestamp? createdAt;
  final Timestamp? lastSeenSalon;
  final Timestamp? lastSeenCustomer;
  final List<dynamic> messages;
  final String? appointmentId;
  final String? lastMessage;
  final bool? salonDeleted;
  final bool? customerDeleted;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        customerId: json["customerId"],
        customerAvtar: json["customerAvtar"],
        salonId: json["salonId"],
        salonAvtar: json["saloonAvtar"],
        createdAt: json["createdAt"],
        messages: List<dynamic>.from(json["messages"].map((x) => x)),
        appointmentId: json["appointmentId"],
        customerDeleted: json['customerDeleted'],
        customerName: json['customerName'],
        lastMessage: json['lastMessage'],
        lastSeenCustomer: json['lastSeenCustomer'],
        lastSeenSalon: json['lastSeenSalon'],
        salonDeleted: json['salonDeleted'],
        salonName: json['salonName'],
      );

  Map<String, dynamic> toJson() => {
        "customerId": customerId,
        "customerAvtar": customerAvtar,
        "salonId": salonId,
        "salonAvtar": salonAvtar,
        "createdAt": createdAt,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "appointmentId": appointmentId,
        "customerDeleted": customerDeleted,
        "customerName": customerName,
        "lastMessage": lastMessage,
        "lastSeenCustomer": lastSeenCustomer,
        "lastSeenSalon": lastSeenSalon,
        "salonDeleted": salonDeleted,
        "salonName": salonName
      };
}
