import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/screens/search/search_page.dart';
import 'package:nungil/screens/video_detail/components/custom_animated_switcher.dart';
import 'package:nungil/screens/video_detail/components/skeleton.dart';
import 'package:nungil/data/gvm/video_GVM.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/screens/video_detail/components/detail_tap_imgs.dart';
import 'package:nungil/screens/video_detail/components/detail_tap_info.dart';
import 'package:nungil/screens/video_detail/components/detail_tap_review.dart';
import 'package:nungil/screens/video_detail/components/detail_top.dart';
import 'package:nungil/theme/common_theme.dart';

class VideoDetailPage extends ConsumerStatefulWidget {
  final String item;

  const VideoDetailPage({required this.item, super.key});

  @override
  ConsumerState<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends ConsumerState<VideoDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  double _opacity = 0.0; // 초기 투명도


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_scrollListener);
  }

  void _switchTab(int index) {
    _tabController.animateTo(index);
  }

  void _scrollListener() {
    const double maxOffset = 100.0;
    double offset = _scrollController.offset;

    // 투명도는 0에서 1로 선형 변화
    double newOpacity = (offset / maxOffset).clamp(0.0, 1.0);

    if (newOpacity != _opacity) {
      setState(() {
        _opacity = newOpacity;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final video = ref.watch(videoDetailProvider(widget.item));
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(_opacity),
          title: Opacity(
            opacity: _opacity,
            child: CustomAnimatedSwitcher(
              child: video.title.isEmpty
                  ? const ShimmerBox(height: 200, width: 80)
                  : Text(
                      video.title,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0),
                    ),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.left_chevron,
              color: Theme.of(context).primaryColor,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
              },
              icon: const Icon(FontAwesomeIcons.magnifyingGlass),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true, // 상단 패딩 제거
          child: NestedScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            // 스크롤 문제 해결
            floatHeaderSlivers: true,
            // 헤더가 자연스럽게 떠 있도록 설정
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              // DetailTop을 SliverPersistentHeader로 변경
              SliverPersistentHeader(
                pinned: true,
                delegate: _DetailTopDelegate(video),
              ),

              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      const Tab(
                          child:
                              Text("작품정보", style: CustomTextStyle.pretendard)),
                      Tab(
                          child: Text("리뷰 ${video.reviewCnt}",
                              style: CustomTextStyle.pretendard)),
                      Tab(
                          child: Text("영상/이미지 ${video.mediaList.length}",
                              style: CustomTextStyle.pretendard))
                    ],
                    indicatorColor: Theme.of(context).colorScheme.secondary,
                    labelColor: Theme.of(context).colorScheme.secondary,
                    overlayColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.secondary),
                    unselectedLabelColor: Theme.of(context).colorScheme.primary,
                    indicatorPadding: EdgeInsets.only(bottom: -1.5),
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                ),
              )
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent(
                  CustomAnimatedSwitcher(
                    child: video.plots.isNotEmpty
                        ? DetailTapInfo(
                            key: const ValueKey('data'),
                            item: video,
                      changeTab: _switchTab,
                          )
                        : const ShimmerInfo(
                            key: ValueKey('shimmer'),
                          ),
                  ),
                ),
                _buildTabContent(DetailTapReview(item: video)),
                _buildTabContent(DetailTapImgs(item: video)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(Widget content) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 32.0),
      child: content,
    );
  }
}

// SliverPersistentHeader로 탭바를 고정하는 델리게이트
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _StickyTabBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
              bottom: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  width: 1.0))),
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class _DetailTopDelegate extends SliverPersistentHeaderDelegate {
  final Video item;

  _DetailTopDelegate(this.item);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return CustomAnimatedSwitcher(
        child: item.posters.isNotEmpty
            ? DetailTop(
                item: item,
                key: const ValueKey('data'),
              )
            : const SkeletonDetailTop(
                key: ValueKey('shimmer'),
              ));
  }

  @override
  double get maxExtent => 420; // DetailTop 높이에 맞게 조절
  @override
  double get minExtent => 50; // 스크롤 시 사라지도록 설정
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
