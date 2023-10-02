import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> getLatLongFromAddress(String address) async {
  Uri url = Uri.parse('https://nominatim.openstreetmap.org/search?format=json&q=$address');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    List<dynamic> results = json.decode(response.body);
    if (results.isNotEmpty) {
      Map<String, dynamic> location = {
        'lat': double.parse(results[0]['lat']),
        'lng': double.parse(results[0]['lon']),
      };
      return location;
    } else {
      throw Exception('Address not found');
    }
  } else {
    throw Exception('Failed to load data');
  }
}
