import 'dart:convert';

ReferralModel referralModelFromJson(String str) => ReferralModel.fromJson(json.decode(str));

String referralModelToJson(ReferralModel data) => json.encode(data.toJson());

class ReferralModel {
  ReferralModel({
    required this.referralId,
    required this.referredById,
    required this.referredToId,
    required this.referredByBonusId,
    required this.referredToBonusId, // not in use
    required this.createdAt,
    required this.doubleBonusGiven,
  });
  String referralId;
  String referredById;
  String referredToId;
  List<String> referredByBonusId;
  List<String> referredToBonusId;
  DateTime createdAt;
  bool doubleBonusGiven;

  factory ReferralModel.fromJson(Map<String, dynamic> json) => ReferralModel(
        referralId: json['referralId'],
        referredById: json["referredById"],
        referredToId: json["referredToId"],
        referredByBonusId: json["referredByBonusId"],
        referredToBonusId: json["referredToBonusId"],
        createdAt: DateTime.parse(json["createdAt"]),
        doubleBonusGiven: json["doubleBonusGiven"],
      );

  Map<String, dynamic> toJson() => {
        "referralId": referralId,
        "referredById": referredById,
        "referredToId": referredToId,
        "referredByBonusId": referredByBonusId,
        "referredToBonusId": referredToBonusId,
        "createdAt": createdAt,
        "doubleBonusGiven": doubleBonusGiven,
      };
}
