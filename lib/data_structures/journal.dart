import 'answer.dart';

class Journal{
  String id;
  String timestamp;
  String userID;
  List<Answer> answers;

  // Only used for /journals/new
  String? token;

  Journal(this.id, this.timestamp, this.userID, this.answers);

  void addAnswer(Answer answer){
    answers.add(answer);
  }

  void addToken(String token){
    this.token = token;
  }
}
