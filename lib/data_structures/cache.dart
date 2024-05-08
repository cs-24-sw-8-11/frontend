import 'package:frontend/data_structures/journal_data.dart';

// yeet these two later
import 'package:flutter/material.dart';
import 'package:frontend/custom_widgets/custom_diag.dart';

class Cache {
  List<JournalDataObject> jdata = [];

  void updateCache(JournalDataObject object, int index) {
    if(jdata.length <= index) {
      jdata.add(object);
    }
    else {
      jdata[index] = object;
    }
  }

  void clearCache() {
    jdata.clear();
  }

  void submitJournalCache(BuildContext context) {
    // Await backend completion of data type before i can submit the cache
    clearCache();
    dialogBuilder(context, "Success", "Journal successfully created, but no backend connection yet :)) ");
  }
}
