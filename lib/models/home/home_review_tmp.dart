/// 2025-01-29 강중원 - 생성
///

class HomeReviewTmp {
  final String mName;
  final String contents;
  final String uName;

  HomeReviewTmp(
      {required this.mName, required this.contents, required this.uName});
}

List<HomeReviewTmp> homeReviewTmp = [
  HomeReviewTmp(mName: "미키 17", contents: "너무 재미있어서 3번째 관람중입니다!", uName: "홍길동"),
  HomeReviewTmp(mName: "오징어 게임 2", contents: "배우가 마음에 들어요", uName: "홍길동"),
  HomeReviewTmp(
      mName: "인사이드 아웃2", contents: "창의력이 돋보이는 작품이었습니다.", uName: "홍길동"),
];
