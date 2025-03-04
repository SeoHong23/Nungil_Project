import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nungil/data/repository/Banner_repository.dart';
import 'package:nungil/models/admin/banner_model.dart';
import 'package:nungil/screens/common_components/poster_image_component.dart';
import 'package:nungil/theme/common_theme.dart';

class BannerItemComponent extends StatefulWidget {
  final BannerModel bannerModel;
  final Function(String) onDelete;
  const BannerItemComponent(
      {required this.bannerModel, required this.onDelete, super.key});

  @override
  State<BannerItemComponent> createState() => _BannerItemComponentState();
}

class _BannerItemComponentState extends State<BannerItemComponent> {
  Future<void> DeleteBanner(String id) async {
    try {
      final repository = BannerRepository();
      await repository.DeleteBanner(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("  삭제 완료되었습니다.")),
      );
      widget.onDelete(id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(" 오류 발생: 삭제 실패했습니다. $e")),
      );
    }

    setState(() {});
  }

  Future<void> confirmDelete(String id) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("삭제 확인"),
        content: Text("정말 삭제하시겠습니까?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("취소")),
          TextButton(
              onPressed: () => Navigator.pop(context, true), child: Text("삭제")),
        ],
      ),
    );

    if (confirm == true) {
      DeleteBanner(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    String URL = "http://13.239.238.92:8080/api/banner/image/";
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.bannerModel.title,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                IconButton(
                  onPressed: () {
                    confirmDelete(widget.bannerModel.id);
                  },
                  icon: Icon(Icons.delete,
                      color: Theme.of(context).primaryColor), // 🗑️ 삭제 아이콘
                ),
              ],
            ),
            widget.bannerModel.fileName.isNotEmpty
                ? Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    clipBehavior: Clip.hardEdge, // 둥근 모서리를 Clip 효과로 적용
                    child: Image.network(
                      URL + widget.bannerModel.fileName,
                      fit: BoxFit.fill,
                    ),
                  )
                : SvgPicture.asset(
                    'assets/images/app.svg', // 기본 이미지
                    fit: BoxFit.cover,
                  ),
          ],
        ),
      ),
    );
  }
}
