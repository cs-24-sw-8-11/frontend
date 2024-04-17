
class UserData{
  String? Token;
  String? UserName;
  String? AgeGroup;
  String? Occupation;
  int? UserId;

  UserData(this.Token, this.UserName, this.AgeGroup, this.Occupation, this.UserId);


  void printData(){
    print('Username: $UserName');
    print('AgeGroup: $AgeGroup');
    print('Occupation: $Occupation');
    print('UserId: $UserId');
    print('Token: $Token');
  }
}