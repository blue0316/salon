import 'package:cloud_firestore/cloud_firestore.dart';

class Collection {
  static final CollectionReference allCategories =
      FirebaseFirestore.instance.collection('allCategories');
  static final CollectionReference allSubCategories =
      FirebaseFirestore.instance.collection('allSubCategories');
  static final CollectionReference allServices =
      FirebaseFirestore.instance.collection('allServices');
  static final CollectionReference chats =
      FirebaseFirestore.instance.collection('chats');
  static final CollectionReference customLinks =
      FirebaseFirestore.instance.collection('customLinks');
  static final CollectionReference customerAdmins =
      FirebaseFirestore.instance.collection('customerAdmins');
  static final CollectionReference salonAdmins =
      FirebaseFirestore.instance.collection('salonAdmins');
  static final CollectionReference salons =
      FirebaseFirestore.instance.collection('salons');
  static final CollectionReference services =
      FirebaseFirestore.instance.collection('services');
  static final CollectionReference masters =
      FirebaseFirestore.instance.collection('salonMasters');
  static final CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  static final CollectionReference customersAdmins =
      FirebaseFirestore.instance.collection('customerAdmins');
  static final CollectionReference appointments =
      FirebaseFirestore.instance.collection('appointments');
  static final CollectionReference appData =
      FirebaseFirestore.instance.collection('userAppSettings');
  static final CollectionReference notifications =
      FirebaseFirestore.instance.collection('notifications');
  static final CollectionReference referrals =
      FirebaseFirestore.instance.collection('referrals');
  static final CollectionReference bonuses =
      FirebaseFirestore.instance.collection('bonuses');
  static final CollectionReference beautyPro =
      FirebaseFirestore.instance.collection('beautyPro');
  static final CollectionReference promotions =
      FirebaseFirestore.instance.collection('promotions');
  static final CollectionReference yClients =
      FirebaseFirestore.instance.collection('yClients');
  //auth error in customer app
  static final CollectionReference customerAuthError =
      FirebaseFirestore.instance.collection('customerAuthError');
}
