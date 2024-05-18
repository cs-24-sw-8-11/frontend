import 'package:flutter/material.dart';

import 'package:frontend/data_structures/answer.dart';

import 'package:frontend/custom_widgets/custom_diag.dart';
import 'package:frontend/data_structures/journal.dart';

import 'package:frontend/scripts/api_handler.dart';

class JournalCache {
  List<PostAnswer> answerData = [];

  void updateCache(PostAnswer answer, int index) {
    if(answerData.length <= index) {
      answerData.add(answer);
    }
    else {
      answerData[index] = answer;
    }
  }

  void clearCache() {
    answerData.clear();
  }

  void submitJournalCache(BuildContext context, String token) {
    executePostJournal(PostJournal(answerData), token);
    clearCache();
  }

  //delete this soon
  String stringOfAnswers(List<PostAnswer> answerList) {
    String result = "";
    for (var answer in answerList) {
      result += '$answer\n';
    }
    return result;
  }
}
