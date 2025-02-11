class VideoRankModel {
  final String id;
  final String title;
  final String poster;
  final String rank;
  final String rankInten;
  final String rankOldAndNew;

  VideoRankModel(
      {required this.id,
      required this.title,
      required this.poster,
      required this.rank,
      required this.rankInten,
      required this.rankOldAndNew});

  factory VideoRankModel.fromJson(Map<String, dynamic> json) {
    return VideoRankModel(
      id: (json['id'] != null) ? json['id'] : "",
      title: json['title'],
      poster: (json['poster'] != null) ? json['poster'] : "",
      rank: json['rank'],
      rankInten: json['rankInten'],
      rankOldAndNew: json['rankOldAndNew'],
    );
  }
}
