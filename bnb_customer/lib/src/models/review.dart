class ReviewModel {
  late String reviewId;
  late String appointmentId;
  late String? salonId;
  late String? masterId;
  late String customerId;
  late String customerName;
  late String customerPic;
  late String salonName;
  late String review;
  late double rating;
  late DateTime createdAt;
  late List<String> choosenTags;
  // todo: add subsequent comments for a review
  List<Comment>? comments;
  ReviewModel({
    required this.reviewId,
    required this.appointmentId,
    required this.customerId,
    required this.customerName,
    required this.customerPic,
    required this.salonName,
    required this.review,
    required this.rating,
    required this.createdAt,
    required this.choosenTags,
    required this.salonId,
    required this.masterId,
  });

  ReviewModel.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointmentId'];
    salonId = json['salonId'];
    masterId = json['masterId'];
    customerId = json['customerId'];
    salonName = json['salonName'];
    review = json['review'];
    rating = json['rating'];
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
    data['rating'] = rating;
    data['createdAt'] = createdAt;
    data['choosenTags'] = choosenTags;
    data['customerName'] = customerName;
    data['customerPic'] = customerPic;
    return data;
  }
}

class Comment {
  String? comment;
  // salon or customer
  String? commentedBy;
  // either it can be salonId or customerId
  String? commenterId;
  DateTime? createdAt;
  String? commenterName;

  Comment({this.comment, this.commentedBy, this.commenterId, this.createdAt, this.commenterName});

  Comment.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    commentedBy = json['commentedBy'];
    commenterId = json['commenterId'];
    createdAt = json['createdAt'];
    commenterName = json['commenterName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['comment'] = comment;
    data['commentedBy'] = commentedBy;
    data['commenterId'] = commenterId;
    data['createdAt'] = createdAt;
    data['commenterName'] = commenterName;
    return data;
  }
}
