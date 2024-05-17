class Prediction implements Comparable<Prediction>{
  int id;
  String userId;
  String value;
  int timeStamp;

  Prediction(this.id, this.userId, this.value, this.timeStamp);

  @override
  int compareTo(Prediction other) {
    if (timeStamp < other.timeStamp) {
      return -1;
    } else if (timeStamp > other.timeStamp) {
      return 1;
    } else {
      if(id < other.id){
        return -1;
      }
      else if (id > other.id) {
        return 1;
      }
      else{
        return 0;
      }
    }
  }
}