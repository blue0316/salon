import 'dart:async';

import 'package:bbblient/src/firebase/search.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/translation.dart';
import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  final SearchApi _api = SearchApi();
  Status serviceStatus = Status.loading;
  Status salonStatus = Status.loading;
  String langCode = 'uk';
  final FocusNode focusNode = FocusNode();

  List<ParentServiceModel> parentServices = [];

  bool showServices = true;

  //this map holds all the resultant salons returned from query
  // each salon will act as a kay and have got list of services as value
  Map<SalonModel, List<ServiceModel>> salonServicesMap = {};

  init(lang) {
    langCode = lang;
    showServices = true;
    serviceStatus = Status.loading;
    salonStatus = Status.loading;


    focusNode.addListener(() {
      showServices = focusNode.hasFocus;
      notifyListeners();
    });
    onSearchChange("");
  }

  Timer? _debounce;
  onSearchChange(String text) async {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    if (serviceStatus != Status.loading) {
      serviceStatus = Status.loading;
      notifyListeners();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      parentServices.clear();
      parentServices =
          (await _api.searchRootServices(searchText: text, locale: langCode));
      serviceStatus = Status.success;
      notifyListeners();
    });
  }

  disposeFields() {
    if (_debounce != null) {
      _debounce!.cancel();
    }
    focusNode.dispose();
  }

  onSelectService(
      ParentServiceModel service, TextEditingController controller) async {
    controller.text =
        Translation.translate(map: service.translations, langCode: langCode) ??
            "";
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    } else {
      showServices = focusNode.hasFocus;
    }
    salonStatus = Status.loading;
    notifyListeners();
    final List<SalonModel> salons =
        await _api.getSalonsFromParentServiceId(parentService: service);
    final List<ServiceModel> services =
        await _api.getServicesFromParent(parentService: service);

    salonStatus = Status.success;
    _generateServiceSalonMap(salons, services);

    notifyListeners();
  }

  //generates a map
  _generateServiceSalonMap(
      List<SalonModel> salons, List<ServiceModel> services) {
    salonServicesMap.clear();
    for (SalonModel salon in salons) {
      salonServicesMap[salon] = [];
      for (ServiceModel service in services) {
        if (service.salonId == salon.salonId) {
          salonServicesMap[salon]!.add(service);
        }
      }
    }
  }
}
