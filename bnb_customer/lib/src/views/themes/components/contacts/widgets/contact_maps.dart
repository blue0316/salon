import 'dart:html';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_maps/google_maps.dart';
import 'dart:ui' as ui;
import 'package:google_maps/google_maps.dart' as maps;

class GoogleMaps extends ConsumerStatefulWidget {
  final SalonModel? salonModel;
  const GoogleMaps({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends ConsumerState<GoogleMaps> {
  String htmlId = "7";

  @override
  Widget build(BuildContext context) {
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final myLatlng = maps.LatLng(
        widget.salonModel!.position?.geoPoint?.latitude ?? 1.3521,
        widget.salonModel!.position?.geoPoint?.longitude ?? 103.8198,
      );

      final mapOptions = maps.MapOptions()
        ..zoom = 10
        ..maxZoom = 19
        ..center = maps.LatLng(
          widget.salonModel!.position?.geoPoint?.latitude ?? 1.3521,
          widget.salonModel!.position?.geoPoint?.longitude ?? 103.8198,
        );

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      final map = maps.GMap(elem, mapOptions);

      maps.Marker(maps.MarkerOptions()
            ..position = myLatlng
            ..map = map
          // ..title = 'Hello World!'
          );

      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }
}
