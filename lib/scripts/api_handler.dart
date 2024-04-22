import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:frontend/data_structures/prediction.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data_structures/answer.dart';
import '../data_structures/question.dart';
import '../data_structures/user_data.dart';
import '../data_structures/journal.dart';
import 'json_handler.dart';

//--------------------------API OBJECT CALLS------------------------------------

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

// New Journal
Future<http.Response> executeNewJournal(BuildContext context, Journal journal) async {
  final jsonString = jsonEncode(journal);
  dynamic httpResponse = await handleNewJournalHttp(jsonString);
  return Future.value(httpResponse);
}

// Get User Data
Future<UserData> getUserData(String token) async {
  var response = await handleUserDataHttp(token);
  final data = jsonDecode(response.body) as Map<String, dynamic>;
  UserData userData = UserData(data['username'], data['agegroup'], data['occupation'], data['userId']);
  return userData;
}

// Get Journal Data
Future<Journal> getJournal(int journalId, String token) async {
  var response = await handleJournalHttp(journalId);
  final data = jsonDecode(response.body) as Map<String, dynamic>;
  List<Answer> journalAnswers = [];
  List<int> answerIds = jsonDecode(data['answers']) as List<int>;
  for (int id in answerIds){
    journalAnswers.add(await getAnswer(id, token));
  }
  Journal journal = Journal(data['id'], data['comment'], data['userId'], journalAnswers);
  return journal;
}

// Get Journal Data from a user
Future<List<Journal>> getJournals(String token) async {
  var response = await handleJournalsHttp(token);
  final data = jsonDecode(response.body) as List<int>;
  List<Journal> journals = [];
  for(int d in data){
    journals.add(await getJournal(d, token));
  }
  return journals;
}

// Get Answer Data
Future<Answer> getAnswer(int answerId, String token) async {
  var response = await handleAnswerHttp(answerId, token);
  final data = jsonDecode(response.body) as Map<String, dynamic>;
  Answer answer = Answer(data['id'], data['answer'], data['journalId'], data['questionId']);
  return answer;
}

// Get Default Question Data
Future<List<Question>> getDefaultQuestions() async {
  var response = await handleDefaultQuestionsHttp();
  final data = jsonDecode(response.body) as List<Map<String, dynamic>>;
  List<Question> questions = [];
  for (Map<String, dynamic> d in data){
    questions.add(Question(d['id'], d['tags'], d['type'], d['question']));
  }
  return questions;
}

// Get Default Question Data
Future<List<Question>> getTaggedQuestions(String tag) async {
  var response = await handleQuestionsWithTagsHttp(tag);
  final data = jsonDecode(response.body) as List<Map<String, dynamic>>;
  List<Question> questions = [];
  for (Map<String, dynamic> d in data){
    questions.add(Question(d['id'], d['tags'], d['type'], d['question']));
  }
  return questions;
}

// Get Prediction Data from User
Future<List<Prediction>> getPredictionData(String token) async {
  var response = await handlePredictionHttp(token);
  final data = jsonDecode(response.body) as List<Map<String, dynamic>>;
  List<Prediction> predictions = [];
  for(Map<String, dynamic> d in data){
    predictions.add(Prediction(d['id'], d['userid'], d['value']));
  }
  return predictions;
}

//-----------------------------HTTP API CALLS-----------------------------------

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

// New Journal API POST
Future<http.Response> handleNewJournalHttp(String json) async {
  http.Response response = await http.post(
      Uri.http('localhost:8080', '/journals/new'),
      body: json
  );
  return response;
}

// New Prediction API POST
Future<http.Response> handleNewPredictionHttp(String json) async {
  http.Response response = await http.post(
      Uri.http('localhost:8080', '/predictions/new'),
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

// Answer API GET
Future<http.Response> handleAnswerHttp(int answerId, String token) async {
  http.Response response = await http.get(
      Uri.http('localhost:8080', '/answers/get/$answerId/$token')
  );
  return response;
}

// Journal API GET
Future<http.Response> handleJournalHttp(int journalId) async {
  http.Response response = await http.get(
      Uri.http('localhost:8080', '/journals/get/$journalId')
  );
  return response;
}

// Journals from user API GET
Future<http.Response> handleJournalsHttp(String token) async {
  http.Response response = await http.get(
      Uri.http('localhost:8080', '/journals/ids/$token')
  );
  return response;
}

// Default Questions API GET
Future<http.Response> handleDefaultQuestionsHttp() async {
  http.Response response = await http.get(
      Uri.http('localhost:8080', '/questions/defaults')
  );
  return response;
}

// Question with Tags API GET
Future<http.Response> handleQuestionsWithTagsHttp(String tag) async {
  http.Response response = await http.get(
      Uri.http('localhost:8080', '/questions/get/$tag')
  );
  return response;
}

// Predictions API GET
Future<http.Response> handlePredictionHttp(String token) async {
  http.Response response = await http.get(
      Uri.http('localhost:8080', '/predictions/get/$token')
  );
  return response;
}