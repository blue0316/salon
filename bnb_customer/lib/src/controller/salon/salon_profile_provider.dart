import 'package:bbblient/src/firebase/master.dart';
import 'package:bbblient/src/firebase/salons.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:flutter/material.dart';

// todo make salons and masters profile responsiblity here from salonSearchProvider
class SalonProfileProvider with ChangeNotifier {
  final SalonApi _salonApi = SalonApi();
  Status loadingStatus = Status.loading;

  late SalonModel chosenSalon;

  List<ReviewModel> salonReviews = [];
  List<ReviewModel> masterReviews = [];

  Future<SalonModel?> init(salonId) async {
    try {
      loadingStatus = Status.loading;
      chosenSalon = (await _salonApi.getSalonFromId(salonId))!;
      // await Time().setTimeSlot(chosenSalon.timeSlotsInterval);
      await getSalonReviews(salonId: salonId);
      loadingStatus = Status.success;
    } catch (e) {
      debugPrint(e.toString());
      loadingStatus = Status.failed;
    }
    notifyListeners();
    return chosenSalon;
  }

  Map<String?, List<ServiceModel>> categoryServicesMap = {};

  getSalonReviews({required String salonId}) async {
    salonReviews.clear();
    salonReviews = await SalonApi().getSalonReviews(salonId: salonId);
  }

  getMasterReviews({required String masterId}) async {
    masterReviews.clear();
    masterReviews = await MastersApi().getMasterReviews(masterId: masterId);
    printIt('got ${masterReviews.length} master reviews');
    notifyListeners();
  }

  // Future _initSalon({required SalonModel salonModel}) async {
  //   salonMasters.clear();
  //   categoryServicesMap.clear();
  //   salonServices.clear();
  //   salonReviews.clear();

  //   loadingStatus = Status.loading;
  //   notifyListeners();
  //   List<MasterModel> _masters = await MastersApi().getAllMaster(salonModel.salonId);
  //   List<ServiceModel> _servicesList = await CategoryServicesApi().getSalonServices(salonId: salonModel.salonId);
  //   printIt(_servicesList.length);
  //   List<ServiceModel> _servicesValidList = [];
  //   List<String> _mastersServices = [];

  //   if (_servicesList.isNotEmpty && _masters.isNotEmpty) {
  //     for (MasterModel master in _masters) {
  //       _mastersServices.addAll(master.serviceIds ?? []);
  //     }
  //     printIt(_mastersServices);
  //     printIt(salonModel.ownerType);

  //     if (salonModel.ownerType == OwnerType.singleMaster) {
  //       salonServices = _servicesList;
  //       _servicesValidList = _servicesList;
  //     } else {
  //       for (ServiceModel _service in _servicesList) {
  //         if (_mastersServices.contains(_service.serviceId)) {
  //           printIt('service valid');
  //           printIt(_service.serviceId);
  //           _servicesValidList.add(_service);
  //         } else {
  //           printIt(" removed ${_service.serviceId}");
  //         }
  //       }
  //     }
  //     printIt(_servicesList.length);
  //     printIt(_servicesValidList.length);
  //     printIt(salonServices.length);
  //     salonMasters = _masters;
  //     loadingStatus = Status.success;
  //     notifyListeners();
  //   } else {
  //     loadingStatus = Status.failed;
  //     notifyListeners();
  //   }

  //   for (ServiceModel _service in _servicesValidList) {
  //     if (categoryServicesMap[_service.categoryId] == null) {
  //       categoryServicesMap[_service.categoryId] = [];
  //     }
  //     categoryServicesMap[_service.categoryId]!.add(_service);
  //     if (categoryServicesMap != {}) {
  //       loadingStatus = Status.success;
  //       notifyListeners();
  //     } else {
  //       loadingStatus = Status.failed;
  //       notifyListeners();
  //     }
  //   }
  // }
}
