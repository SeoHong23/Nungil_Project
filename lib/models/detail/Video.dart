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

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      staffNm: map['staffNm'],
      staffRoleGroup: map['staffRoleGroup'],
      staffRole: map['staffRole'],
      staffId: map['staffId'],
    );
  }

  static List<Staff> fromList(List<dynamic> list) {
    return list
        .map((item) => Staff.fromMap(item as Map<String, dynamic>))
        .toList();
  }
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
  Map<String, dynamic>? makers; // 제작자 투자자 제작사 배급사 수입사
  Map<String, dynamic>? crew; // 이외
  String? awards1;
  String? awards2;
  List<dynamic>? keywords;
  int reviewCnt;
  List<dynamic> mediaList;

  Video(
      {required this.id,
      required this.title,
      this.titleEng,
      required this.prodYear,
      required this.nation,
      this.score = 0.0,
      required this.company,
      required this.plots,
      this.runtime,
      this.rating,
      required this.genre,
      required this.releaseDate,
      required this.posters,
      required this.stlls,
      this.directors = const {},
      this.cast = const [],
      this.makers,
      this.crew,
      this.awards1,
      this.awards2,
      this.keywords,
      this.reviewCnt = 0,
      this.mediaList = const []});

  factory Video.fromNull() {
    return Video(
      id: "",
      title: "",
      titleEng: "",
      prodYear: "",
      nation: "",
      score: 0.0,
      company: [],
      plots: "",
      runtime: "",
      genre: [],
      releaseDate: "",
      rating: "",
      posters: [],
      stlls: [],
      directors: {},
      cast: [],
      makers: {},
      crew: {},
      awards1: "",
      awards2: "",
      keywords: [],
    );
  }

  // Map 데이터를 Video 객체로 변환하는 팩토리 메서드
  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['id'],
      title: map['title'],
      titleEng: map['titleEng'],
      prodYear: map['prodYear'],
      nation: map['nation'],
      score: map['score']?.toDouble() ?? 0.0,
      // null 방지
      company: map['company'] ?? [],
      plots: map['plots'],
      runtime: map['runtime'],
      genre: map['genre'] ?? [],
      releaseDate: map['releaseDate'],
      rating: map['rating'],
      posters: map['posters'] ?? [],
      stlls: map['stlls'] ?? [],
      directors: map['directors'] ?? {},
      cast: Staff.fromList(map['cast'] ?? []),
      // cast 리스트 변환
      makers: map['makers'],
      crew: map['crew'],
      awards1: map['awards1'],
      awards2: map['awards2'],
      keywords: map['keywords'] ?? [],
      reviewCnt: map['reviewCnt'] ?? 0,
      mediaList: [
        ...map['stlls'],
        ...map['posters'],
      ],
    );
  }
}