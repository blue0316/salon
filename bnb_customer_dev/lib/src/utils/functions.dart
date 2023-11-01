import 'package:bbblient/src/models/customer/customer.dart';

class NamingConventions {
  static String? getName(PersonalInfo? info) {
    String? name = '';
    if (info != null) {
      if (info.firstName != null) name = info.firstName;
      if (info.lastName != null) name = name! + " ${info.lastName}";
    }
    return name;
  }
}
