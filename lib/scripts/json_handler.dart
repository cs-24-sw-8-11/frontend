import 'dart:convert';

String encodeJson(String username, String password) {
  var data = {'username': username, 'password': password};
  return jsonEncode(data);
}

String encodePredictionJson(String token, String questionId){
  var data = {'token': token, 'questionid': questionId};
  return jsonEncode(data);
}