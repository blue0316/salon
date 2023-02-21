// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:bbblient/src/firebase/category_services.dart';
import 'package:bbblient/src/firebase/customer.dart';
import 'package:bbblient/src/firebase/master.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/themes/glam_one/glam_one.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../firebase/salons.dart';
import '../../models/enums/gender.dart';
import '../../models/enums/service_specialist.dart';
import '../../models/salon_master/salon.dart';

class SalonSearchProvider with ChangeNotifier {
  bool saloonLoading = false;
  bool categoriesLoading = false;
  bool servicesLoading = false;
  bool resultLoading = false;
  Status status = Status.loading;
  String preferredGender = '';
  List<CategoryModel> categories = [];
  List<SubCategoryModel> subCategories = []; // contains all sub categories
  List<SalonModel> salons = []; // contains all the salons // dont clear
  List<SalonModel> nearbySalons = []; // for homescreen
  List<SalonModel> recommendedSalons = []; // todo recommendation logic
  List<SalonModel> salonsSearched = []; // for showing search results
  List<SalonModel> salonsForServicesSearched = []; // for showing search results
  List<SalonModel> filteredSalons = []; // after applying filters look at end functions
  List<SalonModel> filteredSalonsResult = []; // after applying filters look at end functions
  List<SalonModel> salonsUnfiltered = []; // raw salons
  List<MasterModel> masters = [];
  List<MasterModel> filteredmasters = [];
  // List<ServiceModel> services = [];
  List<ServiceModel> servicesSearched = [];
  List<ServiceModel> filteredServices = [];
  LatLng currentLocation = Position().getDefaultLatLng();
  LatLng tempCenter = Position().getDefaultLatLng();
  String currentAddress = '';
  String tempAddress = '';
  bool hasRadiusChanged = false;
  double searchRadius = 25;
  double tempSearchRadius = 25;
  String? selectedCategoryId;
  Status loadingStatus = Status.loading;

  Future<List<CategoryModel>?> init(salonId) async {
    // try {
    categories.clear();
    List<CategoryModel> allCategories = await CategoryServicesApi().getCategories();
    categories = await CategoryServicesApi().getCategories();
    notifyListeners();
    loadingStatus = Status.success;
    // } catch (e) {
    //   print(e);
    //   loadingStatus = Status.failed;
    // }
    notifyListeners();
    return categories;
  }

  changeTempCenter({required LatLng latlng}) async {
    tempCenter = latlng;
    // tempAddress = await LocationUtils.getAddressFromCoordinates(latlng);
    notifyListeners();
  }

  onRadiusChange(double radius) {
    hasRadiusChanged = true;
    tempSearchRadius = radius;
    notifyListeners();
  }

  incrementRadius() {
    if (searchRadius <= 50) {
      status = Status.loading;
      searchRadius = searchRadius + 2;
    } else {
      if (nearbySalons.isEmpty) {
        status = Status.failed;
      }
    }
    loadSalonsSlowly();
    notifyListeners();
  }

  chooseCategory(String id) {
    selectedCategoryId = id;
    filterSalonCategoryWiseAlone();
    notifyListeners();
  }

  //will return true if device gives the location otherwise need to use pre saved location

  Future setLocation({LatLng? backupLocation}) async {
    // LatLng? _currentLocation = await LocationUtils.getLocation();

    final defaultLocation = Position().getDefaultLatLng();

    //makes sure that position is not null
    //uncomment line below to set default location
    // _currentLocation = defaultLocation;
    //_currentLocation ??= backupLocation ?? defaultLocation;

    //setting location
    // currentLocation = _currentLocation;
    // tempCenter = _currentLocation;

    // currentAddress =
    //     await LocationUtils.getAddressFromCoordinates(_currentLocation);

    tempAddress = currentAddress;
    await loadSalons();
    notifyListeners();
  }

  refresh() => notifyListeners();

  initialize() async {
    await setLocation();
    loadAllCategories();
    loadAllSubCategories();
    tempSearchRadius = searchRadius;
    serviceSpecialistTemp = serviceSpecialist;
    selectedGenderTemp = selectedGender;
    tempRatings.clear();
    for (var i in rating) {
      tempRatings.add(i);
    }

    notifyListeners();
  }

  Future loadSalons() async {
    status = Status.loading;
    notifyListeners();
    salons.clear();
    salonsUnfiltered = await SalonApi().getSalons(position: tempCenter, radius: searchRadius);
    printIt('got saloons');
    _refreshList();

    computeDistanceFromCenterAll(salonsUnfiltered);
    for (var salon in salonsUnfiltered) {
      salons.add(salon);
    }
    if (salons.length < 5 && searchRadius < 50) {
      incrementRadius();
      await loadSalons();
    }

    nearbySalons = salons;
    if (nearbySalons.isEmpty) {
      status = Status.failed;
    } else {
      status = Status.success;
    }
    notifyListeners();
  }

  Future loadSalonsSlowly() async {
    nearbySalons = await SalonApi().getSalons(position: tempCenter, radius: searchRadius);

    notifyListeners();
  }

  Future loadSalonsResult({required String text}) async {
    resultLoading = true;
    List<SalonModel>? _salons = await SalonApi().getSalonsForSearch(searchText: text);
    salonsSearched.clear();
    if (_salons != null) {
      if (_salons.isNotEmpty) {
        salonsSearched.addAll(_salons);
        computeDistanceFromCenterAll(salonsSearched);

        resultLoading = false;
        notifyListeners();
      }
      resultLoading = false;
      notifyListeners();
    }
    resultLoading = false;
    notifyListeners();
  }

  Future loadServices({required String text}) async {
    servicesLoading = true;
    salonsForServicesSearched.clear();
    List<ServiceModel> _services = await CategoryServicesApi().getServicesByName(searchText: text);
    if (_services.isNotEmpty) {
      if (_services.isNotEmpty) {
        servicesSearched.addAll(_services);
        List<String?> _salonId = [for (var s in _services) s.salonId];
        List<SalonModel> _salons = await SalonApi().getSalonFromIdListOnce(salonIds: _salonId);
        salonsForServicesSearched.addAll(_salons);
        computeDistanceFromCenterAll(salonsForServicesSearched);

        servicesLoading = false;
        notifyListeners();
      }
      servicesLoading = false;
      notifyListeners();
    }
    servicesLoading = false;
    notifyListeners();
  }

  Future loadMasters({required String text}) async {
    printIt('pre ${masters.length}}');
    masters.clear();
    List<MasterModel>? _masters = await MastersApi().getMasterFromName(text: text);
    if (_masters != null) {
      if (_masters.isNotEmpty) {
        masters.addAll(_masters);
        printIt(_masters.length);
        notifyListeners();
      }
    }
    notifyListeners();
  }

  Future loadAllCategories() async {
    categories.clear();
    List<CategoryModel> allCategories = await CategoryServicesApi().getCategories();
    categories = await CategoryServicesApi().getCategories();
    notifyListeners();

    printIt("categories length = ${categories.length}");
  }

  //load all sub categories
  Future loadAllSubCategories() async {
    subCategories.clear();
    List<SubCategoryModel> allSubCategories = await CategoryServicesApi().getSubCategories();
    subCategories = await CategoryServicesApi().getSubCategories();

    notifyListeners();

    printIt("SUbCategoy length = ${subCategories.length}");
  }

  String getSubCategoryNameFromId(String id) {
    for (SubCategoryModel subCategory in subCategories) {
      if (subCategory.subCategoryId == id) {
        return subCategory.subCategoryName;
      }
    }
    return '';
  }

  //returns the list of CategoryModel from catId list
  List<CategoryModel?> getSelectedCategoryList(List _catIds) {
    if (_catIds.isNotEmpty) {
      return _catIds.map((id) => getCategoryFromId(id)).toList();
    } else {
      return [];
    }
  }

  //returns the cat object on the basis of id
  CategoryModel? getCategoryFromId(String id) {
    for (CategoryModel cat in categories) {
      if (cat.categoryId == id) return cat;
    }
    return null;
  }

  String getCategoryNameFromId(String id) {
    for (CategoryModel cat in categories) {
      if (cat.categoryId == id) return cat.categoryName;
    }
    return '';
  }

  addPosition() async {
    GeoFirePoint myLocation = Geoflutterfire().point(latitude: tempCenter.latitude, longitude: tempCenter.longitude);
    Position myPosition = Position(geoHash: myLocation.hash, geoPoint: GeoPoint(myLocation.latitude, myLocation.longitude));
    await CustomerApi().addCustomerLocation(newPosition: myPosition);
  }

  ///loads up all the salons at the initialization phase

  ///computes the distance of all the salons from the center
  /// assigns distance to [SalonModel.distanceFromCenter]

  void computeDistanceFromCenterAll(List<SalonModel> salons) {
    try {
      final GeoFirePoint _center = Geoflutterfire().point(
        latitude: tempCenter.latitude,
        longitude: tempCenter.longitude,
      );
      for (SalonModel _salon in salons) {
        try {
          final double _distance = _center.distance(lat: _salon.position!.geoPoint!.latitude, lng: _salon.position!.geoPoint!.longitude);

          // print(tempCenter.latitude);
          // print(tempCenter.longitude);

          //round of to 1 digit after decimal
          _salon.distanceFromCenter = double.parse((_distance).toStringAsFixed(1));
          notifyListeners();
        } catch (e) {
          printIt(e);
        }
      }
      notifyListeners();
    } catch (e) {
      printIt(e);
    }
  }

  Future<SalonModel?> getSalonWithDistance({required String salonId}) async {
    try {
      if (salons.indexWhere((element) => element.salonId == salonId) != -1) {
        return salons[salons.indexWhere((element) => element.salonId == salonId)];
      } else {
        final GeoFirePoint _center = Geoflutterfire().point(
          latitude: tempCenter.latitude,
          longitude: tempCenter.longitude,
        );
        SalonModel? _salon = await SalonApi().getSalonFromId(salonId);
        if (_salon != null) {
          final double _distance = _center.distance(lat: _salon.position!.geoPoint!.latitude, lng: _salon.position!.geoPoint!.longitude);
          _salon.distanceFromCenter = double.parse((_distance).toStringAsFixed(1));
          return _salon;
        } else {
          return null;
        }
      }
    } catch (e) {
      printIt(e);
      return null;
    }
  }

  //resets all the filtration variables to their default

  Future resetToDefault() async {
    //setting default values for local variables
    serviceSpecialistTemp = ServiceSpecialist.all;
    serviceSpecialist = ServiceSpecialist.all;
    tempAddress = currentAddress;
    tempCenter = currentLocation;
    notifyListeners();
    searchRadius = 25;
    tempSearchRadius = 25;
    hasRadiusChanged = true;
    selectedGender = PreferredGender.all;
    selectedGenderTemp = selectedGender;
    tempRatings.clear();
    tempRatings.addAll([1, 2, 3, 4, 5]);
    rating.addAll([1, 2, 3, 4, 5]);
    filterSalons();
    notifyListeners();
  }

  // _removeDuplicates() {}

  /// method to apply all the selected filtration
  Future onApplyFilter() async {
    searchRadius = tempSearchRadius;
    await filterSalons();
    notifyListeners();
  }

  //refreshes the list to remove all the filters applied
  _refreshList() {
    filteredSalons.clear();
    salons.clear();
    filteredSalons = salonsUnfiltered;
    notifyListeners();
  }

  //triggers all the applied  filtration algos

  Future filterSalons() async {
    //todo add filter tags list to UI
    //assigning temp variables into permanent variables
    serviceSpecialist = serviceSpecialistTemp;
    selectedGender = selectedGenderTemp;
    rating.clear();
    for (var i in tempRatings) {
      rating.add(i);
    }
    if (hasRadiusChanged) {
      salonsUnfiltered = await SalonApi().getSalons(position: tempCenter, radius: searchRadius);
      printIt("unfiltered salons ${salonsUnfiltered.length}");
    }
    hasRadiusChanged = false;
    filterSalonCategoryWiseAlone();
    _filterServiceSpecialist();
    _genderFilter();
    notifyListeners();
    // _filterSalonRatingWise();
  }

  filterSalonCategoryWiseAlone() {
    printIt('salons Unfiltered length = ${salonsUnfiltered.length}');
    filteredSalons = salonsUnfiltered;
    printIt('salons filtered length = ${filteredSalons.length}');
    if (selectedCategoryId != null) {
      filteredSalons = filteredSalons.where((element) => element.categoryId.contains(selectedCategoryId)).toList();
      printIt('salons filtered length = ${filteredSalons.length}');
      notifyListeners();
    }
  }

  // serviceSpecialist filter
  // can hold 'singleMaster','salon' &'all'

  String serviceSpecialist = ServiceSpecialist.all;

  String serviceSpecialistTemp = ServiceSpecialist.all;

  //filters up the salon on the basis of only [masters],only [salons] or [all]
  onSpecialistChange(String specialist) {
    serviceSpecialistTemp = specialist;
    notifyListeners();
  }

  _filterServiceSpecialist() {
    if (serviceSpecialist != ServiceSpecialist.all) {
      filteredSalons.removeWhere((element) => element.ownerType != serviceSpecialist);
      notifyListeners();
    }
  }

  //rating filter
  //contains the available ratings to filter down salons
  //initially contains all the ratings i.e. [1,2,3,4,5]

  List<int> tempRatings = [1, 2, 3, 4, 5];

  List<int> rating = [1, 2, 3, 4, 5];

  onRatingChange(bool? val, int rating) {
    if (val != null) {
      if (tempRatings.contains(rating) && !val) {
        tempRatings.remove(rating);
        notifyListeners();
      } else {
        tempRatings.add(rating);
        notifyListeners();
      }
    }
  }

  //filters up the salon list acc to the available ratings in [ratings]
  _filterSalonRatingWise() {
    filteredSalons.removeWhere(
      (_salon) {
        int _ratingFloored = _salon.rating.floor();
        //considering all rating below than 1, to be 1
        if (_ratingFloored == 0) _ratingFloored = 1;
        notifyListeners();
        return !rating.contains(_ratingFloored);
      },
    );
  }

  /// gender filter
  String selectedGender = PreferredGender.all;

  String selectedGenderTemp = PreferredGender.all;

  onGenderChange(String value) {
    selectedGenderTemp = value;
    notifyListeners();
  }

  _genderFilter() {
    if (selectedGender != PreferredGender.all) {
      filteredSalons.removeWhere((_salon) {
        return (_salon.preferredGender != selectedGender);
      });
      notifyListeners();
    }
  }

  onSearchChange({String? text}) {
    filteredSalons.clear();
    if (text == '' || text == null) {
      filteredSalons = salonsUnfiltered.toList();
      notifyListeners();
    } else {
      //filteredSalons.where((element) => element.salonName.toLowerCase().contains(text.toLowerCase())).toList();
      notifyListeners();
      for (SalonModel _salon in salonsUnfiltered) {
        if (_salon.salonName.toLowerCase().contains(text.toLowerCase())) {
          filteredSalons.add(_salon);
        }
      }

      notifyListeners();
    }
  }
}
