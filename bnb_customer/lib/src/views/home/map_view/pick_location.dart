import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/home/salon_search_provider.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/location.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:ui' as ui;

class PickLocation extends ConsumerStatefulWidget {
  const PickLocation({Key? key}) : super(key: key);

  @override
  _PickLocationState createState() => _PickLocationState();
}

class _PickLocationState extends ConsumerState<PickLocation> {
  late SalonSearchProvider _salonSearchProvider;
  final Set<Marker> _marker = HashSet<Marker>();
  Completer<GoogleMapController> _controller = Completer();
  bool locationChanged = false;
  final double zoom = 11.3;

  @override
  void initState() {
    super.initState();
    _createMarker();
  }

  BitmapDescriptor? _locationMarker;
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future _createMarker() async {
    _salonSearchProvider = ref.read(salonSearchProvider);
    if (_locationMarker == null) {
      final Uint8List mapSelectedSalonMarker =
          await getBytesFromAsset(AppIcons.mapSelectedSalonMarker, 90);
      _locationMarker = BitmapDescriptor.fromBytes(mapSelectedSalonMarker);
    }
    setMarkers();
  }

  setMarkers() async {
    _marker.clear();
    printIt('Markers drawn again !');
    setState(() {
      _marker.add(Marker(
          markerId: MarkerId('${DateTime.now().millisecondsSinceEpoch}'),
          position: _salonSearchProvider.tempCenter,
          icon: _locationMarker!));
    });
  }

  changeCurrentLoc(LatLng val) {
    EasyDebounce.debounce('my-debouncer', const Duration(milliseconds: 300),
        () {
      _salonSearchProvider.changeTempCenter(latlng: val);
      setMarkers();
      locationChanged = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationEnabled: false,
            markers: _marker,
            compassEnabled: true,
            myLocationButtonEnabled: false,
            trafficEnabled: true,
            indoorViewEnabled: true,
            initialCameraPosition: CameraPosition(
              target: _salonSearchProvider.tempCenter,
              zoom: 11,
            ),
            // onCameraMove: (val) {
            //   changeCurrentLoc(val.target);
            // },
            onTap: changeCurrentLoc,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 40),
            child: BnbMaterialButton(
              minWidth: DeviceConstraints.getResponsiveSize(
                  context, width * 0.8, width * 0.6, width * 0.4),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              onTap: () {
                Navigator.pop(context, locationChanged);
              },
              title: AppLocalizations.of(context)?.done ?? "Done",
            ),
          ),
          Positioned(
              top: 10,
              child: SafeArea(
                child: Container(
                    width: 1.sw - 32,
                    margin: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _salonSearchProvider.tempAddress,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(color: AppTheme.black),
                                maxLines: 3,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                LatLng? currentLocation =
                                    await LocationUtils.getLocation();
                                if (currentLocation != null) {
                                  locationChanged = true;
                                  _salonSearchProvider.changeTempCenter(
                                      latlng: currentLocation);
                                  setMarkers();
                                  final GoogleMapController controller =
                                      await _controller.future;
                                  controller.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                              target: currentLocation,
                                              zoom: 11)));
                                }
                              },
                              child: SizedBox(
                                height: 35.h,
                                width: 35.h,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SvgPicture.asset(
                                      AppIcons.locationCurrentSVG),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ))
        ],
      ),
    );
  }
}
