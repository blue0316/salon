import 'package:intl/intl.dart';
import 'currency_data.dart';

String getCurrency(String countryCode) {
  String currencyCode = 'USD';

  // Find currency code in data set
  for (Map<String, String> country in countryTocurrency) {
    if (country['CountryCode'] == countryCode) {
      currencyCode = country['Code'] as String;
    }
  }

  var format = NumberFormat.simpleCurrency(name: currencyCode);
  return format.currencySymbol;
}
