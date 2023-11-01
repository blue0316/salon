import 'package:bbblient/src/firebase/notification.dart';
import 'package:bbblient/src/models/appointment/notification.dart';
import 'package:bbblient/src/models/backend_codings/notification_type.dart';
import 'package:bbblient/src/models/customer/customer.dart';

class ReferralNotification {
  static NotificationsApi api = NotificationsApi();

  static sendReferralInstallNotification(
      {required CustomerModel customerBy,
      required CustomerModel referredTo}) async {
    await api.uploadNotification(NotificationModel(
      notificationId: '',
      reviewId: '',
      notificationType: NotificationType.referral,
      notificationSubType: NotificationSubType.referralInstall,
      titleTranslations: {
        "en":
            "your friend\b ${referredTo.personalInfo.firstName}\b signed up on bnb",
        "uk":
            "Ваш друг\b ${referredTo.personalInfo.firstName}\b приєднався до bnb"
      },
      bodyTranslations: {
        "en": "when your friends completes first booking you will get bonuses",
        "uk":
            "Коли ваш друг завершить своє перше бронювання, ви отримаєте бонус"
      },
      profilePic: customerBy.profilePic,
      locale: customerBy.locale,
      fcmToken: customerBy.fcmToken,
      triggerTime: DateTime.now(),
      createdAt: DateTime.now(),
      targetId: customerBy.customerId,
      salonId: '',
      customerId: customerBy.customerId,
      appointmentId: '',
      pushNotificationDue: true,
      seen: false,
    ));
  }

  static sendReferralBonusNotification({
    required CustomerModel customerModel,
    required int totalValidatedAmount,
  }) async {
    await api.uploadNotification(
      NotificationModel(
        notificationId: '',
        reviewId: '',
        notificationType: NotificationType.referral,
        notificationSubType: NotificationSubType.referralBonus,
        titleTranslations: {
          "en": "You got a bonus for inviting a friend",
          "uk": "Ви отримали бонус за запрошення друга",
        },
        bodyTranslations: {
          "en": " +$totalValidatedAmount",
          "uk": " +$totalValidatedAmount"
        },
        profilePic: customerModel.profilePic,
        locale: customerModel.locale,
        fcmToken: customerModel.fcmToken,
        triggerTime: DateTime.now(),
        createdAt: DateTime.now(),
        targetId: customerModel.customerId,
        salonId: '',
        customerId: customerModel.customerId,
        appointmentId: '',
        pushNotificationDue: true,
        seen: false,
      ),
    );
  }
}
