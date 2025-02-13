import 'package:flutter/material.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/screens/video_detail/components/detail_tap_info.dart';
import 'package:nungil/theme/common_theme.dart';

class DetailCastListPage extends StatefulWidget {
  final Video item;

  const DetailCastListPage({required this.item, super.key});

  @override
  State<DetailCastListPage> createState() => _DetailCastListPageState();
}

class _DetailCastListPageState extends State<DetailCastListPage> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> _tabs = [
      ListView.builder(
        itemCount: widget.item.cast.length,
        itemBuilder: (context, index) => ListTile(
          leading: const CircleAvatar(
            radius: 30,
            child: Icon(Icons.person, size: 30),
          ),
          title: Text(
            widget.item.cast[index].staffNm,
            style: ColorTextStyle.smallNavy(context),
            textAlign: TextAlign.start,
          ),
          subtitle: Text(
            widget.item.cast[index].staffRole != ""
                ? '(${widget.item.cast[index].staffRole} 역)'
                : '',
            style: ColorTextStyle.smallLightNavy(context),
            textAlign: TextAlign.start,
          ),
        ),
      ),
      ListView(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 32.0),
        children: [
          const SizedBox(height: 4.0),
          InfoTable(data: widget.item.directors),
          _buildList(map: widget.item.makers ?? {}),
          _buildList(map: widget.item.crew ?? {}),
        ],
      ),
    ];
    return SafeArea(
      // DefaultTabController를 사용해 탭바 컨트롤러를 자동으로 제공
      child: DefaultTabController(
        length: _tabs.length, // 탭 개수
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_rounded),
            ),
            title: const Text('출연진/제작진'),
            bottom: const TabBar(
              tabs: [
                Tab(text: '출연진'),
                Tab(text: '제작진'),
              ],
            ),
          ),
          // body에 TabBarView를 사용해 각 탭의 내용을 표시
          body: TabBarView(
            children: _tabs,
          ),
        ),
      ),
    );
  }

  Widget _buildList({required Map<String, dynamic> map}) {
    return Visibility(
      visible: map.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4.0),
          Divider(color: Theme.of(context).primaryColor.withOpacity(0.3)),
          const SizedBox(height: 4.0),
          InfoTable(data: map),
        ],
      ),
    );
  }
}
