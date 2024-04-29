class Setting{
  String? id; //Fix later
  String key;
  String value;
  String userId;

  Setting(this.id, this.key, this.value, this.userId);

  Setting createNewSetting(String key, String value, String userid){
    return Setting(null, key, value, userid);
  }
}