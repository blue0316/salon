import 'dart:convert';

BonusSettings bonusSettingsFromJson(String str) => BonusSettings.fromJson(json.decode(str));
String bonusSettingsToJson(BonusSettings data) => json.encode(data.toJson());

class BonusSettings {
  BonusSettings({
    required this.referralsActive,
    required this.installBonusActive,
    required this.doubleHours,
    required this.installBonusesAmounts,
    required this.installBonusesValidity,
    required this.referralBonusesAmounts,
    required this.referralBonusesValidity,
  });
  bool referralsActive;
  bool installBonusActive;
  int doubleHours;
  List<int> installBonusesAmounts;
  List<int> installBonusesValidity;
  List<int> referralBonusesAmounts;
  List<int> referralBonusesValidity;

  factory BonusSettings.fromJson(Map<String, dynamic> json) => BonusSettings(
        referralsActive: json['referralsActive'],
        installBonusActive: json['installBonusActive'],
        doubleHours: json["doubleHours"],
        installBonusesAmounts:
            json["installBonusesAmounts"] == null ? [] : List<int>.from(json["installBonusesAmounts"].map((x) => x)),
        installBonusesValidity:
            json["installBonusesValidity"] == null ? [] : List<int>.from(json["installBonusesValidity"].map((x) => x)),
        referralBonusesAmounts:
            json["referralBonusesAmounts"] == null ? [] : List<int>.from(json["referralBonusesAmounts"].map((x) => x)),
        referralBonusesValidity:
            json["referralBonusesValidity"] == null ? [] : List<int>.from(json["referralBonusesValidity"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "referralsActive": referralsActive,
        "installBonusActive": installBonusActive,
        "doubleHours": doubleHours,
        "installBonusesAmounts": installBonusesAmounts,
        "installBonusesValidity": installBonusesValidity,
        "referralBonusesAmounts": referralBonusesAmounts,
        "referralBonusesValidity": referralBonusesValidity,
      };
}

// import 'dart:convert';

// BonusSettings bonusSettingsFromJson(String str) => BonusSettings.fromJson(json.decode(str));

// String bonusSettingsToJson(BonusSettings data) => json.encode(data.toJson());

// class BonusSettings {
//   BonusSettings({
//     required this.referralsActive,
//     required this.installBonusActive,
//     required this.doubleHours,
//     required this.installBonusValidityDays,
//     required this.referralAmount,
//     required this.referralBonusValidityDays,
//     required this.signupAmount,
//   });
//   bool referralsActive;
//   bool installBonusActive;
//   int doubleHours;
//   int installBonusValidityDays;
//   int referralAmount;
//   int referralBonusValidityDays;
//   int signupAmount;

//   factory BonusSettings.fromJson(Map<String, dynamic> json) => BonusSettings(
//         referralsActive: json['referralsActive'],
//         installBonusActive: json['installBonusActive'],
//         doubleHours: json["doubleHours"],
//         installBonusValidityDays: json["installBonusValidityDays"],
//         referralAmount: json["referralAmount"],
//         referralBonusValidityDays: json["referralBonusValidityDays"],
//         signupAmount: json["signupAmount"],
//       );

//   Map<String, dynamic> toJson() => {
//         "referralsActive": referralsActive,
//         "installBonusActive": installBonusActive,
//         "doubleHours": doubleHours,
//         "installBonusValidityDays": installBonusValidityDays,
//         "referralAmount": referralAmount,
//         "referralBonusValidityDays": referralBonusValidityDays,
//         "signupAmount": signupAmount,
//       };
// }

