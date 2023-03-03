import 'package:bbblient/src/models/customer/customer.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/notification/fcm_token.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'collections.dart';

class CustomerApi {
  CustomerApi._privateConstructor();
  static final CustomerApi _instance = CustomerApi._privateConstructor();
  factory CustomerApi() {
    return _instance;
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<CustomerModel?> getCustomer() async {
    try {
      if (_firebaseAuth.currentUser == null) return null;

      DocumentSnapshot snap = await Collection.customersAdmins.doc(_firebaseAuth.currentUser?.uid).get();

      if (snap.exists) {
        Map<String, dynamic> adminData = snap.data() as Map<String, dynamic>;
        DocumentSnapshot doc = await Collection.customers.doc(adminData['customerIds'][0]).get();

        printIt(doc.data());
        if (doc.exists) {
          final CustomerModel customer = CustomerModel.fromJson(doc.data() as Map<String, dynamic>);
          customer.customerId = doc.id;

          FCMTokenHandler.updateCustomerFCMToken(customer);

          return customer;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      printIt('error in getting customer');
      printIt(e);
    }
    return null;
  }

  Future<bool> checkIfCustomerExists(String number) async {
    printIt(number);
    try {
      // //f (_firebaseAuth.currentUser == null) return null;

      Query snap = Collection.customers.where('personalInfo.phone', isEqualTo: number);

      final getData = await snap.get();
      if (getData.docs.isEmpty) {
        printIt('customer is emptyyyy');
        return false;
      } else {
        debugPrint('geData${getData.docs}');
        printIt('customer is not emptyyyy');

        return true;
      }
    } catch (e) {
      printIt('error in getting customer');
      printIt(e);
      return false;
    }
  }

  Future<CustomerModel?> getCustomerById({required String customerId}) async {
    try {
      DocumentSnapshot doc = await Collection.customers.doc(customerId).get();
      printIt(doc.data());
      if (doc.exists) {
        final CustomerModel user = CustomerModel.fromJson(doc.data() as Map<String, dynamic>);
        user.customerId = doc.id;
        return user;
      } else {
        return null;
      }
    } catch (e) {
      printIt(e);
    }
    return null;
  }

  updateFcmToken({required String customerId, required String fcmToken}) async {
    try {
      await Collection.customers.doc(customerId).update(
        {'fcmToken': fcmToken},
      );
    } catch (e) {
      printIt(e);
    }
  }

  updateLocale({required String customerId, required String locale}) async {
    try {
      await Collection.customers.doc(customerId).update(
        {'locale': locale},
      );
    } catch (e) {
      printIt(e);
    }
  }

  updateReferral({required String customerId, required String referralLink}) async {
    try {
      await Collection.customers.doc(customerId).update(
        {
          'referralLink': referralLink,
        },
      );
    } catch (e) {
      printIt(e);
    }
  }

  updateFavourites(CustomerModel customer) async {
    try {
      await Collection.customers.doc(customer.customerId).update(
        {'favSalons': customer.favSalons},
      );
    } catch (e) {
      printIt(e);
    }
  }

  updatePreferences({required String customerId, required String preferredGender, required List<String> preferredCategories}) async {
    try {
      await Collection.customers.doc(customerId).update(
        {'preferredCategories': preferredCategories, 'preferredGender': preferredGender},
      );
    } catch (e) {
      printIt(e);
    }
  }

  updatePersonalInfo({
    required String customerId,
    required PersonalInfo personalInfo,
  }) async {
    try {
      await Collection.customers.doc(customerId).update(
        {
          'personalInfo': personalInfo.toJson(),
        },
      );
    } catch (e) {
      printIt('Catch error on updatePersonalInfo() - $e');
    }
  }

  Future<String?> updateCustomer({required CustomerModel customerModel}) async {
    try {
      DocumentSnapshot snap = await Collection.customersAdmins.doc(_firebaseAuth.currentUser?.uid).get();
      printIt(snap.data());
      if (snap.exists) {
        Map<String, dynamic> adminData = snap.data() as Map<String, dynamic>;
        await Collection.customers.doc(adminData['customerIds'][0]).set(customerModel.toJson());
      } else {
        DocumentReference doc = await Collection.customers.add(customerModel.toJson());
        await Collection.customersAdmins.doc(_firebaseAuth.currentUser?.uid).set({
          'customerIds': [doc.id]
        });
      }
    } catch (e) {
      printIt(e);
      return null;
    }
    return null;
  }

  Future<bool> addCustomerLocation({required Position newPosition}) async {
    try {
      DocumentSnapshot snap = await Collection.customersAdmins.doc(_firebaseAuth.currentUser?.uid).get();
      printIt(snap.data());
      if (snap.exists) {
        Map<String, dynamic> adminData = snap.data() as Map<String, dynamic>;
        await Collection.customers.doc(adminData['customerIds'][0]).update(
          {
            'locations': [newPosition.toJson()]
          },
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

// //customer related operations
// class CustomerApi {
//   // returns customer profile
//   // will return null if no profile found or on exception
//   Future<CustomerModel?> getCustomer(String phoneNo) async {
//     try {
//       QuerySnapshot _response = await Collection.customers.where("personalInfo.phone", isEqualTo: phoneNo).get();
//       printIt(_response.docs.length == 1);
//       printIt(_response.docs.toString());
//       if (_response.docs.length == 1) {
//         Map _customerMap = _response.docs.first.data() as Map<dynamic, dynamic>;
//         CustomerModel customerModel = CustomerModel.fromJson(_customerMap as Map<String, dynamic>);
//         customerModel.customerId = _response.docs.first.id;
//         printIt(customerModel.toJson());
//         return customerModel;
//       }
//     } catch (e) {
//       printIt(e);
//       return null;
//     }
//     return null;
//   }

// links the userdocument to UID in firebase
// Future<String?> linkCustomer({required CustomerModel customer, required String uid}) async {
//   try {
//     // if customer is already present then customer id must not be null
//     // so that doc with same customer id can be updated
//     // other wise a brand new document will be created
//     final String? customerId = await (updateCustomer(customer));
//     //links this salon with owner/admin via id
//     await AdminApi().updateAdmin(customerIds: [customerId], adminUid: uid);

//     return customerId;
//   } catch (e) {
//     debugPrint(e.toString());
//     return null;
//   }
// }

// Future<String?> updateCustomer(CustomerModel customer) async {
//   try {
//     printIt(customer.customerId);
//     final DocumentReference _docRef = Collection.customers.doc();
//     // printIt(_docRef);
//     // printIt(customer.fcmToken);
//     // printIt("updating fcm");
//     await _docRef.set(customer.toJson(), SetOptions(merge: true));
//     return _docRef.id;
//   } catch (e) {
//     printIt('customer Not Updated');
//     printIt(e);
//     return null;
//   }
// }

// updates the customer data
// Future linkCustomerProfilePic(CustomerModel customer) async {
//   try {
//     // if customer is already present then customer id must not be null
//     // so that doc with same customer id can be updated
//     // other wise a brand new document will be created

//     final DocumentReference _docRef = Collection.customers.doc(customer.customerId);

//     //updates customer's profile pic's address
//     await _docRef.set({"profilePic": customer.profilePic}, SetOptions(merge: true));

//     return _docRef.id;
//   } catch (e) {
//     debugPrint(e.toString());
//     debugPrint('exception caught while updating an image');
//     return null;
//   }
// }

///checks if customer id is already present before registering/creating a new one
//customer id can also be created by the salon, so if salon has already created it then we must link that profile while registering a new customer
//returns an id if profile already exists (checks by matching phone number)
// Future<String?> checkIfCustomerPresent({required String phoneNumber}) async {
//   printIt(phoneNumber);
//   QuerySnapshot response = await Collection.customers.where("personalInfo.phone", isEqualTo: phoneNumber).get();
//   if (response.docs.isEmpty) {
//     return null;
//   } else {
//     return response.docs[0].id;
//   }
// }

// Future<bool?> toggleSalonToFav({required String? salonId}) async {
//   try {
//     // if customer is already present then customer id must not be null
//     // so that doc with same customer id can be updated
//     // other wise a brand new document will be created
//     final DocumentReference _docRef = Collection.customers.doc(homeController.customerId);
//     if (homeController.customer!.favSalons!.contains(salonId)) {
//       printIt("fav");
//       homeController.customer!.favSalons!.removeWhere((element) => element == salonId);

//       await _docRef.update({"favSalons": homeController.customer!.favSalons});
//       // printIt(homeController.customer.favSalons);

//       return false;
//     } else {
//       printIt("not fav");
//       await _docRef.update({
//         "favSalons": FieldValue.arrayUnion([salonId])
//       });
//       homeController.customer!.favSalons!.add(salonId);
//       // printIt(homeController.customer.favSalons);
//       return true;
//     }

//     // return _docRef.id;
//   } catch (e) {
//     printIt(e);
//     printIt('exception caught');
//     return null;
//   }
// }
// }
