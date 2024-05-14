class PostAnswer{
  String qid;
  String meta;
  String rating;

  PostAnswer(this.qid, this.meta, this.rating);

  @override
  String toString() {
    return 'Question ID: $qid, Meta: $meta, Rating: $rating';
  }
}

class GetAnswer{
  String value;
  String rating;
  String jid;
  String qid;
  String aid;

  GetAnswer(this.value, this.rating, this.jid, this.qid, this.aid);
}