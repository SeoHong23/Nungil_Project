import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nungil/data/repository/Banner_repository.dart';
import 'package:nungil/models/admin/banner_model.dart';
import 'package:nungil/screens/admin/banner/banner_item_component.dart';
import 'package:nungil/theme/common_theme.dart';
import 'package:nungil/util/my_http.dart';

class BannerList extends StatefulWidget {
  @override
  _BannerListState createState() => _BannerListState();
}

class _BannerListState extends State<BannerList> {
  List<BannerModel> bannerList = [];
  bool isLoading = true;

  void _onBannerDeleted(String id) {
    setState(() {
      bannerList.removeWhere((banner) => banner.id == id);
    });
  }

  Future<void> fetchBanners() async {
    setState(() {
      isLoading = true;
    });

    try {
      final repository = BannerRepository();
      List<BannerModel> banners = await repository.fetchBannerList();

      setState(() {
        bannerList = banners;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching Banner: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBanners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("배너 목록"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("배너 목록", style: Theme.of(context).textTheme.displayLarge),
                SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: List.generate(
                  bannerList.length,
                  (index) => BannerItemComponent(
                      bannerModel: bannerList[index],
                      onDelete: _onBannerDeleted),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
