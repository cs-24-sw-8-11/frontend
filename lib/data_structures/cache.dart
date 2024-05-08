import 'package:frontend/data_structures/answer.dart';

// yeet these two later
import 'package:flutter/material.dart';
import 'package:frontend/custom_widgets/custom_diag.dart';

class Cache {
  List<Answer> answerData = [];

  void updateCache(Answer answer, int index) {
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

  void submitJournalCache(BuildContext context) {
    // Await backend completion of data type before i can submit the cache
    dialogBuilder(context, "Success", stringOfAnswers(answerData));
    clearCache();
  }

  String stringOfAnswers(List<Answer> answerList) {
    String result = "";
    for (var answer in answerList) {
      result += answer.toString() + '\n';
    }
    return result;
  }
}
