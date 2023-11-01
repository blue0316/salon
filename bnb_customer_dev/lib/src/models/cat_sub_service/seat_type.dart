class SeatTypeModel {
  String? seatTypeId;
  // number of seats available
  int? count;
  //name of the seat
  // eg Manicure seat
  String? seatName;

  SeatTypeModel({this.seatTypeId, this.count, this.seatName});

  SeatTypeModel.fromJson(Map<String, dynamic> json) {
    seatTypeId = json['seatTypeId'];
    count = json['count'];
    seatName = json['seatName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['count'] = count;
    data['seatName'] = seatName;
    return data;
  }
}
