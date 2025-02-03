class VideoListModel {
  final String id;
  final String title;
  final String poster;

  VideoListModel({required this.id, required this.title, required this.poster});

  factory VideoListModel.fromJson(Map<String, dynamic> json) {
    return VideoListModel(
      id: json['id'],
      title: json['title'],
      poster: (json['poster'] != null) ? json['poster'] : "",
    );
  }
}
