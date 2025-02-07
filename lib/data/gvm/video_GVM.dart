import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/data/repository/video_repository.dart';
import 'package:nungil/models/Video.dart';

class VideoGVM extends Notifier<Video> {
  VideoRepository videoRepository = VideoRepository();

  @override
  Video build() {
    return Video(
      id: "",
      title: "복숭아",
      prodYear: "0000",
      nation: "눈길",
      score: 0.0,
      company: [],
      plots: "자꾸 눈이 가네 하얀 그 얼굴에 질리지도 않아 넌 왜",
      runtime: "3",
      genre: [],
      releaseDate: "releaseDate",
      posters: [],
      stlls: [],
      directors: {"": ""},
      cast: [],
      makers: "",
      crew: {"": ""},
      awards1: "",
      awards2: "",
      keywords: [],
    );
  }

  Future<void> findVideo(String id) async {
    final resData = await videoRepository.readData(id);

    List<Staff> cast = [];
    for (dynamic one in resData['cast']) {
      Map<String, dynamic> model = one;
      Staff st = Staff(
        staffNm: model['staffNm'],
        staffRoleGroup: model['staffRoleGroup'],
        staffRole: model['staffRole'],
      );
      cast.add(st);
    }
    state = Video(
      id: resData['id'],
      title: resData['title'],
      titleEng: resData['titleEng'],
      prodYear: resData['prodYear'],
      nation: resData['nation'],
      score: 0,
      company: resData['company'],
      plots: resData['plots'],
      runtime: resData['runtime'],
      genre: resData['genre'],
      releaseDate: resData['releaseDate'],
      rating: resData['rating'],
      posters: resData['posters'],
      stlls: resData['stlls'],
      directors: resData['directors'],
      cast: cast,
      makers: resData['makers'],
      crew: resData['crew'],
      awards1: resData['awards1'],
      awards2: resData['awards2'],
      keywords: resData['keywords'],
    );
  }
}

final videoProvider = NotifierProvider<VideoGVM, Video>(
  () => VideoGVM(),
);
