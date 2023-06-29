class TransactionModel {
  late DateTime timeInitiated;
  late String amount;
  late String? docId;

  TransactionModel({
    required this.timeInitiated,
    required this.amount,
    this.docId,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    timeInitiated = json['timeInitiated'].toDate();
    amount = json['amount'];
    docId = json['docId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['timeInitiated'] = timeInitiated;
    data['amount'] = amount;
    data['docId'] = docId;

    return data;
  }
}
