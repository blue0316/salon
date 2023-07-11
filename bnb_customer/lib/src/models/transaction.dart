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
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    timeInitiated = json['timeInitiated'].toDate();
    amount = json['amount'];
    transactionId = json['transactionId'];
    responseCode = json['RESPONSECODE'] ?? '';

    cardNumber = json['CARDNUMBER'];
    cardExpiry = json['CARDEXPIRY'];
    cardReference = json['CARDREFERENCE'];
    cardType = json['CARDTYPE'];
    storedCredentialUse = json['STOREDCREDENTIALUSE'];
    merchantRef = json['MERCHANTREF'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['timeInitiated'] = timeInitiated;
    data['amount'] = amount;
    data['transactionId'] = transactionId;
    data['RESPONSECODE'] = responseCode;

    return data;
  }
}
