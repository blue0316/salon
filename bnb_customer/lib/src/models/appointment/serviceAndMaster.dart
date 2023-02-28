import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/salon_master/master.dart';

// model for service against selected master
class ServiceAndMaster {
  ServiceModel? service;
  MasterModel? master;
  bool? isRandom;
  List<String>? validSlots;
  List<String>? NotCommonvalidSlots;
  ServiceAndMaster(
      {this.service,
      this.master,
      this.isRandom = false,
      this.validSlots,
      this.NotCommonvalidSlots});

  factory ServiceAndMaster.fromJson(Map<String, dynamic> json) =>
      ServiceAndMaster(
          service: ServiceModel.fromJson(json["service"]),
          isRandom: json["isRandom"],
          validSlots: json["validSlots"],
          NotCommonvalidSlots: json['NotCommonvalidSlots'],
          master: MasterModel.fromJson(json["master"]));

  Map<String, dynamic> toJson() => {
        "service": service!.toJson(),
        "master": master!.toJson(),
        "NotCommonvalidSlots": NotCommonvalidSlots,
        "isRandom": isRandom,
        "validSlots": validSlots
      };
}
