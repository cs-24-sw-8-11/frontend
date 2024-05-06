import 'package:frontend/data_structures/journal_data.dart';

class Cache {
  List<JournalDataObject> jdata = List.empty();

  void cacheData(JournalDataObject object) {
    jdata.add(object);
  }

  void editCache(JournalDataObject object, int index) {
    if(jdata[index] != object) {
      jdata[index] = object;
    }
  }

  void clearCache() {
    jdata.clear();
  }
}
