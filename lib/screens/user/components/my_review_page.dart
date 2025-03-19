import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/data/repository/review_repository.dart';
import 'package:nungil/data/repository/setting_repository.dart';
import 'package:nungil/models/review/review_model.dart';
import 'package:nungil/theme/common_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyReviewPage extends ConsumerWidget {
  const MyReviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userReviewAsync = ref.watch(userReviewsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("내가 작성한 리뷰")),
      body: userReviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("리뷰를 불러오는 중 오류 발생: $error")),
        data: (List<Review> reviews) {
          if (reviews.isEmpty ) {
            return const Center(child: Text("아직 작성한 리뷰가 없습니다."));
          }
          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return ListTile(
                title: Text(review.movieTitle),
                subtitle: Text(review.content),
                trailing: Text("${review.rating} ⭐"),
              );
            },
          );
        },
      ),
    );
  }
}