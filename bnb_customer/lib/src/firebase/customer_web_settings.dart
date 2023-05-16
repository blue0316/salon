// import 'package:bbblient/src/models/products.dart';
import 'package:bbblient/src/models/customer_web_settings.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'collections.dart';

class CustomerWebSettingsApi {
  CustomerWebSettingsApi._privateConstructor();
  static final CustomerWebSettingsApi _instance = CustomerWebSettingsApi._privateConstructor();
  factory CustomerWebSettingsApi() {
    return _instance;
  }

  Future<CustomerWebSettings?> getSalonTheme({required String salonId}) async {
    try {
      // String salonTheme = '';

      QuerySnapshot _response = await Collection.customerWebSettings.where('salonId', isEqualTo: salonId).get();

      // print('***********************');
      // print(_response);
      // print(_response.docs);
      // print('***********************');

      if (_response.docs.isNotEmpty) {
        Map<String, dynamic> _temp = _response.docs[0].data() as Map<String, dynamic>;

        CustomerWebSettings webSettings = CustomerWebSettings.fromJson(_temp);
        return webSettings;
      } else {
        return null;
      }
    } catch (e) {
      printIt('Error on getSalonTheme() - ${e.toString()}');
    }
    return null;
  }

  // Future<Map<String, dynamic>> getSalonTheme({required String salonId}) async {
  //   try {
  //     // String salonTheme = '';

  //     QuerySnapshot _response = await Collection.customerWebSettings.where('salonId', isEqualTo: salonId).get();

  //     // print('***********************');
  //     // print(_response);
  //     // print(_response.docs);
  //     // print('***********************');

  //     Map<String, dynamic> _temp = _response.docs[0].data() as Map<String, dynamic>;

  //     // salonTheme = _temp['theme']['id'];

  //     return _temp['theme'];
  //   } catch (e) {
  //     printIt('Error on getSalonTheme() - ${e.toString()}');
  //   }
  //   return {};
  // }
}
