import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:frontend/data_structures/legend.dart';
import 'package:frontend/data_structures/user_data.dart';

import 'package:frontend/custom_widgets/custom_diag.dart';

import 'package:frontend/scripts/api_handler.dart';


class RegisterCache {
  List<String> userData = [];
  Response? response;
  List<List<LegendEntry>> completeLegend = [];

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
    PostUserData userDataObject = buildDataObject(token);
    executeUpdateUserData(userDataObject).then((data) {
      response = data;
      if (response!.statusCode == 200) {
        dialogBuilder(context, "Success", response!.body);
      }
      else {
        dialogBuilder(context, "Unexpected Error - ${response!.statusCode}", response!.body);
      }
      clearCache();
    });
  }

  PostUserData buildDataObject(String token) {
    dataIndexer();
    PostUserData postUserData = PostUserData(
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
    postUserData.addToken(token);
    return postUserData;
  }

  void dataIndexer() {
    for (int i = 0; i < userData.length; i++) {
      List<LegendEntry> legends = completeLegend[i];
      for (var legend in legends) {
        if (legend.text == userData[i]) {
          userData[i] = legend.legendId;
        }
      }
    }
  }

  Future<void> storeDataIndexes(List<List<LegendEntry>> completeLegend) async {
    this.completeLegend = completeLegend;
  }
}