import 'package:bbblient/src/models/appointment/notification.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'collections.dart';

class NotificationsApi {
  NotificationsApi._privateConstructor();
  static final NotificationsApi _instance = NotificationsApi._privateConstructor();
  factory NotificationsApi() {
    return _instance;
  }

  /// uploads the notification doc over the server
  Future<Status> uploadNotification(NotificationModel notification) async {
    try {
      Status status = Status.success;
      await Collection.notifications.doc().set(notification.toJson()).onError((error, stackTrace) => status = Status.failed);
      return status;
    } catch (e) {
      printIt(e);
      return Status.failed;
    }
  }

  // returns the notification stream in real-time
  Stream<List<NotificationModel>> listenNotifications(String customerId) {
    return Collection.notifications
        .where("pushNotificationDue", isEqualTo: false)
        .where("targetId", isEqualTo: customerId)
        .orderBy('triggerTime', descending: true)
        .limit(10)
        .snapshots()
        .map((snapShot) => snapShot.docs.map<NotificationModel>((notification) {
              Map<String, dynamic> _temp = notification.data() as Map<String, dynamic>;
              _temp['notificationId'] = notification.id;
              return NotificationModel.fromJson(_temp);
            }).toList());
  }

  ///takes in the list of notifications and turns on the seen flag
  Future makeNotificationsSeen(List<NotificationModel> notifications) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    try {
      for (NotificationModel _notification in notifications) {
        if (_notification.notificationId != null) {
          batch.set(Collection.notifications.doc(_notification.notificationId), {"seen": true}, SetOptions(merge: true));
        }
      }
      await batch.commit();
      return 1;
    } catch (e) {
      printIt(e);
      return 0;
    }
  }

  //delete notification doc
  Future<Status> deleteNotification(String notificationId) async {
    try {
      Status status = Status.success;
      await Collection.notifications.doc(notificationId).delete().onError((error, stackTrace) => status = Status.failed);
      return status;
    } catch (e) {
      printIt(e);
      return Status.failed;
    }
  }
}
