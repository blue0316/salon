// import 'package:bbblient/src/firebase/customer.dart';
// import 'package:bbblient/src/models/customer/customer.dart';
// import 'package:bbblient/src/utils/utils.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';

// class FCMTokenHandler {
//   static getFCMToken() async {
//     if (kIsWeb) return null;
//     // return await FirebaseMessaging.instance.getToken();
//   }

//   static updateCustomerFCMToken(CustomerModel customer) async {
//     final newToken = await getFCMToken();
//     if (newToken == null) return null;

//     if (customer.fcmToken != newToken) {
//       CustomerApi().updateFcmToken(customerId: customer.customerId, fcmToken: newToken);
//       customer.fcmToken = newToken;
//       printIt('fcm updated $newToken');
//       return newToken;
//     }
//     return null;
//   }
// }
