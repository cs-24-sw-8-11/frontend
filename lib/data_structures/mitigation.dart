
class Mitigation{
  String id;
  String title;
  String description;
  List<String> tags;

  Mitigation(this.id, this.title, this.description, this.tags);

  static Mitigation Default() {
    return Mitigation('0', 'Mitigations', 'This is where stress mitigations appear when enough data is present', ['default']);
  }
}