class BannerModel {
  final String id;
  final String title;
  final String fileName;

  BannerModel({required this.id, required this.title, required this.fileName});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: (json['id'] != null) ? json['id'] : "",
      title: json['title'],
      fileName: json['fileName'],
    );
  }
}
