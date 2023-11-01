class TransactionModel {
  late DateTime timeInitiated;
  late String amount;
  late String? transactionId; // SAME AS DOC ID
  late String? responseCode; // SAME AS DOC ID
  late String? cardNumber;
  late String? cardExpiry;
  late String? cardReference;
  late String? cardType;
  late String? merchantRef;
  late String? storedCredentialUse;
  late String? salonId;

  TransactionModel({
    required this.timeInitiated,
    required this.amount,
    this.transactionId,
    this.responseCode,
    this.cardNumber,
    this.cardExpiry,
    this.cardReference,
    this.merchantRef,
    this.cardType,
    this.storedCredentialUse,
    this.salonId,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    timeInitiated = json['timeInitiated'].toDate();
    amount = json['amount'];
    transactionId = json['transactionId'];
    responseCode = json['RESPONSECODE'] ?? '';

    cardNumber = json['CARDNUMBER'] ?? json['MASKEDCARDNUMBER'];
    cardExpiry = json['CARDEXPIRY'];
    cardReference = json['CARDREFERENCE'];
    cardType = json['CARDTYPE'];
    storedCredentialUse = json['STOREDCREDENTIALUSE'];
    merchantRef = json['MERCHANTREF'];
    salonId = json['salonId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['timeInitiated'] = timeInitiated;
    data['amount'] = amount;
    data['transactionId'] = transactionId;
    data['RESPONSECODE'] = responseCode;
    data['salonId'] = salonId;

    return data;
  }
}
