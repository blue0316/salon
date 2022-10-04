class PriceAndDurationModel {
  /// initially zero and elsewhere ignored if '0'
  String price = '0';
  String duration = '0';
  PriceAndDurationModel({this.price = "0", this.duration = "0"});
  PriceAndDurationModel.fromJson(Map<String, dynamic> json) {
    price = json['price'] ?? '0';
    duration = json['duration'] ?? '0';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['price'] = price;
    data['duration'] = duration;
    return data;
  }
}
