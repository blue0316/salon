// ignore_for_file: public_member_api_docs, sort_constructors_first
class EnquiryModel {
  // Customer name
  late String customerName;

  // Customer phone
  late String customerPhone;

  // Customer email
  late String customerEmail;

  // Salon
  late String salonId;

  // Date & Time Enquiry was created
  late DateTime createdAt;

  // Status of Enquiry
  late String status;

  EnquiryModel({
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.salonId,
    required this.createdAt,
    required this.status,
  });

  EnquiryModel.fromJson(Map<String, dynamic> json) {
    customerName = json['customerName'];
    customerPhone = json['customerPhone'];
    customerEmail = json['customerEmail'];
    salonId = json['salonId'];
    createdAt = json['createdAt'].toDate();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['customerName'] = customerName;
    data['customerPhone'] = customerPhone;
    data['customerEmail'] = customerEmail;
    data['salonId'] = salonId;
    data['createdAt'] = createdAt;
    data['status'] = status;

    return data;
  }
}
