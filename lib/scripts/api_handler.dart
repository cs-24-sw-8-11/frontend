import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';

import 'package:frontend/data_structures/legend.dart';
import 'package:frontend/data_structures/prediction.dart';
import 'package:frontend/data_structures/answer.dart';
import 'package:frontend/data_structures/mitigation.dart';
import 'package:frontend/data_structures/question.dart';
import 'package:frontend/data_structures/user_data.dart';
import 'package:frontend/data_structures/journal.dart';

import 'package:frontend/scripts/json_handler.dart';

//--------------------------API OBJECT CALLS------------------------------------

String addr = "p8-test.skademaskinen.win";
String port = "11034";

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
Future<https.Response> executePostJournal(PostJournal journal, String token) async {
  journal.addToken(token);
  var jsonString;
  for (var answer in journal.answers) {
    jsonString += {'qid':answer.qid, 'meta':answer.meta, 'rating':answer.rating};
  }
  dynamic httpResponse = await handleNewJournalHttp(jsonEncode({'token':token, 'data':jsonString}));
  return httpResponse;
}

// Make new Prediction
Future<https.Response> executeNewPrediction(String token) async {
  final jsonString = {'token':token};
  dynamic httpResponse = await handleNewPredictionHttp(jsonEncode(jsonString));
  return httpResponse;
}

// Update UserData
Future<https.Response> executeUpdateUserData(PostUserData data) async {
  final jsonString = {'education':data.education, 'urban':data.urban, 'gender':data.gender, 'religion':data.religion, 'orientation':data.orientation, 'race':data.race, 'married':data.married, 'age':data.age, 'pets':data.pets};
  dynamic httpResponse = await handleUserDataUpdateHttp(jsonEncode({'token':data.token, 'data':jsonString}));
  return httpResponse;
}

// Submit Prediction rating
Future<https.Response> executeTestRating(String token, int pid, String rating, String expected) async {
  final jsonString = {'token':token, 'id':pid.toString(), 'rating':rating, 'expected':expected};
  dynamic httpResponse = await handleTestRatingHttp(jsonEncode(jsonString));
  return httpResponse;
}

// Get UserData
Future<GetUserData> getUserData(String token) async {
  var response = await handleUserDataHttp(token);
  final data = jsonDecode(response.body) as dynamic;
  GetUserData userData = GetUserData(data['username']);
  return userData;
}

// Get Journal Data
Future<GetJournal> getJournal(int journalId, String token) async {
  var response = await handleJournalHttp(journalId);
  final data = jsonDecode(response.body) as dynamic;
  List<GetAnswer> journalAnswers = [];
  List<int> answerIds = (data['answers'] as List<dynamic>).map((dynamic id) => id as int).toList();
  for (int id in answerIds){
    journalAnswers.add(await getAnswer(id, token));
  }
  GetJournal journal = GetJournal(data['userId'], data['id'], data['timestamp'], journalAnswers);
  return journal;
}

// Get Journal Data from a user
Future<List<GetJournal>> getJournals(String token) async {
  var response = await handleJournalsHttp(token);
  final data = jsonDecode(response.body) as dynamic;
  List<GetJournal> journals = [];
  for(int d in data){
    journals.add(await getJournal(d, token));
  }
  return journals;
}

// Get Journal Data
Future<GetJournal> getJournalWithoutAnswers(int journalId, String token) async {
  var response = await handleJournalHttp(journalId);
  final data = jsonDecode(response.body) as dynamic;
  GetJournal journal = GetJournal(data['userId'], data['id'], data['timestamp'], []);
  return journal;
}

// Get Journal Data
Future<GetJournal> getLatestJournalWithoutAnswers(String token) async {
  var response = await handleJournalsHttp(token);
  final data = jsonDecode(response.body) as dynamic;
  GetJournal lastJournal = await getJournal(data.last, token);
  return lastJournal;
}

// Get Journal Data from a user
Future<List<GetJournal>> getJournalsWithoutAnswers(String token) async {
  var response = await handleJournalsHttp(token);
  final data = jsonDecode(response.body) as dynamic;
  List<GetJournal> journals = [];
  for(int d in data){
    GetJournal journal = await getJournalWithoutAnswers(d, token);
    journals.add(journal);
  }
  return journals;
}

// Get Journal Data from a user
Future<int> getJournalCount(String token) async {
  var response = await handleJournalsHttp(token);
  final data = jsonDecode(response.body) as dynamic;
  return data.length;
}

// Get Answer Data
Future<GetAnswer> getAnswer(int answerId, String token) async {
  var response = await handleAnswerHttp(answerId, token);
  final data = jsonDecode(response.body) as dynamic;
  GetAnswer answer = GetAnswer(data['value'], data['rating'], data['journalId'], data['questionId'], data['id']);
  return answer;
}

// Get Default Question Data
Future<List<Question>> getDefaultQuestions() async {
  var response = await handleDefaultQuestionsHttp();
  final data = jsonDecode(response.body) as dynamic;
  List<Question> questions = [];
  for (Map<String, dynamic> d in data){
    questions.add(Question(d['id'], d['tags'], d['question']));
  }
  return Future.value(questions);
}

// Get Tagged Question Data
Future<List<Question>> getTaggedQuestions(String tag) async {
  var response = await handleQuestionsWithTagsHttp(tag);
  final data = jsonDecode(response.body) as dynamic;
  List<Question> questions = [];
  for (Map<String, dynamic> d in data){
    questions.add(Question(d['id'], d['tags'], d['question']));
  }
  return questions;
}

// Get Prediction Data from User
Future<List<Prediction>> getPredictionData(String token) async {
  var response = await handlePredictionHttp(token);
  final data = jsonDecode(response.body) as dynamic;
  List<Prediction> predictions = [];
  for(Map<String, dynamic> d in data){
    predictions.add(Prediction(int.parse(d['id']), d['userId'], d['value'], int.parse(d['timestamp'])));
  }
  return predictions;
}

// Get Mitigation Data from Tag
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

// Get Curated Mitigation Data from User
Future<Mitigation> getCuratedMitigation(String token) async {
  var response = await handleCuratedMitigationsHttp(token);
  final data = jsonDecode(response.body) as dynamic;
  //List<String> tags = data['data']['tags'].split(',');
  List<String> tags = [data['data']['tags']];
  Mitigation mitigation = Mitigation(data['data']['id'], data['data']['title'], data['data']['description'], data['data']['type'], tags);
  return mitigation;
}

Future<List<List<LegendEntry>>> getAllLegends() async {
  List<List<LegendEntry>> allLegends = [];
  for (int i = 1; i < 10; i++) {
    List<LegendEntry> legends = [];
    var response = await handleQuestionLegend(i);
    final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
    data.forEach((key, value) {
      legends.add(LegendEntry(value, key));
    });
    allLegends.add(legends);
  }
  return allLegends;
}

//-----------------------------HTTP API CALLS-----------------------------------

// Login API POST
Future<https.Response> handleLoginHttp(String json) async {
  https.Response response = await https.post(
    Uri.https('$addr:$port', '/user/auth'),
    body: json
  );
  return response;
}

// Register API POST
Future<https.Response> handleRegisterHttp(String json) async {
  https.Response response = await https.post(
    Uri.https('$addr:$port', '/user/register'),
    body: json
  );
  return response;
}

// New Journal API POST
Future<https.Response> handleNewJournalHttp(String json) async {
  https.Response response = await https.post(
    Uri.https('$addr:$port', '/journals/new'),
    body: json
  );
  return response;
}

// New Prediction API POST
Future<https.Response> handleNewPredictionHttp(String json) async {
  https.Response response = await https.post(
    Uri.https('$addr:$port', '/predictions/add'),
    body: json
  );
  return response;
}

// Update UserData API POST
Future<https.Response> handleUserDataUpdateHttp(String json) async {
  https.Response response = await https.post(
    Uri.https('$addr:$port', '/user/data/update'),
    body: json
  );
  return response;
}

// Submit prediction rating API POST
Future<https.Response> handleTestRatingHttp(String json) async {
  https.Response response = await https.post(
    Uri.https('$addr:$port', '/tests/rate'),
    body: json
  );
  return response;
}

// UserData API GET
Future<https.Response> handleUserDataHttp(String token) async {
  https.Response response = await https.get(
    Uri.https('$addr:$port', '/user/get/$token')
  );
  return response;
}

// User Ids API GET
Future<https.Response> handleUserIdsHttp() async {
  https.Response response = await https.get(
    Uri.https('$addr:$port', '/user/ids')
  );
  return response;
}

// Answer API GET
Future<https.Response> handleAnswerHttp(int answerId, String token) async {
  https.Response response = await https.get(
    Uri.https('$addr:$port', '/answers/get/$answerId/$token')
  );
  return response;
}

// Journal API GET
Future<https.Response> handleJournalHttp(int journalId) async {
  https.Response response = await https.get(
    Uri.https('$addr:$port', '/journals/get/$journalId')
  );
  return response;
}

// Journals from user API GET
Future<https.Response> handleJournalsHttp(String token) async {
  https.Response response = await https.get(
    Uri.https('$addr:$port', '/journals/ids/$token')
  );
  return response;
}

// Default Questions API GET
Future<https.Response> handleDefaultQuestionsHttp() async {
  https.Response response = await https.get(
    Uri.https('$addr:$port', '/questions/defaults')
  );
  return response;
}

// Question with Tags API GET
Future<https.Response> handleQuestionsWithTagsHttp(String tag) async {
  https.Response response = await https.get(
    Uri.https('$addr:$port', '/questions/get/$tag')
  );
  return response;
}

// Predictions API GET
Future<https.Response> handlePredictionHttp(String token) async {
  https.Response response = await https.get(
    Uri.https('$addr:$port', '/predictions/get/$token')
  );
  return response;
}


// Mitigation API GET
Future<https.Response> handleMitigationsTagHttp(String tag) async {
  https.Response response = await https.get(
    Uri.https('$addr:$port', '/mitigations/tags/$tag')
  );
  return response;
}

// Mitigation API GET
Future<https.Response> handleMitigationsIdHttp(String id) async {
  https.Response response = await https.get(
    Uri.https('$addr:$port', '/mitigations/get/$id')
  );
  return response;
}

// Mitigation API GET
Future<https.Response> handleCuratedMitigationsHttp(String token) async {
  https.Response response = await https.get(
      Uri.https('$addr:$port', '/mitigations/new/$token')
  );
  return response;
}

// Question Options (Legend) API GET
Future<https.Response> handleQuestionLegend(int id) async {
  https.Response response = await https.get(
    Uri.https('$addr:$port', '/questions/legend/$id')
  );
  return response;
}