// import 'package:bbblient/src/models/products.dart';
import 'dart:convert';
import 'package:bbblient/src/models/customer_web_settings.dart';
import 'package:bbblient/src/mongodb/collection.dart';
import 'package:bbblient/src/mongodb/db_service.dart';
import 'package:bbblient/src/utils/utils.dart';

class CustomerWebSettingsApi {
  // CustomerWebSettingsApi._privateConstructor();
  // static final CustomerWebSettingsApi _instance = CustomerWebSettingsApi._privateConstructor();
  // factory CustomerWebSettingsApi() {
  //   return _instance;
  // }

  CustomerWebSettingsApi._privateConstructor(this.mongodbProvider);

  static final CustomerWebSettingsApi _instance = CustomerWebSettingsApi._privateConstructor(null);

  factory CustomerWebSettingsApi({DatabaseProvider? mongodbProvider}) {
    _instance.mongodbProvider = mongodbProvider;
    return _instance;
  }

  DatabaseProvider? mongodbProvider;

  Future<CustomerWebSettings?> getSalonTheme({required String salonId}) async {
    try {
      var _response = await mongodbProvider!.fetchCollection(CollectionMongo.customerWebSettings).findOne(
        filter: {"salonId": salonId},
      );

      if (_response != null) {
        Map<String, dynamic> _temp = json.decode(_response.toJson()) as Map<String, dynamic>;

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
}
