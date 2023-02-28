import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/salon_master/master.dart';

// model for service against selected master
class ServiceAndMaster {
  ServiceModel? service;
  MasterModel? master;
  ServiceAndMaster({this.service, this.master});

  factory ServiceAndMaster.fromJson(Map<String, dynamic> json) =>
      ServiceAndMaster(
          service: ServiceModel.fromJson(json["service"]),
          master: MasterModel.fromJson(json["master"]));

  Map<String, dynamic> toJson() => {
        "service": service!.toJson(),
        "master": master!.toJson(),
      };
}
