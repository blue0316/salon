// ignore_for_file: unnecessary_null_comparison, prefer_collection_literals

class ScheduleModel {
  late bool success;
  late List<Schedule> schedule = [];

  ScheduleModel({
    required this.success,
    required this.schedule,
  });

  ScheduleModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      schedule.clear();
      json['data'].forEach((v) {
        schedule.add(Schedule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    if (schedule != null) {
      data['data'] = schedule.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Schedule {
  late String time;
  late int seanceLength;
  late int sumLength;
  late DateTime datetime;

  Schedule({
    required this.time,
    required this.seanceLength,
    required this.sumLength,
    required this.datetime,
  });

  Schedule.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    seanceLength = json['seance_length'];
    sumLength = json['sum_length'];
    if (json['datetime'] != null) {
      final String date = json['datetime'].substring(0, 19);
      datetime = DateTime.parse(date);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['time'] = time;
    data['seance_length'] = seanceLength;
    data['sum_length'] = sumLength;
    data['datetime'] = datetime.toString();
    return data;
  }
}
