import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> getLatLongFromAddress(String address) async {
  String geocodingKEY = dotenv.env['Geocoding_KEY']!;
  Uri url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$geocodingKEY');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    if (data['status'] == 'OK') {
      Map<String, dynamic> location = {
        'lat': data['results'][0]['geometry']['location']['lat'],
        'lng': data['results'][0]['geometry']['location']['lng'],
      };
      return location;
    } else {
      throw Exception('Error: ${data['status']}');
    }
  } else {
    throw Exception('Failed to load data');
  }
}
