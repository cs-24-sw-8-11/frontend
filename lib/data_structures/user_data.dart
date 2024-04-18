class UserData{
  String? userName;
  String? ageGroup;
  String? occupation;
  int? userID;

  UserData(this.userName, this.ageGroup, this.occupation, this.userID);


  void printData(){
    print('Username: $userName');
    print('AgeGroup: $ageGroup');
    print('Occupation: $occupation');
    print('UserID: $userID');
  }
}