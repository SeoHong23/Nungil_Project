import 'package:flutter/material.dart';
import 'package:nungil/screens/home/components/home_video_list_component.dart';

import '../../../data/repository/video_list_repository.dart';
import '../../../models/list/video_list_model.dart';
import '../../../models/list/video_list_tmp.dart';
import '../../../theme/common_theme.dart';
import '../../common_components/video_list_component.dart';

class HomeMovieListComponent extends StatefulWidget {
  final String title;
  final String type;
  final List<VideoListModel> videoList;

  const HomeMovieListComponent(
      {required this.title,
      required this.type,
      required this.videoList,
      super.key});

  @override
  State<HomeMovieListComponent> createState() => _HomeMovieListComponentState();
}

class _HomeMovieListComponentState extends State<HomeMovieListComponent> {
  bool isLoading = true;

  Map<String, Set<String>> filter = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(
          height: 8.0,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              children: List.generate(
                widget.videoList.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SizedBox(
                    width: 170,
                    height: 250,
                    child: HomeVideoListComponent(
                      id: widget.videoList[index].id,
                      imgUrl: widget.videoList[index].poster ?? '',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
