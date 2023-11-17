class CreditCard {
  late String id;
  String cardNumber = '';
  String cardExpiry = '';
  String cardReference = '';
  String cardType = '';
  String merchantRef = '';
  String storedCredentialUse = '';
  String customerId = '';

  CreditCard({
    this.id = '',
    required this.cardNumber,
    required this.cardExpiry,
    required this.cardReference,
    required this.merchantRef,
    required this.cardType,
    required this.storedCredentialUse,
    required this.customerId,
  });

  CreditCard.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    customerId = json['customerId'] ?? '';
    if (json['CARDNUMBER'] != null) cardNumber = json['CARDNUMBER'];
    if (json['CARDEXPIRY'] != null) cardExpiry = json['CARDEXPIRY'];
    if (json['CARDREFERENCE'] != null) cardReference = json['CARDREFERENCE'];
    if (json['CARDTYPE'] != null) cardType = json['CARDTYPE'];
    if (json['STOREDCREDENTIALUSE'] != null) storedCredentialUse = json['STOREDCREDENTIALUSE'];
    if (json['MERCHANTREF'] != null) merchantRef = json['MERCHANTREF'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['customerId'] = customerId;
    data['CARDNUMBER'] = cardNumber;
    data['CARDEXPIRY'] = cardExpiry;
    data['CARDREFERENCE'] = cardReference;
    data['CARDTYPE'] = cardType;
    data['STOREDCREDENTIALUSE'] = storedCredentialUse;
    data['MERCHANTREF'] = merchantRef;

    return data;
  }
}
