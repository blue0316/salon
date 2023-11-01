class ReviewModel {
  String? reviewId;
  late String appointmentId;
  late String? salonId;
  late String? masterId;
  late String customerId;
  late String customerName;
  late String customerPic;
  late String salonName;
  late String review;
  bool? isAnonymous;
  late double rating;
  late DateTime createdAt;
  late List<String> choosenTags;
  bool? includeInRatingCal;
  bool? displayOnWebsite;

  ReviewModel({
    this.reviewId,
    required this.appointmentId,
    required this.customerId,
    required this.customerName,
    required this.customerPic,
    required this.salonName,
    required this.review,
    this.isAnonymous,
    this.includeInRatingCal,
    this.displayOnWebsite,
    required this.rating,
    required this.createdAt,
    required this.choosenTags,
    required this.salonId,
    required this.masterId,
  });

  ReviewModel.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointmentId'];
    reviewId = json['reviewId'];
    salonId = json['salonId'];
    masterId = json['masterId'];
    customerId = json['customerId'];
    isAnonymous = json['isAnonymous'] ?? false;
    includeInRatingCal = json['includeInRatingCal'] ?? true;
    displayOnWebsite = json['displayOnWebsite'] ?? true;
    salonName = json['salonName'];
    review = json['review'] ?? "";
    rating = double.parse(json['rating'].toString());
    createdAt = json['createdAt'].toDate();
    choosenTags = json['choosenTags'] != null ? json['choosenTags'].cast<String>() : [];
    customerName = json["customerName"] != null ? json['customerName'] : '';
    customerPic = json["customerPic"] != null ? json['customerPic'] : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['appointmentId'] = appointmentId;
    data['salonId'] = salonId;
    data['masterId'] = masterId;
    data['customerId'] = customerId;
    data['salonName'] = salonName;
    data['review'] = review;
    data['isAnonymous'] = isAnonymous ?? false;
    data['displayOnWebsite'] = displayOnWebsite ?? true;
    data['includeInRatingCal'] = includeInRatingCal ?? true;
    data['rating'] = rating;
    data['createdAt'] = createdAt;
    data['reviewId'] = reviewId;
    data['choosenTags'] = choosenTags;
    data['customerName'] = customerName;
    data['customerPic'] = customerPic;
    return data;
  }
}
