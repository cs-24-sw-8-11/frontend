import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data_structures/user_data.dart';
import 'json_handler.dart';


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

// Get User Data
Future<UserData> getUserData(String token) async {
  var response = await handleUserDataHttp(token);
  print(response.body);
  final data = jsonDecode(response.body) as Map<String, dynamic>;
  UserData userData = UserData(data['username'], data['agegroup'], data['occupation'], data['userId']);
  return userData;
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

// UserData API GET
Future<http.Response> handleUserDataHttp(String token) async {
  http.Response response = await http.get(
    Uri.http('localhost:8080', '/user/get/$token')
  );
  return response;
}