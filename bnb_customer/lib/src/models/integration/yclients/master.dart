class MastersYClients {
  MastersYClients({
    required this.success,
    required this.masters,
  });
  late bool success;
  late List<MasterYClients> masters;

  MastersYClients.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    masters = List.from(json['data']).map((e) => MasterYClients.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = masters.map((e) => e.toJson()).toList();

    return _data;
  }
}

class MasterYClients {
  late int id;
  late String name;
  late String specialization;

  late String avatar;
  late String avatarBig;
  MasterYClients({
    required this.id,
    required this.name,
    required this.specialization,
    required this.avatar,
    required this.avatarBig,
  });
  MasterYClients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    specialization = json['specialization'];

    avatar = json['avatar'];
    avatarBig = json['avatar_big'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['specialization'] = specialization;

    _data['avatar'] = avatar;
    _data['avatar_big'] = avatarBig;
    return _data;
  }
}
