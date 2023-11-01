class CustomerAdmin {
  String? id;
  String? fullName = '';

  String? phoneNumber = '';
  DateTime? createdAt = DateTime.now();
  String? role = '';
  List<String>? authError = [];
  List<String>? customerIds = [];
  List<String>? registeredDevices = [];

  CustomerAdmin(
      {this.id,
      this.fullName,
      this.phoneNumber,
      this.createdAt,
      this.role,
      this.customerIds,
      this.authError,
      this.registeredDevices});

  CustomerAdmin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['fullName'] != null) fullName = json['fullName'];

    if (json['phoneNumber'] != null) phoneNumber = json['phoneNumber'];


    if (json['createdAt'] != null) createdAt = json['createdAt'].toDate();
    if (json['role'] != null) role = json['role'];
    if (json['authError'] != null) {
      authError = json['authError']?.cast<String>();
    }

    if (json['registeredDevices'] != null) {
      registeredDevices = json['registeredDevices']?.cast<String>();
    }

    if (json['customerIds'] != null) {
      customerIds = json['customerIds']?.cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['fullName'] = fullName;
    data['phoneNumber'] = phoneNumber;
    data['createdAt'] = createdAt;
    data['authError'] = authError;
    data['role'] = role;
    data['authError'] = authError;
    data['registeredDevices'] = registeredDevices;
    data['customerIds'] = customerIds;

    return data;
  }
}
