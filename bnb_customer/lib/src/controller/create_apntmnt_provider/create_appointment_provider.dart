import 'package:bbblient/src/firebase/appointments.dart';
import 'package:bbblient/src/firebase/bonus_referral_api.dart';
import 'package:bbblient/src/firebase/category_services.dart';
import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/firebase/integration/beauty_pro.dart';
import 'package:bbblient/src/firebase/master.dart';
import 'package:bbblient/src/firebase/promotion_service.dart';
import 'package:bbblient/src/firebase/salons.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/backend_codings/appointment.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/backend_codings/payment_methods.dart';
import 'package:bbblient/src/models/backend_codings/working_hours.dart';
import 'package:bbblient/src/models/bonus_model.dart';
import 'package:bbblient/src/models/cat_sub_service/price_and_duration.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/customer/customer.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/integration/beauty_pro/beauty_pro.dart';
import 'package:bbblient/src/models/promotions/promotion_service.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/integration/beauty_pro.dart';
import 'package:bbblient/src/utils/integration/yclients.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class CreateAppointmentProvider with ChangeNotifier {
  Status loadingStatus = Status.loading;
  SalonModel? chosenSalon;
  MasterModel? chosenMaster;
  List<ServiceModel> salonServices = [];
  List<MasterModel> salonMasters = [];
  List<ReviewModel> salonReviews = [];

  ///all the slots below
  List<String> allSlots = [];
  List<String> breakSlots = [];
  List<String> validSlots = [];
  List<String> chosenSlots = [];
  List<String> morningTimeslots = [];
  List<String> afternoonTimeslots = [];
  List<String> eveningTimeslots = [];

  ///Promotion Variables
  // PromotionModel? chosenPromotion;
  List<ServiceModel> salonPromotionServices = [];
  List<PromotionModel> salonPromotions = [];
  Map<String, List<ServiceModel>> categoryPromotionServicesMap = {};
  PromotionModel? selectedPromotion;
  List<String> allPromotionSlots = [];
  List<String> validPromotionSlots = [];
  List<String> chosenPromotionSlots = [];
  List<String> morningTimePromotionslots = [];
  List<String> afternoonTimePromotionslots = [];
  List<String> eveningTimesPromotionlots = [];

  DateTime chosenDay = DateTime.now();
  int totalTimeSlotsRequired = 0;
  int totalMinutes = 0;
  double totalPrice = 0;
  int totalMinutesWithFixed = 0;
  double totalPricewithFixed = 0;
  int totalTimeWithMaster = 0;
  int totalPriceWithMaster = 0;
  bool bookWithMaster = false;
  List<ServiceModel> chosenServices = [];

  /// contains all the services for each master, with master price and duration
  /// <masterId, List<services>>
  Map<String, List<ServiceModel>> mastersServicesMapAll = {};

  /// <catId, List<services>>
  Map<String, List<ServiceModel>> categoryServicesMap = {};

  Map<String, List<ServiceModel>> mastersServicesMap = {};
  List<MasterModel> availableMasters = [];
  Map<String, PriceAndDurationModel> mastersPriceDurationMap = {};
  Map<String, PriceAndDurationModel> mastersPriceDurationMapMax = {};
  AppointmentModel? appointmentModel;

  bool bookedForSelf = true;
  String bookedForName = '';
  String bookedForPhone = '';
  BonusModel? chosenBonus;
  String? paymentMethod;
  String ownerType = OwnerType.all;

  // crm integration
  bool yclientActive = false;
  bool beautyProActive = false;

  // bool for when promotion
  bool promotionApplied = false;
  BeautyProConfig? beautyProConfig;
  Status slotsStatus = Status.init;

  setSalon(
      {required SalonModel salonModel,
      required BuildContext context,
      required List<ServiceModel> servicesFromSearch}) async {
    chosenSalon = salonModel;
    //set time slot interval

    // Time().timeSlotSize = Duration(minutes: chosenSalon!.timeSlotsInterval!);
    // Time().timeSlotSizeInt = chosenSalon!.timeSlotsInterval!;
    // await Time().setTimeSlot(chosenSalon!.timeSlotsInterval);
    ownerType = chosenSalon?.ownerType ?? OwnerType.all;
    _clearProvider();
    // print(Time().timeSlotSizeInt);
    calculateValidSlots();
    await _initSalon(
        salonModel: salonModel,
        context: context,
        servicesFromSearch: servicesFromSearch);
    _initCrm(salonId: salonModel.salonId);
    clearSlotsAndSlotsRequired();
    setUpSlots(day: chosenDay, context: context, showNotWorkingToast: false);
    notifyListeners();
  }

// Saving these for promotion
  // setSalonForPromotion(
  //     {required SalonModel salonModel,
  //     required BuildContext context,
  //     required PromotionModel promotion}) async {
  //   selectedPromotion = promotion;
  //   _clearPromotionFromProvider();
  //   // await _initSalonForPromotion{
  //   //   salonModel: salonModel,
  //   //   context: context ,
  //   //   promotionModel : promotion
  //   // };
  // }

//Saving these for promotion
  ///Initializing Salon for Booking(loading the promotion services and categorizing them acccording to masters and categories)
//   Future _initSalonForPromotion(
//       {required SalonModel salonModel, required BuildContext context,required PromotionModel promotionModel}) async {
//     if (promotionModel != null) {
//       List<ServiceModel> _servicesValidList = [];
//       List<String> _mastersServices = [];
//       printIt(salonModel.toJson());
//       if (salonModel.ownerType == OwnerType.singleMaster) {
//         if (promotionModel.services!.isNotEmpty) {
//           salonPromotionServices = promotionModel.services!;
//           _servicesValidList = promotionModel.services!;
//         }

//         loadingStatus = Status.success;
//         notifyListeners();
//       } else {
//         List<MasterModel> _masters =
//             await MastersApi().getAllMaster(salonModel.salonId);

//         List<ServiceModel> _servicesList = promotionModel.services!;
//         if (_servicesList.isNotEmpty && _masters.isNotEmpty) {
//           for (MasterModel master in _masters) {
//             _mastersServices.addAll(master.serviceIds ?? []);
//           }
//           for (ServiceModel _service in _servicesList) {
//             // if (_mastersServices.contains(_service.serviceId) && _service.priceAndDuration.price != '0') {
//             if (_mastersServices.contains(_service.serviceId)) {
//               printIt('service valid ${_service.serviceName}');
//               _servicesValidList.add(_service);
//             } else {
//               printIt("no master found for ${_service.serviceName}");
//             }
//           }

//           salonMasters = _masters;
//           // calculateMasterVariationsAll(services: _servicesList);
//           loadingStatus = Status.success;
//           notifyListeners();
//         } else {
//           loadingStatus = Status.failed;
//           notifyListeners();
//         }
//       }

//       // dividing services into categories
//       for (ServiceModel _service in _servicesValidList) {
//         if (_service.isAvailableOnline) {
//           if (categoryPromotionServicesMap[_service.categoryId] == null) {
//             categoryPromotionServicesMap[_service.categoryId] = [];
//           }
//           categoryPromotionServicesMap[_service.categoryId]!.add(_service);
//           if (categoryPromotionServicesMap != {}) {
//             categoryPromotionServicesMap[_service.categoryId]!.sort((a, b) =>
//                 a.bookOrderId != null && b.bookOrderId != null
//                     ? a.bookOrderId!.compareTo(b.bookOrderId!)
//                     : 1);
//             loadingStatus = Status.success;
//             notifyListeners();
//           } else {
//             loadingStatus = Status.failed;
//             notifyListeners();
//           }
//           printIt(categoryPromotionServicesMap);
//         }
//       }
//     }
//   }

  ///Initializing Salon for Booking(loading services and categorizing them acccording to masters and categories)
  Future _initSalon(
      {required SalonModel salonModel,
      required BuildContext context,
      List<ServiceModel> servicesFromSearch = const []}) async {
    List<ServiceModel> _servicesValidList = [];
    List<String> _mastersServices = [];
    printIt(salonModel.toJson());
    if (salonModel.ownerType == OwnerType.singleMaster) {
      List<ServiceModel> _servicesList = await CategoryServicesApi()
          .getSalonServices(salonId: salonModel.salonId);
      salonServices = _servicesList;
      _servicesValidList = _servicesList;
      //Saving these for promotion
      // List<PromotionModel> _promotionList = await PromotionServiceApi()
      //     .getMasterActivePromtions(salonId: salonModel.salonId);
      // printIt("Promotion List");
      // printIt(_promotionList);
      // salonPromotions = _promotionList;
      loadingStatus = Status.success;
      notifyListeners();
    } else {
      List<MasterModel> _masters =
          await MastersApi().getAllMaster(salonModel.salonId);
      List<ServiceModel> _servicesList = await CategoryServicesApi()
          .getSalonServices(salonId: salonModel.salonId);
      if (_servicesList.isNotEmpty && _masters.isNotEmpty) {
        for (MasterModel master in _masters) {
          _mastersServices.addAll(master.serviceIds ?? []);
        }
        for (ServiceModel _service in _servicesList) {
          // if (_mastersServices.contains(_service.serviceId) && _service.priceAndDuration.price != '0') {
          if (_mastersServices.contains(_service.serviceId)) {
            _servicesValidList.add(_service);
          } else {
            printIt("no master found for ${_service.serviceName}");
          }
        }

        salonMasters = _masters;
        calculateMasterVariationsAll(services: _servicesList);
        loadingStatus = Status.success;
        notifyListeners();
      } else {
        loadingStatus = Status.failed;
        notifyListeners();
      }
    }

    // dividing services into categories
    for (ServiceModel _service in _servicesValidList) {
      if (_service.isAvailableOnline) {
        if (categoryServicesMap[_service.categoryId] == null) {
          categoryServicesMap[_service.categoryId] = [];
        }
        categoryServicesMap[_service.categoryId]!.add(_service);
        if (categoryServicesMap != {}) {
          categoryServicesMap[_service.categoryId]!.sort((a, b) =>
              a.bookOrderId != null && b.bookOrderId != null
                  ? a.bookOrderId!.compareTo(b.bookOrderId!)
                  : 1);
          loadingStatus = Status.success;
          notifyListeners();
        } else {
          loadingStatus = Status.failed;
          notifyListeners();
        }
        printIt(categoryServicesMap);
      }
    }

    // adding services from search
    if (servicesFromSearch.isNotEmpty) {
      if (salonModel.ownerType == OwnerType.singleMaster) {
        for (ServiceModel _service in servicesFromSearch) {
          toggleService(
              serviceModel: _service, clearChosenMaster: true, context: null);
        }
      } else {
        for (ServiceModel _service in servicesFromSearch) {
          // if (_mastersServices.contains(_service.serviceId) && _service.priceAndDuration.price != '0') {
          if (_mastersServices.contains(_service.serviceId)) {
            toggleService(
                serviceModel: _service, clearChosenMaster: true, context: null);
          } else {
            // showToast("no master serving ${_service.serviceName}");
          }
        }
      }
    }
  }

  _initCrm({required String salonId}) async {
    // yclientActive = false;
    // beautyProActive = false;
    // printIt("checking with crms");
    // yclientActive = await YClientsEngine().init(salonId);
    // beautyProActive = await BeautyProEngine().init(salonId);
    // printIt("yclient $yclientActive, beautypro $beautyProActive");
    // if (beautyProActive) {
    //   beautyProConfig = await BeautyProApi().getSalonConfig(salonId);
    //   printIt(beautyProConfig?.toJson());
    // } else if (yclientActive) {
    //   // todo fatch commonly used data
    // }

    notifyListeners();
  }

  _clearProvider() {
    salonMasters.clear();
    categoryServicesMap.clear();
    salonServices.clear();
    salonReviews.clear();
    chosenServices.clear();
    totalPrice = 0;
    totalMinutes = 0;
    totalTimeWithMaster = 0;
    totalPriceWithMaster = 0;
    appointmentModel = null;
    chosenMaster = null;

    notifyListeners();
  }

//Saving these for promotions
  // _clearPromotionFromProvider() {
  //   salonPromotionServices.clear();
  //   salonPromotions.clear();
  //   categoryPromotionServicesMap.clear();
  //   allPromotionSlots.clear();
  //   validPromotionSlots.clear();
  //   chosenPromotionSlots.clear();
  //   morningTimePromotionslots.clear();
  //   afternoonTimePromotionslots.clear();
  //   eveningTimesPromotionlots.clear();
  // }

  clearSlotsAndSlotsRequired() {
    validSlots.clear();
    chosenSlots.clear();
    morningTimeslots.clear();
    afternoonTimeslots.clear();
    eveningTimeslots.clear();
    totalTimeSlotsRequired = 0;
    totalMinutes = 0;
    notifyListeners();
  }

  clearSlots() {
    validSlots.clear();
    chosenSlots.clear();
    morningTimeslots.clear();
    afternoonTimeslots.clear();
    eveningTimeslots.clear();
    notifyListeners();
  }

  void chooseBonus({required BonusModel bonusModel}) {
    chosenBonus = bonusModel;
    notifyListeners();
  }

  void choosePromotion({required PromotionModel promotion}) {
    selectedPromotion = promotion;
    notifyListeners();
  }

  void chooseIfPromotionApplied({required bool promotionApplied}) {
    promotionApplied = promotionApplied;
    notifyListeners();
  }

  void removeBonus() {
    chosenBonus = null;
    notifyListeners();
  }

  void selectPaymentMethod(String paymentMethod) {
    this.paymentMethod = paymentMethod;
    notifyListeners();
  }

  clearChoosenSlots() {
    chosenSlots.clear();
    notifyListeners();
  }

  toggleBookedForSelf({required bool forMySelf}) {
    bookedForSelf = forMySelf;
    if (!forMySelf) {
      bookedForName = '';
      bookedForPhone = '';
    }
    notifyListeners();
  }

  setBookedForName({required String name}) {
    bookedForName = name;
    notifyListeners();
  }

  setBookedForNumber({required String phoneNo}) {
    bookedForPhone = phoneNo;
    notifyListeners();
  }

  setBookWithMaster({required bool bookWithMaster}) {
    this.bookWithMaster = bookWithMaster;
    notifyListeners();
  }

  Future<String> chooseMaster(
      {required MasterModel masterModel, required BuildContext context}) async {
    totalTimeWithMaster = 0;
    totalPriceWithMaster = 0;
    calculateMasterVariations();
    if (int.parse(
            mastersPriceDurationMap[masterModel.masterId]?.price ?? '0') >=
        1) {
      chosenMaster = masterModel;
      totalTimeSlotsRequired = (int.parse(
                  mastersPriceDurationMap[masterModel.masterId]?.duration ??
                      '0') /
              (chosenSalon!.timeSlotsInterval != null
                  ? chosenSalon!.timeSlotsInterval!
                  : 15))
          .ceil();
      printIt(mastersPriceDurationMap[masterModel.masterId]?.duration);
      setUpSlots(day: chosenDay, context: context, showNotWorkingToast: true);
      notifyListeners();
      return 'choosen';
    } else {
      printIt(totalPriceWithMaster);
      printIt(totalTimeWithMaster);
      notifyListeners();
      return "Services Not available";
    }
  }

  setMaster({required MasterModel masterModel}) {
    chosenMaster = masterModel;
    chosenServices.clear();
    totalPrice = 0;
    totalMinutes = 0;
    notifyListeners();
  }

  calculateMasterVariations() {
    if (salonMasters.isNotEmpty) {
      for (MasterModel masterModel in salonMasters) {
        int _totalPrice = 0;
        int _totalDuration = 0;
        int _totalPriceMax = 0;
        int _totalDurationMax = 0;
        List<ServiceModel> _services = [];
        for (ServiceModel serviceModel in chosenServices) {
          ServiceModel _service = serviceModel.getCopy();
          if (masterModel.serviceIds?.contains(serviceModel.serviceId) ??
              false) {
            _service.priceAndDuration.duration = masterModel
                    .servicesPriceAndDuration?[serviceModel.serviceId]
                    ?.duration ??
                '0';
            _service.priceAndDuration.price = masterModel
                    .servicesPriceAndDuration?[serviceModel.serviceId]?.price ??
                "0";
            _totalDuration = _totalDuration +
                (int.tryParse(masterModel
                            .servicesPriceAndDuration?[serviceModel.serviceId]
                            ?.duration ??
                        '0') ??
                    0);

            _totalPrice = _totalPrice +
                (int.tryParse(masterModel
                            .servicesPriceAndDuration?[serviceModel.serviceId]
                            ?.price ??
                        "0") ??
                    0);

            _service.priceAndDurationMax!.duration = masterModel
                    .servicesPriceAndDurationMax?[serviceModel.serviceId]
                    ?.duration ??
                '0';
            _service.priceAndDurationMax!.price = masterModel
                    .servicesPriceAndDurationMax?[serviceModel.serviceId]
                    ?.price ??
                "0";
            _totalDurationMax = _totalDurationMax +
                (!serviceModel.isFixedPrice
                    ? int.parse(serviceModel.priceAndDurationMax!.duration)
                    : (int.tryParse(masterModel
                                .servicesPriceAndDuration?[
                                    serviceModel.serviceId]
                                ?.duration ??
                            '0') ??
                        0));

            _totalPriceMax = _totalPriceMax +
                (!serviceModel.isFixedPrice
                    ? int.parse(serviceModel.priceAndDurationMax!.price)
                    : (int.tryParse(masterModel
                                .servicesPriceAndDuration?[
                                    serviceModel.serviceId]
                                ?.price ??
                            "0") ??
                        0));
            _services.add(_service);
          }
        }
        mastersPriceDurationMap[masterModel.masterId] = PriceAndDurationModel(
          duration: _totalDuration.toString(),
          price: _totalPrice.toString(),
        );
        printIt(_totalDuration.toString());
        printIt(_totalDurationMax.toString());
        mastersPriceDurationMapMax[masterModel.masterId] =
            PriceAndDurationModel(
          duration: _totalDurationMax.toString(),
          price: _totalPriceMax.toString(),
        );
        mastersServicesMap[masterModel.masterId] = _services.toList();
      }
    }
  }

  calculateMasterVariationsAll({required List<ServiceModel> services}) {
    if (salonMasters.isNotEmpty) {
      for (MasterModel masterModel in salonMasters) {
        List<ServiceModel> _services = [];

        for (ServiceModel salonService in services) {
          ServiceModel _service = salonService.getCopy();

          if (masterModel.serviceIds?.contains(_service.serviceId) ?? false) {
            _service.priceAndDuration.duration = masterModel
                    .servicesPriceAndDuration?[_service.serviceId]?.duration ??
                '0';
            _service.priceAndDuration.price = masterModel
                    .servicesPriceAndDuration?[_service.serviceId]?.price ??
                '0';
            _services.add(_service);
          }
        }

        mastersServicesMapAll[masterModel.masterId] = _services.toList();

        notifyListeners();
      }
    }
  }

  toggleService(
      {required ServiceModel serviceModel,
      required bool clearChosenMaster,
      required BuildContext? context}) async {
    int index = chosenServices
        .indexWhere((element) => element.serviceId == serviceModel.serviceId);
    if (index == -1) {
      chosenServices.add(serviceModel);

      totalPrice = totalPrice +
          (!serviceModel.isFixedPrice
              ? (double.tryParse(serviceModel.priceAndDurationMax!.price) ?? 0)
              : (double.tryParse(serviceModel.priceAndDuration.price) ?? 0));
      totalPricewithFixed = totalPricewithFixed +
          (double.tryParse(serviceModel.priceAndDuration.price) ?? 0);
      calculateValidSlots();
      calculateMasterVariations();
      if (context != null) {
        setUpSlots(
            day: chosenDay, context: context, showNotWorkingToast: false);
      }

      Utils().vibratePositively();
      notifyListeners();
    } else {
      chosenServices.removeAt(index);
      totalPrice = totalPrice -
          (!serviceModel.isFixedPrice
              ? (double.tryParse(serviceModel.priceAndDurationMax!.price) ?? 0)
              : (double.tryParse(serviceModel.priceAndDuration.price) ?? 0));
      totalPricewithFixed = totalPricewithFixed -
          (double.tryParse(serviceModel.priceAndDuration.price) ?? 0);
      calculateValidSlots();
      calculateMasterVariations();
      if (context != null) {
        setUpSlots(
            day: chosenDay, context: context, showNotWorkingToast: false);
      }
      Utils().vibrateNegatively();
      notifyListeners();
    }
    if (clearChosenMaster) {
      chosenMaster = null;
      notifyListeners();
    }
  }

  bool isAdded({required ServiceModel serviceModel}) {
    int index = chosenServices
        .indexWhere((element) => element.serviceId == serviceModel.serviceId);
    if (index == -1) {
      return false;
    } else {
      return true;
    }
  }

  calculateAvailableMasters({required DateTime day}) {
    if (salonMasters.isNotEmpty) {
      availableMasters.clear();

      notifyListeners();

      for (MasterModel master in salonMasters) {
        if (master.workingHours != null) {
          print('mmmm${master.workingHours} ${day.weekday}');
          bool isMasterWorking = (Time()
                      .getWorkingHoursFromWeekDay(
                          day.weekday, master.workingHours)
                      ?.isWorking ==
                  true ||
              (master.irregularWorkingHours != null
                  ? master.irregularWorkingHours!.containsKey(
                      DateFormat('yyyy-MM-dd').format(day).toString())
                  : false));
          print("this is date");

          bool servicesAvailable = mastersServicesMap[master.masterId] != null;
          bool servicesAvailableCount =
              mastersServicesMap[master.masterId]?.isNotEmpty ?? false;
          if (isMasterWorking && servicesAvailable && servicesAvailableCount) {
            availableMasters.add(master);
          }
        }
      }
      printIt("available masters ${availableMasters.length}");
      notifyListeners();
    }
  }

  Future setUpPromotionSlots(
      {required DateTime day,
      required BuildContext context,
      required bool showNotWorkingToast}) async {}

  Future setUpSlots(
      {required DateTime day,
      required BuildContext context,
      required bool showNotWorkingToast}) async {
    // await Time().setTimeSlot(chosenSalon!.timeSlotsInterval);
    chosenDay = day;
    chosenSlots.clear();
    for (int i = 1; i <= chosenServices.length; i++) {
      chosenSlots.add('');
    }
    calculateAvailableMasters(day: day);

    // clearChoosenSlots();
    clearSlots();
    slotsStatus = Status.loading;
    notifyListeners();
    if (beautyProActive && chosenMaster != null) {
      print("na here 1");
      printIt('fatching slots from beauty pro');
      Map<String, List<String>>? slots =
          await BeautyProEngine().getMasterSlots(day);
      printIt("beauty pro result $slots");
      printIt(chosenMaster?.beautyProId);
      List<String>? _masterslots = slots?[chosenMaster?.beautyProId];
      printIt(_masterslots);
      if (_masterslots != null) {
        if (_masterslots.isEmpty) {
          if (showNotWorkingToast) {
            showToast(AppLocalizations.of(context)?.masterNotWorking ??
                "master's not Working");
          }
          slotsStatus = Status.failed;
          notifyListeners();
          return;
        } else {
          allSlots.clear();
          validSlots = _masterslots;
          TimeOfDay _startTime = Time().stringToTime(validSlots.first);
          TimeOfDay _endTime = Time().stringToTime(validSlots.last);
          if (chosenDay.day == DateTime.now().day &&
              chosenDay.month == DateTime.now().month) {
            List<String> _pastSlots =
                Time().generateTimeSlots(_startTime, TimeOfDay.now()).toList();
            for (String slot in _pastSlots) {
              validSlots.remove(slot);
            }
          }
          allSlots = Time()
              .getTimeSlots(_startTime, _endTime,
                  step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15))
              .toList();
          slotsStatus = Status.success;
          divideSlotsForDay();
          notifyListeners();
        }
      } else {
        slotsStatus = Status.failed;
        notifyListeners();
        return;
      }
    } else if (yclientActive && chosenMaster != null) {
      print("na here 2");
      List<String>? slots =
          await YClientsEngine().getMasterSlots(day, master: chosenMaster!);
      printIt("yclient result $slots");
      List<String>? _masterslots = slots;
      printIt(_masterslots);
      if (_masterslots != null) {
        if (_masterslots.isEmpty) {
          if (showNotWorkingToast) {
            showToast(AppLocalizations.of(context)?.masterNotWorking ??
                "master's not Working");
          }
          slotsStatus = Status.failed;
          notifyListeners();
          return;
        } else {
          validSlots.clear();
          allSlots.clear();
          validSlots = _masterslots;
          TimeOfDay _startTime = Time().stringToTime(validSlots.first);
          TimeOfDay _endTime = Time().stringToTime(validSlots.last);
          if (chosenDay.day == DateTime.now().day &&
              chosenDay.month == DateTime.now().month) {
            List<String> _pastSlots = Time()
                .generateTimeSlots(_startTime, TimeOfDay.now(),
                    step:
                        Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15))
                .toList();
            for (String slot in _pastSlots) {
              validSlots.remove(slot);
            }
          }
          allSlots = Time()
              .getTimeSlots(_startTime, _endTime,
                  step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15))
              .toList();
          slotsStatus = Status.success;
          divideSlotsForDay();
          notifyListeners();
        }
        slotsStatus = Status.success;
        notifyListeners();
      } else {
        slotsStatus = Status.failed;
        notifyListeners();
        return;
      }
    } else if (!beautyProActive && !yclientActive) {
      // print(chosenSalon!.workingHours!.wed.startTime);
      if (chosenSalon?.ownerType == OwnerType.singleMaster) {
        Hours? workingHours;
        // workingHours = Time().getWorkingHoursFromWeekDay(
        //     chosenDay.weekday, chosenSalon!.workingHours);

        if (chosenSalon!.irregularWorkingHours != null &&
            chosenSalon!.irregularWorkingHours!.containsKey(
                DateFormat('yyyy-MM-dd').format(chosenDay).toString())) {
          workingHours = chosenSalon!.irregularWorkingHours![
              DateFormat('yyyy-MM-dd').format(chosenDay).toString()];
        } else {
          workingHours = Time().getWorkingHoursFromWeekDay(
              chosenDay.weekday, chosenSalon!.workingHours);
        }
        List<String> _blokedSlots = [];
        String? dateString = Time().getDateInStandardFormat(chosenDay);
        List<dynamic> slotsBlocked = chosenSalon?.blockedTime[dateString] ?? [];
        for (dynamic slot in slotsBlocked) {
          _blokedSlots.add(slot.toString());
        }

        if (workingHours != null) {
          TimeOfDay _startTime = Time().stringToTime(workingHours.startTime);
          TimeOfDay _endTime = Time().stringToTime(workingHours.endTime);
          TimeOfDay _breakStartTime =
              Time().stringToTime(workingHours.breakStartTime);
          TimeOfDay _breakEndTime =
              Time().stringToTime(workingHours.breakEndTime);
          allSlots = Time()
              .getTimeSlots(_startTime, _endTime,
                  step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15))
              .toList();
          if (workingHours.isWorking) {
            if (chosenDay.day == DateTime.now().day &&
                chosenDay.month == DateTime.now().month) {
              // if (chosenSalon!.appointmentsLeadTime != null) {
              //   //computing start and end time acc to different parameters
              //   // copied this function from salon app
              //   TimeOfDay? _mystartTime =
              //       _computeStartTime(workingHours.startTime, chosenDay);
              //   var myminutes = Time().toMinutes(_mystartTime!);
              //   // round up to nearest value of slot
              //   myminutes = myminutes! +
              //       ((chosenSalon!.timeSlotsInterval ?? 15) -
              //           (myminutes % (chosenSalon!.timeSlotsInterval ?? 15)));
              //   _mystartTime =
              //       TimeOfDay(hour: myminutes ~/ 60, minute: myminutes % 60);
              //   print(_mystartTime);
              //   validSlots = Time()
              //       .getTimeSlots(_mystartTime, _endTime,
              //           step: Duration(
              //               minutes: chosenSalon!.timeSlotsInterval ?? 15))
              //       .toList();
              // } else {
              TimeOfDay? _mystartTime =
                  _computeStartTime(workingHours.startTime, chosenDay);
              printIt(_mystartTime);
              validSlots = Time()
                  .getTimeSlots(_mystartTime, _endTime,
                      step: Duration(
                          minutes: chosenSalon!.timeSlotsInterval ?? 15))
                  .toList();
              // }
            } else {
              validSlots = Time()
                  .getTimeSlots(_startTime, _endTime,
                      step: Duration(
                          minutes: chosenSalon!.timeSlotsInterval ?? 15))
                  .toList();
            }
            bool isBreakAvailable = Time()
                    .getWorkingHoursFromWeekDay(
                        chosenDay.weekday,
                        (chosenSalon?.ownerType == OwnerType.salon)
                            ? chosenMaster?.workingHours
                            : chosenSalon!.workingHours)
                    ?.isBreakAvailable ??
                false;
            if (isBreakAvailable) {
              printIt('master is taking break on choosen day');
              breakSlots = Time()
                      .getTimeSlots(_breakStartTime, _breakEndTime,
                          step: Duration(
                              minutes: chosenSalon!.timeSlotsInterval ?? 15))
                      .toList() +
                  _blokedSlots;
            } else {
              printIt('master is not taking break on choosen day');
              breakSlots = _blokedSlots;
            }
            for (String slot in breakSlots) {
              validSlots.removeWhere((element) => element == slot);
            }
            printIt('lets see all slots');
            printIt(allSlots.toString());

            slotsStatus = Status.success;
            notifyListeners();
          } else {
            validSlots.clear();
            if (showNotWorkingToast) {
              showToast(AppLocalizations.of(context)?.masterNotWorking ??
                  "master's not Working");
            }
            slotsStatus = Status.failed;
            notifyListeners();
          }
          divideSlotsForDay();
          printIt("valid Slots $validSlots");
        } else {
          debugPrint(allSlots.toString());
          slotsStatus = Status.failed;
          notifyListeners();
        }
      } else {
        Hours? workingHours;

        if (chosenSalon!.irregularWorkingHours != null) {
          if (chosenSalon!.irregularWorkingHours!.containsKey(
              DateFormat('yyyy-MM-dd').format(chosenDay).toString())) {
            workingHours = chosenSalon!.irregularWorkingHours![
                DateFormat('yyyy-MM-dd').format(chosenDay).toString()];
          }
        } else {
          workingHours = Time().getWorkingHoursFromWeekDay(
            chosenDay.weekday,
            (chosenMaster == null)
                ? chosenSalon!.workingHours
                : chosenMaster!.workingHours,
          );
        }

        List<String> masterBlocked = [];
        String? dateString = Time().getDateInStandardFormat(chosenDay);
        List<dynamic> slotsBlocked =
            chosenMaster?.blockedTime?[dateString] ?? [];
        for (dynamic slot in slotsBlocked) {
          masterBlocked.add(slot.toString());
        }
        if (workingHours != null) {
          TimeOfDay _startTime = Time().stringToTime(workingHours.startTime);
          TimeOfDay _endTime = Time().stringToTime(workingHours.endTime);
          TimeOfDay _breakStartTime =
              Time().stringToTime(workingHours.breakStartTime);
          TimeOfDay _breakEndTime =
              Time().stringToTime(workingHours.breakEndTime);
          allSlots = Time()
              .getTimeSlots(_startTime, _endTime,
                  step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15))
              .toList();

          if (workingHours.isWorking) {
            if (chosenDay.day == DateTime.now().day &&
                chosenDay.month == DateTime.now().month) {
              TimeOfDay? _mystartTime =
                  _computeStartTime(workingHours.startTime, chosenDay);
              printIt(_startTime);
              validSlots = Time()
                  .getTimeSlots(_mystartTime, _endTime,
                      step: Duration(
                          minutes: chosenSalon!.timeSlotsInterval ?? 15))
                  .toList();
            } else {
              validSlots = Time()
                  .getTimeSlots(_startTime, _endTime,
                      step: Duration(
                          minutes: chosenSalon!.timeSlotsInterval ?? 15))
                  .toList();
            }
            bool isBreakAvailable = Time()
                    .getWorkingHoursFromWeekDay(
                        chosenDay.weekday,
                        (chosenSalon?.ownerType == OwnerType.salon)
                            ? chosenMaster?.workingHours
                            : chosenSalon!.workingHours)
                    ?.isBreakAvailable ??
                false;
            if (isBreakAvailable) {
              printIt('master is taking break on choosen day');
              breakSlots = Time()
                      .getTimeSlots(_breakStartTime, _breakEndTime,
                          step: Duration(
                              minutes: chosenSalon!.timeSlotsInterval ?? 15))
                      .toList() +
                  masterBlocked;
            } else {
              printIt('master is not taking break on choosen day');
              breakSlots = masterBlocked;
            }
            for (String slot in breakSlots) {
              validSlots.removeWhere((element) => element == slot);
            }
            slotsStatus = Status.success;
            notifyListeners();
          } else {
            validSlots.clear();
            if (chosenMaster != null && showNotWorkingToast) {
              showToast(AppLocalizations.of(context)?.masterNotWorking ??
                  "master's not Working");
            }
            slotsStatus = Status.failed;
            notifyListeners();
            notifyListeners();
          }
          printIt("valid Slots $validSlots");
          printIt("valid Slots $allSlots");
          divideSlotsForDay();
        } else {
          slotsStatus = Status.failed;
          notifyListeners();
          debugPrint(allSlots.toString());
        }
      }
    } else {
      slotsStatus = Status.failed;
      notifyListeners();
    }
  }

  ///Divides Slots into Morning Afternoon and Night
  divideSlotsForDay() {
    int morningIndex = allSlots
        .indexWhere((element) => Time().stringToTime(element).hour >= 12);
    int afterNoonIndex = allSlots
        .indexWhere((element) => Time().stringToTime(element).hour >= 17);

    if (afterNoonIndex != -1) {
      eveningTimeslots = allSlots.sublist(afterNoonIndex, allSlots.length);
      notifyListeners();
    }
    if (morningIndex != -1) {
      morningTimeslots = allSlots.sublist(0, morningIndex);
      if (afterNoonIndex != -1) {
        afternoonTimeslots = allSlots.sublist(morningIndex, afterNoonIndex);
      } else {
        afternoonTimeslots = allSlots.sublist(morningIndex, allSlots.length);
      }
      notifyListeners();
      return;
    }
  }

  Time _time = new Time();

  TimeOfDay? _computeStartTime(String? masterStartTime, DateTime date) {
    try {
      DateTime _now = DateTime.now();

      late TimeOfDay _masterAndSalonFusedTime;
      // added this on the fly..but it seems to solve the problem
      _masterAndSalonFusedTime = _time.stringToTime(masterStartTime!);
      if (chosenSalon!.ownerType == OwnerType.singleMaster) {
        _masterAndSalonFusedTime = _time.stringToTime(masterStartTime!);
      } else {
        //getting salon timings
        Hours selectedSalonHours = _time.getRegularWorkingHoursFromDate(
          chosenSalon?.workingHours ?? null,
          weekDay: date.weekday,
        )!;

        if (!selectedSalonHours.isWorking!) return null;

        TimeOfDay _salonStartTime =
            _time.stringToTime(selectedSalonHours.startTime!);

        TimeOfDay _masterStartTime = _time.stringToTime(masterStartTime!);

        // computes the starting time by comparing master and salon starting time
        TimeOfDay _masterAndSalonFusedTime = _time.getMinMaxTime(
            _salonStartTime, _masterStartTime,
            returnMaxTime: true);
      }

      if (_time.compareDate(date, _now)) {
        //dates are same, Then it
        // computes the start time by comparing current time and master working time

        // for the effect of restricted time before appointment
        if (chosenSalon!.appointmentsLeadTime != null) {
          _now =
              _now.add(Duration(minutes: chosenSalon!.appointmentsLeadTime!));
        }
        TimeOfDay _currentTime =
            TimeOfDay(hour: _now.hour, minute: _now.minute);
        print(TimeOfDay(hour: _now.hour, minute: _now.minute));
        print(_masterAndSalonFusedTime);
        return _time.getMinMaxTime(_currentTime, _masterAndSalonFusedTime,
            returnMaxTime: true);
      } else {
        return _masterAndSalonFusedTime;
      }
    } catch (e) {
      print('error while generating start time');
      print(e);
      return _time.stringToTime(masterStartTime!);
    }
  }

  calculateValidSlots() {
    clearChoosenSlots();
    totalMinutes = 0;
    totalMinutesWithFixed = 0;
    for (ServiceModel serviceModel in chosenServices) {
      printIt(serviceModel.toJson());
      totalMinutes = totalMinutes +
          (!serviceModel.isFixedPrice
              ? int.parse(serviceModel.priceAndDurationMax!.duration)
              : int.parse(serviceModel.priceAndDuration.duration));
      totalMinutesWithFixed = totalMinutesWithFixed +
          int.parse(serviceModel.priceAndDuration.duration);
      printIt(totalMinutes);
      notifyListeners();
    }
    totalTimeSlotsRequired = (totalMinutes /
            (chosenSalon!.timeSlotsInterval != null
                ? chosenSalon!.timeSlotsInterval!
                : 15))
        .ceil();
    if (totalMinutes <=
        (chosenSalon!.timeSlotsInterval != null
            ? chosenSalon!.timeSlotsInterval!
            : 15)) {
      totalMinutes = chosenSalon!.timeSlotsInterval ?? 15;
      totalTimeSlotsRequired = 1;
    }
    notifyListeners();
    printIt(
        'total time and slots required $totalMinutes $totalTimeSlotsRequired');
  }

  bool checkContinuousSlots({required List<String> slots}) {
    List<int> indexes = [];
    for (int i = 0; i <= slots.length - 1; i++) {
      indexes.add(allSlots.indexWhere((element) => element == slots[i]));
    }
    for (int i = 0; i < indexes.length - 1; i++) {
      if (indexes[i + 1] - indexes[i] != 1) {
        return false;
      }
    }
    printIt(indexes);
    return true;
  }

  Future chooseSlot(String slot, BuildContext context) async {
    printIt("choosing slots $totalTimeSlotsRequired");
    if (totalTimeSlotsRequired != 0) {
      if (totalTimeSlotsRequired > validSlots.length) {
        showToast(
            AppLocalizations.of(context)?.notEnoughSlots ?? "Not enough slots");
      } else {
        int index = validSlots.indexWhere((element) => element == slot);
        if (index != -1) {
          if (index == 0) {
            chosenSlots =
                validSlots.getRange(index, totalTimeSlotsRequired).toList();
            notifyListeners();
            printIt(chosenSlots);
          } else if (index > validSlots.length - totalTimeSlotsRequired) {
            chosenSlots = validSlots
                .getRange(validSlots.length - (totalTimeSlotsRequired),
                    validSlots.length)
                .toList();
            notifyListeners();
            printIt(chosenSlots);
          } else {
            chosenSlots = validSlots
                .getRange(index, (index + totalTimeSlotsRequired))
                .toList();
            printIt(chosenSlots);

            notifyListeners();
          }
          bool continues = checkContinuousSlots(slots: chosenSlots);
          if (!continues) {
            chosenSlots = [];
            notifyListeners();
            showToast(AppLocalizations.of(context)?.slotsNotAvailable ??
                'Slots not available');
          } else {
            printIt(chosenDay);
            notifyListeners();
            showToast(
                AppLocalizations.of(context)?.slotsChoosen ?? 'slots chosen');
          }
        } else {
          chosenSlots = [];
          notifyListeners();
          showToast(AppLocalizations.of(context)?.slotsNotAvailable ??
              'Slots not available');
        }
      }
    } else {
      showToast(AppLocalizations.of(context)?.noServices ?? 'no services');
    }
  }

  bool checkSlotsAndMaster({required BuildContext context}) {
    final bool isMasterNull =
        (chosenMaster == null && chosenSalon!.ownerType == OwnerType.salon);
    if (isMasterNull) {
      printIt(chosenMaster);
      showToast(AppLocalizations.of(context)?.chooseMaster ?? 'choose master');
    }
    if (chosenSlots.contains('') || chosenSlots.isEmpty) {
      printIt(chosenSlots);
      showToast(AppLocalizations.of(context)?.chooseSlots ?? "choose slots");
    }
    if (chosenServices.isEmpty) {
      showToast('no services');
    }

    bool isWorking = Time()
                .getWorkingHoursFromWeekDay(
                    chosenDay.weekday,
                    (chosenSalon?.ownerType == OwnerType.salon)
                        ? chosenMaster?.workingHours
                        : chosenSalon!.workingHours)
                ?.isWorking ==
            true ||
        chosenSalon!.irregularWorkingHours!
            .containsKey(DateFormat('yyyy-MM-dd').format(chosenDay).toString());
    printIt("working today $isWorking");
    if (!isWorking) {
      showToast(AppLocalizations.of(context)?.masterNotAvlblDay ??
          'master not available on choosen day');
    }
    if (isMasterNull ||
        chosenSlots.contains('') ||
        chosenSlots.isEmpty ||
        chosenServices.isEmpty ||
        !isWorking) {
      return false;
    } else {
      return true;
    }
  }

  ///creates appointment in integration, both in yClient and beautyPro
  /// Takes in [AppointmentModel] as input and returns app [AppointmentModel] with either beautyPro or yClientsId
  /// will return [AppointmentModel] back as it is without any change if integration is inactive
  /// will return [null] in case of error, so u need to abort current appointment and show user error
  Future<AppointmentModel?> createAppointmentInIntegration(
      AppointmentModel app, MasterModel master) async {
    AppointmentModel _app;
    //booking in beauty pro
    //  picking the booking from suitable integration
    //  if beauty-pro id is present means system has integration with beauty pro, same with yclients
    //  so will pickup that integration
    if (beautyProActive) {
      final AppointmentModel? _appointmentWithBeautyPro =
          await BeautyProEngine().makeAppointment(app, master.beautyProId);

      if (_appointmentWithBeautyPro == null) {
        showToast("Booking failed..");
        return null;
      } else {
        _app = _appointmentWithBeautyPro;
        return _app;
      }
    } else if (yclientActive) {
      //booking in yClients
      final AppointmentModel? _appointmentWithYClients =
          await YClientsEngine().makeAppointment(app, master.yClientsId);
      if (_appointmentWithYClients == null) {
        showToast("Booking failed.");
        return null;
      } else {
        _app = _appointmentWithYClients;
        return _app;
      }
    } else {
      return app;
    }
  }

  Future<bool> createAppointment(
      {required CustomerModel? customerModel,
      required BuildContext context}) async {
    print('${customerModel!.customerId}');
    if (chosenServices.isEmpty) {
      showToast(' no services');
    } else {
      printIt(chosenSlots);

      //  total price and duration
      PriceAndDurationModel _totalPriceAndDuration =
          chosenSalon!.ownerType == OwnerType.singleMaster
              ? PriceAndDurationModel(
                  duration: totalMinutes.toString(),
                  price: totalPrice.toString(),
                )
              : mastersPriceDurationMapMax[chosenMaster!.masterId]!;

      var locale =
          AppLocalizations.of(context)?.localeName.toString().toLowerCase();

      printIt("Chosen Slots");
      printIt(chosenSlots);
      DateTime _startTime = DateTime(
          chosenDay.year,
          chosenDay.month,
          chosenDay.day,
          int.parse(chosenSlots.first.split(':')[0]),
          int.parse(chosenSlots.first.split(':')[1]));

      DateTime _endTime = _startTime
          .add(Duration(minutes: int.parse(_totalPriceAndDuration.duration)));

      final List<Service> _services =
          chosenSalon!.ownerType == OwnerType.singleMaster
              ? chosenServices
                  .map((element) => Service.fromService(serviceModel: element))
                  .toList()
              : mastersServicesMap[chosenMaster!.masterId]!
                  .map((element) => Service.fromService(
                      serviceModel: element,
                      masterPriceAndDuration:chosenMaster!
                          .servicesPriceAndDurationMax!=null?chosenMaster!
                          .servicesPriceAndDurationMax![element.serviceId]: chosenMaster!
                          .servicesPriceAndDuration![element.serviceId]))
                  .toList();

      appointmentModel = AppointmentModel(
        appointmentStartTime: _startTime,
        appointmentEndTime: _endTime,
        createdAt: DateTime.now(),
        appointmentTime: chosenSlots.first,
        appointmentDate: Time().getDateInStandardFormat(chosenDay) ?? '',
        appointmentId: '',
        locale: locale,
        // firstName: ,
        createdBy: CreatedBy.customer,
        bookedForSelf: bookedForSelf,
        updates: [AppointmentUpdates.createdByCustomer],
        status: chosenSalon!.requestSalon
            ? AppointmentStatus.requested
            : AppointmentStatus.active,
        services: _services,
        customer: Customer(
          id: customerModel!.customerId,
          name: Utils().getName(customerModel.personalInfo),
          phoneNumber: customerModel.personalInfo.phone,
          pic: customerModel.profilePic,
        ),
        priceAndDuration: _totalPriceAndDuration,
        paymentInfo: null,
        master: chosenSalon!.ownerType == OwnerType.singleMaster
            ? Master(
                id: chosenSalon!.salonId,
                name: chosenSalon!.salonName,
              )
            : Master(
                id: chosenMaster!.masterId,
                name: Utils().getNameMaster(chosenMaster!.personalInfo),
              ),
        salon: Salon(
          id: chosenSalon!.salonId,
          name: chosenSalon!.salonName,
          address: chosenSalon!.address,
          // location: chosenSalon!.position!,
          phoneNo: chosenSalon!.phoneNumber,
        ),
        bookedForName: bookedForSelf ? bookedForName : '',
        bookedForPhoneNo: bookedForSelf ? bookedForPhone : '',
        chatId: '',
        note: '',
        salonOwnerType: chosenSalon!.ownerType,
        type: AppointmentType.reservation,
        masterReviewed: false,
        salonReviewed: false,
        updatedAt: [DateTime.now()],
      );
      printIt(appointmentModel!.toJson());
      return true;
    }
    return false;
  }

  Future<bool> createAppointment2(
      {
      //  required CustomerModel? customerModel,
      required BuildContext context}) async {
    if (chosenServices.isEmpty) {
      showToast(' no services');
    } else {
      printIt(chosenSlots);

      //  total price and duration
      PriceAndDurationModel _totalPriceAndDuration =
          chosenSalon!.ownerType == OwnerType.singleMaster
              ? PriceAndDurationModel(
                  duration: totalMinutes.toString(),
                  price: totalPrice.toString(),
                )
              : mastersPriceDurationMapMax[chosenMaster!.masterId]!;

      var locale =
          AppLocalizations.of(context)?.localeName.toString().toLowerCase();

      printIt("Chosen Slots");
      printIt(chosenSlots);
      DateTime _startTime = DateTime(
          chosenDay.year,
          chosenDay.month,
          chosenDay.day,
          int.parse(chosenSlots.first.split(':')[0]),
          int.parse(chosenSlots.first.split(':')[1]));

      DateTime _endTime = _startTime
          .add(Duration(minutes: int.parse(_totalPriceAndDuration.duration)));

      final List<Service> _services =
          chosenSalon!.ownerType == OwnerType.singleMaster
              ? chosenServices
                  .map((element) => Service.fromService(serviceModel: element))
                  .toList()
              : mastersServicesMap[chosenMaster!.masterId]!
                  .map((element) => Service.fromService(
                      serviceModel: element,
                      masterPriceAndDuration: chosenMaster!
                          .servicesPriceAndDuration![element.serviceId]))
                  .toList();

      appointmentModel = AppointmentModel(
        appointmentStartTime: _startTime,
        appointmentEndTime: _endTime,
        createdAt: DateTime.now(),
        appointmentTime: chosenSlots.first,
        appointmentDate: Time().getDateInStandardFormat(chosenDay) ?? '',
        appointmentId: '',
        locale: locale,
        // firstName: ,
        createdBy: CreatedBy.customer,
        bookedForSelf: bookedForSelf,
        updates: [AppointmentUpdates.createdByCustomer],
        status: chosenSalon!.requestSalon
            ? AppointmentStatus.requested
            : AppointmentStatus.active,
        services: _services,
        customer: Customer(
          id: "customerModel!.customerId",
          name: "Utils().getName(customerModel.personalInfo)",
          phoneNumber:" customerModel.personalInfo.phone",
          pic:" customerModel.profilePic",
        ),
        priceAndDuration: _totalPriceAndDuration,
        paymentInfo: null,
        master: chosenSalon!.ownerType == OwnerType.singleMaster
            ? Master(
                id: chosenSalon!.salonId,
                name: chosenSalon!.salonName,
              )
            : Master(
                id: chosenMaster!.masterId,
                name: Utils().getNameMaster(chosenMaster!.personalInfo),
              ),
        salon: Salon(
          id: chosenSalon!.salonId,
          name: chosenSalon!.salonName,
          address: chosenSalon!.address,
          // location: chosenSalon!.position!??null,
          phoneNo: chosenSalon!.phoneNumber,
        ),
        bookedForName: bookedForSelf ? bookedForName : '',
        bookedForPhoneNo: bookedForSelf ? bookedForPhone : '',
        chatId: '',
        note: '',
        salonOwnerType: chosenSalon!.ownerType,
        type: AppointmentType.reservation,
        masterReviewed: false,
        salonReviewed: false,
        updatedAt: [DateTime.now()],
      );
      printIt(appointmentModel!.toJson());
      return true;
    }
    return false;
  }

// step 1. update payment info
// step 2. update appointment
// step 3. update blockTime
// step 4. update bonus status
// step 5. send notifications

  Future<bool> finishBooking({
    required BuildContext context,
    required CustomerModel customerModel,
  }) async {
    print('llllll');
    loadingStatus = Status.loading;
    if (appointmentModel != null) {
      PaymentInfo _paymentInfo = PaymentInfo(
        bonusApplied: chosenBonus != null,
        bonusAmount: chosenBonus?.amount ?? 0,
        actualAmount:
            double.parse(appointmentModel?.priceAndDuration.price ?? '0')
                .toInt(),
        bonusIds: chosenBonus != null ? [chosenBonus!.bonusId] : [],
        paymentDone: false,
        onlinePayment: false,
        paymentMethod: PaymentMethods.cardSalon,
      );

      ///passes discounted amount in priceAndDuration model
      if (chosenBonus != null) {
        final discountedAmount =
            (double.parse(appointmentModel?.priceAndDuration.price ?? '0')
                    .toInt() -
                chosenBonus!.amount);
        if (discountedAmount < 0) {
          appointmentModel?.priceAndDuration.price = '0';
        } else {
          appointmentModel?.priceAndDuration.price =
              discountedAmount.toString();
        }
      }

      appointmentModel?.paymentInfo = _paymentInfo;
      AppointmentModel? finalAppointment;
      if (ownerType != OwnerType.singleMaster) {
        finalAppointment = await createAppointmentInIntegration(
            appointmentModel!, chosenMaster!);

        if (finalAppointment != null) {
          DocumentReference doc =
              await Collection.appointments.add(finalAppointment.toJson());

          finalAppointment.appointmentId = doc.id;
          await blockTime();

          if (chosenBonus != null) {
            await BonusReferralApi().invalidateBonus(
                bonusModel: chosenBonus!, usedAppointmentId: doc.id);
          }

          // AppointmentNotification().sendNotifications(
          //     finalAppointment, customerModel, chosenSalon!, context);
          printIt(finalAppointment.toJson());
          reset();

          Collection.customers.doc(customerModel.customerId).update({
            'registeredSalons':
                FieldValue.arrayUnion([appointmentModel!.salon.id])
          });
          loadingStatus = Status.success;
          notifyListeners();
          notifyListeners();

          return true;
        } else {
          loadingStatus = Status.failed;
          notifyListeners();

          return false;
        }
      } else {
        DocumentReference doc =
            await Collection.appointments.add(appointmentModel!.toJson());

        appointmentModel!.appointmentId = doc.id;
        await blockTime();

        if (chosenBonus != null) {
          await BonusReferralApi().invalidateBonus(
              bonusModel: chosenBonus!, usedAppointmentId: doc.id);
        }

        // AppointmentNotification().sendNotifications(
        //     appointmentModel!, customerModel, chosenSalon!, context);
        printIt(finalAppointment?.toJson());
        reset();

        Collection.customers.doc(customerModel.customerId).update({
          'registeredSalons':
              FieldValue.arrayUnion([appointmentModel!.salon.id])
        });
        loadingStatus = Status.success;
        notifyListeners();
        return true;
      }
    } else {
      loadingStatus = Status.failed;
      notifyListeners();
      printIt('error in making booking');
      showToast(AppLocalizations.of(context)?.errorOccurred ??
          'error! please try again');
      return false;
    }
  }

  blockTime() async {
    if (chosenSalon!.ownerType == OwnerType.singleMaster) {
      await AppointmentApi().blockSalonTime(
        salon: chosenSalon!,
        date: chosenDay,
        time: chosenSlots.first,
        minutes: int.parse(appointmentModel!.priceAndDuration.duration),
      );
    } else {
      await AppointmentApi().blockMastersTime(
        master: chosenMaster!,
        date: chosenDay,
        time: chosenSlots.first,
        minutes: int.parse(appointmentModel!.priceAndDuration.duration),
      );
    }
  }

  reset() {
    loadingStatus = Status.loading;
    chosenSalon = null;
    chosenMaster = null;
    salonServices = [];
    salonMasters = [];
    salonReviews = [];
    allSlots = [];
    breakSlots = [];
    validSlots = [];
    chosenSlots = [];
    morningTimeslots = [];
    afternoonTimeslots = [];
    eveningTimeslots = [];
    chosenDay = DateTime.now();
    totalTimeSlotsRequired = 0;
    totalMinutes = 0;
    totalPrice = 0;
    totalMinutesWithFixed = 0;
    totalPricewithFixed = 0;
    totalTimeWithMaster = 0;
    totalPriceWithMaster = 0;
    chosenServices = [];
    mastersServicesMapAll = {};
    categoryServicesMap = {};
    mastersServicesMap = {};
    mastersPriceDurationMap = {};
    mastersPriceDurationMapMax = {};
    chosenBonus = null;
    paymentMethod = null;
    yclientActive = false;
    beautyProActive = false;
    beautyProConfig = null;
    slotsStatus = Status.init;
    notifyListeners();
  }
}

// Future blockTime() async {
//   if (chosenSalon!.ownerType == OwnerType.singleMaster) {
//     Map<String, dynamic> blockedTimes = chosenSalon?.blockedTime ?? {};
//     if (blockedTimes[Time().getDateStr(chosenDay)] == null) {
//       blockedTimes[Time().getDateStr(chosenDay)!] = chosenSlots;
//     } else {
//       blockedTimes[Time().getDateStr(chosenDay)!].addAll(chosenSlots);
//     }
//     SalonModel _updatedSalon = chosenSalon!;
//     _updatedSalon.blockedTime = blockedTimes;
//     await SalonApi().updateSalonBlockedTime(_updatedSalon);
//   } else {
//     Map<String, dynamic> blockedTimes = chosenMaster?.blockedTime ?? {};
//     if (blockedTimes[Time().getDateStr(chosenDay)] == null) {
//       blockedTimes[Time().getDateStr(chosenDay)!] = chosenSlots;
//     } else {
//       blockedTimes[Time().getDateStr(chosenDay)!].addAll(chosenSlots);
//     }
//     MasterModel _updatedMaster = chosenMaster!;
//     _updatedMaster.blockedTime = blockedTimes;
//     await MastersApi().updateMasterBlockTime(_updatedMaster);
//   }
// }
