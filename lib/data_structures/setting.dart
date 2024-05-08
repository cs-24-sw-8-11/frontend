class Setting{
  String id;
  String key;
  String value;
  String userId;

  Setting(this.id, this.key, this.value, this.userId);

  Setting createNewSetting(String key, String value, String userid){
    return Setting("0", key, value, userid);
  }
}