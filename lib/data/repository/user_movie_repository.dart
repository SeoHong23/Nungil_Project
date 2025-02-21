
import 'package:nungil/data/objectbox_helper.dart';
import 'package:nungil/models/detail/Movie.dart';
import 'package:nungil/objectbox.g.dart';

final movieBox = ObjectBox().getBox<Movie>();

List<Movie> getLikedMovie(){
  return movieBox.query(Movie_.isLiked.equals(true)).build().find();
}
List<Movie> getDislikedMovie(){
  return movieBox.query(Movie_.isDisliked.equals(true)).build().find();
}
List<Movie> getIgnoredMovie(){
  return movieBox.query(Movie_.isIgnored.equals(true)).build().find();
}
List<Movie> getBookmarkedMovie(){
  return movieBox.query(Movie_.isBookmarked.equals(true)).build().find();
}
List<Movie> getWatchedMovie(){
  return movieBox.query(Movie_.isWatched.equals(true)).build().find();
}
List<Movie> getWatchingMovie(){
  return movieBox.query(Movie_.isWatching.equals(true)).build().find();
}