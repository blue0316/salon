import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'collections.dart';

class SearchApi {
  //locale can be only uk or en
  Future<List<ParentServiceModel>> searchRootServices({required String searchText, String locale = "uk"}) async {
    try {
      final String field = "translations.$locale";

      QuerySnapshot _response = await Collection.allServices.orderBy(field).startAt([searchText.toUpperCase()]).endAt([searchText.toLowerCase() + "~"]).limit(20).get();

      return _response.docs.map((e) {
        Map serviceMap = e.data() as Map<dynamic, dynamic>;
        serviceMap['parentServiceId'] = e.id;

        ParentServiceModel service = ParentServiceModel.fromJson(serviceMap as Map<String, dynamic>);
        return service;
      }).toList();
    } catch (e) {
      printIt(e);
    }
    return [];
  }

  Future<List<ServiceModel>> getServicesFromParent({required ParentServiceModel parentService}) async {
    try {
      QuerySnapshot _response = await Collection.services.where("parentServiceId", isEqualTo: parentService.parentServiceId).get();

      return _response.docs.map((e) {
        Map serviceMap = e.data() as Map<dynamic, dynamic>;
        serviceMap['serviceId'] = e.id;

        ServiceModel service = ServiceModel.fromJson(serviceMap as Map<String, dynamic>);
        return service;
      }).toList();
    } catch (e) {
      printIt(e);
    }
    return [];
  }

  double? computeDistance(LatLng position, double radius, SalonModel salon) {
    // final GeoFirePoint _center = Geoflutterfire().point(
    //   latitude: position.latitude,
    //   longitude: position.longitude,
    // );

    //   return _center.distance(
    //       lat: salon.position!.geoPoint!.latitude,
    //       lng: salon.position!.geoPoint!.longitude);
  }

  Future<List<SalonModel>> getSalonsFromParentServiceId({required ParentServiceModel parentService, LatLng? position, double? radius}) async {
    try {
      QuerySnapshot _response = await Collection.salons.where("parentServiceId", arrayContains: parentService.parentServiceId).where('isAvailableOnline', isEqualTo: true).get();

      return _response.docs.map((e) {
        Map map = e.data() as Map<dynamic, dynamic>;
        map['salonId'] = e.id;
        printIt(e.id);
        SalonModel salon = SalonModel.fromJson(map as Map<String, dynamic>);
        if (position != null && radius != null) {
          salon.distanceFromCenter = computeDistance(position, radius, salon);
        }
        return salon;
      }).toList();
    } catch (e) {
      printIt(e);
    }
    return [];
  }
}
