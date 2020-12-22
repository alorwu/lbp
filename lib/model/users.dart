class Users {
  String id;
  String playerId;
  String segment;

  Users({this.id, this.playerId, this.segment});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      playerId: json['playerId'],
      segment: json['segment']
    );
  }
}