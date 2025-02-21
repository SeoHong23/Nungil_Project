import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nungil/data/repository/user_movie_repository.dart';
import 'package:nungil/theme/common_theme.dart';

class WatchedPage extends StatelessWidget {
  const WatchedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final movieList = getWatchedMovie();
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
                      Icons.thumb_up_rounded,
                      color: DefaultColors.green,
                    )
                  : movie.isDisliked
                      ? Icon(Icons.thumb_down_alt_rounded)
                      : Text(''),
            );
          },
        ),
      ),
    );
  }
}
