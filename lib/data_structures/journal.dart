import 'answer.dart';

class Journal{
  String? token;
  String? id;
  List<Answer> answers;

  Journal(this.answers);

  void addAnswer(Answer answer){
    answers.add(answer);
  }

  void addToken(String token){
    this.token = token;
  }
}
