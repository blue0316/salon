class NotificationModel {
  //type mean notification is for review or appointment
  late String? notificationId;

  ///token for the firebase notification
  late String? fcmToken;

  ///type of the notification,see [NotificationType]
  late String? notificationType;
  late String? notificationSubType;
  //creation time

  /// notification title and body translations
  late Map? titleTranslations;
  late Map? bodyTranslations;

  ///profile pic who have made the action
  late String? profilePic;
  // selected locale for a salon/customer
  late String? locale;

  ///time for the notification we want to trigger
  late DateTime triggerTime;

  ///notification creation time
  late DateTime? createdAt;

  /// user has seen notification or not
  /// must be initially false
  late bool? seen;
  // AppointmentModel? appointment;

  /// enable it to send push notification to devices if on [triggerTime]
  /// it will be disabled once sent
  /// can also be used to disable push notification
  late bool? pushNotificationDue;

  /// All IDs down here
  /// targets
  late String? targetId;
  late String? salonId;
  late String? customerId;

  late String? appointmentId;
  late String? reviewId;

  NotificationModel({
    required this.notificationId,
    required this.fcmToken,
    required this.notificationType,
    required this.notificationSubType,
    required this.titleTranslations,
    required this.bodyTranslations,
    required this.profilePic,
    required this.locale,
    required this.triggerTime,
    required this.createdAt,
    required this.pushNotificationDue,
    required this.seen,
    required this.targetId,
    required this.salonId,
    required this.customerId,
    required this.appointmentId,
    required this.reviewId,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId'];
    fcmToken = json['fcmToken'];
    notificationType = json['notificationType'];
    notificationSubType = json['notificationSubType'];
    titleTranslations = json['titleTranslations'];
    bodyTranslations = json['bodyTranslations'];
    profilePic = json['profilePic'];
    locale = json['locale'];
    if (json['triggerTime'] != null) triggerTime = json['triggerTime'].toDate();
    if (json['createdAt'] != null) createdAt = json['createdAt'].toDate();
    pushNotificationDue = json['pushNotificationDue'];
    seen = json['seen'];

    // if (json['appointment'] != null) {
    //   appointment = AppointmentModel.fromJson(json['appointment']);
    // }
    targetId = json['targetId'];
    salonId = json['salonId'];
    customerId = json['customerId'];
    appointmentId = json['appointmentId'];
    reviewId = json['reviewId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['fcmToken'] = fcmToken;
    data['notificationType'] = notificationType;
    data['notificationSubType'] = notificationSubType;
    data['titleTranslations'] = titleTranslations;
    data['bodyTranslations'] = bodyTranslations;
    data['profilePic'] = profilePic;
    data['locale'] = locale;
    data['triggerTime'] = triggerTime;
    data['createdAt'] = createdAt;
    data['pushNotificationDue'] = pushNotificationDue;
    data['seen'] = seen;
    // if (appointment != null) {
    //   data['appointment'] = appointment!.toJson();
    // }
    data['targetId'] = targetId;
    data['salonId'] = salonId;
    data['customerId'] = customerId;
    data['appointmentId'] = appointmentId;
    data['reviewId'] = reviewId;
    return data;
  }
}



























// class NotificationModel {
//   //type mean notification is for review or appointment
//   late String notificationId;

//   ///token for the firebase notification
//   late String fcmToken;

//   ///type of the notification,see [NotificationType]
//   late String notificationType;
//   //creation time

//   /// notification title and body translations
//   late Map titleTranslations;
//   late Map bodyTranslations;

//   ///profile pic who have made the action
//   late String profilePic;
//   // selected locale for a salon/customer
//   late String locale;

//   ///time for the notification we want to trigger
//   late DateTime triggerTime;

//   ///notification creation time
//   late DateTime createdAt;

//   /// user has seen notification or not
//   /// must be initially false
//   late bool seen;
//   // AppointmentModel? appointment;

//   /// enable it to send push notification to devices if on [triggerTime]
//   /// it will be disabled once sent
//   /// can also be used to disable push notification
//   late bool pushNotificationDue;

//   /// All IDs down here
//   /// targets
//   late String targetId;
//   late String salonId;
//   late String customerId;

//   late String appointmentId;
//   late String reviewId;

//   NotificationModel({
//     required this.notificationId,
//     required this.fcmToken,
//     required this.notificationType,
//     required this.titleTranslations,
//     required this.bodyTranslations,
//     required this.profilePic,
//     required this.locale,
//     required this.triggerTime,
//     required this.createdAt,
//     required this.pushNotificationDue,
//     required this.seen,
//     required this.targetId,
//     required this.salonId,
//     required this.customerId,
//     required this.appointmentId,
//     required this.reviewId,
//   });

//   NotificationModel.fromJson(Map<String, dynamic> json) {
//     notificationId = json['notificationId'] ?? '';
//     fcmToken = json['fcmToken'] ?? '';
//     notificationType = json['notificationType'] ?? '';
//     titleTranslations = json['titleTranslations'] ?? {};
//     bodyTranslations = json['bodyTranslations'] ?? {};
//     profilePic = json['profilePic'] ?? '';
//     locale = json['locale'] ?? 'en';
//     if (json['triggerTime'] != null) triggerTime = json['triggerTime'].toDate();
//     if (json['createdAt'] != null) createdAt = json['createdAt'].toDate();
//     pushNotificationDue = json['pushNotificationDue'] ?? true;
//     seen = json['seen'] ?? false;

//     // if (json['appointment'] != null) {
//     //   appointment = AppointmentModel.fromJson(json['appointment']);
//     // }
//     targetId = json['targetId'] ?? '';
//     salonId = json['salonId'] ?? '';
//     customerId = json['customerId'] ?? '';
//     appointmentId = json['appointmentId'] ?? "";
//     reviewId = json['reviewId'] ?? '';
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['fcmToken'] = fcmToken;
//     data['notificationType'] = notificationType;
//     data['titleTranslations'] = titleTranslations;
//     data['bodyTranslations'] = bodyTranslations;
//     data['profilePic'] = profilePic;
//     data['locale'] = locale;
//     data['triggerTime'] = triggerTime;
//     data['createdAt'] = createdAt;
//     data['pushNotificationDue'] = pushNotificationDue;
//     data['seen'] = seen;
//     // if (appointment != null) {
//     //   data['appointment'] = appointment!.toJson();
//     // }
//     data['targetId'] = targetId;
//     data['salonId'] = salonId;
//     data['customerId'] = customerId;
//     data['appointmentId'] = appointmentId;
//     data['reviewId'] = reviewId;
//     return data;
//   }
// }
