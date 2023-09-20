// ignore_for_file: public_member_api_docs, sort_constructors_first
class EnquiryModel {
  // Customer name
  late String customerName;

  // Customer Last name
  late String lastName;

  // Customer phone
  late String customerPhone;

  // Customer request
  late String customerRequest;

  // Salon
  late String salonId;

  // Date & Time Enquiry was created
  late DateTime createdAt;

  // Status of Enquiry
  late String status;

  EnquiryModel({
    required this.customerName,
    required this.lastName,
    required this.customerPhone,
    required this.customerRequest,
    required this.salonId,
    required this.createdAt,
    required this.status,
  });

  EnquiryModel.fromJson(Map<String, dynamic> json) {
    customerName = json['customerName'];
    lastName = json['lastName'];
    customerPhone = json['customerPhone'];
    customerRequest = json['customerRequest'];
    salonId = json['salonId'];
    createdAt = json['createdAt'].toDate();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['customerName'] = customerName;
    data['lastName'] = lastName;
    data['customerPhone'] = customerPhone;
    data['customerRequest'] = customerRequest;
    data['salonId'] = salonId;
    data['createdAt'] = createdAt;
    data['status'] = status;

    return data;
  }
}
