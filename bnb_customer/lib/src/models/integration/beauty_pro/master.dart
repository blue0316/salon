class MasterBeautyPro {
  late String id;
  late String name;

  MasterBeautyPro({
    required this.id,
    required this.name,
  });

  MasterBeautyPro.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
