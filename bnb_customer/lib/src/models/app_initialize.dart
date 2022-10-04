

class AppInitialization {
  //bool to check if server is down or not
  late bool serverDown;

  //if server is down it contains the error message in different languages
  late Map serverDownReason;

  AppInitialization({required this.serverDown, required this.serverDownReason});

  AppInitialization.fromJson(dynamic json) {
    serverDown = json["serverDown"];

    serverDownReason = json["serverDownReason"] ?? {};
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["serverDown"] = serverDown;
    map["serverDownReason"] = serverDownReason;
    return map;
  }
}
