class CustomerAuthError {
  String? id;
  String? phoneNumber;
  DateTime createdAt = DateTime.now();
  String authError = "";
  String? deviceInfo;

  CustomerAuthError(
      {this.id,
      this.phoneNumber,
      required this.createdAt,
      required this.authError,
      this.deviceInfo});

  CustomerAuthError.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    createdAt = DateTime.parse(json['createdAt']);
    authError = json['authError'];
    deviceInfo = json['deviceInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['phoneNumber'] = phoneNumber;
    data['createdAt'] = createdAt;
    data['authError'] = authError;
    data['deviceInfo'] = deviceInfo;
    return data;
  }
}
