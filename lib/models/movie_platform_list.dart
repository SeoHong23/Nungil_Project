class OttIconList {
  final String name;
  final String uri;
  String? link = "";

  OttIconList({required this.name, required this.uri, this.link});
}

List<OttIconList> ottIconList = [
  OttIconList(name: '넷플릭스', uri: 'assets/images/ott_icons/netflix.png'),
  OttIconList(name: '티빙', uri: 'assets/images/ott_icons/tving.png'),
  OttIconList(name: '쿠팡플레이', uri: 'assets/images/ott_icons/coupang_play.png'),
  OttIconList(name: '웨이브', uri: 'assets/images/ott_icons/wavve.png'),
  OttIconList(name: '디즈니+', uri: 'assets/images/ott_icons/disneyplus.png'),
  OttIconList(name: '유튜브', uri: 'assets/images/ott_icons/youtube.png'),
  OttIconList(name: '왓챠', uri: 'assets/images/ott_icons/watcha.png'),
  OttIconList(name: '라프텔', uri: 'assets/images/ott_icons/laftel.png'),
  OttIconList(name: 'Apple TV', uri: 'assets/images/ott_icons/appletv.png'),
  OttIconList(name: 'U+모바일tv', uri: 'assets/images/ott_icons/lguplus.png'),
  OttIconList(name: '아마존 프라임 비디오', uri: 'assets/images/ott_icons/amazon.png'),
  OttIconList(name: '씨네폭스', uri: 'assets/images/ott_icons/cinefox.png'),
];

class TheaterList {
  final String name;
  final String uri;
  String? link = "";
  TheaterList({required this.name, required this.uri, this.link});
}

List<TheaterList> theaterList = [
  TheaterList(name: 'CGV', uri: 'assets/images/theater_icons/CGV.svg'),
  TheaterList(name: '롯데시네마', uri: 'assets/images/theater_icons/롯데시네마.svg'),
  TheaterList(name: '메가박스', uri: 'assets/images/theater_icons/메가박스.svg'),
  TheaterList(
      name: 'KT&G 상상마당 시네마',
      uri: 'assets/images/theater_icons/KT&G 상상마당 시네마.svg'),
];
