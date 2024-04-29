class UserData{
  String userName;
  String ageGroup;
  String major;
  String userID;

  // Only used in /user/data/update
  String? token;

  UserData(this.userName, this.ageGroup, this.major, this.userID);

  void addToken(String token){
    this.token = token;
  }
}