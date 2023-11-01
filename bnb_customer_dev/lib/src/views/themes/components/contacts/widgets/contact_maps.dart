import 'dart:html';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/views/themes/components/contacts/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  double lat = 28.538336;
  double long = -81.379234;
  bool _spinner = false;

  @override
  void initState() {
    super.initState();
    fetchLatAndLong();
  }

  fetchLatAndLong() async {
    setState(() => _spinner = true);

    try {
      Map<String, dynamic> location = await getLatLongFromAddress(widget.salonModel!.address);

      setState(() {
        lat = location['lat'];
        long = location['lng'];
      });
    } catch (e) {
      debugPrint('Maps Error: $e');

      setState(() {
        lat = 28.538336;
        long = -81.379234;
      });
    }

    setState(() => _spinner = false);
  }

  @override
  Widget build(BuildContext context) {
    // print('=======@@@@@================@@@@===========');
    // print(widget.salonModel!.address);
    // print(lat);
    // print(long);
    // print('=======@@@@@================@@@@===========');

    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final myLatlng = maps.LatLng(lat, long);

      final mapOptions = maps.MapOptions()
        ..zoom = 17
        ..maxZoom = 20
        ..center = maps.LatLng(lat, long);

      final elem = DivElement()..id = htmlId;
      // ..style.width = "100%"
      // ..style.height = "100%"
      // ..style.border = 'none';

      final map = maps.GMap(elem, mapOptions);

      maps.Marker(maps.MarkerOptions()
            ..position = myLatlng
            ..map = map
          // ..title = 'Hello World!'
          );

      return elem;
    });

    return _spinner
        ? const Center(child: CircularProgressIndicator())
        : HtmlElementView(
            viewType: htmlId,
          );
  }
}
