import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nungil/data/repository/video_repository.dart';
import 'package:nungil/models/detail/Video.dart';
import 'package:nungil/models/movie_platform_list.dart';
import 'package:nungil/theme/common_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailOtt extends StatefulWidget {
  final Video item;
  final Map<String, dynamic> ottLinks;
  final Map<String, dynamic> theaterLinks;
  const DetailOtt(
      {required this.item,
      required this.ottLinks,
      required this.theaterLinks,
      super.key});

  @override
  State<DetailOtt> createState() => _DetailOttState();
}

class _DetailOttState extends State<DetailOtt> {
  @override
  void initState() {
    super.initState();
  }

  String getTheaterUrl(String name) {
    final theater = theaterList.firstWhere(
      (theater) => theater.name == name,
      orElse: () => TheaterList(name: '', uri: ''), // 일치하는 값이 없을 경우 기본값 반환
    );
    return theater.uri;
  }

  String getOTTUrl(String name) {
    final ott = ottIconList.firstWhere(
      (ott) => ott.name == name,
      orElse: () => OttIconList(name: '', uri: ''), // 일치하는 값이 없을 경우 기본값 반환
    );
    return ott.uri;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //상영 정보
        Text('상영 정보 ${widget.theaterLinks.length}',
            style: ColorTextStyle.mediumNavy(context)),
        const SizedBox(height: 8),
        widget.theaterLinks.isNotEmpty
            ? Column(
                children: List.generate(
                  widget.theaterLinks.length,
                  (index) {
                    // Map의 entries를 리스트로 변환 후 접근
                    var entry = widget.theaterLinks.entries.toList()[index];
                    String theaterName = entry.key; // key: 극장 이름
                    String theaterUrl = entry.value; // value: URL

                    return Container(
                      decoration: BoxDecoration(),
                      padding: EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () => launchUrl(Uri.parse("${theaterUrl}")),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  getTheaterUrl(theaterName),
                                  width: 60,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(theaterName,
                                style: ColorTextStyle.largeNavy(context)),
                            Expanded(child: Container()),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : Text("현재 상영중인 영화가 아니에요!",
                style: ColorTextStyle.smallNavy(context)),
        const SizedBox(height: 24),
        //상영 정보 끝
        //OTT 정보
        Text('OTT ${widget.ottLinks.length}',
            style: ColorTextStyle.mediumNavy(context)),
        const SizedBox(height: 8),

        widget.ottLinks.isNotEmpty
            ? Column(
                children: List.generate(
                  widget.ottLinks.length,
                  (index) {
                    var entry = widget.ottLinks.entries.toList()[index];
                    String ottName = entry.key; // key: 이름
                    String ottUrl = entry.value; // value: URL
                    return Container(
                      decoration: BoxDecoration(),
                      padding: EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () => launchUrl(Uri.parse("${ottUrl}")),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Image.asset(
                                  getOTTUrl(ottName),
                                  width: 60,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(ottName,
                                style: ColorTextStyle.largeNavy(context)),
                            Expanded(child: Container()),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : Text("현재 제공하는 OTT가 없어요!",
                style: ColorTextStyle.smallNavy(context)),
        const SizedBox(height: 24),
        //OTT 정보 끝
      ],
    );
  }
}
