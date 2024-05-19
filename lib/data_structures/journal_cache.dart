import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:frontend/data_structures/answer.dart';
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

  Future<Response> submitJournalCache(BuildContext context, String token) async {
    Response res = await executePostJournal(PostJournal(answerData), token);
    return res;
  }
}
