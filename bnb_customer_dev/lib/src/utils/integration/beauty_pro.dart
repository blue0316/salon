// import 'package:bbblient/src/firebase/integration/beauty_pro.dart';
// import 'package:bbblient/src/models/appointment/appointment.dart';
// import 'package:bbblient/src/models/enums/status.dart';
// import 'package:bbblient/src/models/integration/beauty_pro/beauty_pro.dart';
// import 'package:bbblient/src/utils/time.dart';
// import 'package:bbblient/src/utils/translation.dart';
// import 'package:bbblient/src/utils/utils.dart';

// /// !!!!!!!!!!!!!!! important !!!!!!!!!!!!!!!
// /// init must be called before calling any other function
// /// init maintains the state of the required token

// class BeautyProEngine {
//   BeautyProEngine._privateConstructor();
//   static final BeautyProEngine _instance = BeautyProEngine._privateConstructor();
//   factory BeautyProEngine() {
//     return _instance;
//   }
//   static final BeautyProApi _api = BeautyProApi();

//   static BeautyProConfig? config;

//   static DateTime? _selectedDate;

//   static Map<String, List<String>>? _masterSlotsMap;

//   ///initializes tokens
//   // return true if syncing is active other will return false
//   Future<bool> init(salonId) async {
//     //getting token from firebase
//     final _oldConfig = await _api.getSalonConfig(salonId);
//     // refreshing tokens
//     config = await _api.beautyProComputeToken(_oldConfig);

//     return (config?.syncActive ?? false);
//   }

//   //for customer app
//   /// returns all the available slots on a specific day
//   /// in the form of {"master-id":[10:30,10:45,11:00]} : slots are there
//   Future<Map<String, List<String>>?> getMasterSlots(DateTime date) async {
//     //in case sync is not active or config is null
//     if (!(config?.syncActive ?? false)) return null;
//     return await _api.getBeautyProAvailableTime(date, config);
//   }

//   /// for partners app only
//   //  takes in slots available in bnb app and merge it with beauty_pro app
//   Future<List<String>> syncSlots(
//     List<String> slots,
//     date,
//     beautyProMasterId,
//   ) async {
//     try {
//       if (beautyProMasterId == null || beautyProMasterId == "") return slots;

//       //in case sync is not active or config is null
//       if (!(config?.syncActive ?? false)) return slots;

//       if (_selectedDate != date) {
//         printIt("fetched for $date");
//         //will fetch all the available slots from beauty pro
//         _masterSlotsMap = await _api.getBeautyProAvailableTime(date, config);
//         _selectedDate = date;
//       }

//       //if (_masterSlotsMap == null) return slots;

//       final List<String>? _beautyProSlots = _masterSlotsMap![beautyProMasterId];

//       return Time().getCommonSlots(_beautyProSlots, slots);
//     } catch (e) {
//       printIt("error while parsing time slots");
//       printIt(e);
//       return [];
//     }
//   }

//   /// Takes in [AppointmentModel] and tries to make booking in beauty pro
//   /// if beauty pro integration is not active then returns the appointment model back
//   /// otherwise creates a booking in beauty pro system and returns back [AppointmentModel] with beautyProId
//   /// in case of error will return null and u need to [abort] the booking
//   Future<AppointmentModel?> makeAppointment(AppointmentModel app, String? beautyProMasterId) async {
//     try {
//       if (config == null || beautyProMasterId == "" || beautyProMasterId == null) return app;
//       //in case sync is not active
//       if (!(config?.syncActive ?? false)) return app;

//       //will fetch all the available slots
//       final String? id = await _api.bookAppointment(app.appointmentStartTime, beautyProMasterId, int.parse(app.priceAndDuration.duration!), config, comment: generateComment(app.services));

//       if (id == null) return null;
//       app.beautyProId = id;
//       return app;
//     } catch (e) {
//       printIt(e);
//       return null;
//     }
//   }

//   ///cancels the appointment and returns the status
//   Future<Status> cancelAppointment(AppointmentModel? app) async {
//     try {
//       //in case sync is not active or app id is null
//       if (!(config?.syncActive ?? false) || app == null || app.beautyProId == null || app.beautyProId == "") {
//         return Status.success;
//       } else {
//         //will fetch all the available slots
//         return await _api.cancelAppointment(app.beautyProId, config);
//       }
//     } catch (e) {
//       printIt(e);
//       return Status.failed;
//     }
//   }

//   String generateComment(List<Service>? services) {
//     if (services == null || services.isEmpty) return "";
//     String comment;

//     if (services.length == 1) {
//       //(bnb) (Service Name: Hair color) (price:350)
//       final Service e = services.first;
//       comment = "(bnb) (Service Name: ${Translation.translate(map: e.translations, langCode: 'uk')}) (price: ${e.priceAndDuration!.price}₴})";
//     } else {
//       //(bnb) [(Service Name: Harcut / price: 250), (Service Name: Harcut / price: 250) ]
//       comment = "(bnb) ${services.map((e) => "(Service Name: ${Translation.translate(map: e.translations, langCode: 'uk')} / price: ${e.priceAndDuration!.price}₴})${e == services.last ? "" : ","} ").toList()} ";
//     }
//     return comment;
//   }
// }
