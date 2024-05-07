
class Mitigation{
  String id;
  String title;
  String description;
  String type;
  List<String> tags;

  Mitigation(this.id, this.title, this.description, this.type, this.tags);

  static Mitigation Default() {
    return Mitigation('0', 'Mitigations', 'This is where stress mitigations appear when enough data is present', '1', ['default']);
  }
}