class PostUserData{
  String token = "";
  String education;
  String urban;
  String gender;
  String religion;
  String orientation;
  String race;
  String married;
  String age;
  String pets;
  
  PostUserData(this.education, this.urban, this.gender, this.religion, this.orientation, this.race, this.married, this.age, this.pets);

  void addToken(String token) {
    this.token = token;
  }
}

class GetUserData{
  String userName;

  GetUserData(this.userName);
}