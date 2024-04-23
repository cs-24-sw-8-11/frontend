class UserData{
  String? userName;
  String? ageGroup;
  String? occupation;
  String? userID;

  // Only used in /user/data/update
  String? token;

  UserData(this.userName, this.ageGroup, this.occupation, this.userID);

  void addToken(String token){
    this.token = token;
  }
}