import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class NetworkHandler {
  NetworkHandler._privateConstructor();
  static final NetworkHandler _instance = NetworkHandler._privateConstructor();
  factory NetworkHandler() {
    return _instance;
  }

  Future<dynamic> postRequest(url, Map<String, dynamic> body) async {
    String token = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InRpbW15YmFqb0BnbWFpbC5jb20iLCJwYXNzd29yZCI6IjEyMzQ1Njc4OTAiLCJpYXQiOjE2OTM1OTc3MjF9.kBEnsor_zKbrhtL8i0yI2b9Jtz-3POBj9vQYF4SLyVk";
    try {
      var callUrl = Uri.parse(url);

      var response = await http.post(
        callUrl,
        body: json.encode(body),
        headers: {
          'Accept': 'application/json',
          'Content-type': 'application/json',
          'Authorization': token,
        },
      ).timeout(const Duration(seconds: 15));

      print(response);
      print('---------------------');
      print(response.body.toString());
      return json.decode(response.body.toString());
    } on SocketException {
      return null;
    } on HttpException {
      return null;
    } on TimeoutException {
      return null;
    } catch (e) {}
  }
}

String hostUrl = 'http://34.23.250.26:3000/api/v1';
