import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nungil/data/repository/Banner_repository.dart';
import 'package:nungil/theme/common_theme.dart';
import 'package:nungil/util/my_http.dart';

class BannerInsert extends StatefulWidget {
  @override
  _BannerInsertState createState() => _BannerInsertState();
}

class _BannerInsertState extends State<BannerInsert> {
  final TextEditingController _nameController = TextEditingController();
  String type = "mainPage";
  File? _image;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImageToServer() async {
    final name = _nameController.text;
    if (name.isEmpty || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("이미지와 이름을 입력해주세요.")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final repository = BannerRepository();
      bool result = await repository.fetchBanner(_image, name, type);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("업로드 성공.")),
        );
      } else {
        throw Exception("업로드 실패");
      }
    } catch (e) {
      print("  이미지 업로드 오류: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("업로드 중 오류 발생.")),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _saveBanner() {
    final name = _nameController.text;
    if (name.isEmpty || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("이미지와 이름을 입력해주세요.")),
      );
      return;
    }
    // 저장 로직 (예: 서버 업로드, 로컬 저장 등)

    Navigator.pop(context);
  }

  void onSortChanged(String? newType) {
    if (newType != null) {
      setState(
        () {
          type = newType;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("배너 추가"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("배너 이름", style: Theme.of(context).textTheme.displayLarge),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "배너 이름을 입력하세요",
                    hintStyle: CustomTextStyle.mediumLightNavy,
                  ),
                ),
                Row(
                  children: [
                    Text("배너타입",
                        style: Theme.of(context).textTheme.displayLarge),
                    SizedBox(width: 8),
                    DropdownButton<String>(
                      value: type,
                      items: [
                        DropdownMenuItem(
                          value: "mainPage",
                          child: Text("메인페이지"),
                        ),
                        DropdownMenuItem(
                          value: "detailPage",
                          child: Text("상세페이지"),
                        ),
                      ],
                      onChanged: onSortChanged, //   정렬 변경 시 실행
                    ),
                  ],
                ),
                SizedBox(height: 20),
                type == "mainPage"
                    ? Text("배너 이미지 (세로 100px)",
                        style: Theme.of(context).textTheme.displayLarge)
                    : Text("배너 이미지 (세로 40px)",
                        style: Theme.of(context).textTheme.displayLarge),
                SizedBox(height: 10),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: _image != null
                        ? Image.file(
                            _image!,
                            height: type == "mainPage" ? 100 : 40,
                            fit: BoxFit.fill,
                          )
                        : Container(
                            height: type == "mainPage" ? 100 : 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.image,
                                size: type == "mainPage" ? 50 : 30,
                                color: Colors.grey),
                          ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _uploadImageToServer,
                    child: Text("저장"),
                  ),
                ),
                Divider(
                  color: DefaultColors.lightNavy,
                ),
                Text("미리보기", style: Theme.of(context).textTheme.displayLarge),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    type == "mainPage"
                        ? "assets/images/banner/banner_template/bannerTop.png"
                        : "assets/images/banner/banner_template/bannerTopD.png",
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  _image != null
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: type == "mainPage" ? 100 : 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10), // 둥근 모서리
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.file(
                              _image!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: type == "mainPage" ? 100 : 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.image,
                                size: type == "mainPage" ? 50 : 30,
                                color: Colors.grey),
                          ),
                        ),
                  Image.asset(
                    type == "mainPage"
                        ? "assets/images/banner/banner_template/bannerBottom.png"
                        : "assets/images/banner/banner_template/bannerBottomD.png",
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
