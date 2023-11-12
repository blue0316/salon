// -------------- CANCELLATION --------------
// 1. Cancellation policy is only available in US

// -------------- THEMES --------------
// 1. Barbershop Theme is now called Vintage Craft
// 2. Accent color is stored in colorScheme.secondary


//  Future<SalonModel?> getSalonFromId(String? salonId) async {
//     if (salonId == null) return null;

//     stylePrint('get salon');

//     try {
//       var _response = await mongodbProvider!.fetchCollection(CollectionMongo.salons).findOne(
//         filter: {"__path__": "salons/$salonId"},
//       );

//       if (_response != null) {
//         Map<String, dynamic> _map = json.decode(_response.toJson()) as Map<String, dynamic>;

//         SalonModel salon = SalonModel.fromJson(_map);
//         return salon;
//       }
//     } catch (e) {
//       debugPrint("Error on getSalonFromId() - $e");
//       return null;
//     }
//     return null;
//   }
