import 'answer.dart';

class Journal{
  String? id;
  String? comment;
  String? userID;
  List<Answer>? answers;

  Journal(this.id, this.comment, this.userID, this.answers);

  void addAnswer(Answer answer){
    answers?.add(answer);
  }
}
