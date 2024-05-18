import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:frontend/data_structures/answer.dart';
import 'package:frontend/data_structures/journal.dart';

import 'package:frontend/custom_widgets/custom_diag.dart';

import 'package:frontend/scripts/api_handler.dart';

class JournalCache {
  List<PostAnswer> answerData = [];
  Response? response;

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
    executePostJournal(PostJournal(answerData), token).then((data) {
      response = data;
      if (response!.statusCode == 200) {
        dialogBuilder(context, "Success", response!.body);
      }
      else {
        dialogBuilder(context, "Unexpected Error - ${response!.statusCode}", response!.body);
      }
    });
    clearCache();
  }
}
