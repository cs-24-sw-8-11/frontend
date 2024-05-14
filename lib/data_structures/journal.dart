import 'answer.dart';

class PostJournal{
  String token = "";
  List<PostAnswer> answers;

  PostJournal(this.answers);

  void addToken(String token) {
    this.token = token;
  }
}

class GetJournal{
  String uid;
  String jid;
  String timestamp;
  List<GetAnswer> answers;

  GetJournal(this.uid, this.jid, this.timestamp, this.answers);
}