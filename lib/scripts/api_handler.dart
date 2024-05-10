import 'package:frontend/data_structures/prediction.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';

import '../data_structures/answer.dart';
import '../data_structures/mitigation.dart';
import '../data_structures/question.dart';
import '../data_structures/setting.dart';
import '../data_structures/user_data.dart';
import '../data_structures/journal.dart';
import 'json_handler.dart';

//--------------------------API OBJECT CALLS------------------------------------

// Login
Future<https.Response> executeLogin(String username, String password) async {
  final jsonString = encodeJson(username, password);
  dynamic httpResponse = await handleLoginHttp(jsonString);
  return httpResponse;
}

// Register
Future<https.Response> executeRegister(String username, String password) async {
  final jsonString = encodeJson(username, password);
  dynamic httpResponse = await handleRegisterHttp(jsonString);
  return httpResponse;
}

// New Journal
Future<https.Response> executeNewJournal(Journal journal, String token) async {
  journal.addToken(token);
  final jsonString = jsonEncode(journal);
  dynamic httpResponse = await handleNewJournalHttp(jsonString);
  return httpResponse;
}

// Delete Journal
Future<https.Response> executeDeleteJournal(Journal journal, String token) async {
  dynamic httpResponse = await handleDeleteJournalHttp(journal.id!, token);
  return httpResponse;
}

// Delete Journal From Id
Future<https.Response> executeDeleteJournalFromId(String journalId, String token) async {
  dynamic httpResponse = await handleDeleteJournalHttp(journalId, token);
  return httpResponse;
}

// Update UserData
Future<https.Response> executeUpdateUserData(UserData data, String token) async {
  data.addToken(token);
  final jsonString = jsonEncode(data);
  dynamic httpResponse = await handleUserDataUpdateHttp(jsonString);
  return httpResponse;
}

// Update UserData
Future<https.Response> executeUpdateSettings(List<Setting> settings, String token) async {
  final jsonString = encodeSettingsJson(token, settings);
  dynamic httpResponse = await handleSettingsUpdateHttp(jsonString);
  return httpResponse;
}

// Update UserData
Future<https.Response> executeNewPrediction(String questionId, String token) async {
  final jsonString = encodePredictionJson(token, questionId);
  dynamic httpResponse = await handleNewPredictionHttp(jsonString);
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
  List<int> answerIds = jsonDecode(data['answers']) as dynamic;
  for (int id in answerIds){
    journalAnswers.add(await getAnswer(id, token));
  }
  Journal journal = Journal(journalAnswers);
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

// Get Answer Data
Future<Answer> getAnswer(int answerId, String token) async {
  var response = await handleAnswerHttp(answerId, token);
  final data = jsonDecode(response.body) as dynamic;
  Answer answer = Answer(data['qid'], data['meta'], data['rating']);
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
Future<https.Response> handleRegisterHttp(String json) async {
  https.Response response = await https.post(
    Uri.https('p8.skademaskinen.win:11034', '/user/register'),
    body: json
   );
   return response;
}

// Login API POST
Future<https.Response> handleLoginHttp(String json) async {
  https.Response response = await https.post(
    Uri.https('p8.skademaskinen.win:11034', '/user/auth'),
    body: json
   );
   return response;
}

// New Journal API POST
Future<https.Response> handleNewJournalHttp(String json) async {
  https.Response response = await https.post(
      Uri.https('p8.skademaskinen.win:11034', '/journals/new'),
      body: json
  );
  return response;
}

// New Prediction API POST
Future<https.Response> handleNewPredictionHttp(String json) async {
  https.Response response = await https.post(
      Uri.https('p8.skademaskinen.win:11034', '/predictions/add'),
      body: json
  );
  return response;
}

// Update UserData API POST
Future<https.Response> handleUserDataUpdateHttp(String json) async {
  https.Response response = await https.post(
      Uri.https('p8.skademaskinen.win:11034', '/user/data/update'),
      body: json
  );
  return response;
}

// Update UserData API POST
Future<https.Response> handleSettingsUpdateHttp(String json) async {
  https.Response response = await https.post(
      Uri.https('p8.skademaskinen.win:11034', '/settings/update'),
      body: json
  );
  return response;
}

// Delete Journal API DELETE
Future<https.Response> handleDeleteJournalHttp(String journalId, String token) async {
  https.Response response = await https.delete(
      Uri.https('p8.skademaskinen.win:11034', '/journals/delete/$journalId/$token')
  );
  return response;
}

// UserData API GET
Future<https.Response> handleUserDataHttp(String token) async {
  https.Response response = await https.get(
    Uri.https('p8.skademaskinen.win:11034', '/user/get/$token')
  );
  return response;
}

// User Ids API GET
Future<https.Response> handleUserIdsHttp() async {
  https.Response response = await https.get(
      Uri.https('p8.skademaskinen.win:11034', '/user/ids')
  );
  return response;
}

// Answer API GET
Future<https.Response> handleAnswerHttp(int answerId, String token) async {
  https.Response response = await https.get(
      Uri.https('p8.skademaskinen.win:11034', '/answers/get/$answerId/$token')
  );
  return response;
}

// Journal API GET
Future<https.Response> handleJournalHttp(int journalId) async {
  https.Response response = await https.get(
      Uri.https('p8.skademaskinen.win:11034', '/journals/get/$journalId')
  );
  return response;
}

// Journals from user API GET
Future<https.Response> handleJournalsHttp(String token) async {
  https.Response response = await https.get(
      Uri.https('p8.skademaskinen.win:11034', '/journals/ids/$token')
  );
  return response;
}

// Default Questions API GET
Future<https.Response> handleDefaultQuestionsHttp() async {
  https.Response response = await https.get(
      Uri.https('p8.skademaskinen.win:11034', '/questions/defaults')
  );
  return response;
}

// Question with Tags API GET
Future<https.Response> handleQuestionsWithTagsHttp(String tag) async {
  https.Response response = await https.get(
      Uri.https('p8.skademaskinen.win:11034', '/questions/get/$tag')
  );
  return response;
}

// Predictions API GET
Future<https.Response> handlePredictionHttp(String token) async {
  https.Response response = await https.get(
      Uri.https('p8.skademaskinen.win:11034', '/predictions/get/$token')
  );
  return response;
}

// Settings API GET
Future<https.Response> handleSettingsHttp(String token) async {
  https.Response response = await https.get(
      Uri.https('p8.skademaskinen.win:11034', '/settings/get/$token')
  );
  return response;
}

// Mitigation API GET
Future<https.Response> handleMitigationsTagHttp(String tag) async {
  https.Response response = await https.get(
      Uri.https('p8.skademaskinen.win:11034', '/mitigations/tags/$tag')
  );
  return response;
}

// Mitigation API GET
Future<https.Response> handleMitigationsIdHttp(String id) async {
  https.Response response = await https.get(
      Uri.https('p8.skademaskinen.win:11034', '/mitigations/get/$id')
  );
  return response;
}