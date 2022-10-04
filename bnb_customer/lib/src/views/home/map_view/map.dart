import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/home/map_view_provider.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../models/salon_master/salon.dart';
import '../../../utils/icons.dart';
import 'dart:ui' as ui;

class MapWidget extends ConsumerStatefulWidget {
  final List<SalonModel> salons;

  final double radius;
  final LatLng center;
  final String selectedSalonId;
  const MapWidget({
    Key? key,
    required this.salons,
    required this.radius,
    required this.center,
    required this.selectedSalonId,
  }) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends ConsumerState<MapWidget> {
  late MapViewProvider _mapViewProvider;
  final Set<Circle> _circle = HashSet<Circle>();
  final Set<Marker> _marker = HashSet<Marker>();

  BitmapDescriptor? _salonMarker;
  BitmapDescriptor? _selectedSalonMarker;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future _createMarker() async {
    if (_salonMarker == null || _selectedSalonMarker == null) {
      final Uint8List mapSalonMarker = await getBytesFromAsset(AppIcons.mapSalonMarker, 80);
      final Uint8List mapSelectedSalonMarker = await getBytesFromAsset(AppIcons.mapSelectedSalonMarker, 80);
      _salonMarker = BitmapDescriptor.fromBytes(mapSalonMarker);
      _selectedSalonMarker = BitmapDescriptor.fromBytes(mapSelectedSalonMarker);
    }
    setCircle();
    setMarkers();
  }

  setCircle() {
    setState(
      () {
        _circle.clear();
        _circle.add(
          Circle(
            circleId: const CircleId("circle_uid"),
            center: widget.center,
            radius: widget.radius * 1000,
            fillColor: Colors.black.withOpacity(0.2),
            strokeWidth: 1,
            strokeColor: Colors.black.withOpacity(0.2),
          ),
        );
      },
    );
  }

  setMarkers() async {
    printIt('Markers drawn again !');
    setState(() {
      _marker.clear();
      for (int i = 0; i < widget.salons.length; i++) {
        SalonModel _salon = widget.salons[i];
        _marker.add(Marker(
            onTap: () {
              _mapViewProvider.onSelectedSalonChange(
                salon: _salon,
              );
            },
            markerId: MarkerId('marker_uid_${_salon.salonId}'),
            position: LatLng(_salon.position!.geoPoint!.latitude, _salon.position!.geoPoint!.longitude),
            icon: widget.selectedSalonId == _salon.salonId ? _selectedSalonMarker! : _salonMarker!));
      }
    });
  }

  final double zoom = 11.3;

  @override
  Widget build(BuildContext context) {
    _mapViewProvider = ref.watch(mapViewProvider);
    _createMarker();

    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        if (!_mapViewProvider.mapController.isCompleted) {
          _mapViewProvider.mapController.complete(controller);
        }
      },

      myLocationEnabled: true,
      circles: _circle,
      markers: _marker,
      compassEnabled: false,
      myLocationButtonEnabled: false,
      trafficEnabled: true,
      indoorViewEnabled: true,
      initialCameraPosition: CameraPosition(
        target: widget.center,
        zoom: zoom,
      ),
    );
  }
}
