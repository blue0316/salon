// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:bbblient/src/firebase/appointments.dart';
import 'package:bbblient/src/firebase/category_services.dart';
import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/firebase/master.dart';
import 'package:bbblient/src/firebase/promotion_service.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/appointment/serviceAndMaster.dart';
import 'package:bbblient/src/models/backend_codings/appointment.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/backend_codings/payment_methods.dart';
import 'package:bbblient/src/models/backend_codings/working_hours.dart';
import 'package:bbblient/src/models/bonus_model.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/cat_sub_service/price_and_duration.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/customer/customer.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/integration/beauty_pro/beauty_pro.dart';
import 'package:bbblient/src/models/products.dart';
import 'package:bbblient/src/models/promotions/promotion_service.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/integration/beauty_pro.dart';
import 'package:bbblient/src/utils/integration/yclients.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import "dart:math";

class CreateAppointmentProvider with ChangeNotifier {
  Status loadingStatus = Status.loading;
  SalonModel? chosenSalon;
  MasterModel? chosenMaster;
  List<ServiceModel> salonServices = [];
  List<ServiceModel> allAvailableServices = [];

  List<MasterModel> salonMasters = [];
  List<ReviewModel> salonReviews = [];

  // Products
  List<ProductModel> salonProductsBrand = [];

  ///all the slots below
  List<String> allSlots = [];
  List<String> breakSlots = [];
  List<String> validSlots = [];
  List<String> chosenSlots = [];
  List<String> morningTimeslots = [];
  List<String> afternoonTimeslots = [];
  List<String> eveningTimeslots = [];

// stores the master choosen to service
  List<ServiceAndMaster> serviceAgainstMaster = [];

  ///Promotion Variables
  // PromotionModel? chosenPromotion;
  List<ServiceModel> xsalonPromotionServices = [];
  List<PromotionModel> salonPromotions = [];
  Map<String, List<ServiceModel>> categoryPromotionServicesMap = {};
  PromotionModel? selectedPromotion;
  List<String> allPromotionSlots = [];
  List<String> validPromotionSlots = [];
  List<String> chosenPromotionSlots = [];
  List<String> morningTimePromotionslots = [];
  List<String> afternoonTimePromotionslots = [];
  List<String> eveningTimesPromotionlots = [];

  DateTime chosenDay = Time().getDate();
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

  /// Separate categories for masters
  Map<CategoryModel, List<ServiceModel>> masterCategoryAndServices = {};

  Map<String, List<ServiceModel>> mastersServicesMap = {};
  List<MasterModel> availableMasters = [];
  Map<String, PriceAndDurationModel> mastersPriceDurationMap = {};
  Map<String, PriceAndDurationModel> mastersPriceDurationMapMax = {};
  AppointmentModel? appointmentModel;
  List<AppointmentModel>? appointmentModelSalonOwner = [];

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

  String countryCode = '';
  String otp = '';

  List<CategoryModel> categoriesAvailable = [];
  List<List<ServiceModel>> servicesAvailable = [];
  List<List<ServiceModel>> masterServicesAvailable = [];

  String defaultServiceDuration = '60';

  // PageView Controller on `Confirmation` Tab Bar
  final PageController confirmationPageController = PageController();

  //masters list that serves that particular service
  List<MasterModel> serviceableMasters = [];
  Status masterViewStatus = Status.loading;
  int? timeOfDayIndexForSlots;
  Map<String?, List<String>?> availableAppointments = {};
  Map<String?, List<String>?> allAppointments = {};
  Map<String?, PriceAndDurationModel> priceAndDuration = {};
  int totalDuration = 0;
  int totalPriceForMultiple = 0;
  int totalPriceMaxForMultiple = 0;
  String? selectedAppointmentSlot;
  String? selectedAppointmentDuration;
  DateTime? appointmentDate;
  List<bool> isWorkingList = [];
  MasterModel? chooseMasterForBooking; // Master selected on Date & Time view

  Status bookAppointmentStatus = Status.init;

  //currently selected  category tab
  CategoryModel? selectedCat;
  List<ServiceModel> itemList = [];
  List<ServiceModel> selectedItems = [];
  List<ServiceModel> selectedSubItems = [];

  ///list holds all selected available services for booking appointments
  List<ServiceModel> totalSelectedSubItems = [];
  List<ServiceModel> unavailableSelectedItems = [];
  // List<ServiceModel> filteredServicesList = [];
  Map<String, List<ServiceModel>> groupUnavailableSelectedItems = {};
  double totalDeposit = 0;
  int bookingFlowPageIndex = 0;
  bool showModal = false; // Mini container on date and time screen
  String? servicePrice;
  String? serviceDuration;

  getServiceMasters() {
    unavailableSelectedItems.clear();
    groupUnavailableSelectedItems.clear();

    String? serviceId = selectedItems[0].serviceId;

    /// MASTERS
    // Tets -=- 5Ph7qd7K7EmibIzfhFEv
    // emma -=- NSGW5dPWnAMveRt2olCS
    // gill -=- TlqhJD2qWmO6BRfChhqt
    // emma -=- gmCpDkuEfCIUCR7JWJES
    // Timmy -=- jMBqf41PWJqaLRIauMb9
    // Joy -=- mu9mxQsROJekSsoR9yeL

    ///get all services in salon
    for (var service in allAvailableServices) {
      //get the service id of the first selected service
      if (service.serviceId == serviceId) {
        //loop through all masters in salon
        for (var servicemaster in salonMasters) {
          //if master is offering that service
          if (service.masterPriceAndDurationMap!.containsKey(servicemaster.masterId)) {
            //loop through all services
            for (var service1 in allAvailableServices) {
              //check if master is offering any service we are looping through
              if (service1.masterPriceAndDurationMap!.containsKey(servicemaster.masterId)) {
                //if the selected list  and subservice list doesn't contain the first selected item
                if (selectedItems.contains(service1) == false && selectedSubItems.contains(service1) == false) {
                  if (selectedItems.contains(service1) == false) {
                    selectedSubItems.add(service1);
                  }
                  //add to the selected sub items list
                }
              } else {
                ///add services that master is not offering to unavailble list
                if (unavailableSelectedItems.contains(service1) == false) {
                  unavailableSelectedItems.add(service1);
                }

                if (selectedItems.contains(service1) == false && selectedSubItems.contains(service1) == false) {
                  // print('****************************########************');
                  // print(service1.categoryId);
                  // print(getCategoryFromId(service1.categoryId));
                  // print('****************************########************');
                  if (groupUnavailableSelectedItems[service1.categoryId] != null) {
                    if (groupUnavailableSelectedItems[service1.categoryId]?.contains(service1) == false) {
                      groupUnavailableSelectedItems[service1.categoryId]?.add(service1);
                    }
                  } else {
                    groupUnavailableSelectedItems[service1.categoryId!] = [service1];
                  }
                }
              }
            }
            break;
          }
        }
      }
    }
  }

  initTimeOfDay() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      timeOfDayIndexForSlots = 0;
      return;
    }
    if (hour < 17) {
      timeOfDayIndexForSlots = 1;
      return;
    }
    timeOfDayIndexForSlots = 2;
    return;
  }

  List<MasterModel> mastersAbleToPerformService = [];

  initMastersAndTime({required bool isSingleMaster}) {
    availableAppointments.clear();
    allAppointments.clear();
    serviceableMasters.clear();
    mastersAbleToPerformService.clear();
    notifyListeners();

    serviceableMasters = getMultipleServiceableMasters(salonMasters);
    // mastersAbleToPerformService = getMultipleServiceableMasters(salonMasters);

    // print('@@@@----@@@@@---@@@@@---@@@');
    // print(serviceableMasters);
    // print('@@@@----@@@@@---@@@@@---@@@');

    ///load price and duration of masters for multiple services
    if (!isSingleMaster) {
      loadMultiplePriceAndDuration();
    } else {
      loadPriceAndDurationForMultipleServicesSingleMaster();
    }

    // for (MasterModel master in mastersAbleToPerformService) {
    //   String? price = priceAndDuration[master.masterId]?.price ?? '0';
    //   String? duration = priceAndDuration[master.masterId]?.duration ?? '0';

    //   if (price != '0' && duration != '0') {
    //     serviceableMasters.add(master);
    //   }
    // }
    notifyListeners();
    loadMasterView();
    loadDayView();
  }

  // gets multiple serviceable master for new design
  getMultipleServiceableMasters(List<MasterModel> masters) {
    List<MasterModel> _tempMasters = [];

    // print('@@@@@@@@@@@@@@@@');
    // print(masters);

    // print('@@@@@@@@@@@@@@@@');
    for (MasterModel master in masters) {
      // print('@@@@@@@@@@@@@@@@');
      // print(master.masterId);
      // print('@@@@@@@@@@@@@@@@');

      // if (chosenMaster != null) {
      //   for (var services in chosenServices) {
      //     if (chosenMaster!.serviceIds!.contains(services.serviceId) && _tempMasters.contains(master) == false) {
      //       _tempMasters.add(master);
      //     }
      //   }
      // }

      // Single Master
      // else
      if (chosenSalon!.ownerType == OwnerType.singleMaster) {
        for (var services in chosenServices) {
          if (master.serviceIds!.contains(services.serviceId)) {
            _tempMasters.add(master);
          }
        }
      }
      // Salon Owner
      else {
        for (var services in chosenServices) {
          if (master.serviceIds!.contains(services.serviceId) && _tempMasters.contains(master) == false) {
            _tempMasters.add(master);
          }
        }
      }
    }

    return _tempMasters.toList();
  }

  /// returns the all slots for master only
  /// different from getAvailablemasterslots
  List<String>? getMasterSlotsFormer(MasterModel master) {
    Hours? workingHours;
    List<String> allSlotsMaster = [];

    if (master.irregularWorkingHours != null &&
        master.irregularWorkingHours!.containsKey(
          DateFormat('yyyy-MM-dd').format(chosenDay).toString(),
        )) {
      workingHours = master.irregularWorkingHours![DateFormat('yyyy-MM-dd').format(chosenDay).toString()];
    } else {
      workingHours = Time().getWorkingHoursFromWeekDay(chosenDay.weekday, master.workingHours);
    }

    if (workingHours != null) {
      TimeOfDay _startTime = Time().stringToTime(workingHours.startTime);
      TimeOfDay _endTime = Time().stringToTime(workingHours.endTime);
      TimeOfDay _breakStartTime = Time().stringToTime(workingHours.breakStartTime);
      TimeOfDay _breakEndTime = Time().stringToTime(workingHours.breakEndTime);
      allSlotsMaster = Time()
          .getTimeSlots(
            _startTime,
            _endTime,
            step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15),
          )
          .toList();
    }

    return allSlotsMaster;
  }

  List<String>? getMasterSlots(MasterModel master, DateTime date) {
    final String dateKey = Time().getDateInStandardFormat(date);
    if (master.irregularWorkingHours != null && master.irregularWorkingHours!.containsKey(dateKey)) {
      Hours hours = master.irregularWorkingHours![dateKey]!;
      if (hours.isWorking) {
        return getAvailableSlots(
          master.blockedTime,
          date,
          hours: hours,
          irregularWorkingHours: master.irregularWorkingHours,
          master: master,
        );
      }
    }

    var now = DateTime.now();
    return date.isBefore(DateTime(now.year, now.month, now.day - 1, 11, 59, 59))
        ? null
        : getAvailableSlots(
            master.blockedTime,
            date,
            workingHours: master.workingHours,
            master: master,
          );
  }

  List<String>? getAvailableSlots(Map<String, dynamic>? blockedTime, DateTime date, {WorkingHoursModel? workingHours, Hours? hours, MasterModel? master, Map<String, Hours>? irregularWorkingHours}) {
    try {
      DateTime currentTime = DateTime.now();
      if (!date.isSameDate(currentTime) && date.isBefore(currentTime)) return null;

      //if (date.isBefore(DateTime.now())) return null;

      List<String> _availableSlots = [];

      final String _dateKey = _time.getDateInStandardFormat(date);

      Hours? _hours;
      //selecting between WorkingHours and hours option
      final bool _chooseIrregularHours = (irregularWorkingHours != null && irregularWorkingHours.containsKey(_dateKey) && irregularWorkingHours[_dateKey] != null && irregularWorkingHours[_dateKey]!.isWorking);
      if (_chooseIrregularHours) {
        final _dateKey = Time().getDateInStandardFormat(date);
        _hours = irregularWorkingHours[_dateKey];
        (_dateKey);
        (_hours!.toJson().toString());
      } else if (hours == null) {
        // print('workking hhrs ${workingHours}');
        _hours = _time.getRegularWorkingHoursFromDate(workingHours, date: date);
      } else {
        _hours = hours;
      }
      // print('hours ${_hours}');

      if (_hours == null || !_hours.isWorking) return null;

      //computing start and end time acc to different parameters
      TimeOfDay? _startTime;
      TimeOfDay? _endTime;
      if (_chooseIrregularHours) {
        _startTime = _computeStartTime(_hours.startTime, date, master: master, irregular: true);
      } else {
        _startTime = _computeStartTime(_hours.startTime, date);
      }

      if (_chooseIrregularHours) {
        _endTime = _computeEndTime(_hours.endTime, date, master: master, irregular: true);
      } else {
        _endTime = _computeEndTime(_hours.endTime, date);
      }
      //  retrieving all the available slots

      Iterable<String> _slots = _time.generateTimeSlots(
        _startTime,
        _endTime,
        timeSlotSizeDuration: chosenSalon!.timeSlotsInterval,
      );

      if (_slots.isEmpty) return null;
      _availableSlots.addAll(_slots);

      //removes the break time from the available slots
      if (_hours.isBreakAvailable != null && _hours.isBreakAvailable == true) {
        _time
            .generateTimeSlots(
          _time.stringToTime(_hours.breakStartTime),
          _time.stringToTime(_hours.breakEndTime),
          timeSlotSizeDuration: chosenSalon!.timeSlotsInterval,
        )
            .forEach((element) {
          if (_availableSlots.contains(element)) _availableSlots.remove(element);
        });
      }

      //removes all the pre-occupied slots

      if (blockedTime != null && blockedTime.isNotEmpty && blockedTime[_dateKey] != null && blockedTime[_dateKey].isNotEmpty) {
        blockedTime[_dateKey].forEach((slot) {
          _availableSlots.remove(slot);
        });
      }
      ('this slots ${_availableSlots.toList()}');
      return (_availableSlots.isEmpty) ? null : _availableSlots.toList();
    } catch (e) {
      ('Error while generating slots');
      (e);
      return null;
    }
  }

  /// computes the end time
  /// by comparing following parameters : masterEndTime, salonEndTime
  TimeOfDay? _computeEndTime(String? masterEndTime, DateTime date, {MasterModel? master, bool irregular = false}) {
    try {
      if (chosenSalon!.ownerType == OwnerType.singleMaster) return _time.stringToTime(masterEndTime!);

      //getting salon timings
      Hours? selectedSalonHours;
      if (irregular) {
        selectedSalonHours = _time.getMasterIrregularWorkingHours(
          master!,
          date: date,
        )!;
        // if it's still null then we reverted to old version
        if (selectedSalonHours == null) {
          selectedSalonHours = _time.getIrregularWorkingHours(
            chosenSalon?.irregularWorkingHours,
            date: date,
          );
        }
      } else {
        selectedSalonHours = _time.getRegularWorkingHoursFromDate(
          chosenSalon?.workingHours,
          weekDay: date.weekday,
        )!;
      }

      if (!selectedSalonHours!.isWorking) return null;

      TimeOfDay _salonEndTime = _time.stringToTime(selectedSalonHours.endTime);

      TimeOfDay _masterEndTime = _time.stringToTime(masterEndTime!);

      // computes the ending time by comparing master and salon starting time [master and salon fused timing]
      return _time.getMinMaxTime(_salonEndTime, _masterEndTime, returnMaxTime: false);
    } catch (e) {
      ('error while generating end time');
      (e);
      return _time.stringToTime(masterEndTime!);
    }
  }

  // -----%%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&&&&&&--------

  // /// returns the slots for all masters
  // List<String>? getAllMasterSlots(MasterModel master, DateTime date) {
  //   // final String dateKey = _time.getDateInStandardFormat(date);

  //   if (master.irregularWorkingHours != null && master.irregularWorkingHours!.containsKey(date)) {
  //     // print('entered here 1');
  //     Hours hours = master.irregularWorkingHours![DateFormat('yyyy-MM-dd').format(chosenDay).toString()]!;
  //     if (hours.isWorking) {
  //       return getAllSlots(
  //         master.blockedTime,
  //         date,
  //         hours: hours,
  //         irregularWorkingHours: master.irregularWorkingHours,
  //         master: master,
  //       );
  //     }
  //   }
  //   var now = DateTime.now();

  //   // print('entered here 2');
  //   return date.isBefore(DateTime(now.year, now.month, now.day - 1, 11, 59, 59))
  //       ? []
  //       : getAllSlots(
  //           master.blockedTime,
  //           date,
  //           workingHours: master.workingHours,
  //           master: master,
  //         );
  // }

  /// returns the all slots for master only
  /// different from getAvailablemasterslots
  List<String>? getAllMasterSlots(MasterModel master, DateTime date) {
    final String dateKey = _time.getDateInStandardFormat(date);

    if (master.irregularWorkingHours != null && master.irregularWorkingHours!.containsKey(dateKey)) {
      Hours hours = master.irregularWorkingHours![dateKey]!;
      if (hours.isWorking) {
        return getAllSlots(
          master.blockedTime,
          date,
          hours: hours,
          irregularWorkingHours: master.irregularWorkingHours,
          master: master,
        );
      }
    }
    var now = DateTime.now();
    return date.isBefore(DateTime(now.year, now.month, now.day - 1, 11, 59, 59))
        ? null
        : getAllSlots(
            master.blockedTime,
            date,
            workingHours: master.workingHours,
            master: master,
          );
  }

  /// get all slot for the day
  /// note:it is different from getAvailableSlots
  List<String>? getAllSlots(
    Map<String, dynamic>? blockedTime,
    DateTime date, {
    WorkingHoursModel? workingHours,
    Hours? hours,
    MasterModel? master,
    Map<String, Hours>? irregularWorkingHours,
  }) {
    try {
      DateTime currentTime = DateTime.now();

      if (!date.isSameDate(currentTime) && !currentTime.isBefore(date)) {
        return null;
      }

      List<String> _availableSlots = [];

      // final String _dateKey = _time.getDateInStandardFormat(date);

      Hours? _hours;
      //selecting between WorkingHours and hours option
      final bool _chooseIrregularHours = (irregularWorkingHours != null &&
          irregularWorkingHours.containsKey(
            date,
          ) &&
          irregularWorkingHours[date] != null &&
          irregularWorkingHours[date]!.isWorking);

      if (_chooseIrregularHours) {
        // final _dateKey = Time().getDateInStandardFormat(date);
        _hours = irregularWorkingHours[date];
        (date);
        (_hours!.toJson());
      } else if (hours == null) {
        _hours = _time.getRegularWorkingHoursFromDate(workingHours, date: date);
      } else {
        _hours = hours;
      }

      if (_hours == null || !_hours.isWorking) return null;

      //computing start and end time acc to different parameters
      TimeOfDay? _startTime;
      TimeOfDay? _endTime;

      _startTime = _computeStartTime(_hours.startTime, date);

      _endTime = Time().stringToTime(_hours.endTime);

      //  retrieving all the available slots
      ('timesss $_startTime $_endTime');
      Iterable<String> _slots = _time.generateTimeSlots(
        _startTime!,
        _endTime,
        timeSlotSizeDuration: chosenSalon!.timeSlotsInterval,
      );
      if (_slots.isEmpty) return null;
      ('slotsss$_slots');
      _availableSlots.addAll(_slots);

      return (_availableSlots.isEmpty) ? null : _availableSlots.toList();
    } catch (e) {
      ('Error while generating slots');
      (e);
      return null;
    }
  }

  loadMasterView() async {
    masterViewStatus = Status.loading;
    notifyListeners();

    for (MasterModel master in serviceableMasters) {
      {
        List<String>? _masterSlots = getMasterSlots(master, chosenDay);
        List<String>? _allSlots = getAllMasterSlots(master, chosenDay) ?? [];

        if (_masterSlots != null) {
          //(_masterSlots);
          int morningIndex = _masterSlots.indexWhere((element) => Time().stringToTime(element).hour >= 12);
          int afterNoonIndex = _masterSlots.indexWhere((element) => Time().stringToTime(element).hour >= 17);

          int morningAllIndex = _allSlots.indexWhere((element) => Time().stringToTime(element).hour >= 12);
          int afterNoonAllIndex = _allSlots.indexWhere((element) => Time().stringToTime(element).hour >= 17);

          List<String>? eveningTimeslots = [];
          List<String>? morningTimeslots = [];
          List<String>? afternoonTimeslots = [];
          // for all slots
          List<String>? eveningAllTimeslots = [];
          List<String>? morningAllTimeslots = [];
          List<String>? afternoonAllTimeslots = [];
          if (afterNoonIndex != -1 && _allSlots.isNotEmpty) {
            eveningTimeslots = _masterSlots.sublist(afterNoonIndex, _masterSlots.length);
            eveningAllTimeslots = _allSlots.sublist(afterNoonAllIndex, _allSlots.length);
          }
          if (morningIndex != -1 && _allSlots.isNotEmpty) {
            morningTimeslots = _masterSlots.sublist(0, morningIndex);
            morningAllTimeslots = _allSlots.sublist(0, morningAllIndex);
            if (afterNoonIndex != -1 && _allSlots.isNotEmpty) {
              afternoonTimeslots = _masterSlots.sublist(morningIndex, afterNoonIndex);
              afternoonAllTimeslots = _allSlots.sublist(morningAllIndex, afterNoonAllIndex);
            } else {
              afternoonTimeslots = _masterSlots.sublist(morningIndex, _masterSlots.length);
              afternoonAllTimeslots = _allSlots.sublist(morningAllIndex, _allSlots.length);
            }
            // print(morningTimeslots);
          }
          if (timeOfDayIndexForSlots == 0) {
            _masterSlots = morningTimeslots;
            _allSlots = morningAllTimeslots;
          } else if (timeOfDayIndexForSlots == 1) {
            _masterSlots = afternoonTimeslots;
            _allSlots = afternoonAllTimeslots;
          } else {
            _masterSlots = eveningTimeslots;
            _allSlots = eveningAllTimeslots;
          }
        }

        //fetching slots from integration if any
        availableAppointments[master.masterId] = _masterSlots;
        allAppointments[master.masterId] = _allSlots;

        // print('--------------------- ALL APPOINTMENTS ----------------------------');
        // print(allAppointments);
        // print('--------------------- ALL APPOINTMENTS ----------------------------');

        if (availableAppointments.containsKey(master.masterId)) {
          if (availableAppointments[master.masterId] == null || availableAppointments[master.masterId]!.isEmpty) {
            availableAppointments.remove(master.masterId);
            // remove for allSlots also
            allAppointments.remove(master.masterId);
          }
        }
      }
    }

    masterViewStatus = Status.success;
    notifyListeners();
  }

  ///load multiple price and duration for multiple masters in the salon
  // loadMultiplePriceAndDuration() {
  //   priceAndDuration.clear();
  //   for (var master in serviceableMasters) {
  //     // mastersAbleToPerformService) {
  //     totalDuration = 0;
  //     totalPriceForMultiple = 0;
  //     totalPriceMaxForMultiple = 0;
  //     var newPriceAndDuration = PriceAndDurationModel();
  //     for (ServiceModel eachSelectedService in chosenServices) {
  //       if (eachSelectedService.serviceId != null && eachSelectedService.serviceId!.isNotEmpty && master.servicesPriceAndDuration != null) {
  //         totalDuration += int.parse(eachSelectedService.priceAndDuration!.duration ?? '0');
  //         totalPriceForMultiple += (int.parse(master.servicesPriceAndDuration?[eachSelectedService.serviceId]?.price ?? '0'));
  //         totalPriceMaxForMultiple += (int.parse(master.servicesPriceAndDuration?[eachSelectedService.serviceId]?.priceMax ?? '0'));
  //         // totalPriceForMultiple += (int.parse(eachSelectedService.priceAndDuration!.price!));

  //         master.servicesPriceAndDuration![eachSelectedService.serviceId]?.price = totalPriceForMultiple.toString();
  //         master.servicesPriceAndDuration![eachSelectedService.serviceId]?.duration = totalDuration.toString();

  //         newPriceAndDuration.price = (int.parse(newPriceAndDuration.price ?? '0') + totalPriceForMultiple).toString();
  //         newPriceAndDuration.duration = (int.parse(newPriceAndDuration.duration ?? '0') + totalDuration).toString();
  //         newPriceAndDuration.priceMax = (int.parse(newPriceAndDuration.priceMax ?? '0') + totalPriceMaxForMultiple).toString();

  //         // not sure
  //         newPriceAndDuration.isFixedPrice = master.servicesPriceAndDuration?[eachSelectedService.serviceId]?.isFixedPrice;
  //         newPriceAndDuration.isPriceRange = master.servicesPriceAndDuration?[eachSelectedService.serviceId]?.isPriceRange;
  //         newPriceAndDuration.isPriceStartAt = master.servicesPriceAndDuration?[eachSelectedService.serviceId]?.isPriceStartAt;
  //         newPriceAndDuration.isPriceStartAt = master.servicesPriceAndDuration?[eachSelectedService.serviceId]?.isPriceStartAt;

  //         // String? durationinHr = '0';
  //         // String? durationinMin = '0';
  //         // priceAndDuration[master.masterId] = getPriceAndDuration(eachSelectedService, master);

  //         // print('____+++++___+++++___++@@@@@@@@&&&&&&&___------++++');
  //         // print(totalDuration);
  //         // print(totalPriceForMultiple);
  //         // print(priceAndDuration[master.masterId]?.price);
  //         // print(priceAndDuration[master.masterId]?.duration);
  //         // print('____+++++___+++++___++@@@@@@@@&&&&&&&___------++++');
  //       }
  //     }

  //     priceAndDuration[master.masterId] = newPriceAndDuration;
  //   }
  // }

  loadMultiplePriceAndDuration() {
    priceAndDuration.clear();
    serviceableMasters.forEach((MasterModel master) {
      totalDuration = 0;
      totalPrice = 0;
      for (var eachSelectedService in chosenServices) {
        if (eachSelectedService != null && master != null && eachSelectedService.serviceId != null && eachSelectedService.masterPriceAndDurationMap![master.masterId]?.price != null && eachSelectedService.masterPriceAndDurationMap![master.masterId]!.price!.isNotEmpty) {
          totalDuration += int.parse(eachSelectedService.priceAndDuration!.duration!);
          totalPrice += (int.parse(convertToMinutes(eachSelectedService.masterPriceAndDurationMap![master.masterId]!.price!)));

          master.servicesPriceAndDuration![eachSelectedService.serviceId]?.price = totalPrice.toString();
          master.servicesPriceAndDuration![eachSelectedService.serviceId]?.duration = totalDuration.toString();

          priceAndDuration[master.masterId] = getPriceAndDuration(eachSelectedService, master);
        }
      }
      debugPrint('total price? $totalPrice');
    });
  }

  String convertToMinutes(String timeString) {
    if (timeString.contains("hrs") || timeString.contains("min")) {
      List<String> timeParts = timeString.split(' ');

      int hours = int.parse(timeParts[0].replaceAll('hrs', ''));
      int minutes = int.parse(timeParts[1].replaceAll('min', ''));
      int totalMinutes = (hours * 60) + minutes;
      return "$totalMinutes";
    }
    return timeString;
  }

  // returns the service charge from service and master data
  PriceAndDurationModel getPriceAndDuration(ServiceModel? service, MasterModel master) {
    try {
      if (service != null && master != null && service.serviceId != null && master.servicesPriceAndDuration != null) {
        print('master price${master.servicesPriceAndDuration![service.serviceId]!.price}');
        return master.servicesPriceAndDuration![service.serviceId] ?? PriceAndDurationModel();
      }
    } catch (e) {
      (e.toString());
    }
    return PriceAndDurationModel();
  }

  //extracts price and duration for multiple services
  loadPriceAndDurationForMultipleServicesSingleMaster() {
    int totalPrice = 0;
    int totalDuration = 0;
    //loop through each selected service list and set time and duration to display
    for (var eachSelectedService in chosenServices) {
      //if current selected service has fixed price
      if (eachSelectedService.isFixedPrice) {
        // we add normal price to total price
        totalPrice += int.tryParse(eachSelectedService.priceAndDuration!.price!.toString())!;
      } else {
        //where service is not a fixed price we add max price instead
        totalPrice += int.tryParse(eachSelectedService.priceAndDurationMax!.price!.toString())!;
      }
      //if service fixed duration is not null
      if (eachSelectedService.isFixedDuration != null) {
        //if service has a fixed duration
        if (eachSelectedService.isFixedDuration) {
          //we add it to total duration
          totalDuration += int.tryParse(eachSelectedService.priceAndDuration!.duration!.toString())!;
        } else {
          //else if no fixed duration we add max duration
          totalDuration += int.tryParse(eachSelectedService.priceAndDurationMax!.duration!.toString())!;
        }
      } else {
        //selected service has fixed price
        if (eachSelectedService.isFixedPrice) {
          //add to total duration
          totalDuration += int.tryParse(eachSelectedService.priceAndDuration!.duration!.toString())!;
        } else {
          // else add max duration to total duration
          totalDuration += int.tryParse(eachSelectedService.priceAndDurationMax!.duration!.toString())!;
        }
      }
      //assign total calculated duration  and price of all looped services;
      serviceDuration = totalDuration.toString();
      servicePrice = totalPrice.toString();
      debugPrint('price $servicePrice durations $serviceDuration');
    }
  }

  // // returns the service charge from service and master data
  // PriceAndDurationModel getPriceAndDuration(ServiceModel? service, MasterModel master) {
  //   try {
  //     if (service != null && service.serviceId!.isNotEmpty && master.servicesPriceAndDuration != null) {
  //       // print('master price${master.servicesPriceAndDuration![service.serviceId]!.price}');

  //       // print('____+++++___+++++___++@@@@@@@@&&&&&&&___------++++');
  //       // print(service.serviceName);
  //       // print(service.serviceId);
  //       // print(master.servicesPriceAndDuration?['nVqUIPr07PLneP8QW3wd']?.price);
  //       // print(master.servicesPriceAndDuration?['nVqUIPr07PLneP8QW3wd']?.durationinHr);
  //       // print(master.title);
  //       // print('____+++++___+++++___++@@@@@@@@&&&&&&&___------++++');
  //       return master.servicesPriceAndDuration?[service.serviceId] ?? PriceAndDurationModel();
  //     }
  //   } catch (e) {
  //     (e.toString());
  //   }
  //   return PriceAndDurationModel();
  // }

  bool checkContinuousSlotsNew({required MasterModel master, required List<String> slotspresent}) {
    List<int> indexes = [];
    // since we noLonger work with 3 days in a row
    // we only check against the first day
    for (int i = 0; i <= slotspresent.length - 1; i++) {
      indexes.add(allAppointments[master.masterId]!.indexWhere((element) => element == slotspresent[i]));
    }
    for (int i = 0; i < indexes.length - 1; i++) {
      if (indexes[i + 1] - indexes[i] != 1) {
        return false;
      }
    }

    return true;
  }

  //called up every time appointment changes
  bool isBlocked = false;

  controlModal(bool val) {
    showModal = val;
    notifyListeners();
  }

  onAppointmentChange(BuildContext context, MasterModel master, String? appointment, {DateTime? date}) {
    debugPrint('On Appointment Change Function');
    // print(master.personalInfo?.firstName);
    isBlocked = false;

    totalTimeSlotsRequired = (int.parse(priceAndDuration[master.masterId]?.duration ?? defaultServiceDuration) / (chosenSalon!.timeSlotsInterval ?? 15)).ceil();

    if (int.parse(priceAndDuration[master.masterId]?.duration ?? defaultServiceDuration) % (chosenSalon!.timeSlotsInterval ?? 15) > 0) {
      totalTimeSlotsRequired += 1;
    }
    //(totalTimeSlotsRequired);
    if (totalTimeSlotsRequired > availableAppointments[master.masterId]!.length) {
      showToast(AppLocalizations.of(context)?.notEnoughSlots ?? 'Not enough slots');
      controlModal(false);
    } else {
      int index = availableAppointments[master.masterId]!.indexWhere((element) => element == appointment);
      //(index);
      List<String> chosenSlots = [];
      if (index != -1) {
        if (index == 0) {
          chosenSlots = availableAppointments[master.masterId]!.getRange(index, totalTimeSlotsRequired).toList();
        } else if (index > availableAppointments[master.masterId]!.length - totalTimeSlotsRequired) {
          chosenSlots = availableAppointments[master.masterId]!
              .getRange(
                availableAppointments[master.masterId]!.length - (totalTimeSlotsRequired),
                availableAppointments[master.masterId]!.length,
              )
              .toList();
        } else {
          chosenSlots = availableAppointments[master.masterId]!
              .getRange(
                index,
                (index + totalTimeSlotsRequired),
              )
              .toList();
        }

        bool continues = checkContinuousSlots(master: master, slotspresent: chosenSlots);
        if (!continues) {
          // chosenSlots = [];
          // notifyListeners();
          showToast(AppLocalizations.of(context)?.slotsOverlap ?? 'Slots  Overlap with salon\'s booked Time, choose another slot'); // AppLocalizations.of(context)?.slotsOverlap
          controlModal(false);
          return;
        } else {
          if (date != null) {
            chosenDay = date;
          }
          chosenMaster = master;
          chosenMaster?.masterId = master.masterId;
          appointmentDate = chosenDay;
          selectedAppointmentSlot = appointment;

          selectedAppointmentDuration = Time().getAppointmentString(
            selectedAppointmentSlot,
            int.parse(
              priceAndDuration[chosenMaster?.masterId]?.duration ?? defaultServiceDuration,
            ),
          );

          controlModal(true);

          // isNextEnabled = true;
        }
      } else {
        selectedAppointmentSlot = appointment;
        selectedAppointmentDuration = Time().getAppointmentString(
          selectedAppointmentSlot,
          int.parse(
            priceAndDuration[chosenMaster?.masterId]?.duration ?? defaultServiceDuration,
          ),
        );
        controlModal(true);

        // chosenSlots = [];
        // notifyListeners();
        chosenMaster = master;
        // showToast(tr(Keys.slotNotAvailable));
        isBlocked = true;
      }
    }

    notifyListeners();
  }

  // returns true of specified master is selected
  isMasterSelected(String? masterId, DateTime? selectedDate, String? appointment) {
    // if the result is 1 the appointmentend time is lesser than the present slot
    // else it is greaterThan
    // and the presentSlot is greather than the selectedStart time
    //
    //i.e they are in between startTime and EndTime
    bool inBetween = false;
    if (selectedAppointmentSlot != null) {
      inBetween = (Time().compareTime(
                Time().stringToTime(selectedAppointmentSlot!).addMinutes(int.parse(priceAndDuration[chosenMaster?.masterId]?.duration ?? defaultServiceDuration)),
                Time().stringToTime(appointment!),
              ) !=
              1) &&
          (Time().compareTime(
                Time().stringToTime(appointment),
                Time().stringToTime(selectedAppointmentSlot!),
              ) !=
              1);
    }

    if (chosenMaster?.masterId == masterId && appointmentDate == selectedDate && (selectedAppointmentSlot == appointment || inBetween)) {
      return true;
    } else {
      return false;
    }
  }

  onDateChange(DateTime date) {
    chosenDay = date;
    loadMasterView();
    selectedAppointmentSlot = null;
  }

  ///checks if master working on a particular day.
  ///this was done to display a different calendar border and show when appointments for services are available
  ///if isWorkingList is empty
  ///it means no appointment available since master is not working then
  bool checkIfMasterIsWorking(DateTime itemValue) {
    isWorkingList.clear();
    for (var workingMaster in serviceableMasters) {
      if (workingMaster.workingHours != null) {
        if (itemValue.weekday == 1 && workingMaster.workingHours!.mon.isWorking) {
          isWorkingList.add(true);
        }
        if (itemValue.weekday == 2 && workingMaster.workingHours!.tue.isWorking) {
          isWorkingList.add(true);
        }
        if (itemValue.weekday == 3 && workingMaster.workingHours!.wed.isWorking) {
          isWorkingList.add(true);
        }
        if (itemValue.weekday == 4 && workingMaster.workingHours!.thu.isWorking) {
          isWorkingList.add(true);
        }
        if (itemValue.weekday == 5 && workingMaster.workingHours!.fri.isWorking) {
          isWorkingList.add(true);
        }
        if (itemValue.weekday == 6 && workingMaster.workingHours!.sat.isWorking) {
          isWorkingList.add(true);
        }
        if (itemValue.weekday == 7 && workingMaster.workingHours!.sun.isWorking) {
          isWorkingList.add(true);
        }
      }
    }

    if (isWorkingList.isNotEmpty) {
      // isWorking = true;

      return true;
    }
    // isWorking = false;
    return false;
  }

  Status dayViewStatus = Status.loading;
  Map<String, List<MasterModel>> todayTimeMasterMap = {};
  Map<String, List<MasterModel>> tomorrowTimeMasterMap = {};
  Map<String, List<MasterModel>> dayAfterTomorrowTimeMasterMap = {};

  DateTime? today;
  DateTime? tomorrow;
  DateTime? dayAfterTomorrow;

  //sets the dates for next three days
  // if no date provided then sets the current date
  setDate({DateTime? date}) {
    //selectedDate = date ?? Time().getDate();
    today = date ?? Time().getDate();
    tomorrow = today!.add(const Duration(days: 1));
    dayAfterTomorrow = today!.add(const Duration(days: 2));
  }

  loadDayView({DateTime? date}) async {
    dayViewStatus = Status.loading;

    setDate(date: date);
    todayTimeMasterMap = await getTimeMasterMap(today);
    tomorrowTimeMasterMap = await getTimeMasterMap(tomorrow);
    dayAfterTomorrowTimeMasterMap = await getTimeMasterMap(dayAfterTomorrow);
    dayViewStatus = Status.success;
  }

  // returns the master map
  // where key is time-slot and value will be a list of master available in that time slot
  Future<Map<String, List<MasterModel>>> getTimeMasterMap(DateTime? date) async {
    Map<String, List<MasterModel>> tempMap = {};

    for (MasterModel master in serviceableMasters) {
      {
        final _masterSlots = getMasterSlots(master, chosenDay);
        List<String> _freeSlots = [];

        if (_freeSlots.isNotEmpty) {
          final _availableSlots = Time().checkAvailableSlotsForTheServiceTime(
            _freeSlots,
            int.parse(
              priceAndDuration[master.masterId]?.duration ?? defaultServiceDuration,
            ),
          );

          if (_availableSlots != null) {
            for (String slot in _availableSlots) {
              tempMap[slot] ??= [];
              tempMap[slot]!.add(master);
            }
          }
        }
      }
    }
    return tempMap;
  }

  void selectMasterForBooking(MasterModel master) {
    chooseMasterForBooking = master;
    notifyListeners();
  }

  void changeSelectedCategory(CategoryModel? category) {
    selectedCat = category;
    notifyListeners();
  }

  //returns the cat object on the basis of id
  CategoryModel? getCategoryFromId(String? id) {
    for (CategoryModel cat in categoriesAvailable) {
      if (cat.categoryId == id) return cat;
    }
    return null;
  }

  getTotalDeposit() {
    totalDeposit = 0;

    for (ServiceModel service in chosenServices) {
      totalDeposit += double.parse(service.deposit ?? '0');
    }

    notifyListeners();
  }

  int? confirmationPageIndex;

  changeBookingFlowIndex({bool decrease = false, bool enteringConfirmationView = false}) {
    if (!decrease) {
      bookingFlowPageIndex += 1;
    } else {
      bookingFlowPageIndex -= 1;
    }

    if (enteringConfirmationView) {
      confirmationPageIndex = 0;
    }
    notifyListeners();
  }

  bool checkIfSalonPriceAndMasterPriceIsDifferent() {
    for (ServiceModel service in chosenServices) {
      for (MasterModel master in serviceableMasters) {
        String salonServicePrice = service.priceAndDuration?.price ?? '';
        String masterServicePrice = master.servicesPriceAndDuration?[service.serviceId]?.price ?? '';

        if (salonServicePrice != masterServicePrice) {
          return true;
        }
      }
    }

    // price of service is not different
    return false;
  }

  String getStartTime() {
    if (showModal && selectedAppointmentSlot != null) {
      TimeOfDay _startTime = Time().stringToTime(selectedAppointmentSlot!);

      return Time().timeToString(_startTime) ?? '';
    }

    return '';
  }

  String getEndTime() {
    if (showModal && selectedAppointmentSlot != null) {
      TimeOfDay _startTime = Time().stringToTime(selectedAppointmentSlot!);
      final PriceAndDurationModel _priceAndDuration = priceAndDuration[chosenMaster?.masterId] ?? PriceAndDurationModel();

      TimeOfDay _endTime = _startTime.addMinutes(int.parse(_priceAndDuration.duration!));

      return Time().timeToString(_endTime) ?? '';
    }

    return '';
  }

  /// --------------------------- stop cooking -------------------------------------------------------------------------

  void nextPageView(int index) {
    confirmationPageIndex = index;
    notifyListeners();
    confirmationPageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 100),
      curve: Curves.ease,
    );
  }

  void changeCountryCode(String value) {
    countryCode = value;
    notifyListeners();
  }

  void changeOtp(String value) {
    otp = value;
    notifyListeners();
  }

  setSalon({required SalonModel salonModel, required BuildContext context, required List<ServiceModel> servicesFromSearch, required List<CategoryModel> categories}) async {
    chosenSalon = salonModel;
    //set time slot interval

    // Time().timeSlotSize = Duration(minutes: chosenSalon!.timeSlotsInterval!);
    // Time().timeSlotSizeInt = chosenSalon!.timeSlotsInterval!;
    // await Time().setTimeSlot(chosenSalon!.timeSlotsInterval);
    ownerType = chosenSalon?.ownerType ?? OwnerType.all;
    _clearProvider();
    // print(Time().timeSlotSizeInt);
    calculateValidSlots();
    await _initSalon(salonModel: salonModel, context: context, servicesFromSearch: servicesFromSearch);
    _initCrm(salonId: salonModel.salonId);
    clearSlotsAndSlotsRequired();
    setUpSlots(day: chosenDay, context: context, showNotWorkingToast: false);
    getSalonServices(categories: categories);
    notifyListeners();
  }

  // List<ServiceModel> a333 = [];

  getSalonServices({required List<CategoryModel> categories}) async {
    categoriesAvailable.clear();
    notifyListeners();
    servicesAvailable.clear();
    for (CategoryModel cat in categories) {
      if (categoryServicesMap[cat.categoryId.toString()] != null && categoryServicesMap[cat.categoryId.toString()]!.isNotEmpty) {
        final CategoryModel? categoryModel = categories.firstWhereOrNull(
          (element) => element.categoryId == cat.categoryId.toString(),
        );

        if (categoryModel != null) {
          categoriesAvailable.add(categoryModel);
          notifyListeners();

          List<ServiceModel> services = categoryServicesMap[cat.categoryId.toString()] ?? [];

          List<ServiceModel> availableServices = [];
          // find service where allowClientsBookOnline! = false and remove it
          for (var service in services) {
            if (service.allowClientsBookOnline!) {
              availableServices.add(service);
              // a333.add(service);
            }
          }
          servicesAvailable.add(availableServices);
        }
      }
    }

    // print('****************************########************');
    // print(categoriesAvailable);
    // print('****************************########************');

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
//             // if (_mastersServices.contains(_service.serviceId) && _service.priceAndDuration!.price != '0') {
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
//         if (_service.allowClientsBookOnline!!) {
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
  Future _initSalon({required SalonModel salonModel, required BuildContext context, List<ServiceModel> servicesFromSearch = const []}) async {
    List<ServiceModel> _servicesValidList = [];
    List<String> _mastersServices = [];
    // printIt(salonModel.toJson());

    if (salonModel.ownerType == OwnerType.singleMaster) {
      List<ServiceModel> _servicesList = await CategoryServicesApi().getSalonServices(salonId: salonModel.salonId);

      salonServices = _servicesList; // _clearProvider not clearing list // TODO: FIX LATER

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
      List<MasterModel> _masters = await MastersApi().getAllMaster(salonModel.salonId);

      List<ServiceModel> _servicesList = await CategoryServicesApi().getSalonServices(salonId: salonModel.salonId);

      salonServices = _servicesList; // _clearProvider not clearing list // TODO: FIX LATER

      if (_servicesList.isNotEmpty && _masters.isNotEmpty) {
        for (MasterModel master in _masters) {
          _mastersServices.addAll(master.serviceIds ?? []);
        }
        for (ServiceModel _service in _servicesList) {
          // if (_mastersServices.contains(_service.serviceId) && _service.priceAndDuration!.price != '0') {
          if (_mastersServices.contains(_service.serviceId)) {
            _servicesValidList.add(_service);

            if (_service.allowClientsBookOnline == true) {
              allAvailableServices.add(_service);
            }
          } else {
            // printIt("no master found for ${_service.serviceName}");
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
      if (_service.allowClientsBookOnline!) {
        // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
        // print(_service.serviceName);
        // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

        if (categoryServicesMap[_service.categoryId] == null) {
          categoryServicesMap[_service.categoryId!] = [];
        }
        categoryServicesMap[_service.categoryId]!.add(_service);
        if (categoryServicesMap != {}) {
          categoryServicesMap[_service.categoryId]!.sort((a, b) => a.bookOrderId != null && b.bookOrderId != null ? a.bookOrderId!.compareTo(b.bookOrderId!) : 1);
          loadingStatus = Status.success;
          notifyListeners();
        } else {
          loadingStatus = Status.failed;
          notifyListeners();
        }
      }
    }

    // adding services from search
    if (servicesFromSearch.isNotEmpty) {
      if (salonModel.ownerType == OwnerType.singleMaster) {
        for (ServiceModel _service in servicesFromSearch) {
          toggleService(serviceModel: _service, clearChosenMaster: true, context: null);
        }
      } else {
        for (ServiceModel _service in servicesFromSearch) {
          // if (_mastersServices.contains(_service.serviceId) && _service.priceAndDuration!.price != '0') {
          if (_mastersServices.contains(_service.serviceId)) {
            toggleService(serviceModel: _service, clearChosenMaster: true, context: null);
          } else {
            // showToast("no master serving ${_service.serviceName}");
          }
        }
      }
    }

    salonPromotions = await PromotionServiceApi().getSalonPromotions(salonId: salonModel.salonId);

    notifyListeners();
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
    categoriesAvailable.clear();
    servicesAvailable.clear();
    totalPrice = 0;
    totalMinutes = 0;
    totalTimeWithMaster = 0;
    totalPriceWithMaster = 0;
    appointmentModel = null;
    chosenMaster = null;

    salonProductsBrand = [];

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

  Future<String> chooseMaster({required MasterModel masterModel, required BuildContext context}) async {
    totalTimeWithMaster = 0;
    totalPriceWithMaster = 0;
    calculateMasterVariations();
    if (int.parse(mastersPriceDurationMap[masterModel.masterId]?.price ?? '0') >= 1) {
      chosenMaster = masterModel;
      totalTimeSlotsRequired = (int.parse(mastersPriceDurationMap[masterModel.masterId]?.duration ?? '0') / (chosenSalon!.timeSlotsInterval != null ? chosenSalon!.timeSlotsInterval! : 15)).ceil();
      // printIt(mastersPriceDurationMap[masterModel.masterId]?.duration!);
      setUpSlots(day: chosenDay, context: context, showNotWorkingToast: true);
      notifyListeners();
      return 'choosen';
    } else {
      // printIt('Total Price With Master - $totalPriceWithMaster');
      // printIt('Total Time With Master - $totalTimeWithMaster');

      notifyListeners();
      return "Services Not available";
    }
  }

  Future<String> addMasterToServiceMasterList({required MasterModel masterModel, required BuildContext context}) async {
    totalTimeWithMaster = 0;
    totalPriceWithMaster = 0;
    calculateMasterVariations();
    if (int.parse(mastersPriceDurationMap[masterModel.masterId]?.price ?? '0') >= 1) {
      chosenMaster = masterModel;
      totalTimeSlotsRequired = (int.parse(mastersPriceDurationMap[masterModel.masterId]?.duration ?? '0') / (chosenSalon!.timeSlotsInterval != null ? chosenSalon!.timeSlotsInterval! : 15)).ceil();
      // printIt(mastersPriceDurationMap[masterModel.masterId]?.duration!);
      setUpSlots(day: chosenDay, context: context, showNotWorkingToast: true);
      notifyListeners();
      return 'choosen';
    } else {
      // printIt('Total Price With Master - $totalPriceWithMaster');
      // printIt('Total Time With Master - $totalTimeWithMaster');

      notifyListeners();
      return "Services Not available";
    }
  }

  setMaster({required MasterModel masterModel, required List<CategoryModel> categories}) {
    chosenMaster = masterModel;
    chosenServices.clear();
    masterServicesAvailable.clear();
    masterCategoryAndServices.clear();
    totalPrice = 0;
    totalMinutes = 0;
    notifyListeners();

    // categorize master services
    for (int i = 0; i <= categories.length + 1; i++) {
      List<ServiceModel> _services = mastersServicesMapAll[masterModel.masterId]
              ?.where(
                (element) => element.categoryId == (i).toString(),
              )
              .toList() ??
          [];

      List<ServiceModel> availableServices = [];

      if (_services.isNotEmpty) {
        // find service where allowClientsBookOnline! = false and remove it
        for (var service in _services) {
          if (service.allowClientsBookOnline!) {
            availableServices.add(service);
          }
        }

        masterServicesAvailable.add(availableServices);

        CategoryModel cat = categories.where((element) => element.categoryId == (i).toString()).first;

        masterCategoryAndServices[cat] = _services; // necessary ??
      }
    }

    notifyListeners();
  }

// gets list of master providing sevice
  getMasterProvidingService(ServiceModel service) {
    List<MasterModel> masters = [];
    for (MasterModel element in salonMasters) {
      if (element.serviceIds!.contains(service.serviceId)) {
        masters.add(element);
      }
    }
    return masters;
  }

  getSlotsForSalonOwnerTye({required DateTime day, required BuildContext context, required bool showNotWorkingToast, required List<ServiceAndMaster> masterAndservice}) {
    validSlots.clear();
    allSlots.clear();
    breakSlots.clear();

    int index = 0;
    for (ServiceAndMaster serviceMaster in masterAndservice) {
      Hours? workingHours;
      List<String> validSlotsMaster = [];
      List<String> allSlotsMaster = [];
      List<String> breakSlotsMaster = [];

      if (serviceMaster.master!.irregularWorkingHours != null && serviceMaster.master!.irregularWorkingHours!.containsKey(DateFormat('yyyy-MM-dd').format(chosenDay).toString())) {
        workingHours = serviceMaster.master!.irregularWorkingHours![DateFormat('yyyy-MM-dd').format(chosenDay).toString()];
      } else {
        workingHours = Time().getWorkingHoursFromWeekDay(
          chosenDay.weekday,
          serviceMaster.master!.workingHours,
        );
        // divideSlotsForDay();
      }

      List<String> masterBlocked = [];
      String? dateString = Time().getDateInStandardFormat(chosenDay);
      List<dynamic> slotsBlocked = serviceMaster.master?.blockedTime?[dateString] ?? [];
      for (dynamic slot in slotsBlocked) {
        masterBlocked.add(slot.toString());
      }
      if (workingHours != null) {
        TimeOfDay _startTime = Time().stringToTime(workingHours.startTime);
        TimeOfDay _endTime = Time().stringToTime(workingHours.endTime);
        TimeOfDay _breakStartTime = Time().stringToTime(workingHours.breakStartTime);
        TimeOfDay _breakEndTime = Time().stringToTime(workingHours.breakEndTime);
        allSlotsMaster = Time().getTimeSlots(_startTime, _endTime, step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15)).toList();

        if (workingHours.isWorking) {
          if (chosenDay.day == DateTime.now().day && chosenDay.month == DateTime.now().month) {
            TimeOfDay? _mystartTime = _computeStartTime(workingHours.startTime, chosenDay);
            printIt(_startTime);

            validSlotsMaster = Time().getTimeSlots(_mystartTime, _endTime, step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15)).toList();
          } else {
            validSlotsMaster = Time().getTimeSlots(_startTime, _endTime, step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15)).toList();
          }
          bool isBreakAvailable = Time().getWorkingHoursFromWeekDay(chosenDay.weekday, serviceMaster.master!.workingHours)?.isBreakAvailable ?? false;
          if (isBreakAvailable) {
            printIt('master is taking break on choosen day');
            breakSlotsMaster = Time().getTimeSlots(_breakStartTime, _breakEndTime, step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15)).toList() + masterBlocked;
          } else {
            printIt('master is not taking break on choosen day');
            breakSlotsMaster = masterBlocked;
            printIt(breakSlotsMaster);
          }
          for (String slot in breakSlotsMaster) {
            validSlotsMaster.removeWhere((element) => element == slot);
          }
          serviceAgainstMaster[index].validSlots = validSlotsMaster;

          validSlots.addAll(validSlotsMaster);
          allSlots.addAll(allSlotsMaster);
          breakSlots.addAll(breakSlotsMaster);

          // remove duplicates
          validSlots = validSlots.toSet().toList();
          allSlots = allSlots.toSet().toList();
          allSlots.sort((a, b) => ((Time().stringToTime(a).hour * 60) + (Time().stringToTime(a).minute)).compareTo(((Time().stringToTime(b).hour * 60) + (Time().stringToTime(b).minute))));
          validSlots.sort((a, b) => ((Time().stringToTime(a).hour * 60) + (Time().stringToTime(a).minute)).compareTo(((Time().stringToTime(b).hour * 60) + (Time().stringToTime(b).minute))));
          // make breakTime only break time in all masters

          // print('################################################################################');
          // print('################################################################################');
          // print(validSlotsMaster);
          // print('################################################################################');
          // print('################################################################################');

// [13:15, 13:30, 13:45, 14:00, 14:15, 14:30, 14:45, 15:00, 15:15, 15:30, 15:45, 16:00, 16:15, 16:30, 16:45, 17:00, 17:15, 17:30, 17:45, 18:00, 18:15, 18:30, 18:45, 19:00, 19:15, 19:30, 19:45, 20:00, 20:15, 20:30, 20:45]

          // divideSlotsForDay();
          slotsStatus = Status.success;
          notifyListeners();
        } else {
          if (serviceMaster.master != null && showNotWorkingToast) {
            showToast(AppLocalizations.of(context)?.masterNotWorking ?? "master's not Working");
          }
          slotsStatus = Status.failed;
          notifyListeners();
          notifyListeners();
        }
        // printIt("valid Slots $validSlots");
        // printIt("valid Slots $allSlots");
        // divideSlotsForDay();
      } else {
        slotsStatus = Status.failed;
        notifyListeners();
        debugPrint(allSlots.toString());
      }
      notifyListeners();
      index += 1;
    }
    var map = Map();
    for (var element in breakSlots) {
      if (!map.containsKey(element)) {
        map[element] = 1;
      } else {
        map[element] += 1;
      }
    }
    List newList = map.keys.toList();
    breakSlots.clear();
    for (var element in newList) {
      if (map[element] == masterAndservice.length) {
        breakSlots.add(element);
      }
    }
    breakSlots.sort((a, b) => ((Time().stringToTime(a).hour * 60) + (Time().stringToTime(a).minute)).compareTo(((Time().stringToTime(b).hour * 60) + (Time().stringToTime(b).minute))));
    serviceAgainstMaster.forEach((element) {
      element.NotCommonvalidSlots = element.validSlots != null ? element.validSlots!.where((elem) => !validSlots.contains(elem)).toList() : [];
    });
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
          if (masterModel.serviceIds?.contains(serviceModel.serviceId) ?? false) {
            _service.priceAndDuration?.duration = masterModel.servicesPriceAndDuration?[serviceModel.serviceId]?.duration ?? '0';
            _service.priceAndDuration?.price = masterModel.servicesPriceAndDuration?[serviceModel.serviceId]?.price ?? "0";
            _totalDuration = _totalDuration + (int.tryParse(masterModel.servicesPriceAndDuration?[serviceModel.serviceId]?.duration ?? '0') ?? 0);

            _totalPrice = _totalPrice + (int.tryParse(masterModel.servicesPriceAndDuration?[serviceModel.serviceId]?.price ?? "0") ?? 0);

            _service.priceAndDurationMax!.duration = masterModel.servicesPriceAndDurationMax?[serviceModel.serviceId]?.duration ?? '0';
            _service.priceAndDurationMax!.price = masterModel.servicesPriceAndDurationMax?[serviceModel.serviceId]?.price ?? "0";
            _totalDurationMax = _totalDurationMax +
                ((serviceModel.isFixedDuration != null)
                    ? !serviceModel.isFixedDuration
                        ? int.parse(serviceModel.priceAndDurationMax!.duration!)
                        : (int.tryParse(masterModel.servicesPriceAndDuration?[serviceModel.serviceId]?.duration ?? '0') ?? 0)
                    : int.parse(serviceModel.priceAndDurationMax!.duration!));

            _totalPriceMax = _totalPriceMax + (!serviceModel.isFixedPrice ? int.parse(serviceModel.priceAndDurationMax!.price!) : (int.tryParse(masterModel.servicesPriceAndDuration?[serviceModel.serviceId]?.price ?? "0") ?? 0));
            _services.add(_service);
          }
        }
        mastersPriceDurationMap[masterModel.masterId] = PriceAndDurationModel(
          duration: _totalDuration.toString(),
          price: _totalPrice.toString(),
        );
        printIt("totoal Duration: " + _totalDuration.toString());
        printIt("totoal DurationMax: " + _totalDurationMax.toString());

        mastersPriceDurationMapMax[masterModel.masterId] = PriceAndDurationModel(
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
            _service.priceAndDuration?.duration = masterModel.servicesPriceAndDuration?[_service.serviceId]?.duration ?? '0';
            _service.priceAndDuration?.price = masterModel.servicesPriceAndDuration?[_service.serviceId]?.price ?? '0';
            _services.add(_service);
          }
        }

        mastersServicesMapAll[masterModel.masterId] = _services.toList();

        notifyListeners();
      }
    }
  }

  // toggleForSubItems({required ServiceModel serviceModel, required Function() function}) {
  //   int index = chosenServices.indexWhere((element) => element.serviceId == serviceModel.serviceId);
  //   if (index == -1) {
  //     chosenServices.add(serviceModel);

  //     selected();
  //     // getServiceMasters();
  //     notifyListeners();
  //   } else {
  //     chosenServices.removeAt(index);

  //     unselected();
  //     // getServiceMasters();
  //     notifyListeners();
  //   }
  // }

  toggleCookings({
    required ServiceModel serviceModel,
    required Function() unselected,
    required Function() selected,
    required List<ServiceModel> subItems,
  }) {
    int index = chosenServices.indexWhere((element) => element.serviceId == serviceModel.serviceId);
    if (index == -1) {
      chosenServices.add(serviceModel);

      selected();
      // getServiceMasters();
      notifyListeners();
    } else {
      chosenServices.removeAt(index);

      unselected();

      print(chosenServices);
      // getServiceMasters();
      notifyListeners();
    }
  }

  toggleService({required ServiceModel serviceModel, required bool clearChosenMaster, required BuildContext? context}) async {
    // print('----------TOGGLED SERVICE----------');
    int index = chosenServices.indexWhere((element) => element.serviceId == serviceModel.serviceId);
    if (index == -1) {
      chosenServices.add(serviceModel);

      notifyListeners();
    } else {
      if (chosenSalon?.ownerType != OwnerType.singleMaster) {
        serviceAgainstMaster.removeWhere((element) => element.service!.serviceId == chosenServices[index].serviceId);
      }
      chosenServices.removeAt(index);

      notifyListeners();
    }
    if (clearChosenMaster) {
      chosenMaster = null;
      notifyListeners();
    }

    // print(serviceAgainstMaster);
    // print('----------TOGGLED SERVICE----------');
  }

  bool isAdded({required ServiceModel serviceModel}) {
    int index = chosenServices.indexWhere((element) => element.serviceId == serviceModel.serviceId);
    if (index == -1) {
      return false;
    } else {
      return true;
    }
  }

  // Highlight Category Tab if a service on that category has been selected
  bool isCategoryServiceAdded({required CategoryModel categoryModel}) {
    int index = chosenServices.indexWhere((element) => element.categoryId == categoryModel.categoryId);
    if (index == -1) {
      return false;
    }
    return true;
  }

  calculateAvailableMasters({required DateTime day}) {
    // print('entered here ??? ');
    // print(salonMasters);
    // print('entered here ??? ');

    if (salonMasters.isNotEmpty) {
      availableMasters.clear();

      notifyListeners();

      for (MasterModel master in salonMasters) {
        // print('##############');
        // print(master.workingHours);
        // print('##############');
        if (master.workingHours != null) {
          bool isMasterWorking = (Time().getWorkingHoursFromWeekDay(day.weekday, master.workingHours)?.isWorking == true ||
              (master.irregularWorkingHours != null
                  ? master.irregularWorkingHours!.containsKey(
                      DateFormat('yyyy-MM-dd').format(day).toString(),
                    )
                  : false));

          bool servicesAvailable = mastersServicesMap[master.masterId] != null;
          bool servicesAvailableCount = mastersServicesMap[master.masterId]?.isNotEmpty ?? false;
          // print('---------------------------------------------------------------------------------------------------------');
          // print(servicesAvailable);
          // print(servicesAvailableCount);
          // print(isMasterWorking);
          // print('---------------------------------------------------------------------------------------------------------');
          if (isMasterWorking && servicesAvailable && servicesAvailableCount) {
            availableMasters.add(master);
          }
        }
      }
      // printIt("available masters ${availableMasters.length}");
      notifyListeners();
    }
  }

  Future setUpPromotionSlots({required DateTime day, required BuildContext context, required bool showNotWorkingToast}) async {}

  Future setUpSlots({required DateTime day, required BuildContext context, required bool showNotWorkingToast}) async {
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
      printIt('fatching slots from beauty pro');
      Map<String, List<String>>? slots = await BeautyProEngine().getMasterSlots(day);
      printIt("beauty pro result $slots");
      printIt(chosenMaster?.beautyProId);
      List<String>? _masterslots = slots?[chosenMaster?.beautyProId];
      printIt(_masterslots);
      if (_masterslots != null) {
        if (_masterslots.isEmpty) {
          if (showNotWorkingToast) {
            showToast(AppLocalizations.of(context)?.masterNotWorking ?? "master's not Working");
          }
          slotsStatus = Status.failed;
          notifyListeners();
          return;
        } else {
          allSlots.clear();
          validSlots = _masterslots;
          TimeOfDay _startTime = Time().stringToTime(validSlots.first);
          TimeOfDay _endTime = Time().stringToTime(validSlots.last);
          if (chosenDay.day == DateTime.now().day && chosenDay.month == DateTime.now().month) {
            List<String> _pastSlots = Time()
                .generateTimeSlots(
                  _startTime,
                  TimeOfDay.now(),
                  timeSlotSizeDuration: chosenSalon!.timeSlotsInterval,
                )
                .toList();
            for (String slot in _pastSlots) {
              validSlots.remove(slot);
            }
          }
          allSlots = Time().getTimeSlots(_startTime, _endTime, step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15)).toList();
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
      List<String>? slots = await YClientsEngine().getMasterSlots(day, master: chosenMaster!);
      // printIt("yclient result $slots");
      List<String>? _masterslots = slots;
      // printIt(_masterslots);
      if (_masterslots != null) {
        if (_masterslots.isEmpty) {
          if (showNotWorkingToast) {
            showToast(AppLocalizations.of(context)?.masterNotWorking ?? "master's not Working");
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
          if (chosenDay.day == DateTime.now().day && chosenDay.month == DateTime.now().month) {
            List<String> _pastSlots = Time()
                .generateTimeSlots(
                  _startTime,
                  TimeOfDay.now(),
                  step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15),
                  timeSlotSizeDuration: chosenSalon!.timeSlotsInterval,
                )
                .toList();
            for (String slot in _pastSlots) {
              validSlots.remove(slot);
            }
          }
          allSlots = Time().getTimeSlots(_startTime, _endTime, step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15)).toList();
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

        if (chosenSalon!.irregularWorkingHours != null && chosenSalon!.irregularWorkingHours!.containsKey(DateFormat('yyyy-MM-dd').format(chosenDay).toString())) {
          workingHours = chosenSalon!.irregularWorkingHours![DateFormat('yyyy-MM-dd').format(chosenDay).toString()];
        } else {
          workingHours = Time().getWorkingHoursFromWeekDay(chosenDay.weekday, chosenSalon!.workingHours);
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
          TimeOfDay _breakStartTime = Time().stringToTime(workingHours.breakStartTime);
          TimeOfDay _breakEndTime = Time().stringToTime(workingHours.breakEndTime);
          allSlots = Time().getTimeSlots(_startTime, _endTime, step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15)).toList();
          if (workingHours.isWorking) {
            if (chosenDay.day == DateTime.now().day && chosenDay.month == DateTime.now().month) {
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
              TimeOfDay? _mystartTime = _computeStartTime(workingHours.startTime, chosenDay);
              // printIt(_mystartTime);
              validSlots = Time().getTimeSlots(_mystartTime, _endTime, step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15)).toList();
              // }
            } else {
              validSlots = Time().getTimeSlots(_startTime, _endTime, step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15)).toList();
            }
            bool isBreakAvailable = Time().getWorkingHoursFromWeekDay(chosenDay.weekday, (chosenSalon?.ownerType == OwnerType.salon) ? chosenMaster?.workingHours : chosenSalon!.workingHours)?.isBreakAvailable ?? false;
            if (isBreakAvailable) {
              // printIt('master is taking break on choosen day');
              breakSlots = Time().getTimeSlots(_breakStartTime, _breakEndTime, step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15)).toList() + _blokedSlots;
            } else {
              // printIt('master is not taking break on choosen day');
              breakSlots = _blokedSlots;
            }
            for (String slot in breakSlots) {
              validSlots.removeWhere((element) => element == slot);
            }
            // printIt('lets see all slots');
            // printIt(allSlots.toString());

            slotsStatus = Status.success;
            notifyListeners();
          } else {
            validSlots.clear();
            if (showNotWorkingToast) {
              showToast(AppLocalizations.of(context)?.masterNotWorking ?? "master's not Working");
            }
            slotsStatus = Status.failed;
            notifyListeners();
          }
          divideSlotsForDay();
          // printIt("valid Slots $validSlots");
        } else {
          debugPrint(allSlots.toString());
          slotsStatus = Status.failed;
          notifyListeners();
        }
      } else {
        Hours? workingHours;

        if (chosenSalon!.irregularWorkingHours != null && chosenSalon!.irregularWorkingHours!.containsKey(DateFormat('yyyy-MM-dd').format(chosenDay).toString())) {
          workingHours = chosenSalon!.irregularWorkingHours![DateFormat('yyyy-MM-dd').format(chosenDay).toString()];
        } else {
          workingHours = Time().getWorkingHoursFromWeekDay(
            chosenDay.weekday,
            (chosenMaster == null) ? chosenSalon!.workingHours : chosenMaster!.workingHours,
          );
          // divideSlotsForDay();
        }

        List<String> masterBlocked = [];
        String? dateString = Time().getDateInStandardFormat(chosenDay);
        List<dynamic> slotsBlocked = chosenMaster?.blockedTime?[dateString] ?? [];
        for (dynamic slot in slotsBlocked) {
          masterBlocked.add(slot.toString());
        }
        if (workingHours != null) {
          TimeOfDay _startTime = Time().stringToTime(workingHours.startTime);
          TimeOfDay _endTime = Time().stringToTime(workingHours.endTime);
          TimeOfDay _breakStartTime = Time().stringToTime(workingHours.breakStartTime);
          TimeOfDay _breakEndTime = Time().stringToTime(workingHours.breakEndTime);
          allSlots = Time().getTimeSlots(_startTime, _endTime, step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15)).toList();

          if (workingHours.isWorking) {
            if (chosenDay.day == DateTime.now().day && chosenDay.month == DateTime.now().month) {
              TimeOfDay? _mystartTime = _computeStartTime(workingHours.startTime, chosenDay);
              printIt(_startTime);

              validSlots = Time().getTimeSlots(_mystartTime, _endTime, step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15)).toList();
            } else {
              validSlots = Time().getTimeSlots(_startTime, _endTime, step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15)).toList();
            }
            bool isBreakAvailable = Time().getWorkingHoursFromWeekDay(chosenDay.weekday, (chosenSalon?.ownerType == OwnerType.salon) ? chosenMaster?.workingHours : chosenSalon!.workingHours)?.isBreakAvailable ?? false;
            if (isBreakAvailable) {
              // printIt('master is taking break on choosen day');
              breakSlots = Time().getTimeSlots(_breakStartTime, _breakEndTime, step: Duration(minutes: chosenSalon!.timeSlotsInterval ?? 15)).toList() + masterBlocked;
            } else {
              // printIt('master is not taking break on choosen day');
              breakSlots = masterBlocked;
            }
            for (String slot in breakSlots) {
              validSlots.removeWhere((element) => element == slot);
            }
            divideSlotsForDay();
            slotsStatus = Status.success;
            notifyListeners();
          } else {
            validSlots.clear();
            if (chosenMaster != null && showNotWorkingToast) {
              showToast(AppLocalizations.of(context)?.masterNotWorking ?? "master's not Working");
            }
            slotsStatus = Status.failed;
            notifyListeners();
            notifyListeners();
          }
          // printIt("valid Slots $validSlots");
          // printIt("valid Slots $allSlots");
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
    int morningIndex = allSlots.indexWhere((element) => Time().stringToTime(element).hour >= 12);
    int afterNoonIndex = allSlots.indexWhere((element) => Time().stringToTime(element).hour >= 17);

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

  final Time _time = Time();

  /// computes the start time
  /// by comparing following parameters :
  /// 1. masterStartTime
  /// 2. salonStartTime
  /// 3. currentTime
  /// it will take which ever is max
  /// in case of single master it will not fuse salonStartTime and masterStartTime, since only 1 is present
  TimeOfDay? _computeStartTime(String? masterStartTime, DateTime date, {MasterModel? master, bool irregular = false}) {
    try {
      DateTime _now = DateTime.now();

      late TimeOfDay _masterAndSalonFusedTime;
      // added this on the fly..but it seems to solve the problem
      _masterAndSalonFusedTime = _time.stringToTime(masterStartTime!);
      if (chosenSalon!.ownerType == OwnerType.singleMaster) {
        _masterAndSalonFusedTime = _time.stringToTime(masterStartTime);
      } else {
        //getting salon timings
        Hours? selectedSalonHours;
        if (irregular) {
          selectedSalonHours = _time.getMasterIrregularWorkingHours(
            master!,
            date: date,
          )!;
          // if it's still null then we reverted to old version
          if (selectedSalonHours == null) {
            selectedSalonHours = _time.getIrregularWorkingHours(
              chosenSalon?.irregularWorkingHours,
              date: date,
            );
          }
        } else {
          selectedSalonHours = _time.getRegularWorkingHoursFromDate(
            chosenSalon?.workingHours,
            weekDay: date.weekday,
          )!;
        }
        if (!selectedSalonHours!.isWorking) return null;

        TimeOfDay _salonStartTime = _time.stringToTime(selectedSalonHours.startTime);

        TimeOfDay _masterStartTime = _time.stringToTime(masterStartTime);

        // computes the starting time by comparing master and salon starting time
        TimeOfDay _masterAndSalonFusedTime = _time.getMinMaxTime(_salonStartTime, _masterStartTime, returnMaxTime: true);
      }

      if (_time.compareDate(date, _now)) {
        //dates are same, Then it
        // computes the start time by comparing current time and master working time

        // for the effect of restricted time before appointment
        if (chosenSalon!.appointmentsLeadTime != null) {
          _now = _now.add(Duration(minutes: chosenSalon!.appointmentsLeadTime!));
        }
        TimeOfDay _currentTime = TimeOfDay(hour: _now.hour, minute: _now.minute);
        return _time.getMinMaxTime(_currentTime, _masterAndSalonFusedTime, returnMaxTime: true);
      } else {
        return _masterAndSalonFusedTime;
      }
    } catch (e) {
      debugPrint('error while generating start time');
      (e);
      return _time.stringToTime(masterStartTime!);
    }
  }

  TimeOfDay? _computeStartTimeFormer(String? masterStartTime, DateTime date) {
    try {
      DateTime _now = DateTime.now();

      late TimeOfDay _masterAndSalonFusedTime;
      // added this on the fly..but it seems to solve the problem
      _masterAndSalonFusedTime = _time.stringToTime(masterStartTime!);
      if (chosenSalon!.ownerType == OwnerType.singleMaster) {
        _masterAndSalonFusedTime = _time.stringToTime(masterStartTime);
      } else {
        //getting salon timings
        Hours selectedSalonHours = _time.getRegularWorkingHoursFromDate(
          chosenSalon?.workingHours,
          weekDay: date.weekday,
        )!;

        if (!selectedSalonHours.isWorking) return null;

        TimeOfDay _salonStartTime = _time.stringToTime(selectedSalonHours.startTime);

        TimeOfDay _masterStartTime = _time.stringToTime(masterStartTime);

        // computes the starting time by comparing master and salon starting time
        TimeOfDay _masterAndSalonFusedTime = _time.getMinMaxTime(_salonStartTime, _masterStartTime, returnMaxTime: true);
      }

      if (_time.compareDate(date, _now)) {
        //dates are same, Then it
        // computes the start time by comparing current time and master working time

        // for the effect of restricted time before appointment
        if (chosenSalon!.appointmentsLeadTime != null) {
          _now = _now.add(Duration(minutes: chosenSalon!.appointmentsLeadTime!));
        }
        TimeOfDay _currentTime = TimeOfDay(hour: _now.hour, minute: _now.minute);
        debugPrint(TimeOfDay(hour: _now.hour, minute: _now.minute).toString());
        debugPrint(_masterAndSalonFusedTime.toString());
        return _time.getMinMaxTime(_currentTime, _masterAndSalonFusedTime, returnMaxTime: true);
      } else {
        return _masterAndSalonFusedTime;
      }
    } catch (e) {
      debugPrint('error while generating start time');
      debugPrint(e.toString());
      return _time.stringToTime(masterStartTime!);
    }
  }

  calculateValidSlots() {
    clearChoosenSlots();
    totalMinutes = 0;
    totalMinutesWithFixed = 0;
    for (ServiceModel serviceModel in chosenServices) {
      // printIt(serviceModel.toJson());
      totalMinutes = totalMinutes +
          (serviceModel.isFixedDuration != null
              ? !serviceModel.isFixedDuration
                  ? int.parse(serviceModel.priceAndDurationMax!.duration!)
                  : int.parse(serviceModel.priceAndDuration!.duration!)
              : int.parse(serviceModel.priceAndDuration!.duration!));
      totalMinutesWithFixed = totalMinutesWithFixed + int.parse(serviceModel.priceAndDuration!.duration!);
      // printIt(totalMinutes);
      notifyListeners();
    }
    totalTimeSlotsRequired = (totalMinutes / (chosenSalon!.timeSlotsInterval != null ? chosenSalon!.timeSlotsInterval! : 15)).ceil();
    if (totalMinutes <= (chosenSalon!.timeSlotsInterval != null ? chosenSalon!.timeSlotsInterval! : 15)) {
      totalMinutes = chosenSalon!.timeSlotsInterval ?? 15;
      totalTimeSlotsRequired = 1;
    }
    notifyListeners();
    // printIt('total time and slots required $totalMinutes $totalTimeSlotsRequired');
  }

  bool checkContinuousSlots({required MasterModel master, required List<String> slotspresent}) {
    List<int> indexes = [];
    // since we noLonger work with 3 days in a row
    // we only check against the first day
    for (int i = 0; i <= slotspresent.length - 1; i++) {
      indexes.add(allAppointments[master.masterId]!.indexWhere((element) => element == slotspresent[i]));
    }
    for (int i = 0; i < indexes.length - 1; i++) {
      if (indexes[i + 1] - indexes[i] != 1) {
        return false;
      }
    }

    return true;
  }

  // Future chooseSlot(String slot, BuildContext context) async {
  //   printIt("choosing slots $totalTimeSlotsRequired");
  //   if (totalTimeSlotsRequired != 0) {
  //     if (totalTimeSlotsRequired > validSlots.length) {
  //       showToast(AppLocalizations.of(context)?.notEnoughSlots ?? "Not enough slots");
  //     } else {
  //       int index = validSlots.indexWhere((element) => element == slot);
  //       if (index != -1) {
  //         if (index == 0) {
  //           chosenSlots = validSlots.getRange(index, totalTimeSlotsRequired).toList();
  //           notifyListeners();
  //           printIt(chosenSlots);
  //         } else if (index > validSlots.length - totalTimeSlotsRequired) {
  //           chosenSlots = validSlots.getRange(validSlots.length - (totalTimeSlotsRequired), validSlots.length).toList();
  //           notifyListeners();
  //           printIt(chosenSlots);
  //         } else {
  //           chosenSlots = validSlots.getRange(index, (index + totalTimeSlotsRequired)).toList();
  //           printIt(chosenSlots);

  //           notifyListeners();
  //         }
  //         bool continues = checkContinuousSlots(slots: chosenSlots);
  //         if (!continues) {
  //           chosenSlots = [];
  //           notifyListeners();
  //           showToast(AppLocalizations.of(context)?.slotsNotAvailable ?? 'Slots not available');
  //         } else {
  //           printIt(chosenDay);
  //           notifyListeners();
  //           showToast(AppLocalizations.of(context)?.slotsChoosen ?? 'slots chosen');
  //         }
  //       } else {
  //         chosenSlots = [];
  //         notifyListeners();
  //         showToast(AppLocalizations.of(context)?.slotsNotAvailable ?? 'Slots not available');
  //       }
  //     }
  //   } else {
  //     showToast(AppLocalizations.of(context)?.noServices ?? 'no services');
  //   }
  // }

  bool checkSlotsAndMaster({required BuildContext context}) {
    final bool isMasterNull = (chosenMaster == null && chosenSalon!.ownerType == OwnerType.salon);
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

    bool isWorking = Time().getWorkingHoursFromWeekDay(chosenDay.weekday, (chosenSalon?.ownerType == OwnerType.salon) ? chosenMaster?.workingHours : chosenSalon!.workingHours)?.isWorking == true || chosenSalon!.irregularWorkingHours!.containsKey(DateFormat('yyyy-MM-dd').format(chosenDay).toString());
    printIt("working today $isWorking");
    if (!isWorking) {
      showToast(AppLocalizations.of(context)?.masterNotAvlblDay ?? 'master not available on choosen day');
    }
    if (isMasterNull || chosenSlots.contains('') || chosenSlots.isEmpty || chosenServices.isEmpty || !isWorking) {
      return false;
    } else {
      return true;
    }
  }

  ///creates appointment in integration, both in yClient and beautyPro
  /// Takes in [AppointmentModel] as input and returns app [AppointmentModel] with either beautyPro or yClientsId
  /// will return [AppointmentModel] back as it is without any change if integration is inactive
  /// will return [null] in case of error, so u need to abort current appointment and show user error
  Future<AppointmentModel?> createAppointmentInIntegration(AppointmentModel app, MasterModel master) async {
    AppointmentModel _app;
    //booking in beauty pro
    //  picking the booking from suitable integration
    //  if beauty-pro id is present means system has integration with beauty pro, same with yclients
    //  so will pickup that integration
    if (beautyProActive) {
      final AppointmentModel? _appointmentWithBeautyPro = await BeautyProEngine().makeAppointment(app, master.beautyProId);

      if (_appointmentWithBeautyPro == null) {
        showToast("Booking failed..");
        return null;
      } else {
        _app = _appointmentWithBeautyPro;
        return _app;
      }
    } else if (yclientActive) {
      //booking in yClients
      final AppointmentModel? _appointmentWithYClients = await YClientsEngine().makeAppointment(app, master.yClientsId);
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

  creatAppointmentSalonOwner({required CustomerModel? customerModel, required BuildContext context}) {
    int index = 0;
    DateTime? nextStart;

    List<ServiceAndMaster> serviceMasterDup = serviceAgainstMaster.map<ServiceAndMaster>((e) => e).toList();
    var locale = AppLocalizations.of(context)?.localeName.toString().toLowerCase();

    // loop through the present service to master
    for (int i = 0; i < serviceAgainstMaster.length; i++) {
      DateTime? _startTime;
      if (nextStart != null) {
        _startTime = nextStart;
      } else {
        _startTime = DateTime(
          chosenDay.year,
          chosenDay.month,
          chosenDay.day,
          int.parse(chosenSlots.first.split(':')[0]),
          int.parse(chosenSlots.first.split(':')[1]),
        );
      }
      int timeOfDayInNumber = (TimeOfDay.fromDateTime(_startTime).hour * 60) + TimeOfDay.fromDateTime(_startTime).minute;
      int remainder = timeOfDayInNumber % (chosenSalon!.timeSlotsInterval ?? 15);
      int toAdd = (chosenSalon!.timeSlotsInterval ?? 15) - remainder;

      int nearestStepStartTime = timeOfDayInNumber + toAdd;
      ServiceAndMaster? MasterServiceAtPresentTime;
      if (serviceMasterDup
          .where(
            (element) => element.NotCommonvalidSlots!.contains(
              Time().timeToString(
                TimeOfDay.fromDateTime(DateTime(
                  chosenDay.year,
                  chosenDay.month,
                  chosenDay.day,
                  nearestStepStartTime ~/ 60,
                  nearestStepStartTime % 60,
                )),
              ),
            ),
          )
          .toList()
          .isNotEmpty) {
        MasterServiceAtPresentTime = serviceMasterDup
            .where(
              (element) => element.NotCommonvalidSlots!.contains(Time()
                  .timeToString(
                    TimeOfDay.fromDateTime(DateTime(
                      chosenDay.year,
                      chosenDay.month,
                      chosenDay.day,
                      nearestStepStartTime ~/ 60,
                      nearestStepStartTime % 60,
                    )),
                  )
                  .toString()),
            )
            .toList()[0];
      } else {
        // print("this is time" +
        //     Time()
        //         .timeToString(TimeOfDay.fromDateTime(DateTime(
        //           chosenDay.year,
        //           chosenDay.month,
        //           chosenDay.day,
        //           nearestStepStartTime ~/ 60,
        //           nearestStepStartTime % 60,
        //         )))
        //         .toString());

        MasterServiceAtPresentTime = serviceMasterDup
            .where(
              (element) => (element.validSlots!).contains(Time()
                  .timeToString(
                    TimeOfDay.fromDateTime(DateTime(
                      chosenDay.year,
                      chosenDay.month,
                      chosenDay.day,
                      nearestStepStartTime ~/ 60,
                      nearestStepStartTime % 60,
                    )),
                  )
                  .toString()),
            )
            .toList()[0];
      }
      //  total price and duration

      DateTime _endTime = _startTime.add(
        Duration(
          minutes: MasterServiceAtPresentTime.service!.isFixedDuration != null
              ? !MasterServiceAtPresentTime.service!.isFixedDuration
                  ? int.parse(MasterServiceAtPresentTime.service!.priceAndDurationMax!.duration!)
                  : int.parse(MasterServiceAtPresentTime.service!.priceAndDuration!.duration!)
              : int.parse(MasterServiceAtPresentTime.service!.priceAndDuration!.duration!),
        ),
      );
      nextStart = _endTime;

      final List<Service> _services = [Service.fromService(serviceModel: MasterServiceAtPresentTime.service!)];
      notifyListeners();

      ///if selected service is greater than one
      if (_services.length > 1) {
        ///model for multiple service block
        // appointmentModel = _createMultipleServiceAppointmentModel(
        //   services: _services,
        //   startTime: _startTime,
        //   endTime: _endTime,
        //   appointmentTime: Time().timeToString(TimeOfDay.fromDateTime(_startTime))!,
        //   customerModel: customerModel,
        //   priceAndDuration: PriceAndDurationModel(
        //     duration: MasterServiceAtPresentTime.service!.isPriceRange
        //         ? int.parse(
        //             MasterServiceAtPresentTime.service!.priceAndDurationMax!.duration!!,
        //           ).toString()
        //         : int.parse(MasterServiceAtPresentTime.service!.priceAndDuration!.duration!).toString(),
        //     price: MasterServiceAtPresentTime.service!.isPriceRange
        //         ? int.parse(MasterServiceAtPresentTime.service!.priceAndDurationMax!.price!).toString()
        //         : int.parse(
        //             MasterServiceAtPresentTime.service!.priceAndDuration!.price,
        //           ).toString(),
        //   ),
        //   master: Master(
        //     id: serviceAgainstMaster.where((element) => element.service?.serviceId == MasterServiceAtPresentTime!.service!.serviceId).toList().isNotEmpty
        //         ? serviceAgainstMaster.where((element) => element.service!.serviceId == MasterServiceAtPresentTime!.service!.serviceId).toList()[0].master!.masterId
        //         : getMasterProvidingService(
        //             MasterServiceAtPresentTime.service!,
        //           )[0]
        //             .masterId,
        //     name: Utils().getNameMaster(
        //       serviceAgainstMaster.where((element) => element.service?.serviceId == MasterServiceAtPresentTime!.service!.serviceId).toList().isNotEmpty
        //           ? serviceAgainstMaster.where((element) => element.service!.serviceId == MasterServiceAtPresentTime!.service!.serviceId).toList()[0].master!.personalInfo
        //           : getMasterProvidingService(
        //               MasterServiceAtPresentTime.service!,
        //             )[0]
        //               .personalInfo,
        //     ),
        //   ),
        // );
      } else {
        // appointmentModel = _createAppointmentModel(
        //   services: _services,
        //   startTime: _startTime,
        //   endTime: _endTime,
        //   appointmentTime: Time().timeToString(TimeOfDay.fromDateTime(_startTime))!,
        //   customerModel: customerModel,
        //   priceAndDuration: PriceAndDurationModel(
        //     duration: MasterServiceAtPresentTime.service!.isPriceRange
        //         ? int.parse(
        //             MasterServiceAtPresentTime.service!.priceAndDurationMax!.duration!!,
        //           ).toString()
        //         : int.parse(MasterServiceAtPresentTime.service!.priceAndDuration!.duration!).toString(),
        //     price: MasterServiceAtPresentTime.service!.isPriceRange
        //         ? int.parse(MasterServiceAtPresentTime.service!.priceAndDurationMax!.price!).toString()
        //         : int.parse(
        //             MasterServiceAtPresentTime.service!.priceAndDuration!.price,
        //           ).toString(),
        //   ),
        //   master: Master(
        //     id: serviceAgainstMaster.where((element) => element.service?.serviceId == MasterServiceAtPresentTime!.service!.serviceId).toList().isNotEmpty
        //         ? serviceAgainstMaster.where((element) => element.service!.serviceId == MasterServiceAtPresentTime!.service!.serviceId).toList()[0].master!.masterId
        //         : getMasterProvidingService(
        //             MasterServiceAtPresentTime.service!,
        //           )[0]
        //             .masterId,
        //     name: Utils().getNameMaster(
        //       serviceAgainstMaster.where((element) => element.service?.serviceId == MasterServiceAtPresentTime!.service!.serviceId).toList().isNotEmpty
        //           ? serviceAgainstMaster.where((element) => element.service!.serviceId == MasterServiceAtPresentTime!.service!.serviceId).toList()[0].master!.personalInfo
        //           : getMasterProvidingService(
        //               MasterServiceAtPresentTime.service!,
        //             )[0]
        //               .personalInfo,
        //     ),
        // ),
        // );
      }

      // appointmentModel = AppointmentModel(
      //   appointmentStartTime: _startTime,
      //   appointmentEndTime: _endTime,
      //   createdAt: DateTime.now(),
      //   appointmentTime: Time().timeToString(TimeOfDay.fromDateTime(_startTime))!,
      //   appointmentDate: Time().getDateInStandardFormat(chosenDay) ?? '',
      //   appointmentId: '',
      //   locale: locale,
      //   // firstName: ,
      //   createdBy: CreatedBy.customer,
      //   bookedForSelf: bookedForSelf,
      //   updates: [AppointmentUpdates.createdByCustomer],
      //   status: chosenSalon!.requestSalon ? AppointmentStatus.requested : AppointmentStatus.active,
      //   subStatus: (chosenSalon!.isAutomaticBookingConfirmation == true) ? AppointmentSubStatus.confirmed : AppointmentSubStatus.unconfirmed,
      //   services: _services,
      //   customer: Customer(
      //     id: customerModel!.customerId, //"00iomPh4TKeE1GFGSNqI",
      //     name: Utils().getName(customerModel.personalInfo), //"Banjo Oluwatimmy",
      //     phoneNumber: customerModel.personalInfo.phone,
      //     pic: "",
      //     email: customerModel.personalInfo.email ?? '',
      //   ),
      //   priceAndDuration: PriceAndDurationModel(
      //     duration: MasterServiceAtPresentTime.service!.isPriceRange
      //         ? int.parse(
      //             MasterServiceAtPresentTime.service!.priceAndDurationMax!.duration!!,
      //           ).toString()
      //         : int.parse(MasterServiceAtPresentTime.service!.priceAndDuration!.duration!).toString(),
      //     price: MasterServiceAtPresentTime.service!.isPriceRange
      //         ? int.parse(MasterServiceAtPresentTime.service!.priceAndDurationMax!.price!).toString()
      //         : int.parse(
      //             MasterServiceAtPresentTime.service!.priceAndDuration!.price,
      //           ).toString(),
      //   ),

      //   paymentInfo: null,
      //   master: Master(
      //     id: serviceAgainstMaster.where((element) => element.service?.serviceId == MasterServiceAtPresentTime!.service!.serviceId).toList().isNotEmpty ? serviceAgainstMaster.where((element) => element.service!.serviceId == MasterServiceAtPresentTime!.service!.serviceId).toList()[0].master!.masterId : getMasterProvidingService(MasterServiceAtPresentTime.service!)[0].masterId,
      //     name: Utils().getNameMaster(serviceAgainstMaster.where((element) => element.service?.serviceId == MasterServiceAtPresentTime!.service!.serviceId).toList().isNotEmpty ? serviceAgainstMaster.where((element) => element.service!.serviceId == MasterServiceAtPresentTime!.service!.serviceId).toList()[0].master!.personalInfo : getMasterProvidingService(MasterServiceAtPresentTime.service!)[0].personalInfo),
      //   ),
      //   salon: Salon(
      //     id: chosenSalon!.salonId,
      //     name: chosenSalon!.salonName,
      //     address: chosenSalon!.address,
      //     // location: chosenSalon!.position!,
      //     phoneNo: chosenSalon!.phoneNumber,
      //   ),
      //   bookedForName: bookedForSelf ? bookedForName : '',
      //   bookedForPhoneNo: bookedForSelf ? bookedForPhone : '',
      //   chatId: '',
      //   note: '',
      //   salonOwnerType: chosenSalon!.ownerType,
      //   type: AppointmentType.reservation,
      //   masterReviewed: false,
      //   salonReviewed: false,
      //   updatedAt: [DateTime.now()],
      // );
      // printIt(appointmentModel!.toJson());
      appointmentModelSalonOwner!.add(appointmentModel!);

// remove from duplicate so we don't loop through uncessary element..and to prevent duplicate booking
      serviceMasterDup.removeWhere(
        (
          element,
        ) =>
            element.service!.serviceId == MasterServiceAtPresentTime!.service!.serviceId,
      );
    }
  }

  Future<bool> createAppointment({required CustomerModel? customerModel, required BuildContext context}) async {
    if (chosenServices.isEmpty) {
      showToast(' no services');
    } else {
      // printIt(chosenSlots);

      //  total price and duration
      PriceAndDurationModel _totalPriceAndDuration = chosenSalon!.ownerType == OwnerType.singleMaster
          ? PriceAndDurationModel(
              duration: totalMinutes.toString(),
              price: totalPrice.toString(),
            )
          : mastersPriceDurationMapMax[chosenMaster!.masterId]!;

      var locale = AppLocalizations.of(context)?.localeName.toString().toLowerCase();

      // printIt("Chosen Slots");
      // printIt(chosenSlots);

      DateTime _startTime = DateTime(
        chosenDay.year,
        chosenDay.month,
        chosenDay.day,
        int.parse(chosenSlots.first.split(':')[0]),
        int.parse(chosenSlots.first.split(':')[1]),
      );

      DateTime _endTime = _startTime.add(
        Duration(minutes: int.parse(_totalPriceAndDuration.duration!)),
      );

      final List<Service> _services = chosenSalon!.ownerType == OwnerType.singleMaster
          ? chosenServices.map((element) => Service.fromService(serviceModel: element)).toList()
          : mastersServicesMap[chosenMaster!.masterId]!
              .map(
                (element) => Service.fromService(
                  serviceModel: element,
                  masterPriceAndDuration: (chosenMaster!.servicesPriceAndDuration == null) ? chosenMaster!.servicesPriceAndDurationMax![element.serviceId] : chosenMaster!.servicesPriceAndDuration![element.serviceId],
                ),
              )
              .toList();

      notifyListeners();

      ///if selected service is greater than one
      if (_services.length > 1) {
        ///model for multiple service block
        // appointmentModel = _createMultipleServiceAppointmentModel(
        //   services: _services,
        //   startTime: _startTime,
        //   endTime: _endTime,
        //   customerModel: customerModel,
        //   priceAndDuration: _totalPriceAndDuration,
        //   master: chosenSalon!.ownerType == OwnerType.singleMaster
        //       ? Master(
        //           id: chosenSalon!.salonId,
        //           name: chosenSalon!.salonName,
        //         )
        //       : Master(
        //           id: chosenMaster!.masterId,
        //           name: Utils().getNameMaster(chosenMaster!.personalInfo),
        //         ),
        // );
      } else {
        // appointmentModel = _createAppointmentModel(
        //   services: _services,
        //   startTime: _startTime,
        //   endTime: _endTime,
        //   customerModel: customerModel,
        //   priceAndDuration: _totalPriceAndDuration,
        //   master: chosenSalon!.ownerType == OwnerType.singleMaster
        //       ? Master(
        //           id: chosenSalon!.salonId,
        //           name: chosenSalon!.salonName,
        //         )
        //       : Master(
        //           id: chosenMaster!.masterId,
        //           name: Utils().getNameMaster(chosenMaster!.personalInfo),
        //         ),
        // );
      }

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
      PriceAndDurationModel _totalPriceAndDuration = chosenSalon!.ownerType == OwnerType.singleMaster
          ? PriceAndDurationModel(
              duration: totalMinutes.toString(),
              price: totalPrice.toString(),
            )
          : mastersPriceDurationMapMax[chosenMaster!.masterId]!;

      var locale = AppLocalizations.of(context)?.localeName.toString().toLowerCase();

      printIt("Chosen Slots");
      printIt(chosenSlots);
      DateTime _startTime = DateTime(chosenDay.year, chosenDay.month, chosenDay.day, int.parse(chosenSlots.first.split(':')[0]), int.parse(chosenSlots.first.split(':')[1]));

      DateTime _endTime = _startTime.add(Duration(minutes: int.parse(_totalPriceAndDuration.duration!)));

      final List<Service> _services = chosenSalon!.ownerType == OwnerType.singleMaster ? chosenServices.map((element) => Service.fromService(serviceModel: element)).toList() : mastersServicesMap[chosenMaster!.masterId]!.map((element) => Service.fromService(serviceModel: element, masterPriceAndDuration: chosenMaster!.servicesPriceAndDuration![element.serviceId])).toList();

      appointmentModel = AppointmentModel(
        appointmentStartTime: _startTime,
        appointmentEndTime: _endTime,
        createdAt: DateTime.now(),
        appointmentTime: chosenSlots.first,
        appointmentDate: Time().getDateInStandardFormat(chosenDay) ?? '',
        locale: locale,
        // firstName: ,
        createdBy: CreatedBy.customer,
        bookedForSelf: bookedForSelf,
        updates: [AppointmentUpdates.createdByCustomer],
        status: chosenSalon!.requestSalon ? AppointmentStatus.requested : AppointmentStatus.active,
        subStatus: (chosenSalon!.isAutomaticBookingConfirmation == true) ? ActiveAppointmentSubStatus.confirmed : ActiveAppointmentSubStatus.unConfirmed,

        services: _services,
        customer: Customer(
          id: "customerModel!.customerId",
          name: "Utils().getName(customerModel.personalInfo)",
          phoneNumber: " customerModel.personalInfo.phone",
          pic: " customerModel.profilePic",
          email: '',
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

  Future<bool> finishBooking({required BuildContext context, required CustomerModel customerModel}) async {
    loadingStatus = Status.loading;
    notifyListeners();
    // if (customerModel.salonIdsBlocked!.contains(chosenSalon!.salonId)) {
    //   showToast("You have been blocked from making appointments by this salon");
    //   loadingStatus = Status.failed;
    //   notifyListeners();
    //   return false;
    // }

    if (ownerType == OwnerType.singleMaster) {
      if (appointmentModel != null) {
        // PaymentInfo _paymentInfo = PaymentInfo(
        //   bonusApplied: chosenBonus != null,
        //   bonusAmount: chosenBonus?.amount ?? 0,
        //   actualAmount: double.parse(appointmentModel?.priceAndDuration!.price ?? '0').toInt(),
        //   bonusIds: chosenBonus != null ? [chosenBonus!.bonusId] : [],
        //   paymentDone: false,
        //   onlinePayment: false,
        //   paymentMethod: PaymentMethods.cardSalon,
        // );

        ///passes discounted amount in priceAndDuration model
        if (chosenBonus != null) {
          final discountedAmount = (double.parse(appointmentModel?.priceAndDuration.price ?? '0').toInt() - chosenBonus!.amount);
          if (discountedAmount < 0) {
            appointmentModel?.priceAndDuration.price = '0';
          } else {
            appointmentModel?.priceAndDuration.price = discountedAmount.toString();
          }
        }

        // Check no of services booked in appointment model
        if (appointmentModel!.services.length > 1) {
          ///saves appointments when service is more that one
          // await saveNewAppointmentForMultipleServices(
          //   appointment: appointmentModel!,
          //   timeForBlockEndProcessing: chosenSlots.first,
          //   isSingleMaster: chosenSalon!.ownerType == OwnerType.singleMaster,
          //   customerModel: customerModel,
          // );
        } else {
          ///to save the appointment for single services selected
          // await saveAppointment(
          //   appointment: appointmentModel!,
          //   timeForBlockEndProcessing: chosenSlots.first,
          //   isSingleMaster: chosenSalon!.ownerType == OwnerType.singleMaster,
          //   customerModel: customerModel,
          // );
        }

        // AppointmentModel? finalAppointment;
        // DocumentReference doc = await Collection.appointments.add(appointmentModel!.toJson());

        // appointmentModel!.appointmentId = doc.id;
        // await blockTime();

        // if (chosenBonus != null) {
        //   await BonusReferralApi().invalidateBonus(bonusModel: chosenBonus!, usedAppointmentId: doc.id);
        // }

        // AppointmentNotification().sendNotifications(
        //     appointmentModel!, customerModel, chosenSalon!, context);
        // printIt(finalAppointment?.toJson());
        // resetFlow();

        // Collection.customers.doc(customerModel.customerId).update({
        //   'registeredSalons': FieldValue.arrayUnion([appointmentModel!.salon.id])
        // });
        loadingStatus = Status.success;
        notifyListeners();
        return true;
        // finalAppointment = await createAppointmentInIntegration(
        //     appointmentModel!, chosenMaster!);

        // if (finalAppointment != null) {
        //   DocumentReference doc =
        //       await Collection.appointments.add(finalAppointment.toJson());

        //   finalAppointment.appointmentId = doc.id;
        //   await blockTime();

        //   if (chosenBonus != null) {
        //     await BonusReferralApi().invalidateBonus(
        //         bonusModel: chosenBonus!, usedAppointmentId: doc.id);
        //   }

        //   // AppointmentNotification().sendNotifications(
        //   //     finalAppointment, customerModel, chosenSalon!, context);
        //   printIt(finalAppointment.toJson());
        //   reset();

        //   Collection.customers.doc(customerModel.customerId).update({
        //     'registeredSalons':
        //         FieldValue.arrayUnion([appointmentModel!.salon.id])
        //   });
        //   loadingStatus = Status.success;
        //   notifyListeners();
        //   notifyListeners();

        //   return true;
        // } else {
        //   loadingStatus = Status.failed;
        //   notifyListeners();

        //   return false;
        // }
      } else {
        loadingStatus = Status.failed;
        notifyListeners();
        printIt('error in making booking');
        showToast(AppLocalizations.of(context)?.errorOccurred ?? 'error! please try again');
        return false;
      }
    } else {
      for (AppointmentModel app in appointmentModelSalonOwner!) {
        PaymentInfo _paymentInfo = PaymentInfo(
          bonusApplied: chosenBonus != null,
          bonusAmount: chosenBonus?.amount ?? 0,
          actualAmount: double.parse(app.priceAndDuration.price!).toInt(),
          bonusIds: chosenBonus != null ? [chosenBonus!.bonusId] : [],
          paymentDone: false,
          onlinePayment: false,
          paymentMethod: PaymentMethods.cardSalon,
        );

        ///passes discounted amount in priceAndDuration model
        if (chosenBonus != null) {
          final discountedAmount = (double.parse(app.priceAndDuration.price!).toInt() - chosenBonus!.amount);
          if (discountedAmount < 0) {
            app.priceAndDuration.price = '0';
          } else {
            app.priceAndDuration.price = discountedAmount.toString();
          }
        }

        app.paymentInfo = _paymentInfo;

        // Check no of services booked in appointment model
        if (app.services.length > 1) {
          ///saves appointments when service is more that one
          // await saveNewAppointmentForMultipleServices(
          //   appointment: app,
          //   timeForBlockEndProcessing: app.appointmentTime,
          //   isSingleMaster: false,
          //   customerModel: customerModel,
          // );
        } else {
          ///to save the appointment for single services selected
          // await saveAppointment(
          //   appointment: app,
          //   timeForBlockEndProcessing: app.appointmentTime,
          //   isSingleMaster: false,
          //   customerModel: customerModel,
          // );
        }

        // DocumentReference doc = await Collection.appointments.add(app.toJson());
        // app.appointmentId = doc.id;
        // await blockTimeSalonOwnerMaster(
        //     app,
        //     serviceAgainstMaster
        //             .where((element) =>

        //                 element.service?.serviceId ==
        //                 app.services.first.serviceId)
        //             .toList()
        //             .isNotEmpty
        //         ? serviceAgainstMaster
        //             .where((element) =>
        //                 element.service?.serviceId ==
        //                 app.services.first.serviceId)
        //             .toList()
        //             .first
        //             .master!
        //         : getMasterProvidingService(chosenServices
        //             .where((element) =>
        //                 element.serviceId == app.services.first.serviceId)
        //             .toList()[0])[0]);

        // await blockTimeSalonOwnerMaster(
        //   app,
        //   serviceAgainstMaster.where((element) => element.service?.serviceId == app.services.first.serviceId).toList().first.master!,
        // );

        // if (chosenBonus != null) {
        //   await BonusReferralApi().invalidateBonus(bonusModel: chosenBonus!, usedAppointmentId: doc.id);
        // }

        // AppointmentNotification().sendNotifications(
        //     appointmentModel!, customerModel, chosenSalon!, context);
        // printIt(finalAppointment?.toJson());
        // resetFlow();

        // Collection.customers.doc(customerModel.customerId).update({
        //   'registeredSalons': FieldValue.arrayUnion([appointmentModel!.salon.id])
        // });
      }
      loadingStatus = Status.success;
      notifyListeners();
      return true;
    }
  }

  getMasterProvidingServiceFromService(Service service) {
    List<MasterModel> masters = [];
    for (MasterModel element in salonMasters) {
      if (element.serviceIds!.contains(service.serviceId)) {
        masters.add(element);
      }
    }
    return masters;
  }

  blockTime({String? time, int? minutes}) async {
    if (chosenSalon!.ownerType == OwnerType.singleMaster) {
      await AppointmentApi().blockSalonTime(
        salon: chosenSalon!,
        date: chosenDay,
        time: time ?? chosenSlots.first,
        minutes: minutes ?? int.parse(appointmentModel!.priceAndDuration.duration!),
      );
    } else {
      await AppointmentApi().blockMastersTime(
        master: chosenMaster!,
        date: chosenDay,
        time: time ?? chosenSlots.first,
        minutes: minutes ?? int.parse(appointmentModel!.priceAndDuration.duration!),
      );
    }
  }

  blockTimeSalonOwnerMaster(AppointmentModel app, MasterModel master, {int? minutes, String? time}) async {
    await AppointmentApi().blockMastersTime(
      master: master,
      date: chosenDay,
      time: time ?? app.appointmentTime,
      minutes: minutes ?? int.parse(app.priceAndDuration.duration!),
    );
  }

  clearChosenMaster() {
    chosenMaster = null;
    notifyListeners();
  }

// remove seviceMaster from the list
  removeServiceMaster(ServiceModel service, BuildContext context) {
    serviceAgainstMaster.removeWhere((element) => element.service!.serviceId == service.serviceId);
    if (getMasterProvidingService(service).length != 0) {
      serviceAgainstMaster.add(ServiceAndMaster(service: service, master: getMasterProvidingService(service)[0], isRandom: true));

      getSlotsForSalonOwnerTye(day: chosenDay, context: context, showNotWorkingToast: false, masterAndservice: serviceAgainstMaster);
      // serviceAgainstMaster.removeWhere(
      //     (element) => element.service!.serviceId == service.serviceId);
      divideSlotsForDay();
    }
    notifyListeners();
  }

  addServiceMaster(ServiceModel service, MasterModel master, BuildContext context) {
    // print('------------SERVICE MASTER ADDED------------');
    serviceAgainstMaster.removeWhere((element) => element.service!.serviceId == service.serviceId);
    serviceAgainstMaster.add(ServiceAndMaster(service: service, master: master));
    getSlotsForSalonOwnerTye(day: chosenDay, context: context, showNotWorkingToast: false, masterAndservice: serviceAgainstMaster);
    divideSlotsForDay();
    notifyListeners();
    // print('valid slots added here ??');
    // print(serviceAgainstMaster.where((element) => element.master == master).first.validSlots);
    // print('------------SERVICE MASTER ADDED------------');
  }

  // to help recalculate the available slots
  refreshSlotsSalonOwner(BuildContext context) {
    getSlotsForSalonOwnerTye(day: chosenDay, context: context, showNotWorkingToast: false, masterAndservice: serviceAgainstMaster);
    divideSlotsForDay();
  }

  /// model for single service
  AppointmentModel _createAppointmentModel({required CustomerModel customer, required String? transactionId}) {
    ///creating all the required variables
    const String _type = AppointmentType.reservation;
    //updating the latest update
    final List<String> _updates = [AppointmentUpdates.createdByCustomer];
    final List<DateTime> _updatedAt = [DateTime.now()];

    final PriceAndDurationModel _priceAndDuration = priceAndDuration[chosenMaster?.masterId] ?? PriceAndDurationModel();
    debugPrint("Chosen Slots");
    debugPrint(selectedAppointmentSlot);

    TimeOfDay _startTime = Time().stringToTime(selectedAppointmentSlot!);
    //computing appointment end time in string

    debugPrint("_startTime");
    debugPrint(_startTime.toString());
    TimeOfDay _endTime = _startTime.addMinutes(
      int.parse(_priceAndDuration.duration!),
    );

    final DateTime _start = Time().generateDateTimeFromString(chosenDay, selectedAppointmentSlot!);

    debugPrint("_start");
    debugPrint(_start.toString());

    final DateTime _end = Time().generateDateTimeFromString(
      chosenDay,
      Time().timeToString(_endTime)!,
    );

    final String? _appointmentTime = selectedAppointmentSlot;
    final String _appointmentDate = Time().getDateInStandardFormat(chosenDay);

    final DateTime _createdAt = DateTime.now();

    /////////////////////////////////////////////
    final Salon _salon = Salon(
      id: chosenSalon!.salonId,
      name: chosenSalon!.salonName,
      phoneNo: chosenSalon!.phoneNumber,
      address: chosenSalon!.address,
    );

    final Master _master = Master(
      id: chosenMaster!.masterId,
      name: "${chosenMaster?.personalInfo?.firstName ?? ''} ${chosenMaster?.personalInfo?.lastName ?? ''}",
    );

    final Customer _customer = Customer(
      id: customer.customerId,
      name: Utils().getName(customer.personalInfo),
      pic: customer.profilePic,
      phoneNumber: customer.personalInfo.phone,
      email: customer.personalInfo.email ?? '',
    );

    /////////////////////////////////////////////

    const String _status = AppointmentStatus.active;

    ServiceModel selectedService = chosenServices[0];

    final Service _service = Service(
      serviceId: selectedService.serviceId,
      categoryId: selectedService.categoryId,
      subCategoryId: selectedService.subCategoryId,
      serviceName: selectedService.serviceName,
      translations: selectedService.translations,
      priceAndDuration: _priceAndDuration,
    );

    PaymentInfo _paymentInfo = PaymentInfo(
      bonusApplied: false,
      bonusAmount: 0,
      actualAmount: int.parse(_priceAndDuration.price!),
      bonusIds: [],
      paymentDone: false,
      onlinePayment: false,
      paymentMethod: 'card',
    );

    /// assigning all the variables and creating appointment model ....

    return AppointmentModel(
      type: _type,
      createdAt: _createdAt,
      appointmentStartTime: _start,
      appointmentEndTime: _end,
      appointmentTime: _appointmentTime!,
      appointmentDate: _appointmentDate,
      salon: _salon,
      master: _master,
      customer: _customer,
      createdBy: CreatedBy.customer,
      salonOwnerType: OwnerType.salon,
      status: _status,
      updates: _updates,
      updatedAt: _updatedAt,
      services: [_service],
      subStatus: _start.difference(DateTime.now()).inHours < 24 ? ActiveAppointmentSubStatus.confirmed : ActiveAppointmentSubStatus.unConfirmed,
      priceAndDuration: _priceAndDuration,
      paymentInfo: _paymentInfo,
      transactionId: transactionId == null ? [] : [transactionId],
    );
  }

  // AppointmentModel _createAppointmentModel({
  //   required List<Service> services,
  //   required DateTime startTime,
  //   required DateTime endTime,
  //   String? appointmentTime,
  //   required CustomerModel? customerModel,
  //   required PriceAndDurationModel priceAndDuration,
  //   required Master master,
  // }) {
  //   ///creating all the required variables
  //   Service? selectedService = services[0];

  //   const String _type = AppointmentType.reservation;
  //   //updating the latest update
  //   final List<String> _updates = [AppointmentUpdates.createdByCustomer];
  //   final List<DateTime> _updatedAt = [DateTime.now()];
  //   final DateTime _createdAt = DateTime.now();
  //   const String _status = AppointmentStatus.active;
  //   const String _createdBy = CreatedBy.salon;

  //   final Service _service = Service(
  //     serviceId: selectedService.serviceId,
  //     categoryId: selectedService.categoryId,
  //     subCategoryId: selectedService.subCategoryId,
  //     serviceName: selectedService.serviceName,
  //     translations: selectedService.translations,
  //     priceAndDuration: priceAndDuration,
  //   );

  //   /// assigning all the variables and creating appointment model ....
  //   return AppointmentModel(
  //     type: _type,
  //     createdAt: _createdAt,
  //     appointmentStartTime: startTime,
  //     appointmentEndTime: endTime,
  //     appointmentTime: appointmentTime ?? chosenSlots.first,
  //     appointmentDate: Time().getDateInStandardFormat(chosenDay) ?? '',
  //     salon: Salon(
  //       id: chosenSalon!.salonId,
  //       name: chosenSalon!.salonName,
  //       address: chosenSalon!.address,
  //       phoneNo: chosenSalon!.phoneNumber,
  //     ),
  //     master: master,
  //     customer: Customer(
  //       id: customerModel!.customerId,
  //       name: Utils().getName(customerModel.personalInfo),
  //       phoneNumber: customerModel.personalInfo.phone,
  //       pic: customerModel.profilePic,
  //       email: customerModel.personalInfo.email ?? '',
  //     ),
  //     createdBy: _createdBy,
  //     salonOwnerType: OwnerType.salon,
  //     status: _status,
  //     updates: _updates,
  //     updatedAt: _updatedAt,
  //     services: [_service],
  //     subStatus: startTime.difference(DateTime.now()).inHours < 24 ? ActiveAppointmentSubStatus.confirmed : ActiveAppointmentSubStatus.unConfirmed,
  //     priceAndDuration: priceAndDuration,
  //     paymentInfo: PaymentInfo(
  //       bonusApplied: chosenBonus != null,
  //       bonusAmount: chosenBonus?.amount ?? 0,
  //       actualAmount: double.parse(priceAndDuration!.price!).toInt(),
  //       bonusIds: chosenBonus != null ? [chosenBonus!.bonusId] : [],
  //       paymentDone: false,
  //       onlinePayment: false,
  //       paymentMethod: PaymentMethods.cardSalon,
  //     ),
  //   );
  // }

  ///model for multiple service block
  AppointmentModel _createMultipleServiceAppointmentModel({required CustomerModel customer, required String? transactionId}) {
    ///creating all the required variables
    const String _type = AppointmentType.reservation;
    //updating the latest update
    final List<String> _updates = [AppointmentUpdates.createdByCustomer];
    final List<DateTime> _updatedAt = [DateTime.now()];

    //////////////////////////////////////////////
    //handling appointment TIME & DURATION
    //////////////////////////////////////////////
    final PriceAndDurationModel _priceAndDuration = priceAndDuration[chosenMaster?.masterId] ?? PriceAndDurationModel();
    debugPrint("Chosen Slots");
    debugPrint(selectedAppointmentSlot);

    TimeOfDay _startTime = Time().stringToTime(selectedAppointmentSlot!);
    //computing appointment end time in string

    debugPrint("_startTime");
    debugPrint(_startTime.toString());
    TimeOfDay _endTime = _startTime.addMinutes(int.parse(_priceAndDuration.duration!));

    final DateTime _start = Time().generateDateTimeFromString(chosenDay, selectedAppointmentSlot!);

    debugPrint("_start");
    debugPrint(_start.toString());

    final DateTime _end = Time().generateDateTimeFromString(chosenDay, Time().timeToString(_endTime)!);

    final String? _appointmentTime = selectedAppointmentSlot;
    final String _appointmentDate = Time().getDateInStandardFormat(chosenDay);

    final DateTime _createdAt = DateTime.now();

    /////////////////////////////////////////////
    final Salon _salon = Salon(
      id: chosenSalon!.salonId,
      name: chosenSalon!.salonName,
      phoneNo: chosenSalon!.phoneNumber,
      address: chosenSalon!.address,
    );

    final Master _master = Master(
      id: chosenMaster!.masterId,
      name: "${chosenMaster?.personalInfo?.firstName ?? ''} ${chosenMaster?.personalInfo?.lastName ?? ''}",
    );

    final Customer _customer = Customer(
      id: customer.customerId,
      name: Utils().getName(customer.personalInfo),
      pic: customer.profilePic,
      phoneNumber: customer.personalInfo.phone,
      email: customer.personalInfo.email ?? '',
    );

    /////////////////////////////////////////////

    const String _status = AppointmentStatus.active;

    List<Service> selectedAppointmentServices = [];

    for (var selectedAvailableService in chosenServices) {
      selectedAppointmentServices.add(
        Service(
          serviceId: selectedAvailableService.serviceId,
          categoryId: selectedAvailableService.categoryId,
          subCategoryId: selectedAvailableService.subCategoryId,
          serviceName: selectedAvailableService.serviceName,
          translations: selectedAvailableService.translations,
          priceAndDuration: PriceAndDurationModel(
            isFixedPrice: selectedAvailableService.isFixedPrice,
            isPriceRange: selectedAvailableService.isPriceRange,
            isPriceStartAt: selectedAvailableService.isPriceStartAt,
            durationinHr: selectedAvailableService.priceAndDuration!.durationinHr,
            durationinMin: selectedAvailableService.priceAndDuration!.durationinMin,
            duration: selectedAvailableService.priceAndDuration!.duration,
            price: selectedAvailableService.priceAndDuration!.price,
          ),
        ),
      );
    }

    PaymentInfo _paymentInfo = PaymentInfo(
      bonusApplied: false,
      bonusAmount: 0,
      actualAmount: int.parse(_priceAndDuration.price!),
      bonusIds: [],
      paymentDone: false,
      onlinePayment: false,
      paymentMethod: 'card',
    );

    /// assigning all the variables and creating appointment model ....

    return AppointmentModel(
      type: _type,
      createdAt: _createdAt,
      appointmentStartTime: _start,
      appointmentEndTime: _end,
      appointmentTime: _appointmentTime!,
      appointmentDate: _appointmentDate,
      salon: _salon,
      master: _master,
      customer: _customer,
      createdBy: CreatedBy.customer,
      salonOwnerType: OwnerType.salon,
      status: _status,
      updates: _updates,
      updatedAt: _updatedAt,
      services: selectedAppointmentServices,
      subStatus: _start.difference(DateTime.now()).inHours < 24 ? ActiveAppointmentSubStatus.confirmed : ActiveAppointmentSubStatus.unConfirmed,
      priceAndDuration: _priceAndDuration,
      paymentInfo: _paymentInfo,
      transactionId: transactionId == null ? [] : [transactionId],
    );
  }

  // AppointmentModel _createMultipleServiceAppointmentModel({
  //   required List<Service> services,
  //   required DateTime startTime,
  //   required DateTime endTime,
  //   String? appointmentTime,
  //   required CustomerModel? customerModel,
  //   required PriceAndDurationModel priceAndDuration,
  //   required Master master,
  // }) {
  //   ///creating all the required variables
  //   const String _type = AppointmentType.reservation;
  //   //updating the latest update
  //   final List<String> _updates = [AppointmentUpdates.createdByCustomer];
  //   final List<DateTime> _updatedAt = [DateTime.now()];
  //   final DateTime _createdAt = DateTime.now();

  //   const String _status = AppointmentStatus.active;
  //   const String _createdBy = CreatedBy.salon;

  //   List<Service> selectedAppointmentServices = [];

  //   for (var selectedAvailableService in services) {
  //     selectedAppointmentServices.add(Service(
  //       serviceId: selectedAvailableService.serviceId,
  //       categoryId: selectedAvailableService.categoryId,
  //       subCategoryId: selectedAvailableService.subCategoryId,
  //       serviceName: selectedAvailableService.serviceName,
  //       translations: selectedAvailableService.translations,
  //       priceAndDuration: PriceAndDurationModel(
  //         // isFixedPrice: selectedAvailableService.isFixedPrice,
  //         // isPriceRange: selectedAvailableService.isPriceRange,
  //         // isPriceStartAt: selectedAvailableService.isPriceStartAt,
  //         durationinHr: selectedAvailableService.priceAndDuration!.durationinHr,
  //         durationinMin: selectedAvailableService.priceAndDuration!.durationinMin,
  //         duration: selectedAvailableService.priceAndDuration!.duration,
  //         price: selectedAvailableService.priceAndDuration!.price,
  //       ),
  //     ));
  //   }

  //   /// assigning all the variables and creating appointment model ....
  //   return AppointmentModel(
  //     type: _type,
  //     createdAt: _createdAt,
  //     appointmentStartTime: startTime,
  //     appointmentEndTime: endTime,
  //     appointmentTime: appointmentTime ?? chosenSlots.first,
  //     appointmentDate: Time().getDateInStandardFormat(chosenDay) ?? '',
  //     salon: Salon(
  //       id: chosenSalon!.salonId,
  //       name: chosenSalon!.salonName,
  //       address: chosenSalon!.address,
  //       phoneNo: chosenSalon!.phoneNumber,
  //     ),
  //     master: chosenSalon!.ownerType == OwnerType.singleMaster
  //         ? Master(
  //             id: chosenSalon!.salonId,
  //             name: chosenSalon!.salonName,
  //           )
  //         : Master(
  //             id: chosenMaster!.masterId,
  //             name: Utils().getNameMaster(chosenMaster!.personalInfo),
  //           ),
  //     customer: Customer(
  //       id: customerModel!.customerId,
  //       name: Utils().getName(customerModel.personalInfo),
  //       phoneNumber: customerModel.personalInfo.phone,
  //       pic: customerModel.profilePic,
  //       email: customerModel.personalInfo.email ?? '',
  //     ),
  //     createdBy: _createdBy,
  //     salonOwnerType: OwnerType.salon,
  //     status: _status,
  //     updates: _updates,
  //     updatedAt: _updatedAt,
  //     services: selectedAppointmentServices,
  //     subStatus: startTime.difference(DateTime.now()).inHours < 24 ? ActiveAppointmentSubStatus.confirmed : ActiveAppointmentSubStatus.unConfirmed,
  //     priceAndDuration: priceAndDuration,
  //     paymentInfo: PaymentInfo(
  //       bonusApplied: chosenBonus != null,
  //       bonusAmount: chosenBonus?.amount ?? 0,
  //       actualAmount: double.parse(priceAndDuration!.price!).toInt(),
  //       bonusIds: chosenBonus != null ? [chosenBonus!.bonusId] : [],
  //       paymentDone: false,
  //       onlinePayment: false,
  //       paymentMethod: PaymentMethods.cardSalon,
  //     ),
  //   );
  // }

  AppointmentModel? appointmentConfirmation; // so we can show details on the confirmed dialog screen

  ///to save the appointment for single services selected
  Future saveAppointment({required CustomerModel customer, required String? transactionId}) async {
    bookAppointmentStatus = Status.loading;
    notifyListeners();

    ServiceModel selectedService = chosenServices[0];

    final AppointmentModel _appointment = _createAppointmentModel(
      customer: customer,
      transactionId: transactionId,
    );

    appointmentConfirmation = _appointment;
    //   //booking failed
    //  if (_appointment == null) {
    //     bookAppointmentStatus = false;
    //         notifyListeners();
    //     return;
    //   }

    ///this identifier is used to locate prepTime or cleaUptime created with this appointment
    var identifier = chosenSalon!.salonId + DateTime.now().toString() + _appointment.master!.id;
    _appointment.appointmentIdentifier = identifier;
    await AppointmentApi().createUpdateAppointment(_appointment).then((value) async {
      //blocking master's time

      debugPrint('is it getting here');

      // if it has processing time then it is complex

      if (selectedService.hasProcessingTime) {
        // block start processing
        await AppointmentApi().blockMastersTime(
          master: chosenMaster!,
          date: chosenDay,
          time: selectedAppointmentSlot!,
          minutes: selectedService.preparationTime ?? 0,
        );

        /// check if mastes list is 1 (single master), check if original master (phone number == salon phone)
        /// block time of salon and master,
        if (salonMasters.length == 1) {
          if (salonMasters.first.personalInfo?.phone == chosenSalon?.phoneNumber) {
            await AppointmentApi().blockSalonTime(
              salon: chosenSalon!,
              date: chosenDay,
              time: selectedAppointmentSlot!,
              minutes: selectedService.preparationTime ?? 0,
            );
          }
        }

        // block end processing
        TimeOfDay appointend = Time().stringToTime(selectedAppointmentSlot!).addMinutes(
              int.parse(
                priceAndDuration[chosenMaster?.masterId]?.duration ?? defaultServiceDuration,
              ),
            );
        int appointTimeInNumberNew = ((appointend.hour * 60) + appointend.minute) - selectedService.endProcessingTime!;
        String endProcessingTime = Time().timeToString(
          appointend.replacing(
            hour: appointTimeInNumberNew ~/ 60,
            minute: appointTimeInNumberNew % 60,
          ),
        )!;
        await AppointmentApi().blockMastersTime(
          master: chosenMaster!,
          date: chosenDay,
          time: endProcessingTime,
          minutes: selectedService.endProcessingTime ?? 0,
        );

        if (salonMasters.length == 1) {
          if (salonMasters.first.personalInfo?.phone == chosenSalon?.phoneNumber) {
            await AppointmentApi().blockSalonTime(
              salon: chosenSalon!,
              date: chosenDay,
              time: selectedAppointmentSlot!,
              minutes: selectedService.endProcessingTime ?? 0,
            );
          }
        }
      } else {
        // block time normally if
        await AppointmentApi().blockMastersTime(
          master: chosenMaster!,
          date: chosenDay,
          time: selectedAppointmentSlot!,
          minutes: int.parse(
            priceAndDuration[chosenMaster?.masterId]?.duration ?? defaultServiceDuration,
          ),
        );
        if (salonMasters.length == 1) {
          if (salonMasters.first.personalInfo?.phone == chosenSalon?.phoneNumber) {
            await AppointmentApi().blockSalonTime(
              salon: chosenSalon!,
              date: chosenDay,
              time: selectedAppointmentSlot!,
              minutes: int.parse(
                priceAndDuration[chosenMaster?.masterId]?.duration ?? defaultServiceDuration,
              ),
            );
          }
        }
      }

      // create appointment and block preparation time
      if (selectedService.preparationTime != null) {
        TimeOfDay appoint = Time().stringToTime(selectedAppointmentSlot!);
        int appointTimeInNumberNew = ((appoint.hour * 60) + appoint.minute) - selectedService.preparationTime!;
        String prepTime = Time().timeToString(appoint.replacing(hour: appointTimeInNumberNew ~/ 60, minute: appointTimeInNumberNew % 60))!;
        // String prepTime = Time().timeToString(appoint.replacing(
        //     hour: appoint.hour,
        //     minute: appoint.minute - selectedService!.preparationTime!))!;
        final AppointmentModel _appointmentPrep = _createOtherAppointmentTypeModel(
          type: AppointmentType.preparationTime,
          AppointmentSlot: prepTime,
          duration: selectedService.preparationTime,
          customer: customer,
        );
        _appointmentPrep.appointmentIdentifier = identifier;
        //create and block prep time
        if (_appointmentPrep != null) {
          await AppointmentApi().createUpdateAppointment(_appointmentPrep).then((value) async {
            await AppointmentApi().blockMastersTime(
              master: chosenMaster!,
              date: chosenDay,
              time: prepTime,
              minutes: selectedService.preparationTime!,
            );

            if (salonMasters.length == 1) {
              if (salonMasters.first.personalInfo?.phone == chosenSalon?.phoneNumber) {
                await AppointmentApi().blockSalonTime(
                  salon: chosenSalon!,
                  date: chosenDay,
                  time: selectedAppointmentSlot!,
                  minutes: selectedService.preparationTime!,
                );
              }
            }
          });
        }
      }

      //create and block cleanUp time
      if (selectedService.cleanUpTime != null) {
        TimeOfDay appointend = Time().stringToTime(selectedAppointmentSlot!).addMinutes(
              int.parse(
                priceAndDuration[chosenMaster?.masterId]?.duration ?? defaultServiceDuration,
              ),
            );
        final AppointmentModel _appointmentCleanUp = _createOtherAppointmentTypeModel(
          type: AppointmentType.cleanUpTime,
          AppointmentSlot: Time().timeToString(appointend)!,
          duration: selectedService.cleanUpTime,
          customer: customer,
        );
        _appointmentCleanUp.appointmentIdentifier = identifier;
        //create and block cleanUp time
        if (_appointmentCleanUp != null) {
          await AppointmentApi().createUpdateAppointment(_appointmentCleanUp).then((value) async {
            await AppointmentApi().blockMastersTime(
              master: chosenMaster!,
              date: chosenDay,
              time: Time().timeToString(appointend)!,
              minutes: selectedService.cleanUpTime ?? 0,
            );

            if (salonMasters.length == 1) {
              if (salonMasters.first.personalInfo?.phone == chosenSalon?.phoneNumber) {
                await AppointmentApi().blockSalonTime(
                  salon: chosenSalon!,
                  date: chosenDay,
                  time: selectedAppointmentSlot!,
                  minutes: selectedService.cleanUpTime ?? 0,
                );
              }
            }
          });
        }
      }

      bookAppointmentStatus = Status.success;
      notifyListeners();

      // finish booking
      showToast('Successful!!!...');

      //assigning appointment id
      _appointment.appointmentId = value;
      appointmentConfirmation!.appointmentId = value;

      // UPDATE REGISTERED SALONS IN CUSTOMER PROFILE
      Collection.customers.doc(customer.customerId).update({
        'registeredSalons': FieldValue.arrayUnion([_appointment.salon.id])
      });
    });
  }

  ///saves appointments when service is more that one
  Future saveNewAppointmentForMultipleServices({required CustomerModel customer, required String? transactionId}) async {
    bookAppointmentStatus = Status.loading;
    notifyListeners();

    final AppointmentModel _appointment = _createMultipleServiceAppointmentModel(
      customer: customer,
      transactionId: transactionId,
    );

    appointmentConfirmation = _appointment;

    // //booking failed
    // if (_appointment == null) {
    //   bookAppointmentStatus = false;
    //       notifyListeners();
    //   return;
    // }

    var identifier = chosenSalon!.salonId + DateTime.now().toString() + _appointment.master!.id;
    _appointment.appointmentIdentifier = identifier;
    //this will hold the highest appointment prep time
    int preparationTime = 0;

    int endApptProcessingTime = 0;
    //this will hold highest appointment clean up time
    int cleanUpApptTime = 0;
    // debugPrint('at zero before${chosenServices[0].preparationTime}');

    //loop through each service and get highest prep time and cleanup time if there is any
    for (var selectedAvailableService in chosenServices) {
      // debugPrint('at all before${chosenServices[chosenServices.indexOf(selectedAvailableService)].preparationTime}');
      // If prep-time =null , cleantime is not null, then pre-time service as first service in the list.
      // also if the service prep time is greater than preparationTime variable then assign it to the preparationTime
      if (selectedAvailableService.preparationTime != null && selectedAvailableService.cleanUpTime == null) {
        //update prepTime to highest service prep time
        if (selectedAvailableService.preparationTime! > preparationTime) {
          preparationTime = selectedAvailableService.preparationTime!;
          //here we are making inserting the highest service prep time as the first in the list
          int index = chosenServices.indexOf(selectedAvailableService);
          ServiceModel removedService = chosenServices.removeAt(index);
          chosenServices.insert(0, removedService);
        }
      }
      //If pre-time =null, clean time is not null, then make the clean time service as last service in the list.
      // also if the service clean up time is greater than cleanUpTime variable then assign it to the cleanUpTime
      if (selectedAvailableService.preparationTime == null && selectedAvailableService.cleanUpTime != null) {
        //update cleanUpAppt time to highest service clean up time
        if (selectedAvailableService.cleanUpTime! > cleanUpApptTime) {
          cleanUpApptTime = selectedAvailableService.cleanUpTime!;

          ///insert the highest clean up time as the last item in the list
          int index = chosenServices.indexOf(selectedAvailableService);
          ServiceModel removedService = chosenServices.removeAt(index);
          chosenServices.add(removedService);
        }
      }

      //If prep time is not null, clean time is not null, then make prep time service as first and clean time service as last.
      if (selectedAvailableService.preparationTime != null && selectedAvailableService.cleanUpTime != null) {
        if (selectedAvailableService.preparationTime != null) {
          //update preparationTime to highest service prep time \
          if (selectedAvailableService.preparationTime! > preparationTime) {
            preparationTime = selectedAvailableService.preparationTime!;
            //insert highest prep time as first service
            int index = chosenServices.indexOf(selectedAvailableService);
            ServiceModel removedService = chosenServices.removeAt(index);
            chosenServices.insert(0, removedService);
          }
        }
        if (selectedAvailableService.cleanUpTime != null) {
          //update cleanUpApptTime to highest service clean up time
          if (selectedAvailableService.cleanUpTime! > cleanUpApptTime) {
            cleanUpApptTime = selectedAvailableService.cleanUpTime!;
            //update clean up time as last item in the list
            int index = chosenServices.indexOf(selectedAvailableService);
            ServiceModel removedService = chosenServices.removeAt(index);
            chosenServices.add(removedService);
            cleanUpApptTime = selectedAvailableService.cleanUpTime!;
          }
        }
      }
    }

    // debugPrint('at zero after${chosenServices[0].preparationTime}');

    // debugPrint(' prep time $preparationTime');
    // debugPrint('end processing time$endApptProcessingTime');
    _appointment.appointmentIdentifier = identifier;

    await AppointmentApi().createUpdateAppointment(_appointment).then((value) async {
      //blocking master's time

      // debugPrint('is it getting here');
      // block time normally if
      await AppointmentApi().blockMastersTime(
        master: chosenMaster!,
        date: chosenDay,
        time: selectedAppointmentSlot!,
        minutes: int.parse(
          priceAndDuration[chosenMaster?.masterId]?.duration ?? defaultServiceDuration,
        ),
      );
      if (salonMasters.length == 1) {
        if (salonMasters.first.personalInfo?.phone == chosenSalon?.phoneNumber) {
          await AppointmentApi().blockSalonTime(
            salon: chosenSalon!,
            date: chosenDay,
            time: selectedAppointmentSlot!,
            minutes: int.parse(
              priceAndDuration[chosenMaster?.masterId]?.duration ?? defaultServiceDuration,
            ),
          );
        }
      }

      //if prep time is not 0 then we create appt block for prep time
      if (preparationTime != 0) {
        TimeOfDay appoint = Time().stringToTime(selectedAppointmentSlot!);
        int appointTimeInNumberNew = ((appoint.hour * 60) + appoint.minute) - preparationTime;
        String prepTime = Time().timeToString(appoint.replacing(hour: appointTimeInNumberNew ~/ 60, minute: appointTimeInNumberNew % 60))!;
        // String prepTime = Time().timeToString(appoint.replacing(
        //     hour: appoint.hour,
        //     minute: appoint.minute - selectedService!.preparationTime!))!;
        final AppointmentModel _appointmentPrep = _createOtherNewAppointmentTypeModelForMultipleServices(
          type: AppointmentType.preparationTime,
          AppointmentSlot: prepTime,
          duration: preparationTime,
          customer: customer,
        );

        //create and block prep time
        if (_appointmentPrep != null) {
          _appointment.appointmentIdentifier = identifier;

          await AppointmentApi().createUpdateAppointment(_appointmentPrep).then((value) async {
            await AppointmentApi().blockMastersTime(
              master: chosenMaster!,
              date: chosenDay,
              time: prepTime,
              minutes: preparationTime,
            );
            if (salonMasters.length == 1) {
              if (salonMasters.first.personalInfo?.phone == chosenSalon?.phoneNumber) {
                await AppointmentApi().blockSalonTime(
                  salon: chosenSalon!,
                  date: chosenDay,
                  time: selectedAppointmentSlot!,
                  minutes: preparationTime,
                );
              }
            }
          });
        }
      }

      //create and block cleanUp time if clean up time is not 0
      if (cleanUpApptTime != 0) {
        TimeOfDay appointend = Time().stringToTime(selectedAppointmentSlot!).addMinutes(
              int.parse(
                priceAndDuration[chosenMaster?.masterId]?.duration ?? defaultServiceDuration,
              ),
            );
        final AppointmentModel _appointmentCleanUp = _createOtherNewAppointmentTypeModelForMultipleServices(
          type: AppointmentType.cleanUpTime,
          AppointmentSlot: Time().timeToString(appointend)!,
          duration: cleanUpApptTime,
          customer: customer,
        );

        //create and block cleanUp time
        if (_appointmentCleanUp != null) {
          _appointment.appointmentIdentifier = identifier;

          await AppointmentApi().createUpdateAppointment(_appointmentCleanUp).then((value) async {
            await AppointmentApi().blockMastersTime(
              master: chosenMaster!,
              date: chosenDay,
              time: Time().timeToString(appointend)!,
              minutes: cleanUpApptTime,
            );
            if (salonMasters.length == 1) {
              if (salonMasters.first.personalInfo?.phone == chosenSalon?.phoneNumber) {
                await AppointmentApi().blockSalonTime(
                  salon: chosenSalon!,
                  date: chosenDay,
                  time: selectedAppointmentSlot!,
                  minutes: cleanUpApptTime,
                );
              }
            }
          });
        }
      }

      //finish booking
      bookAppointmentStatus = Status.success;
      notifyListeners();

      showToast('Successful!!!...');

      // assigning appointment id
      _appointment.appointmentId = value;
      appointmentConfirmation!.appointmentId = value;

      // UPDATE REGISTERED SALONS IN CUSTOMER PROFILE
      Collection.customers.doc(customer.customerId).update({
        'registeredSalons': FieldValue.arrayUnion([_appointment.salon.id])
      });
    });
  }

  // Future saveNewAppointmentForMultipleServices({
  //   required AppointmentModel appointment,
  //   required String timeForBlockEndProcessing,
  //   required bool isSingleMaster,
  //   required CustomerModel? customerModel,
  // }) async {
  //   var identifier = chosenSalon!.salonId + DateTime.now().toString() + appointment.master!.id;
  //   appointment.appointmentIdentifier = identifier;

  //   List<Service> servicesList = appointment.services;
  //   MasterModel master = serviceAgainstMaster.where((element) => element.service?.serviceId == appointment.services.first.serviceId).toList().first.master!;

  //   //this will hold the highest appointment prep time
  //   int preparationTime = 0;

  //   int endApptProcessingTime = 0;
  //   //this will hold highest appointment clean up time
  //   int cleanUpApptTime = 0;
  //   debugPrint('at zero before${servicesList[0].preparationTime}');

  //   //loop through each service and get highest prep time and cleanup time if there is any
  //   for (var selectedAvailableService in servicesList) {
  //     debugPrint('at all before${servicesList[servicesList.indexOf(selectedAvailableService)].preparationTime}');
  //     // If prep-time =null , cleantime is not null, then pre-time service as first service in the list.
  //     // also if the service prep time is greater than preparationTime variable then assign it to the preparationTime
  //     if (selectedAvailableService.preparationTime != null && selectedAvailableService.cleanUpTime == null) {
  //       //update prepTime to highest service prep time
  //       if (selectedAvailableService.preparationTime! > preparationTime) {
  //         preparationTime = selectedAvailableService.preparationTime!;
  //         //here we are making inserting the highest service prep time as the first in the list
  //         int index = servicesList.indexOf(selectedAvailableService);
  //         Service removedService = servicesList.removeAt(index);
  //         servicesList.insert(0, removedService);
  //       }
  //     }
  //     //If pre-time =null, clean time is not null, then make the clean time service as last service in the list.
  //     // also if the service clean up time is greater than cleanUpTime variable then assign it to the cleanUpTime
  //     if (selectedAvailableService.preparationTime == null && selectedAvailableService.cleanUpTime != null) {
  //       //update cleanUpAppt time to highest service clean up time
  //       if (selectedAvailableService.cleanUpTime! > cleanUpApptTime) {
  //         cleanUpApptTime = selectedAvailableService.cleanUpTime!;

  //         ///insert the highest clean up time as the last item in the list
  //         int index = servicesList.indexOf(selectedAvailableService);
  //         Service removedService = servicesList.removeAt(index);
  //         servicesList.add(removedService);
  //       }
  //     }

  //     //If prep time is not null, clean time is not null, then make prep time service as first and clean time service as last.
  //     if (selectedAvailableService.preparationTime != null && selectedAvailableService.cleanUpTime != null) {
  //       if (selectedAvailableService.preparationTime != null) {
  //         //update preparationTime to highest service prep time \
  //         if (selectedAvailableService.preparationTime! > preparationTime) {
  //           preparationTime = selectedAvailableService.preparationTime!;
  //           //insert highest prep time as first service
  //           int index = servicesList.indexOf(selectedAvailableService);
  //           Service removedService = servicesList.removeAt(index);
  //           servicesList.insert(0, removedService);
  //         }
  //       }
  //       if (selectedAvailableService.cleanUpTime != null) {
  //         //update cleanUpApptTime to highest service clean up time
  //         if (selectedAvailableService.cleanUpTime! > cleanUpApptTime) {
  //           cleanUpApptTime = selectedAvailableService.cleanUpTime!;
  //           //update clean up time as last item in the list
  //           int index = servicesList.indexOf(selectedAvailableService);
  //           Service removedService = servicesList.removeAt(index);
  //           servicesList.add(removedService);
  //           cleanUpApptTime = selectedAvailableService.cleanUpTime!;
  //         }
  //       }
  //     }
  //   }

  //   debugPrint('at zero after${servicesList[0].preparationTime}');

  //   debugPrint(' prep time $preparationTime');
  //   debugPrint('end processing time$endApptProcessingTime');
  //   await AppointmentApi().createUpdateAppointment(appointment).then((value) async {
  //     //blocking master's time

  //     debugPrint('is it getting here 2');
  //     // block time normally if
  //     if (isSingleMaster) {
  //       blockTime(
  //         minutes: int.parse(
  //           mastersPriceDurationMap[appointment]?.duration ?? defaultServiceDuration,
  //         ),
  //       );
  //     } else {
  //       blockTimeSalonOwnerMaster(
  //         appointment,
  //         master,
  //         minutes: int.parse(
  //           mastersPriceDurationMap[appointment]?.duration ?? defaultServiceDuration,
  //         ),
  //       );
  //     }

  //     //if prep time is not 0 then we create appt block for prep time
  //     if (preparationTime != 0) {
  //       TimeOfDay appoint = Time().stringToTime(timeForBlockEndProcessing);
  //       int appointTimeInNumberNew = ((appoint.hour * 60) + appoint.minute) - preparationTime;
  //       String prepTime = Time().timeToString(
  //         appoint.replacing(
  //           hour: appointTimeInNumberNew ~/ 60,
  //           minute: appointTimeInNumberNew % 60,
  //         ),
  //       )!;
  //       // String prepTime = Time().timeToString(appoint.replacing(
  //       //     hour: appoint.hour,
  //       //     minute: appoint.minute - selectedService!.preparationTime!))!;
  //       final AppointmentModel _appointmentPrep = _createOtherNewAppointmentTypeModelForMultipleServices(
  //         type: AppointmentType.preparationTime,
  //         appointmentSlot: prepTime,
  //         duration: preparationTime,
  //         appointment: appointment,
  //         customerModel: customerModel,
  //       );

  //       _appointmentPrep.appointmentIdentifier = identifier;

  //       //create and block prep time
  //       if (_appointmentPrep != null) {
  //         await AppointmentApi().createUpdateAppointment(_appointmentPrep).then((value) async {
  //           if (isSingleMaster) {
  //             blockTime(
  //               time: prepTime,
  //               minutes: preparationTime,
  //             );
  //           } else {
  //             blockTimeSalonOwnerMaster(
  //               appointment,
  //               master,
  //               time: prepTime,
  //               minutes: preparationTime,
  //             );
  //           }
  //         });
  //       }
  //     }

  //     //create and block cleanUp time if clean up time is not 0
  //     if (cleanUpApptTime != 0) {
  //       TimeOfDay appointend = Time().stringToTime(timeForBlockEndProcessing).addMinutes(
  //             int.parse(
  //               mastersPriceDurationMap[appointment]?.duration ?? defaultServiceDuration,
  //             ),
  //           );
  //       final AppointmentModel _appointmentCleanUp = _createOtherNewAppointmentTypeModelForMultipleServices(
  //         appointment: appointment,
  //         customerModel: customerModel,
  //         type: AppointmentType.cleanUpTime,
  //         appointmentSlot: Time().timeToString(appointend)!,
  //         duration: cleanUpApptTime,
  //       );

  //       //create and block cleanUp time
  //       if (_appointmentCleanUp != null) {
  //         await AppointmentApi().createUpdateAppointment(_appointmentCleanUp).then((value) async {
  //           if (isSingleMaster) {
  //             blockTime(
  //               time: Time().timeToString(appointend)!,
  //               minutes: cleanUpApptTime,
  //             );
  //           } else {
  //             blockTimeSalonOwnerMaster(
  //               appointment,
  //               master,
  //               time: Time().timeToString(appointend)!,
  //               minutes: cleanUpApptTime,
  //             );
  //           }
  //         });
  //       }
  //     }

  //     // finish booking
  //     showToast('Successful!!!...');

  //     // assigning appointment id
  //     appointment.appointmentId = value;
  //   });
  // }

  AppointmentModel _createOtherAppointmentTypeModel({String? type, String? AppointmentSlot, int? duration, required CustomerModel customer}) {
    ///creating all the required variables
    final String _type = type!;
    //updating the latest update
    final List<String> _updates = [AppointmentUpdates.createdByCustomer];
    final List<DateTime> _updatedAt = [DateTime.now()];

    //////////////////////////////////////////////
    //handling appointment TIME & DURATION
    //////////////////////////////////////////////
    final PriceAndDurationModel _priceAndDuration = priceAndDuration[chosenMaster!.masterId] ?? PriceAndDurationModel();
    debugPrint(type + " Chosen Slots");
    debugPrint(AppointmentSlot);

    TimeOfDay _startTime = Time().stringToTime(AppointmentSlot!);
    //computing appointment end time in string

    debugPrint("_startTime");
    debugPrint(_startTime.toString());
    TimeOfDay _endTime = _startTime.addMinutes(duration);

    final DateTime _start = Time().generateDateTimeFromString(chosenDay, AppointmentSlot);

    debugPrint("_start");
    debugPrint(_start.toString());

    final DateTime _end = Time().generateDateTimeFromString(chosenDay, Time().timeToString(_endTime)!);

    final String? _appointmentTime = AppointmentSlot;
    final String _appointmentDate = Time().getDateInStandardFormat(chosenDay);

    final DateTime _createdAt = DateTime.now();

    final Salon _salon = Salon(
      id: chosenSalon!.salonId,
      name: chosenSalon!.salonName,
      phoneNo: chosenSalon!.phoneNumber,
      address: chosenSalon!.address,
    );

    final Master _master = Master(
      id: chosenMaster!.masterId,
      name: "${chosenMaster?.personalInfo?.firstName ?? ''} ${chosenMaster?.personalInfo?.lastName ?? ''}",
    );

    const String _status = AppointmentStatus.active;

    ServiceModel selectedService = chosenServices[0];

    final Service _service = Service(
      serviceId: selectedService.serviceId,
      categoryId: selectedService.categoryId,
      subCategoryId: selectedService.subCategoryId,
      serviceName: selectedService.serviceName,
      translations: selectedService.translations,
      priceAndDuration: _priceAndDuration,
    );

    PaymentInfo _paymentInfo = PaymentInfo(
      bonusApplied: false,
      bonusAmount: 0,
      actualAmount: 0,
      bonusIds: [],
      paymentDone: false,
      onlinePayment: false,
      paymentMethod: 'card',
    );

    final Customer _customer = Customer(
      id: customer.customerId,
      name: Utils().getName(customer.personalInfo),
      pic: customer.profilePic,
      phoneNumber: customer.personalInfo.phone,
      email: customer.personalInfo.email ?? '',
    );

    /// assigning all the variables and creating appointment model ....

    return AppointmentModel(
      type: _type,
      createdAt: _createdAt,
      appointmentStartTime: _start,
      appointmentEndTime: _end,
      appointmentTime: _appointmentTime!,
      appointmentDate: _appointmentDate,
      salon: _salon,
      master: _master,
      customer: _customer,
      createdBy: CreatedBy.customer,
      salonOwnerType: OwnerType.salon,
      status: _status,
      subStatus: _start.difference(DateTime.now()).inHours < 24 ? ActiveAppointmentSubStatus.confirmed : ActiveAppointmentSubStatus.unConfirmed,
      updates: _updates,
      updatedAt: _updatedAt,
      services: [_service],
      priceAndDuration: _priceAndDuration,
      paymentInfo: _paymentInfo,
    );
  }

  // AppointmentModel _createOtherAppointmentTypeModel({
  //   required AppointmentModel appointment,
  //   String? type,
  //   String? appointmentSlot,
  //   int? duration,
  //   required CustomerModel? customerModel,
  // }) {
  //   Service singleService = appointment.services[0];

  //   ///creating all the required variables
  //   final String _type = type!;
  //   //updating the latest update
  //   final List<String> _updates = [AppointmentUpdates.createdByCustomer];
  //   final List<DateTime> _updatedAt = [DateTime.now()];

  //   //////////////////////////////////////////////
  //   //handling appointment TIME & DURATION
  //   //////////////////////////////////////////////
  //   final PriceAndDurationModel _priceAndDuration = mastersPriceDurationMap[appointment.master?.id] ?? PriceAndDurationModel();
  //   debugPrint(type + " Chosen Slots");
  //   debugPrint(appointmentSlot);

  //   TimeOfDay _startTime = Time().stringToTime(appointmentSlot!);
  //   //computing appointment end time in string

  //   debugPrint("_startTime");
  //   debugPrint(_startTime.toString());
  //   TimeOfDay _endTime = _startTime.addMinutes(duration ?? 0);

  //   final DateTime _start = Time().generateDateTimeFromString(
  //     chosenDay,
  //     appointmentSlot,
  //   );

  //   debugPrint("_start");
  //   debugPrint(_start.toString());

  //   final DateTime _end = Time().generateDateTimeFromString(
  //     chosenDay,
  //     Time().timeToString(_endTime)!,
  //   );

  //   final String? _appointmentTime = appointmentSlot;
  //   final String _appointmentDate = Time().getDateInStandardFormat(chosenDay);

  //   final DateTime _createdAt = DateTime.now();

  //   /////////////////////////////////////////////

  //   final Master _master = chosenSalon!.ownerType == OwnerType.singleMaster
  //       ? Master(
  //           id: chosenSalon!.salonId,
  //           name: chosenSalon!.salonName,
  //         )
  //       : Master(
  //           id: chosenMaster!.masterId,
  //           name: Utils().getNameMaster(chosenMaster!.personalInfo),
  //         );

  //   /////////////////////////////////////////////

  //   const String _status = AppointmentStatus.active;
  //   const String _createdBy = CreatedBy.salon;

  //   final Service _service = Service(
  //     serviceId: singleService.serviceId,
  //     categoryId: singleService.categoryId,
  //     subCategoryId: singleService.subCategoryId,
  //     serviceName: singleService.serviceName,
  //     translations: singleService.translations,
  //     priceAndDuration: _priceAndDuration,
  //   );

  //   /// assigning all the variables and creating appointment model ....

  //   return AppointmentModel(
  //     type: _type,
  //     createdAt: _createdAt,
  //     appointmentStartTime: _start,
  //     appointmentEndTime: _end,
  //     appointmentTime: _appointmentTime ?? '',
  //     appointmentDate: _appointmentDate,
  //     salon: Salon(
  //       id: chosenSalon!.salonId,
  //       name: chosenSalon!.salonName,
  //       address: chosenSalon!.address,
  //       phoneNo: chosenSalon!.phoneNumber,
  //     ),
  //     master: _master,
  //     customer: Customer(
  //       id: customerModel!.customerId,
  //       name: Utils().getName(customerModel.personalInfo),
  //       phoneNumber: customerModel.personalInfo.phone,
  //       pic: customerModel.profilePic,
  //       email: customerModel.personalInfo.email ?? '',
  //     ),
  //     createdBy: _createdBy,
  //     salonOwnerType: OwnerType.salon,
  //     status: _status,
  //     subStatus: _start.difference(DateTime.now()).inHours < 24 ? ActiveAppointmentSubStatus.confirmed : ActiveAppointmentSubStatus.unConfirmed,
  //     updates: _updates,
  //     updatedAt: _updatedAt,
  //     services: [_service],
  //     priceAndDuration: _priceAndDuration,
  //     paymentInfo: PaymentInfo(
  //       bonusApplied: false,
  //       bonusAmount: 0,
  //       actualAmount: 0,
  //       bonusIds: [],
  //       paymentDone: false,
  //       onlinePayment: false,
  //       paymentMethod: PaymentMethods.cardSalon,
  //     ),
  //   );
  // }

  ///appointment model for multiple services type for prep time, clean up time or processing time
  AppointmentModel _createOtherNewAppointmentTypeModelForMultipleServices({String? type, String? AppointmentSlot, int? duration, required CustomerModel customer}) {
    ///creating all the required variables
    final String _type = type!;
    //updating the latest update
    final List<String> _updates = [AppointmentUpdates.createdByCustomer];
    final List<DateTime> _updatedAt = [DateTime.now()];

    //////////////////////////////////////////////
    //handling appointment TIME & DURATION
    //////////////////////////////////////////////
    final PriceAndDurationModel _priceAndDuration = priceAndDuration[chosenMaster?.masterId] ?? PriceAndDurationModel();
    debugPrint(type + " Chosen Slots");
    debugPrint(AppointmentSlot);

    TimeOfDay _startTime = Time().stringToTime(AppointmentSlot!);
    //computing appointment end time in string

    debugPrint("_startTime");
    debugPrint(_startTime.toString());
    TimeOfDay _endTime = _startTime.addMinutes(duration);

    final DateTime _start = Time().generateDateTimeFromString(chosenDay, AppointmentSlot);

    debugPrint("_start");
    debugPrint(_start.toString());

    final DateTime _end = Time().generateDateTimeFromString(chosenDay, Time().timeToString(_endTime)!);

    final String? _appointmentTime = AppointmentSlot;
    final String _appointmentDate = Time().getDateInStandardFormat(chosenDay);

    final DateTime _createdAt = DateTime.now();

    /////////////////////////////////////////////

    final Salon _salon = Salon(
      id: chosenSalon!.salonId,
      name: chosenSalon!.salonName,
      phoneNo: chosenSalon!.phoneNumber,
      address: chosenSalon!.address,
    );

    final Master _master = Master(
      id: chosenMaster!.masterId,
      name: "${chosenMaster?.personalInfo?.firstName ?? ''} ${chosenMaster?.personalInfo?.lastName ?? ''}",
    );

    final Customer _customer = Customer(
      id: customer.customerId,
      name: Utils().getName(customer.personalInfo),
      pic: customer.profilePic,
      phoneNumber: customer.personalInfo.phone,
      email: customer.personalInfo.email ?? '',
    );

    /////////////////////////////////////////////

    const String _status = AppointmentStatus.active;

    List<Service> selectedAppointmentServices = [];

    for (var selectedAvailableService in chosenServices) {
      selectedAppointmentServices.add(Service(
        serviceId: selectedAvailableService.serviceId,
        categoryId: selectedAvailableService.categoryId,
        subCategoryId: selectedAvailableService.subCategoryId,
        serviceName: selectedAvailableService.serviceName,
        translations: selectedAvailableService.translations,
        priceAndDuration: PriceAndDurationModel(
          isFixedPrice: selectedAvailableService.isFixedPrice,
          isPriceRange: selectedAvailableService.isPriceRange,
          isPriceStartAt: selectedAvailableService.isPriceStartAt,
          durationinHr: selectedAvailableService.priceAndDuration!.durationinHr,
          durationinMin: selectedAvailableService.priceAndDuration!.durationinMin,
          duration: selectedAvailableService.priceAndDuration!.duration,
          price: selectedAvailableService.priceAndDuration!.price,
        ),
      ));
    }

    PaymentInfo _paymentInfo = PaymentInfo(
      bonusApplied: false,
      bonusAmount: 0,
      actualAmount: 0,
      bonusIds: [],
      paymentDone: false,
      onlinePayment: false,
      paymentMethod: 'card',
    );

    /// assigning all the variables and creating appointment model ....

    return AppointmentModel(
      type: _type,
      createdAt: _createdAt,
      appointmentStartTime: _start,
      appointmentEndTime: _end,
      appointmentTime: _appointmentTime!,
      appointmentDate: _appointmentDate,
      salon: _salon,
      master: _master,
      customer: _customer,
      createdBy: CreatedBy.customer,
      salonOwnerType: OwnerType.salon,
      status: _status,
      subStatus: _start.difference(DateTime.now()).inHours < 24 ? ActiveAppointmentSubStatus.confirmed : ActiveAppointmentSubStatus.unConfirmed,
      updates: _updates,
      updatedAt: _updatedAt,
      services: selectedAppointmentServices,
      priceAndDuration: _priceAndDuration,
      paymentInfo: _paymentInfo,
    );
  }

  // AppointmentModel _createOtherNewAppointmentTypeModelForMultipleServices({
  //   required AppointmentModel appointment,
  //   String? type,
  //   String? appointmentSlot,
  //   int? duration,
  //   required CustomerModel? customerModel,
  // }) {
  //   ///creating all the required variables
  //   final String _type = type!;
  //   //updating the latest update
  //   final List<String> _updates = [AppointmentUpdates.createdByCustomer];
  //   final List<DateTime> _updatedAt = [DateTime.now()];

  //   List<Service> servicesList = appointment.services;

  //   //////////////////////////////////////////////
  //   //handling appointment TIME & DURATION
  //   //////////////////////////////////////////////
  //   final PriceAndDurationModel _priceAndDuration = mastersPriceDurationMap[appointment.master?.id] ?? PriceAndDurationModel();
  //   debugPrint(type + " Chosen Slots");
  //   debugPrint(appointmentSlot);

  //   TimeOfDay _startTime = Time().stringToTime(appointmentSlot!);
  //   //computing appointment end time in string

  //   debugPrint("_startTime");
  //   debugPrint(_startTime.toString());
  //   TimeOfDay _endTime = _startTime.addMinutes(duration ?? 0);

  //   final DateTime _start = Time().generateDateTimeFromString(chosenDay, appointmentSlot);

  //   debugPrint("_start");
  //   debugPrint(_start.toString());

  //   final DateTime _end = Time().generateDateTimeFromString(
  //     chosenDay,
  //     Time().timeToString(_endTime)!,
  //   );

  //   final String? _appointmentTime = appointmentSlot;
  //   final String _appointmentDate = Time().getDateInStandardFormat(chosenDay);

  //   final DateTime _createdAt = DateTime.now();

  //   /////////////////////////////////////////////

  //   final Master _master = Master(id: appointment.master!.id, name: appointment.master!.name);

  //   /////////////////////////////////////////////

  //   const String _status = AppointmentStatus.active;

  //   const String _createdBy = CreatedBy.salon;

  //   List<Service> selectedAppointmentServices = [];

  //   for (var selectedAvailableService in servicesList) {
  //     selectedAppointmentServices.add(Service(
  //       serviceId: selectedAvailableService.serviceId,
  //       categoryId: selectedAvailableService.categoryId,
  //       subCategoryId: selectedAvailableService.subCategoryId,
  //       serviceName: selectedAvailableService.serviceName,
  //       translations: selectedAvailableService.translations,
  //       priceAndDuration: PriceAndDurationModel(
  //         // isFixedPrice: selectedAvailableService.isFixedPrice,
  //         // isPriceRange: selectedAvailableService.isPriceRange,
  //         // isPriceStartAt: selectedAvailableService.isPriceStartAt,
  //         durationinHr: selectedAvailableService.priceAndDuration!.durationinHr,
  //         durationinMin: selectedAvailableService.priceAndDuration!.durationinMin,
  //         duration: selectedAvailableService.priceAndDuration!.duration,
  //         price: selectedAvailableService.priceAndDuration!.price,
  //       ),
  //     ));
  //   }

  //   /// assigning all the variables and creating appointment model ....

  //   return AppointmentModel(
  //     type: _type,
  //     createdAt: _createdAt,
  //     appointmentStartTime: _start,
  //     appointmentEndTime: _end,
  //     appointmentTime: _appointmentTime ?? '',
  //     appointmentDate: _appointmentDate,
  //     salon: Salon(
  //       id: chosenSalon!.salonId,
  //       name: chosenSalon!.salonName,
  //       address: chosenSalon!.address,
  //       phoneNo: chosenSalon!.phoneNumber,
  //     ),
  //     master: _master,
  //     customer: Customer(
  //       id: customerModel!.customerId,
  //       name: Utils().getName(customerModel.personalInfo),
  //       phoneNumber: customerModel.personalInfo.phone,
  //       pic: customerModel.profilePic,
  //       email: customerModel.personalInfo.email ?? '',
  //     ),
  //     createdBy: _createdBy,
  //     salonOwnerType: OwnerType.salon,
  //     status: _status,
  //     subStatus: _start.difference(DateTime.now()).inHours < 24 ? ActiveAppointmentSubStatus.confirmed : ActiveAppointmentSubStatus.unConfirmed,
  //     updates: _updates,
  //     updatedAt: _updatedAt,
  //     services: selectedAppointmentServices,
  //     priceAndDuration: _priceAndDuration,
  //     paymentInfo: PaymentInfo(
  //       bonusApplied: false,
  //       bonusAmount: 0,
  //       actualAmount: 0,
  //       bonusIds: [],
  //       paymentDone: false,
  //       onlinePayment: false,
  //       paymentMethod: PaymentMethods.cardSalon,
  //     ),
  //   );
  // }

  resetFlow() {
    loadingStatus = Status.init;
    chosenMaster = null;
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
    serviceAgainstMaster = [];
    // mastersServicesMapAll = {};
    chosenBonus = null;
    paymentMethod = null;
    yclientActive = false;
    beautyProActive = false;
    beautyProConfig = null;
    slotsStatus = Status.init;
    appointmentModelSalonOwner = [];
    selectedItems = [];
    selectedSubItems = [];
    unavailableSelectedItems = [];
    groupUnavailableSelectedItems = {};
    bookingFlowPageIndex = 0;
    confirmationPageIndex = null;
    notifyListeners();
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
    selectedItems = [];
    selectedSubItems = [];
    unavailableSelectedItems = [];
    groupUnavailableSelectedItems = {};
    bookingFlowPageIndex = 0;
    confirmationPageIndex = null;
    notifyListeners();
  }

  cle() {
    categoriesAvailable = [];
    servicesAvailable = [];
    masterServicesAvailable = [];
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
