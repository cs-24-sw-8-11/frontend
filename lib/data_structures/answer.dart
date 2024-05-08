class Answer{

  String qid;
  String meta;
  int rating;

  Answer(this.qid, this.meta, this.rating);

  @override
  String toString() {
    return 'Question ID: $qid, Meta: $meta, Rating: $rating';
  }
}