import 'dart:async';

import 'package:bbblient/src/models/backend_codings/working_hours.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/salon_master/salon.dart';

class MapViewProvider with ChangeNotifier {
  // final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  bool isSearching = false;

  SalonModel? selectedSalon;
  String selectedSalonId = '';

  bool showSelectedSalon = false;
  late Completer<GoogleMapController> mapController = Completer();

  init() {
    showSelectedSalon = false;
    selectedSalon = null;
    selectedSalonId = '';
    // notifyListeners();
  }

  toggleSearch() {
    isSearching = !isSearching;
    notifyListeners();
  }

  toggleShow() {
    showSelectedSalon = !showSelectedSalon;
    notifyListeners();
  }

  onSelectedSalonChange({required SalonModel salon}) {
    showSelectedSalon = true;
    notifyListeners();
    assignWorkingHours(salon);
    selectedSalonId = salon.salonId;
    selectedSalon = salon;
    // changeCameraPos(LatLng(salon.position!.geoPoint!.latitude, salon.position!.geoPoint!.longitude));
    notifyListeners();
  }

  ///function to control the camera position
  changeCameraPos(LatLng position) async {
    GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: position, zoom: 10)));
  }

  Map<int, String> workingHoursMap = {};

  assignWorkingHours(SalonModel salon) {
    workingHoursMap = _computeWorkingHoursMap(salon.workingHours);
    notifyListeners();
  }

  Map<int, String> _computeWorkingHoursMap(WorkingHoursModel? workingHours) {
    Map<int, String> weekDays = {};

    if (workingHours == null) {
      return {};
    }
    // todo fix this logic

    // if (workingHours.mon != null &&
    //     (workingHours.mon?.isWorking ?? false) &&
    //     workingHours.mon!.startTime != null &&
    //     workingHours.mon!.endTime != null) {
    //   weekDays[1] = "${workingHours.mon!.startTime} - ${workingHours.mon!.endTime}";
    // }

    // if (workingHours.tue != null &&
    //     (workingHours.tue?.isWorking ?? false) &&
    //     workingHours.tue!.startTime != null &&
    //     workingHours.tue!.endTime != null) {
    //   weekDays[2] = "${workingHours.tue!.startTime} - ${workingHours.tue!.endTime}";
    // }

    // if (workingHours.wed != null &&
    //     (workingHours.wed?.isWorking ?? false) &&
    //     workingHours.wed!.startTime != null &&
    //     workingHours.wed!.endTime != null) {
    //   weekDays[3] = "${workingHours.wed!.startTime} - ${workingHours.wed!.endTime}";
    // }

    // if (workingHours.thu != null &&
    //     (workingHours.thu?.isWorking ?? false) &&
    //     workingHours.thu!.startTime != null &&
    //     workingHours.thu!.endTime != null) {
    //   weekDays[4] = "${workingHours.thu!.startTime} - ${workingHours.thu!.endTime}";
    // }

    // if (workingHours.fri != null &&
    //     (workingHours.fri?.isWorking ?? false) &&
    //     workingHours.fri!.startTime != null &&
    //     workingHours.fri!.endTime != null) {
    //   weekDays[5] = "${workingHours.fri!.startTime} - ${workingHours.fri!.endTime}";
    // }

    // if (workingHours.sat != null &&
    //     (workingHours.sat?.isWorking ?? false) &&
    //     workingHours.sat!.startTime != null &&
    //     workingHours.sat!.endTime != null) {
    //   weekDays[6] = "${workingHours.sat!.startTime} - ${workingHours.sat!.endTime}";
    // }

    // if (workingHours.sun != null &&
    //     (workingHours.sun?.isWorking ?? false) &&
    //     workingHours.sun!.startTime != null &&
    //     workingHours.sun!.endTime != null) {
    //   weekDays[7] = "${workingHours.sun!.startTime} - ${workingHours.sun!.endTime}";
    // }
    return weekDays;
  }
}
