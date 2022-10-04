import 'dart:convert';

BonusModel bonusModelFromJson(String str) => BonusModel.fromJson(json.decode(str));

String bonusModelToJson(BonusModel data) => json.encode(data.toJson());

class BonusModel {
  BonusModel({
    required this.bonusId,
    required this.amount,
    required this.bonusType,
    required this.validated,
    required this.used,
    required this.expired,
    required this.usedApntmtId,
    required this.createdAt,
    required this.usedAt,
    required this.expiresAt,
    required this.owner,
  });

  String bonusId;
  String owner;
  int amount;
  String bonusType;
  bool validated;
  bool used;
  bool expired;
  String usedApntmtId;
  DateTime createdAt;
  late DateTime usedAt;
  DateTime expiresAt;

  factory BonusModel.fromJson(Map<String, dynamic> json) => BonusModel(
        bonusId: json["bonusId"],
        owner: json['owner'],
        amount: json['amount'],
        bonusType: json["bonusType"],
        validated: json['validated'],
        used: json['used'],
        expired: json['expired'],
        usedApntmtId: json["usedApntmtId"],
        createdAt: json["createdAt"].toDate(),
        usedAt: json["usedAt"].toDate(),
        expiresAt: json["expiresAt"].toDate(),
      );

  Map<String, dynamic> toJson() => {
        "bonusId": bonusId,
        "owner": owner,
        "amount": amount,
        "bonusType": bonusType,
        "validated": validated,
        "used": used,
        "expired": expired,
        "usedApntmtId": usedApntmtId,
        "createdAt": createdAt,
        "usedAt": usedAt,
        "expiresAt": expiresAt,
      };
}
