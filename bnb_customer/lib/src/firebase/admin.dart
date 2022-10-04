import 'package:bbblient/src/models/customer/customer_admin.dart';
import 'package:bbblient/src/models/customer/customer_auth_error.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/utils/utils.dart';

import 'collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminApi {
  AdminApi._privateConstructor();
  static final AdminApi _instance = AdminApi._privateConstructor();
  factory AdminApi() {
    return _instance;
  }
  //updates the salon admin data

  updateAdmin(CustomerAdmin customerAdmin) async {
    if (customerAdmin.id != null) {
      try {
        await Collection.customerAdmins
            .doc(customerAdmin.id)
            .set(customerAdmin.toJson(), SetOptions(merge: true));
        return Status.success;
      } catch (e) {
        printIt(e);
        return Status.failed;
      }
    }
  }

  Future<Status> updateAdminDevice(CustomerAdmin admin) async {
    try {
      final String? info = await Utils().getDeviceInfo();
      if (info == null) return Status.failed;
      Status status = Status.success;

      admin.registeredDevices ??= [];

      if (admin.registeredDevices!.contains(info)) return status;

      admin.registeredDevices!.add(info);

      await _saveAdminDeviceToFirebase(admin)
          .onError((dynamic error, stackTrace) => status = Status.failed);

      return status;
    } catch (e) {
      printIt(e);
      return Status.failed;
    }
  }

  _saveAdminDeviceToFirebase(CustomerAdmin customerAdmin) async {
    if (customerAdmin.id != null && customerAdmin.registeredDevices != null) {
      try {
        await Collection.customerAdmins.doc(customerAdmin.id).set(
            {'registeredDevices': customerAdmin.registeredDevices},
            SetOptions(merge: true));
        return Status.success;
      } catch (e) {
        printIt(e);
        return Status.failed;
      }
    }
  }

  //adds up an auth error in-case of error
  addAuthError(String e, String phoneNumber) async {
    try {
      final CustomerAuthError error = CustomerAuthError(
          authError: e,
          phoneNumber: phoneNumber,
          createdAt: DateTime.now(),
          deviceInfo: await Utils().getDeviceInfo());

      await Collection.customerAuthError
          .doc()
          .set(error.toJson(), SetOptions(merge: true));
      printIt("added auth error");
      printIt(error.toJson());
      return Status.success;
    } catch (e) {
      printIt(e);
      return Status.failed;
    }
  }

  // //updates the customer admin data with the auth error
  // updateAdminAuthError(CustomerAdmin customerAdmin,String error) async {
  //   if (customerAdmin.id != null && customerAdmin.authError != null) {
  //     try {
  //       customerAdmin.authError??=[];
  //       //adds the datetime along with it
  //       customerAdmin.authError!.add("$error (${DateTime.now()})");
  //       await Collection.customerAdmins.doc(customerAdmin.id).set(
  //           {'authError': customerAdmin.authError}, SetOptions(merge: true));
  //       return Status.success;
  //     } catch (e) {
  //       printIt(e);
  //       return Status.failed;
  //     }
  //   }
  // }

  // returns customer profile id if profile is available
  // can be used to check if registration info already present
  // for eg. customer linked with customerAdminId
  Future<String?> getCustomerProfileId(String adminUid) async {
    DocumentSnapshot<Map> _response = await (Collection.customerAdmins
        .doc(adminUid)
        .get() as Future<DocumentSnapshot<Map<dynamic, dynamic>>>);

    if (_response.data() != null &&
        _response.data()!.isNotEmpty &&
        _response.data()!['customerIds'] != null &&
        _response.data()!['customerIds'].length != 0) {
      // homeController.customerId = _response.data()!['customerIds'].first;
      return _response.data()!['customerIds'][0];
    }
  }
}
