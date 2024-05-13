import 'package:frontend/data_structures/prediction.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data_structures/answer.dart';
import '../data_structures/mitigation.dart';
import '../data_structures/question.dart';
import '../data_structures/setting.dart';
import '../data_structures/user_data.dart';
import '../data_structures/journal.dart';
import 'json_handler.dart';

//--------------------------API OBJECT CALLS------------------------------------

String addr = "p8-test.skademaskinen.win";
String port = "11034";

// Login
Future<http.Response> executeLogin(String username, String password) async {
  final jsonString = encodeJson(username, password);
  dynamic httpResponse = await handleLoginHttp(jsonString);
  return httpResponse;
}

// Register
Future<http.Response> executeRegister(String username, String password) async {
  final jsonString = encodeJson(username, password);
  dynamic httpResponse = await handleRegisterHttp(jsonString);
  return httpResponse;
}

// New Journal
Future<http.Response> executeNewJournal(Journal journal, String token) async {
  journal.addToken(token);
  final jsonString = jsonEncode(journal);
  dynamic httpResponse = await handleNewJournalHttp(jsonString);
  return httpResponse;
}

// Delete Journal
Future<http.Response> executeDeleteJournal(Journal journal, String token) async {
  dynamic httpResponse = await handleDeleteJournalHttp(journal.id, token);
  return httpResponse;
}

// Delete Journal From Id
Future<http.Response> executeDeleteJournalFromId(String journalId, String token) async {
  dynamic httpResponse = await handleDeleteJournalHttp(journalId, token);
  return httpResponse;
}

// Update UserData
Future<http.Response> executeUpdateUserData(UserData data, String token) async {
  data.addToken(token);
  final jsonString = jsonEncode(data);
  dynamic httpResponse = await handleUserDataUpdateHttp(jsonString);
  return httpResponse;
}

// Update Settings
Future<http.Response> executeUpdateSettings(List<Setting> settings, String token) async {
  final jsonString = encodeSettingsJson(token, settings);
  dynamic httpResponse = await handleSettingsUpdateHttp(jsonString);
  return httpResponse;
}

// Make new Prediction
Future<http.Response> executeNewPrediction(String token) async {
  final jsonString = {'token':token};
  dynamic httpResponse = await handleNewPredictionHttp(jsonEncode(jsonString));
  return httpResponse;
}

// Submit Prediction rating
Future<http.Response> executeTestRating(String token, String pid) async {
  final jsonString = {'token':token, 'id':pid};
  dynamic httpResponse = await handleTestRatingHttp(jsonEncode(jsonString));
  return httpResponse;
}

// Get User Data
Future<UserData> getUserData(String token) async {
  var response = await handleUserDataHttp(token);
  final data = jsonDecode(response.body) as dynamic;
  UserData userData = UserData(data['username'], data['agegroup'], data['major'], data['userId']);
  return userData;
}

// Get All Users
Future<List<int>> getAllUsers() async{
  var response = await handleUserIdsHttp();
  final data = jsonDecode(response.body) as dynamic;
  return data;
}

// Get Journal Data
Future<Journal> getJournal(int journalId, String token) async {
  var response = await handleJournalHttp(journalId);
  final data = jsonDecode(response.body) as dynamic;
  List<Answer> journalAnswers = [];
  List<dynamic> answerIds = json.decode(json.encode(data['answers'])) as dynamic;
  for (int id in answerIds){
    journalAnswers.add(await getAnswer(id, token));
  }
  Journal journal = Journal(data['id'], data['timestamp'], data['userId'], journalAnswers);
  return journal;
}

// Get Journal Data
Future<Journal> getJournalWithoutAnswers(int journalId, String token) async {
  var response = await handleJournalHttp(journalId);
  final data = jsonDecode(response.body) as dynamic;
  Journal journal = Journal(data['id'], data['timestamp'], data['userId'], []);
  return journal;
}

// Get Journal Data from a user
Future<List<Journal>> getJournals(String token) async {
  var response = await handleJournalsHttp(token);
  final data = jsonDecode(response.body) as dynamic;
  List<Journal> journals = [];
  for(int d in data){
    journals.add(await getJournal(d, token));
  }
  return journals;
}

// Get Journal Data from a user
Future<List<Journal>> getJournalsWithoutAnswers(String token) async {
  var response = await handleJournalsHttp(token);
  final data = jsonDecode(response.body) as dynamic;
  List<Journal> journals = [];
  for(int d in data){
    journals.add(await getJournalWithoutAnswers(d, token));
  }
  return journals;
}

// Get Answer Data
Future<Answer> getAnswer(int answerId, String token) async {
  var response = await handleAnswerHttp(answerId, token);
  final data = jsonDecode(response.body) as dynamic;
  Answer answer = Answer(data['id'], data['value'], data['rating'], data['journalId'], data['questionId']);
  return answer;
}

// Get Default Question Data
Future<List<Question>> getDefaultQuestions() async {
  var response = await handleDefaultQuestionsHttp();
  //print(response);
  final data = jsonDecode(response.body) as dynamic;
  List<Question> questions = [];
  for (Map<String, dynamic> d in data){
    questions.add(Question(d['id'], d['tags'], d['type'], d['question']));
  }
  return Future.value(questions);
}

// Get Default Question Data
Future<List<Question>> getTaggedQuestions(String tag) async {
  var response = await handleQuestionsWithTagsHttp(tag);
  final data = jsonDecode(response.body) as dynamic;
  List<Question> questions = [];
  for (Map<String, dynamic> d in data){
    questions.add(Question(d['id'], d['tags'], d['type'], d['question']));
  }
  return questions;
}

// Get Prediction Data from User
Future<List<Prediction>> getPredictionData(String token) async {
  var response = await handlePredictionHttp(token);
  final data = jsonDecode(response.body) as dynamic;
  List<Prediction> predictions = [];
  for(Map<String, dynamic> d in data){
    predictions.add(Prediction(d['id'], d['userId'], d['value']));
  }
  return predictions;
}

// Get Settings Data from User
Future<List<Setting>> getSettings(String token) async {
  var response = await handleSettingsHttp(token);
  final data = jsonDecode(response.body) as dynamic;
  List<Setting> settings = [];
  for(Map<String, dynamic> d in data){
    settings.add(Setting(d['id'], d['key'], d['value'], d['userid']));
  }
  return settings;
}

// Get Settings Data from User
Future<List<Mitigation>> getMitigationsWithTag(String tag) async {
  var response = await handleMitigationsTagHttp(tag);
  final data = jsonDecode(response.body) as dynamic;
  List<Mitigation> mitigations = [];
  for(Map<String, dynamic> d in data){
    List<String> tags = d['tags'].split(',');
    mitigations.add(Mitigation(d['id'], d['title'], d['description'], d['type'], tags));
  }
  return mitigations;
}

//-----------------------------HTTP API CALLS-----------------------------------


// Register API POST
Future<http.Response> handleRegisterHttp(String json) async {
  http.Response response = await http.post(
    Uri.https('$addr:$port', '/user/register'),
    body: json
   );
   return response;
}

// Login API POST
Future<http.Response> handleLoginHttp(String json) async {
  http.Response response = await http.post(
    Uri.https('$addr:$port', '/user/auth'),
    body: json
   );
   return response;
}

// New Journal API POST
Future<http.Response> handleNewJournalHttp(String json) async {
  http.Response response = await http.post(
      Uri.https('$addr:$port', '/journals/new'),
      body: json
  );
  return response;
}

// New Prediction API POST
Future<http.Response> handleNewPredictionHttp(String json) async {
  http.Response response = await http.post(
      Uri.https('$addr:$port', '/predictions/add'),
      body: json
  );
  return response;
}

// Update UserData API POST
Future<http.Response> handleUserDataUpdateHttp(String json) async {
  http.Response response = await http.post(
      Uri.https('$addr:$port', '/user/data/update'),
      body: json
  );
  return response;
}

// Update UserData API POST
Future<http.Response> handleSettingsUpdateHttp(String json) async {
  http.Response response = await http.post(
      Uri.https('$addr:$port', '/settings/update'),
      body: json
  );
  return response;
}

// Submit prediction rating API POST
Future<http.Response> handleTestRatingHttp(String json) async {
  http.Response response = await http.post(
      Uri.https('$addr:$port', '/tests/rate'),
      body: json
  );
  return response;
}

// Delete Journal API DELETE
Future<http.Response> handleDeleteJournalHttp(String journalId, String token) async {
  http.Response response = await http.delete(
      Uri.https('$addr:$port', '/journals/delete/$journalId/$token')
  );
  return response;
}

// UserData API GET
Future<http.Response> handleUserDataHttp(String token) async {
  http.Response response = await http.get(
    Uri.https('$addr:$port', '/user/get/$token')
  );
  return response;
}

// User Ids API GET
Future<http.Response> handleUserIdsHttp() async {
  http.Response response = await http.get(
      Uri.https('$addr:$port', '/user/ids')
  );
  return response;
}

// Answer API GET
Future<http.Response> handleAnswerHttp(int answerId, String token) async {
  http.Response response = await http.get(
      Uri.https('$addr:$port', '/answers/get/$answerId/$token')
  );
  return response;
}

// Journal API GET
Future<http.Response> handleJournalHttp(int journalId) async {
  http.Response response = await http.get(
      Uri.https('$addr:$port', '/journals/get/$journalId')
  );
  return response;
}

// Journals from user API GET
Future<http.Response> handleJournalsHttp(String token) async {
  http.Response response = await http.get(
      Uri.https('$addr:$port', '/journals/ids/$token')
  );
  return response;
}

// Default Questions API GET
Future<http.Response> handleDefaultQuestionsHttp() async {
  http.Response response = await http.get(
      Uri.https('$addr:$port', '/questions/defaults')
  );
  return response;
}

// Question with Tags API GET
Future<http.Response> handleQuestionsWithTagsHttp(String tag) async {
  http.Response response = await http.get(
      Uri.https('$addr:$port', '/questions/get/$tag')
  );
  return response;
}

// Predictions API GET
Future<http.Response> handlePredictionHttp(String token) async {
  http.Response response = await http.get(
      Uri.https('$addr:$port', '/predictions/get/$token')
  );
  return response;
}

// Settings API GET
Future<http.Response> handleSettingsHttp(String token) async {
  http.Response response = await http.get(
      Uri.https('$addr:$port', '/settings/get/$token')
  );
  return response;
}

// Mitigation API GET
Future<http.Response> handleMitigationsTagHttp(String tag) async {
  http.Response response = await http.get(
      Uri.https('$addr:$port', '/mitigations/tags/$tag')
  );
  return response;
}

// Mitigation API GET
Future<http.Response> handleMitigationsIdHttp(String id) async {
  http.Response response = await http.get(
      Uri.https('$addr:$port', '/mitigations/get/$id')
  );
  return response;
}