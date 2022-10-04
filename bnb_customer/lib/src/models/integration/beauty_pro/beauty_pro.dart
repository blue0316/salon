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
        createdAt = json['createdAt']?.toDate() ?? null,
        ttl = json['ttl']?.toDate() ?? null,
        syncActive = json['syncActive'] ?? true;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salonId'] = this.salonId;
    data['databaseCode'] = this.databaseCode;
    data['locationId'] = this.locationId;
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    data['createdAt'] = this.createdAt;
    data['ttl'] = this.ttl;
    data['syncActive'] = this.syncActive ?? true;

    return data;
  }
}
