// import 'package:bbblient/src/firebase/salons.dart';
// import 'package:bbblient/src/models/salon_master/salon.dart';
// import 'package:bbblient/src/utils/notification/notifications.dart';
// import 'package:bbblient/src/utils/utils.dart';

// class ChatNotification {
//   final SalonApi _salonApi = SalonApi();
//   static String _salonId = '';
//   static String _salonFcmToken = '';

//   ///use it inside customer app
//   //sends the chat notification to salon
//   //todo : need to add translation support, currently limited to "uk" only
//   sendNotificationToSalon(String? customerName, String content, String? salonId,
//       {int type = 0}) async {
//     if (salonId == null || salonId == "") return;

//     final pattern = customerName?.replaceAll(' ', '') ?? "";
//     if (pattern == "") customerName = "клієнта";

//     String body = content;
//     String title = "Нове повідомлення від $customerName";
//     // type: 0 = text, 1 = image, 2 = audio
//     if (type == 1) {
//       body = "Нове зображення";
//     } else if (type == 2) {
//       body = "Нове аудіо";
//     }

//     if (_salonId != salonId) {
//       //will only call if salon fcm token is present
//       //otherwise will use the cached salon token from [_salonFcmToken]
//       //call api to fetch fcm token
//       printIt('retrieving fcm token for salonID : $salonId');
//       final SalonModel? salon = await _salonApi.getSalonFromId(salonId);
//       if (salon == null) return;
//       _salonId = salonId;
//       _salonFcmToken = salon.fcmToken ?? "";
//     }
//     printIt("Sending notification to FCM token id : $_salonFcmToken");
//     await sendNotification(title: title, body: body, fcmToken: _salonFcmToken);
//   }
// }
