import 'dart:collection';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/home/salon_search_provider.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../../../../theme/app_main_theme.dart';
import '../../../../utils/icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapFilter extends ConsumerStatefulWidget {
  const MapFilter({Key? key}) : super(key: key);

  @override
  _MapFilterState createState() => _MapFilterState();
}

class _MapFilterState extends ConsumerState<MapFilter> {
  final double _maxDistance = 50.0;
  final double _minDistance = 0.0;
  final TextEditingController controller = TextEditingController();
  late SalonSearchProvider salonSearchController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final salonSearchController = ref.watch(salonSearchProvider);
    controller.text = salonSearchController.tempAddress;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                AppLocalizations.of(context)?.distanceArea ?? "Distance Area",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ),
          const Divider(
            color: AppTheme.coolGrey,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            child: TextFormField(
              readOnly: true,
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  fillColor: AppTheme.coolerGrey,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () => salonSearchController.setLocation(),
                      child: SvgPicture.asset(AppIcons.locationCurrentSVG),
                    ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Map(
              center: salonSearchController.tempCenter,
              radius: salonSearchController.tempSearchRadius,
              onCenterChange: (LatLng latLng) {
                salonSearchController.changeTempCenter(latlng: latLng);
              },
            ),
          ),
          SfRangeSlider(
            min: _minDistance,
            max: _maxDistance,
            stepSize: 1,
            values: SfRangeValues(0.0, salonSearchController.tempSearchRadius),
            onChanged: (SfRangeValues newValues) => salonSearchController.onRadiusChange(newValues.end),
            enableTooltip: true,
            tooltipShape: const SfPaddleTooltipShape(),
          ),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}

class Map extends StatefulWidget {
  final double radius;
  final LatLng center;
  final Function onCenterChange;

  const Map({Key? key, required this.radius, required this.center, required this.onCenterChange}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  bool loading = true;
  final Set<Circle> _circle = HashSet<Circle>();
  final Set<Marker> _marker = HashSet<Marker>();

  double? _oldRadius;
  LatLng? _oldCoordinates;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    createMarker();
  }

  BitmapDescriptor? _icon;
  Future createMarker() async {
    if (_icon == null) {
      loading = true;
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      _icon = await BitmapDescriptor.fromAssetImage(configuration, AppIcons.mapMarker);
      setState(() {
        loading = false;
      });
    }
  }

  //resets the circle every time the location or radius changes
  setCircle(LatLng? latLng) async {
    if (_oldCoordinates != widget.center || _oldRadius != widget.radius) {
      printIt('Map marked area changed');
      _circle.clear();
      setState(() {
        _circle.add(Circle(
          circleId: const CircleId("circle_uid"),
          center: widget.center,
          radius: widget.radius * 1000,
          fillColor: Colors.black.withOpacity(0.2),
          strokeWidth: 1,
          strokeColor: Colors.black.withOpacity(0.2),
        ));
        _marker.clear();
        _marker.add(Marker(markerId: const MarkerId('marker_uid'), position: latLng!, icon: _icon!));
      });
      _oldRadius = widget.radius;
      _oldCoordinates = widget.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (loading) {
      return const CircularProgressIndicator();
    }

    setCircle(widget.center);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 131,
        width: size.width - 40,
        child: GoogleMap(
          // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
          //   Factory<OneSequenceGestureRecognizer>(
          //     () => EagerGestureRecognizer(),
          //   ),
          // ].toSet(),
          myLocationEnabled: false,
          onTap: widget.onCenterChange as void Function(LatLng)?,
          circles: _circle,
          markers: _marker,
          compassEnabled: false,
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
            target: widget.center,
            zoom: 8,
          ),
        ),
      ),
    );
  }
}
