import 'dart:convert';

import '../data_structures/setting.dart';

String encodeJson(String username, String password) {
  var data = {'username': username, 'password': password};
  return jsonEncode(data);
}

String encodeSettingsJson(String token, List<Setting> settings) {
  String settingsString = '';
  for(Setting setting in settings){
    settingsString += '${setting.key}:${setting.value},';
  }
  if(settingsString.endsWith(',')){
    settingsString = settingsString.substring(0,settingsString.length-1);
  }
  var data = {'token': token, 'settings': {settingsString}};
  return jsonEncode(data);
}

String encodePredictionJson(String token, String questionId){
  var data = {'token': token, 'questionid': questionId};
  return jsonEncode(data);
}