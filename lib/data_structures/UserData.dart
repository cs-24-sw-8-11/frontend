
class UserData{
  String? userName;
  String? ageGroup;
  String? occupation;
  int? userId;

  UserData(this.userName, this.ageGroup, this.occupation, this.userId);


  void printData(){
    print('Username: $userName');
    print('AgeGroup: $ageGroup');
    print('Occupation: $occupation');
    print('UserId: $userId');
  }
}