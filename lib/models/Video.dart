class Plot {
  String plotLang;
  String plotText;

  Plot({
    required this.plotLang,
    required this.plotText,
  });
}

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
  String? id;
  String? commCode; // 외부코드
  String title; // 영화명
  String? titleEng; // 영문제명
  String? titleOrg; // 원제명
  String titleEtc; // 기타제명(제명 검색을 위해 관리되는 제명 모음)
  String prodYear; // 제작연도
  double score; // 평점
  String nation; // 국가
  List<String> company; // 제작사
  List<Plot> plots; // 줄거리
  String runtime; // 상영시간
  String? rating; // 심의등급
  List<String> genre; // 장르
  String type; // 유형구분
  String use; // 용도구분
  String releaseDate; // 대표 개봉일
  List<String> posters; // 포스터
  List<String> stlls; // 스틸이미지
  List<Staff> staffs; // 제작진(감독, 각본, 출연진, 스태프 순서)
  int reviewCnt;

  Video({
    this.id,
    this.commCode,
    required this.title,
    this.titleEng,
    this.titleOrg,
    required this.titleEtc,
    required this.prodYear,
    this.score = 5.0,
    required this.nation,
    required this.company,
    required this.plots,
    required this.runtime,
    this.rating,
    required this.genre,
    required this.type,
    required this.use,
    required this.releaseDate,
    required this.posters,
    this.stlls = const [],
    required this.staffs,
    this.reviewCnt = 0,
  });
}

Video dummyVideo = Video(
  id: "679c58824fd75204ab7f9f52",
  commCode: "20224666",
  title: "파일럿",
  titleEng: "Pilot",
  titleOrg: "",
  titleEtc: "파일럿^Pilot",
  prodYear: "2023",
  nation: "한국",
  company: ["쇼트케이크", "㈜무비락"],
  runtime: "111",
  plots: [
    Plot(
      plotLang: "한국어",
      plotText:
          "최고의 비행 실력을 갖춘 스타 파일럿이자 뜨거운 인기로 유명 TV쇼에도 출연할 만큼 고공행진 하던 한정우는 순간의 잘못으로 하루아침에 모든 것을 잃고 실직까지 하게 된다. 블랙 리스트에 오른 그를 다시 받아줄 항공사는 어느 곳도 없었고 궁지에 몰린 한정우는 여동생의 신분으로 완벽히 변신, 마침내 재취업에 성공한다. 그러나 기쁨도 잠시! 또다시 예상치 못한 난관에 부딪히게 되는데… 인생 순항을 꿈꾸던 그의 삶은 무사히 이륙할 수 있을까?",
    )
  ],
  rating: "12세 이상 관람가",
  genre: [
    "코미디",
  ],
  type: "극영화",
  use: "극장용",
  releaseDate: "20240731",
  posters: [
    "https://s3.ap-northeast-2.amazonaws.com/nungil.file.server/images/DPK021958_01",
    "https://s3.ap-northeast-2.amazonaws.com/nungil.file.server/images/DPK022517_01",
    "https://s3.ap-northeast-2.amazonaws.com/nungil.file.server/images/DPK022518_01",
    "https://s3.ap-northeast-2.amazonaws.com/nungil.file.server/images/DPK022519_01",
    "https://s3.ap-northeast-2.amazonaws.com/nungil.file.server/images/DPK022158_01",
    "https://s3.ap-northeast-2.amazonaws.com/nungil.file.server/images/DPK022541_01",
    "https://s3.ap-northeast-2.amazonaws.com/nungil.file.server/images/DPK022516_01",
    "https://s3.ap-northeast-2.amazonaws.com/nungil.file.server/images/DPK022360_01",
  ],
  stlls: [
    "https://s3.ap-northeast-2.amazonaws.com/nungil.file.server/images/DST852176_01",
    "https://s3.ap-northeast-2.amazonaws.com/nungil.file.server/images/DST850071_01",
    "https://s3.ap-northeast-2.amazonaws.com/nungil.file.server/images/DST850072_01",
    "https://s3.ap-northeast-2.amazonaws.com/nungil.file.server/images/DST850073_01",
    "https://s3.ap-northeast-2.amazonaws.com/nungil.file.server/images/DST850074_01",
    "https://s3.ap-northeast-2.amazonaws.com/nungil.file.server/images/DST851646_01",
    "https://s3.ap-northeast-2.amazonaws.com/nungil.file.server/images/DST851648_01",
    "https://s3.ap-northeast-2.amazonaws.com/nungil.file.server/images/DST851649_01",
    "https://s3.ap-northeast-2.amazonaws.com/nungil.file.server/images/DST851650_01",
    "https://s3.ap-northeast-2.amazonaws.com/nungil.file.server/images/DST850470_01",
  ],
  staffs: [
    Staff(staffNm: "김한결", staffRoleGroup: "감독", staffId: "00149989"),
    Staff(staffNm: "조유진", staffRoleGroup: "각본", staffId: "00230296"),
    Staff(staffNm: "김한결", staffRoleGroup: "각색", staffId: "00149989"),
    Staff(staffNm: "한준희", staffRoleGroup: "각색", staffId: "00045870"),
    Staff(
        staffNm: "조정석",
        staffRoleGroup: "출연",
        staffRole: "한정우",
        staffId: "00161318"),
    Staff(
        staffNm: "이주명",
        staffRoleGroup: "출연",
        staffRole: "윤슬기",
        staffId: "00231186"),
    Staff(
        staffNm: "한선화",
        staffRoleGroup: "출연",
        staffRole: "한정미",
        staffId: "00218719"),
    Staff(
        staffNm: "신승호",
        staffRoleGroup: "출연",
        staffRole: "서현석",
        staffId: "00216020"),
    Staff(
        staffNm: "오민애",
        staffRoleGroup: "출연",
        staffRole: "안자",
        staffId: "00024874"),
    Staff(
        staffNm: "윤수혁",
        staffRoleGroup: "출연",
        staffRole: "응급실 의사",
        staffId: "00228115"),
    Staff(staffNm: "김명진", staffRoleGroup: "제작자", staffId: "00146287"),
    Staff(staffNm: "김재중", staffRoleGroup: "제작자", staffId: "00044187"),
    Staff(staffNm: "중소벤처기업부", staffRoleGroup: "투자사", staffRole: "투자지원"),
    Staff(staffNm: "한국벤처투자", staffRoleGroup: "투자사", staffRole: "투자지원"),
    Staff(staffNm: "문화체육관광부", staffRoleGroup: "투자사", staffRole: "투자지원"),
    Staff(staffNm: "영화진흥위원회", staffRoleGroup: "투자사", staffRole: "투자지원"),
    Staff(staffNm: "롯데컬처웍스㈜롯데엔터테인먼트", staffRoleGroup: "배급사"),
  ],
);
