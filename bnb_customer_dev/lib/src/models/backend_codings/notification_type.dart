class NotificationType {
  static const String appointment = 'appointment';
  static const String chat = 'chat';
  static const String review = 'review';
  static const String referral = 'referral';
  static const String bonus = 'bonus';
  static const String announcement = 'announcement';
  static const String newMessage = 'newMessage';
}

class NotificationSubType {
  ///for appointments
  static const appointmentCreated = "appointmentCreated";
  static const appointmentChanged = "appointmentChanged";
  static const appointmentCancelled = "appointmentCancelled";
  static const appointmentUpcoming = "appointmentUpcoming";
  // referralNotification
  static const String referralInstall = 'referralInstall';
  static const String referralBonus = 'referralBonus';
}
