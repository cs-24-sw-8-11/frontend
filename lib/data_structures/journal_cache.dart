import 'package:frontend/data_structures/answer.dart';

// yeet these two later
import 'package:flutter/material.dart';
import 'package:frontend/custom_widgets/custom_diag.dart';

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

  void submitJournalCache(BuildContext context) {
    // Await backend completion of data type before i can submit the cache - Delete soon when backend link is done
    dialogBuilder(context, "Success", stringOfAnswers(answerData));
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
