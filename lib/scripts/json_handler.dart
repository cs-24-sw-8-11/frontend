import 'dart:convert';

String encodeJson(String username, String password) {
  var data = {'username': username, 'password': password};
  return jsonEncode(data);
}