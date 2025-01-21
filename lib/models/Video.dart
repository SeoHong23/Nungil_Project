class Director {
  String directorNm;
  String directorEnNm;
  String directorId;

  Director({
    required this.directorNm,
    required this.directorEnNm,
    required this.directorId,
  });
}

class Actor {
  String actorNm;
  String? actorEnNm;
  String? actorId;

  Actor({
    required this.actorNm,
    this.actorEnNm,
    this.actorId,
  });
}

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
  String? staffEnNm;
  String staffRoleGroup;
  String? staffRole;
  String? staffEtc;
  String? staffId;

  Staff({
    required this.staffNm,
    this.staffEnNm,
    required this.staffRoleGroup,
    this.staffRole,
    this.staffEtc,
    this.staffId,
  });
}

class Video {
  String DOCID;
  String movieId;
  String movieSeq;
  String title;
  String titleEng;
  String titleOrg;
  String titleEtc;
  String prodYear;
  List<Director> directors;
  List<Actor> actors;
  String nation;
  String company;
  List<Plot> plots;
  String runtime;
  String rating;
  String genre;
  String type;
  String use;
  String ratedYn;
  String repRatDate;
  String repRlsDate;
  List<String> posters;
  List<String> stlls;
  List<Staff> staffs;
  String regDate;
  String modDate;

  Video(
      {required this.DOCID,
      required this.movieId,
      required this.movieSeq,
      required this.title,
      required this.titleEng,
      required this.titleOrg,
      required this.titleEtc,
      required this.prodYear,
      required this.directors,
      required this.actors,
      required this.nation,
      required this.company,
      required this.plots,
      required this.runtime,
      required this.rating,
      required this.genre,
      required this.type,
      required this.use,
      required this.ratedYn,
      required this.repRatDate,
      required this.repRlsDate,
      required this.posters,
      required this.stlls,
      required this.staffs,
      required this.regDate,
      required this.modDate});
}

Video dummyVideo = Video(
  DOCID: "F20701",
  movieId: "F",
  movieSeq: "20701",
  title: "명탐정 코난 : 시한장치의 마천루",
  titleEng: "Detective Conan: The Time-Bombed Skyscraper",
  titleOrg: "名探偵コナン 時計じかけの摩天楼",
  titleEtc:
      "명탐정코난:시한장치의마천루^명탐정 코난 : 시한장치의 마천루^名探偵コナン 時計じかけの摩天楼^Detective Conan the Movie: The Time-Bombed Skyscraper, Detective Conan: The Time Bombed Skyscraper, 명탐정코난시한장치의마천루, 명탐정 코난 시한장치의 마천루, 명탐정 코난: 시한장치의 마천...",
  prodYear: "1997",
  directors: [
    Director(
        directorNm: "코다마 켄지",
        directorEnNm: "Kenji Kodama",
        directorId: "00094033")
  ],
  actors: [
    Actor(actorNm: "타카야마 미나미", actorEnNm: "Minami Takayama", actorId: "00103910"),
    Actor(actorNm: "야마구치 캇페이",actorEnNm: "Kappei Yamaguchi", actorId: "00092835"),
    Actor(actorNm: "야마자키 와카나", actorEnNm: "Wakana Yamazaki", actorId: "00138673"),
    Actor(actorNm: "카미야 아키라", actorEnNm: "Kamiya Akira", actorId: "00180053"),
    Actor(actorNm: "오가타 켄이치", actorEnNm: "Ogata Kenichi", actorId: "00138137"),
  ],
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
  ratedYn: "Y",
  repRatDate: "20240902",
  repRlsDate: "20241002",
  posters: [
    "http://file.koreafilm.or.kr/poster/99/18/56/DPF030009_01.jpg",
    "http://file.koreafilm.or.kr/poster/00/03/08/DPF009370_01.JPG"
  ],
  stlls: [
    "http://file.koreafilm.or.kr/still/copy/00/67/86/DST865540_01.jpg",
    "http://file.koreafilm.or.kr/still/copy/00/67/86/DST865539_01.jpg",
    "http://file.koreafilm.or.kr/still/copy/00/67/86/DST865544_01.jpg",
    "http://file.koreafilm.or.kr/still/copy/00/68/17/DST868681_01.jpg",
    "http://file.koreafilm.or.kr/still/copy/00/68/17/DST868682_01.jpg",
    "http://file.koreafilm.or.kr/still/copy/00/68/17/DST868683_01.jpg",
    "http://file.koreafilm.or.kr/still/copy/00/68/06/DST867664_01.jpg",
    "http://file.koreafilm.or.kr/still/copy/00/68/06/DST867665_01.jpg",
    "http://file.koreafilm.or.kr/still/copy/00/68/06/DST867666_01.jpg",
    "http://file.koreafilm.or.kr/still/copy/00/68/06/DST867667_01.jpg",
  ],
  staffs: [
    Staff(
        staffNm: "코다마 켄지",
        staffEnNm: "Kenji Kodama",
        staffRoleGroup: "감독",
        staffId: "00094033"),
    Staff(
        staffNm: "코우치 카즈나리",
        staffEnNm: "Kouchi Kazunari",
        staffRoleGroup: "각본",
        staffId: "00145445"),
    Staff(
        staffNm: "타카야마 미나미",
        staffEnNm: "Minami Takayama",
        staffRoleGroup: "출연",
        staffRole: "에도가와 코난 목소리",
        staffId: "00103910"),
    Staff(
        staffNm: "야마구치 캇페이",
        staffEnNm: "Kappei Yamaguchi",
        staffRoleGroup: "출연",
        staffRole: "쿠도 신이치 목소리",
        staffId: "00092835"),
    Staff(
        staffNm: "야마자키 와카나",
        staffEnNm: "Wakana Yamazaki",
        staffRoleGroup: "출연",
        staffRole: "모리 란 목소리",
        staffId: "00138673"),
    Staff(
        staffNm: "카미야 아키라",
        staffEnNm: "Kamiya Akira",
        staffRoleGroup: "출연",
        staffRole: "모리 코고로 목소리",
        staffId: "00180053"),
    Staff(
        staffNm: "오가타 켄이치",
        staffEnNm: "Ogata Kenichi",
        staffRoleGroup: "출연",
        staffRole: "아가사 히로시 목소리",
        staffId: "00138137"),
    Staff(
        staffNm: "오카다 테루키요",
        staffEnNm: "Terukiyo Okada",
        staffRoleGroup: "편집",
        staffId: "00119414"),
    Staff(
        staffNm: "오오노 카츠오",
        staffEnNm: "Ohno Katsuo",
        staffRoleGroup: "음악",
        staffId: "00127054"),
    Staff(
        staffNm: "시부타니 유키히로",
        staffEnNm: "Yukihiro Shibutani",
        staffRoleGroup: "미술",
        staffId: "00124690"),
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
      staffEnNm: "CJ ENM",
      staffRoleGroup: "배급사",
    ),
    Staff(
      staffNm: "CJ ENM",
      staffEnNm: "CJ ENM",
      staffRoleGroup: "수입사",
    )
  ],
  regDate: "20070704",
  modDate: "20240904",
);
