// ignore_for_file: prefer_collection_literals

class BeautyProConfig {
  String beautyProDocId;
  String salonId;

  ///6 digit DB code unique for every salon
  String? databaseCode;
  String? locationId;
  String? accessToken;

  String? refreshToken;

  ///TIME TO LIVE for a token
  DateTime? ttl;
  DateTime? createdAt;

  ///if true then actively syncing with beauty pro
  bool? syncActive;

  BeautyProConfig({
    required this.salonId,
    required this.databaseCode,
    required this.locationId,
    required this.accessToken,
    required this.refreshToken,
    required this.ttl,
    required this.createdAt,
    required this.syncActive,
    required this.beautyProDocId,
  });

  BeautyProConfig.fromJson(Map<String, dynamic> json)
      : beautyProDocId = json['beautyProDocId'],
        salonId = json['salonId'],
        databaseCode = json['databaseCode'],
        locationId = json['locationId'],
        accessToken = json['accessToken'],
        refreshToken = json['refreshToken'],
        createdAt = json['createdAt']?.toDate(),
        ttl = json['ttl']?.toDate(),
        syncActive = json['syncActive'] ?? true;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['salonId'] = salonId;
    data['databaseCode'] = databaseCode;
    data['locationId'] = locationId;
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['createdAt'] = createdAt;
    data['ttl'] = ttl;
    data['syncActive'] = syncActive ?? true;

    return data;
  }
}
