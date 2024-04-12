import 'package:flutter/material.dart';
import 'json_handler.dart';
import 'package:http/http.dart' as http;


// Login
Future<http.Response> executeLogin(BuildContext context, String username, String password) async {
  final jsonString = encodeJson(username, password);
  dynamic httpResponse = await handleLoginHttp(jsonString);
  return Future.value(httpResponse);
}

// Register
Future<http.Response> executeRegister(BuildContext context, String username, String password) async {
  final jsonString = encodeJson(username, password);
  dynamic httpResponse = await handleRegisterHttp(jsonString);
  return Future.value(httpResponse);
}

// Register API POST
Future<http.Response> handleRegisterHttp(String json) async {
  http.Response response = await http.post(
    Uri.http('localhost:8080', '/user/register'),
    body: json
   );
   return response;
}

// Login API POST
Future<http.Response> handleLoginHttp(String json) async {
  http.Response response = await http.post(
    Uri.http('localhost:8080', '/user/auth'),
    body: json
   );
   return response;
}