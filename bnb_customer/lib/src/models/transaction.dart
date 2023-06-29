class TransactionModel {
  late DateTime timeInitiated;
  late String amount;
  late String? transactionId; // SAME AS DOC ID

  TransactionModel({
    required this.timeInitiated,
    required this.amount,
    this.transactionId,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    timeInitiated = json['timeInitiated'].toDate();
    amount = json['amount'];
    transactionId = json['transactionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['timeInitiated'] = timeInitiated;
    data['amount'] = amount;
    data['transactionId'] = transactionId;

    return data;
  }
}
