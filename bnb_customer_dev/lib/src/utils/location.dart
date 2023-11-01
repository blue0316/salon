// import 'dart:async';
//
// import 'package:bbblient/src/utils/utils.dart';
// import 'package:flutter/foundation.dart';
// import 'package:geocoding/geocoding.dart' as geoCoder;
//
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
//
// class LocationUtils {
//   static Location location = Location();
//
//   static Future<bool> requestPermission() async {
//     bool _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return false;
//       }
//     }
//
//     PermissionStatus _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   static Future<LatLng?> getLocation() async {
//     try {
//       final bool permission = await requestPermission();
//
//       if (!permission) return null;
//
//       //will wait for 3 seconds to complete otherwise will throw exception
//       LocationData _locationData =
//           await Location().getLocation().timeout(const Duration(seconds: 3));
//
//       if (_locationData.latitude == null || _locationData.longitude == null) {
//         return null;
//       }
//
//       return LatLng(_locationData.latitude!, _locationData.longitude!);
//     } catch (e) {
//       printIt(e);
//       return null;
//     }
//   }
//
//   static Future<String> getAddressFromCoordinates(LatLng location) async {
//     try {
//       if(kIsWeb) return "";
//       List<geoCoder.Placemark> _place = await geoCoder.placemarkFromCoordinates(
//           location.latitude, location.longitude);
//       geoCoder.Placemark placeMark = _place[0];
//       String name = placeMark.name == "" ? "" : "${placeMark.name}, ";
//       String subLocality =
//           placeMark.subLocality == "" ? "" : "${placeMark.subLocality}, ";
//       String locality =
//           placeMark.locality == "" ? "" : "${placeMark.locality}, ";
//       String administrativeArea = placeMark.administrativeArea! + " ";
//       String postalCode =
//           placeMark.postalCode == "" ? "" : "${placeMark.postalCode}, ";
//       String country = placeMark.country == "" ? "" : "${placeMark.country}.";
//       String address = name +
//           subLocality +
//           locality +
//           administrativeArea +
//           postalCode +
//           country;
//       return address;
//     } catch (e) {
//       printIt('error in getAddressFromCoordinates');
//       printIt(e);
//       return '';
//     }
//   }
//
// }
