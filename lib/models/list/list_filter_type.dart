class FilterRepository {
  static final List<FilterData> filters = [
    FilterData(category: "장르", options: [
      'SF',
      '가족',
      '공포',
      '기업ㆍ기관ㆍ단체',
      '느와르',
      '드라마',
      '로드무비',
      '멜로/로맨스',
      '뮤직',
      '뮤지컬',
      '미스터리',
      '무협',
      '문화',
      '범죄',
      '사회',
      '사회물(경향)',
      '서부',
      '스릴러',
      '스포츠',
      '시대극/사극',
      '애니메이션',
      '어드벤처',
      '에로',
      '역사',
      '옴니버스',
      '인권',
      '인물',
      '재난',
      '전쟁',
      '종교',
      '청춘영화',
      '코미디',
      '판타지',
      '자연ㆍ환경',
      '지역',
      '교육',
      '액션'
    ]),
    FilterData(category: "국가", options: [
      '그리스',
      '네덜란드',
      '노르웨이',
      '뉴질랜드',
      '대만',
      '덴마크',
      '독일',
      '라트비아',
      '러시아',
      '리투아니아',
      '말리',
      '멕시코',
      '미국',
      '미얀마',
      '방글라데시',
      '베트남',
      '벨기에',
      '불가리아',
      '부탄',
      '세네갈',
      '세르비아',
      '스웨덴',
      '스위스',
      '스페인',
      '싱가포르',
      '아르헨티나',
      '아랍에미리트',
      '아이슬란드',
      '아일랜드',
      '에스토니아',
      '영국',
      '오스트리아',
      '오스트레일리아',
      '우크라이나',
      '이란',
      '이탈리아',
      '인도',
      '일본',
      '체코',
      '카자흐스탄',
      '카타르',
      '캐나다',
      '콜롬비아',
      '태국',
      '폴란드',
      '핀란드',
      '필리핀',
      '한국',
      '홍콩'
    ]),
    FilterData(category: "연도", options: ["2024", "2025"]),
    FilterData(category: "연령등급", options: [
      "전체 관람가",
      "12세 이상 관람가",
      "15세 이상 관람가",
      "청소년 관람불가",
    ]),
  ];

  /// 특정 필터 카테고리의 옵션을 가져오는 메서드
  static List<String> getOptionsByCategory(String category) {
    return filters
        .firstWhere(
          (filter) => filter.category == category,
          orElse: () => FilterData(category: category, options: []),
        )
        .options;
  }
}

class FilterData {
  final String category;
  final List<String> options;

  FilterData({required this.category, required this.options});
}
