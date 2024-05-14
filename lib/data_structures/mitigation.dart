class Mitigation{
  String id;
  String title;
  String description;
  String type;
  List<String> tags;

  Mitigation(this.id, this.title, this.description, this.type, this.tags);

  static Mitigation defaultMitigation() {
    return Mitigation('0', 'Mitigations', 'This is where stress mitigations appear when enough data is present and if the stress level is high enough.', '1', ['default']);
  }
}