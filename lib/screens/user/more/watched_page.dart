import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/data/repository/video_reaction_repository.dart';
import 'package:nungil/theme/common_theme.dart';

class WatchedPage extends StatelessWidget {
  const WatchedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final movieList = VideoReactionRepository().getWatchedMovies();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          itemCount: movieList.length,
          itemBuilder: (context, index) {
            final movie = movieList[index];
            return ListTile(
              leading: CachedNetworkImage(imageUrl: movie.posterUrl),
              title: Text(movie.title),
              trailing: movie.isLiked
                  ? const Icon(
                      FontAwesomeIcons.faceSmile,
                      color: DefaultColors.green,
                    )
                  : movie.isDisliked
                      ? const Icon(
                          FontAwesomeIcons.faceFrown,
                          color: DefaultColors.red,
                        )
                      : const Text(''),
            );
          },
        ),
      ),
    );
  }
}
