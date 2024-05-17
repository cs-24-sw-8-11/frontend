import 'package:frontend/data_structures/user_data.dart';

// yeet these two later
import 'package:flutter/material.dart';
import 'package:frontend/custom_widgets/custom_diag.dart';

class RegisterCache {
  List<String> userData = [];
  PostUserData? _postUserData;

  void updateCache(String udata, int index) {
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

  void submitRegisterCache(BuildContext context, String token) {
    // Await backend completion of data type before i can submit the cache - Delete soon when backend link is done
    buildDataObject(token);
    dialogBuilder(context, "Success", stringOfAnswers(userData));
    clearCache();
  }

  void buildDataObject(String token) {
    _postUserData = PostUserData(
      userData[0], // education
      userData[1], // urban
      userData[2], // gender
      userData[3], // religion
      userData[4], // orientation
      userData[5], // race
      userData[6], // married
      userData[7], // age
      userData[8], // pets
    );
    _postUserData!.addToken(token);
  }

  //delete this soon
  String stringOfAnswers(List<String> answerList) {
    String result = "";
    for (var answer in answerList) {
      result += '$answer\n';
    }
    return result;
  }
}
