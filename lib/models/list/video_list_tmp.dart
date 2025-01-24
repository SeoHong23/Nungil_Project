//////////////////////////////////////////////////
// 2025-01-24 강중원 - 생성
//////////////////////////////////////////////////

class VideoListTmp {
  final String imgUrl;
  final String name;
  final double rate;

  VideoListTmp({required this.name, required this.imgUrl, required this.rate});
}

List<VideoListTmp> videoListTmp = [
  VideoListTmp(
      name: "더 글로리", imgUrl: 'assets/images/tmp/glory.webp', rate: 35.2),
  VideoListTmp(
      name: "미키17", imgUrl: 'assets/images/tmp/mickey17.webp', rate: 100.0),
  VideoListTmp(
      name: "인사이드 아웃2", imgUrl: 'assets/images/tmp/insideOut.webp', rate: 96.0),
  VideoListTmp(
      name: "오징어게임2", imgUrl: 'assets/images/tmp/squid.webp', rate: 50.4),
];
