import 'appointment/appointment.dart';

// class NotificationModel {
//   //type mean notification is for review or appointment
//   String? notificationId;
//   String? notificationType;
//   //creation time
//   DateTime? createdAt;
//   bool? seen;
//   AppointmentModel? appointment;

//   NotificationModel({this.notificationId, this.notificationType, this.createdAt, this.appointment, this.seen});

//   NotificationModel.fromJson(Map<String, dynamic> json) {
//     notificationId = json['notificationId'];
//     notificationType = json['notificationType'];
//     if (json['createdAt'] != null) createdAt = json['createdAt'].toDate();
//     seen = json['seen'];
//     if (json['appointment'] != null) {
//       appointment = AppointmentModel.fromJson(json['appointment']);
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['notificationType'] = notificationType;
//     data['createdAt'] = createdAt;
//     data['seen'] = seen;
//     if (appointment != null) {
//       data['appointment'] = appointment!.toJson();
//     }
//     return data;
//   }
// }
