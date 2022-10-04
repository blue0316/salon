class YClientsModel {
  late String id;
  late String? companyId;
  late String? salonId;
  late String? userToken;
  late bool? isActive;

  YClientsModel({
    required this.id,
    required this.companyId,
    required this.salonId,
    required this.userToken,
    this.isActive = true,
  });

  YClientsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['companyId'];
    salonId = json['salonId'];
    userToken = json['userToken'];
    isActive = json['isActive'] ?? true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['companyId'] = companyId;
    data['salonId'] =  salonId;
    data['userToken'] = userToken;
    data['isActive'] = isActive ?? true;

    return data;
  }
}
