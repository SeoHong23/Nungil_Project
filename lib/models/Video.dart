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
  String? commCodes; // 외부코드
  String title; // 영화명
  String? titleEng; // 영문제명
  String? titleOrg; // 원제명
  String titleEtc; // 기타제명(제명 검색을 위해 관리되는 제명 모음)
  String prodYear; // 제작연도
  double score; // 평점
  String nation; // 국가
  String company; // 제작사
  List<Plot> plots; // 줄거리
  String runtime; // 상영시간
  String? rating; // 심의등급
  String genre; // 장르
  String type; // 유형구분
  String use; // 용도구분
  String repRlsDate; // 대표 개봉일
  List<String> posters; // 포스터
  List<String> stlls; // 스틸이미지
  List<Staff> staffs; // 제작진(감독, 각본, 출연진, 스태프 순서)
  int reviewCnt;

  Video({
    this.commCodes,
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
    required this.repRlsDate,
    required this.posters,
    this.stlls = const[],
    required this.staffs,
    this.reviewCnt = 0,
  });
}

Video dummyVideo = Video(
  title: "명탐정 코난 : 시한장치의 마천루",
  titleEng: "Detective Conan: The Time-Bombed Skyscraper",
  titleOrg: "名探偵コナン 時計じかけの摩天楼",
  titleEtc:
      "명탐정코난:시한장치의마천루^명탐정 코난 : 시한장치의 마천루^名探偵コナン 時計じかけの摩天楼^Detective Conan the Movie: The Time-Bombed Skyscraper, Detective Conan: The Time Bombed Skyscraper, 명탐정코난시한장치의마천루, 명탐정 코난 시한장치의 마천루, 명탐정 코난: 시한장치의 마천...",
  prodYear: "1997",
  nation: "일본",
  company: "TMS Entertainment,소학관(쇼각칸),요미우리TV,토호,도쿄무비신사",
  plots: [
    Plot(
        plotLang: "한국어",
        plotText:
            "“5월 3일 토요일 밤 10시! 베이카 시네마 로비에서 만나는 거다! 잊지 마!”검은 조직에 의해 초등학생 코난의 몸으로 작아진 고등학생 명탐정 쿠도 신이치.천재 건축가 모리야 테이지 교수에게 가든 파티의 초대를 받았지만, 코난인 상태로는 참석할 수 없어 대리인을 부탁하려 소꿉친구 모리 란에게 목소리 변조기를 사용해 신이치로서 전화를 건다.하지만 란이 신이치의 생일 전날인 5월 3일 밤 10시, 심야 영화를 보자고 조건을 걸어 난처해지고 만다.약속 당일, 뉴스에서 화약 도난 사건을 보던 코난이자 신이치에게 수상한 협박 전화가 걸려 오고 의문의 남자가 도심 전체를 표적으로 한 연쇄 폭탄 테러를 예고한다.자신에게 도전장을 내민 연쇄 폭탄 테러임을 알아챈 신이치는 범인과의 숨 막히는 대결 중, 베이카 시티 빌딩에 있는 란이 타깃이 되어 위험에 처했음을 깨닫는데…‘명탐정 코난’, 전무후무 레전드 애니메이션의 ‘시작’!진실은 언제나 하나!")
  ],
  runtime: "94",
  rating: "12세이상관람가",
  genre: "미스터리,스릴러,범죄",
  type: "애니메이션",
  use: "극장용",
  repRlsDate: "20241002",
  posters: [
    "https://nungil-file-server.s3.ap-northeast-2.amazonaws.com/images/DPF030009_01",
    "https://nungil-file-server.s3.ap-northeast-2.amazonaws.com/images/DPF009370_01"
  ],
  stlls: [
    "https://nungil-file-server.s3.ap-northeast-2.amazonaws.com/images/DST865540_01",
    "https://nungil-file-server.s3.ap-northeast-2.amazonaws.com/images/DST865539_01",
    "https://nungil-file-server.s3.ap-northeast-2.amazonaws.com/images/DST865544_01",
    "https://nungil-file-server.s3.ap-northeast-2.amazonaws.com/images/DST868681_01",
    "https://nungil-file-server.s3.ap-northeast-2.amazonaws.com/images/DST868682_01",
    "https://nungil-file-server.s3.ap-northeast-2.amazonaws.com/images/DST868683_01",
    "https://nungil-file-server.s3.ap-northeast-2.amazonaws.com/images/DST867664_01",
    "https://nungil-file-server.s3.ap-northeast-2.amazonaws.com/images/DST867665_01",
    "https://nungil-file-server.s3.ap-northeast-2.amazonaws.com/images/DST867666_01",
    "https://nungil-file-server.s3.ap-northeast-2.amazonaws.com/images/DST867667_01",
  ],
  staffs: [
    Staff(staffNm: "코다마 켄지", staffRoleGroup: "감독", staffId: "00094033"),
    Staff(staffNm: "코우치 카즈나리", staffRoleGroup: "각본", staffId: "00145445"),
    Staff(
        staffNm: "타카야마 미나미",
        staffRoleGroup: "출연",
        staffRole: "에도가와 코난 목소리",
        staffId: "00103910"),
    Staff(
        staffNm: "야마구치 캇페이",
        staffRoleGroup: "출연",
        staffRole: "쿠도 신이치 목소리",
        staffId: "00092835"),
    Staff(
        staffNm: "야마자키 와카나",
        staffRoleGroup: "출연",
        staffRole: "모리 란 목소리",
        staffId: "00138673"),
    Staff(
        staffNm: "카미야 아키라",
        staffRoleGroup: "출연",
        staffRole: "모리 코고로 목소리",
        staffId: "00180053"),
    Staff(
        staffNm: "오가타 켄이치",
        staffRoleGroup: "출연",
        staffRole: "아가사 히로시 목소리",
        staffId: "00138137"),
    Staff(staffNm: "오카다 테루키요", staffRoleGroup: "편집", staffId: "00119414"),
    Staff(staffNm: "오오노 카츠오", staffRoleGroup: "음악", staffId: "00127054"),
    Staff(staffNm: "시부타니 유키히로", staffRoleGroup: "미술", staffId: "00124690"),
    Staff(
      staffNm: "TMS Entertainment",
      staffRoleGroup: "제작사",
    ),
    Staff(
      staffNm: "소학관(쇼각칸)",
      staffRoleGroup: "제작사",
    ),
    Staff(
      staffNm: "요미우리TV",
      staffRoleGroup: "제작사",
    ),
    Staff(
      staffNm: "토호",
      staffRoleGroup: "제작사",
    ),
    Staff(
      staffNm: "도쿄무비신사",
      staffRoleGroup: "제작사",
    ),
    Staff(
      staffNm: "CJ ENM",
      staffRoleGroup: "배급사",
    ),
    Staff(
      staffNm: "CJ ENM",
      staffRoleGroup: "수입사",
    )
  ],
);
