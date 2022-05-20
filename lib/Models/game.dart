class Game {
  int id = 1;
  String title = "";
  String? description = "";
  String? location;
  int maxPlayersNo = 0;
  DateTime date = DateTime.now();
  String? imgURL;

  Game({
    required this.id,
    required this.title,
    this.description,
    this.location,
    required this.maxPlayersNo,
    required this.date,
    this.imgURL,
  });

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        id: int.parse(json["id"]),
        title: json["title"],
        description: json["description"],
        location: json["location"],
        maxPlayersNo: int.parse(json["maxPlayersNo"]),
        date: DateTime.parse(json["date"]),
        imgURL: json["imgURL"],
      );

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "title": title,
        "description": description,
        "location": location,
        "maxPlayersNo": maxPlayersNo.toString(),
        "date": date.toString(),
        "imgURL": imgURL,
      };
}
