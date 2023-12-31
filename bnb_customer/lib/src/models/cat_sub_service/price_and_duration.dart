class PriceAndDurationModel {
  bool? isFixedPrice;
  bool? isPriceRange;
  bool? isPriceStartAt;
  String? price = '0';
  String? priceMax = '0';
  String? duration = '0';
  String? durationinHr = '0';
  String? durationinMin = '0';

  PriceAndDurationModel({
    this.price = "0",
    this.priceMax,
    this.duration = "0",
    this.isFixedPrice,
    this.isPriceRange,
    this.isPriceStartAt,
    this.durationinMin = '0',
    this.durationinHr = '0',
  });

  PriceAndDurationModel.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    priceMax = json['priceMax'];
    duration = json['duration'] ?? '0';
    isFixedPrice = json["isFixedPrice"];
    isPriceRange = json["isPriceRange"];
    isPriceStartAt = json["isPriceStartAt"];
    if (json['durationInHr'] != null) durationinHr = json['durationInHr'];
    if (json['durationInMin'] != null) durationinMin = json['durationInMin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['priceMax'] = priceMax;
    data["isFixedPrice"] = isFixedPrice;
    data["isPriceRange"] = isPriceRange;
    data["isPriceStartAt"] = isPriceStartAt;
    // if (durationinHr == '0') data['duration'] = this.duration;

    // if (durationinHr != '0') {
    //   data['duration'] = ((int.parse(this.durationinHr.toString()) * 60) + int.parse(this.durationinMin.toString())).toString();
    // } else {
    //   ('hey duration');
    //   data['duration'] = (int.parse(this.durationinMin.toString()) + int.parse(this.duration.toString())).toString();
    // }

    data['duration'] = duration;

    data['durationInMin'] = durationinMin;
    data['durationInHr'] = durationinHr;

    return data;
  }
}
