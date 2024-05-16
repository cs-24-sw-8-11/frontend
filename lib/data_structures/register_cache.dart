import 'package:frontend/data_structures/user_data.dart';

// yeet these two later
import 'package:flutter/material.dart';
import 'package:frontend/custom_widgets/custom_diag.dart';

class RegisterCache {
  List<PostUserData> userData = [];

  void updateCache(PostUserData udata, int index) {
    if(userData.length <= index) {
      userData.add(udata);
    }
    else {
      userData[index] = udata;
    }
  }

  void clearCache() {
    userData.clear();
  }

  void submitRegisterCache(BuildContext context) {
    // Await backend completion of data type before i can submit the cache - Delete soon when backend link is done
    dialogBuilder(context, "Success", stringOfAnswers(userData));
    clearCache();
  }

  //delete this soon
  String stringOfAnswers(List<PostUserData> answerList) {
    String result = "";
    for (var answer in answerList) {
      result += answer.toString() + '\n';
    }
    return result;
  }
}
