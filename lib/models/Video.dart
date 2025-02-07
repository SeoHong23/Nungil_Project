class Staff {
  String staffNm;
  String staffRoleGroup;
  String? staffRole;
  String? staffId;

  Staff({
    required this.staffNm,
    required this.staffRoleGroup,
    this.staffRole,
    this.staffId,
  });
}

class Video {
  String id;
  String title; // 영화명
  String? titleEng; // 영문제명
  String prodYear; // 제작연도
  String nation; // 국가
  double score; // 평점
  List<dynamic> company; // 제작사
  String plots; // 줄거리
  String? runtime; // 상영시간
  String? rating; // 심의등급
  List<dynamic> genre; // 장르
  String releaseDate; // 대표 개봉일
  List<dynamic> posters; // 포스터
  List<dynamic> stlls; // 스틸이미지
  Map<String, dynamic> directors; // 감독, 각본, 각색
  List<Staff> cast; // 출연
  String? makers; // 제작자 투자자 제작사 배급사 수입사
  Map<String, dynamic>? crew; // 이외
  String? awards1;
  String? awards2;
  List<dynamic>? keywords;
  int reviewCnt;

  Video({
    required this.id,
    required this.title,
    this.titleEng,
    required this.prodYear,
    required this.nation,
    this.score=5.0,
    required this.company,
    required this.plots,
    this.runtime,
    this.rating,
    required this.genre,
    required this.releaseDate,
    required this.posters,
    required this.stlls,
    this.directors=const{"":""},
    this.cast=const[],
    this.makers,
    this.crew,
    this.awards1,
    this.awards2,
    this.keywords,
    this.reviewCnt = 0
  });
}
