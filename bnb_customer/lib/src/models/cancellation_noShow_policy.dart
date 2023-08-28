// ignore_for_file: file_names

class CancellationPolicy {
  int key;
  String? from;
  String? to;
  String? percentage;
  CancellationPolicy({
    required this.key,
    this.from,
    this.to,
    this.percentage,
  });

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) => CancellationPolicy(
        key: json['key'],
        from: json["from"],
        to: json['to'],
        percentage: json['percentage'],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "from": from,
        "to": to,
        "percentage": percentage,
      };
}

class NoShowPolicy {
  int key;
  String? percentage;

  NoShowPolicy({
    required this.key,
    this.percentage,
  });

  factory NoShowPolicy.fromJson(Map<String, dynamic> json) => NoShowPolicy(
        key: json['key'],
        percentage: json["percentage"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "percentage": percentage,
      };
}

class CancellationNoShowPolicy {
  String? appointmentId;
  String? customerId;
  String? paymentType;
  String? salonId;
  String? type;
  String? status;
  CancellationPaymentInfo? paymentInfo;
  CancellationPaymentMethod? paymentMethod;
  CancellationNoShowPolicy({
    this.appointmentId,
    this.customerId,
    this.paymentType,
    this.salonId,
    this.type,
    this.status,
    this.paymentInfo,
    this.paymentMethod,
  });

  factory CancellationNoShowPolicy.fromJson(Map<String, dynamic> json) => CancellationNoShowPolicy(
        appointmentId: json['appointmentId'],
        customerId: json["customerId"],
        paymentType: json['paymentType'],
        salonId: json['salonId'],
        type: json['type'],
        status: json["status"],
        paymentInfo: CancellationPaymentInfo.fromJson(json['paymentInfo']),
        paymentMethod: CancellationPaymentMethod.fromJson(json['paymentMethod']),
      );

  Map<String, dynamic> toJson() => {
        "appointmentId": appointmentId,
        "customerId": customerId,
        "paymentType": paymentType,
        "salonId": salonId,
        "type": type,
        "status": status,
        "createdAt": DateTime.now(),
        "paymentInfo": paymentInfo!.toJson(),
        "paymentMethod": paymentMethod!.toJson(),
      };
}

class CancellationPaymentInfo {
  String? cancellationFee;
  String? deposit;
  String? payableAmount;
  CancellationPaymentInfo({
    this.cancellationFee,
    this.deposit,
    this.payableAmount,
  });

  factory CancellationPaymentInfo.fromJson(Map<String, dynamic> json) => CancellationPaymentInfo(
        cancellationFee: json["cancellationFee"],
        deposit: json['deposit'],
        payableAmount: json['payableAmount'],
      );

  Map<String, dynamic> toJson() => {
        "cancellationFee": cancellationFee,
        "deposit": deposit,
        "payableAmount": payableAmount,
      };
}

class CancellationPaymentMethod {
  String? cardNumber;
  String? cardReference;

  CancellationPaymentMethod({
    this.cardNumber,
    this.cardReference,
  });

  factory CancellationPaymentMethod.fromJson(Map<String, dynamic> json) => CancellationPaymentMethod(
        cardNumber: json['CARDNUMBER'],
        cardReference: json['CARDREFERENCE'],
      );

  Map<String, dynamic> toJson() => {
        "CARDNUMBER": cardNumber,
        "CARDREFERENCE": cardReference,
      };
}

class CancellationNoShowType {
  static String cancellation = "cancellation";
  static String noShow = "noShow";
}

class CancellationNoShowPaymentType {
  static String refund = "refund";
  static String charge = "charge";
}
