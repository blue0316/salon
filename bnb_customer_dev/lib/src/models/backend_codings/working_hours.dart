class WorkingHoursModel {
  late Hours mon;
  late Hours tue;
  late Hours wed;
  late Hours thu;
  late Hours fri;
  late Hours sat;
  late Hours sun;

  WorkingHoursModel({
    required this.mon,
    required this.tue,
    required this.wed,
    required this.thu,
    required this.fri,
    required this.sat,
    required this.sun,
  });

  static final Hours _emptyHours = Hours(
      startTime: '-:-', endTime: '-:-', breakStartTime: '-:-', breakEndTime: '-:-', isWorking: false, isBreakAvailable: false);

  WorkingHoursModel.fromJson(Map<String, dynamic>? json) {
    mon = json?['mon'] != null ? Hours.fromJson(json?['mon']) : _emptyHours;
    tue = json?['tue'] != null ? Hours.fromJson(json?['tue']) : _emptyHours;
    wed = json?['wed'] != null ? Hours.fromJson(json?['wed']) : _emptyHours;
    thu = json?['thu'] != null ? Hours.fromJson(json?['thu']) : _emptyHours;
    fri = json?['fri'] != null ? Hours.fromJson(json?['fri']) : _emptyHours;
    sat = json?['sat'] != null ? Hours.fromJson(json?['sat']) : _emptyHours;
    sun = json?['sun'] != null ? Hours.fromJson(json?['sun']) : _emptyHours;
  }

  Hours getHoursFromDay({required int day}) {
    switch (day) {
      case 1:
        return mon;
      case 2:
        return tue;
      case 3:
        return tue;
      case 4:
        return tue;
      case 5:
        return tue;
      case 6:
        return tue;
      case 7:
        return tue;
      default:
        return mon;
    }
  }

  //return the default working hours
  //todo: set the default working hours here
  static WorkingHoursModel getDefaultWorkingHours() {
    //must no pass the same reference everywhere
    return WorkingHoursModel(
      mon: Hours.fromJson(_emptyHours.toJson()),
      tue: Hours.fromJson(_emptyHours.toJson()),
      wed: Hours.fromJson(_emptyHours.toJson()),
      thu: Hours.fromJson(_emptyHours.toJson()),
      fri: Hours.fromJson(_emptyHours.toJson()),
      sat: Hours.fromJson(_emptyHours.toJson()),
      sun: Hours.fromJson(_emptyHours.toJson()),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['mon'] = mon.toJson();
    data['tue'] = tue.toJson();
    data['wed'] = wed.toJson();
    data['thu'] = thu.toJson();
    data['fri'] = fri.toJson();
    data['sat'] = sat.toJson();
    data['sun'] = sun.toJson();
    return data;
  }
}

class Hours {
  String startTime = '--';
  String endTime = '--';
  String breakStartTime = '--';
  String breakEndTime = '--';
  bool isWorking = false;
  bool isBreakAvailable = false;

  Hours({
    required this.startTime,
    required this.endTime,
    required this.breakStartTime,
    required this.breakEndTime,
    required this.isWorking,
    required this.isBreakAvailable,
  });

  Hours.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'] ?? '--';
    endTime = json['endTime'] ?? '--';
    breakStartTime = json['breakStartTime'] ?? '--';
    breakEndTime = json['breakEndTime'] ?? '--';
    isWorking = json['isWorking'] ?? false;
    isBreakAvailable = json['isBreakAvailable'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['breakStartTime'] = breakStartTime;
    data['breakEndTime'] = breakEndTime;
    data['isWorking'] = isWorking;
    data['isBreakAvailable'] = isBreakAvailable;
    return data;
  }
}
