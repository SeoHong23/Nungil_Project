import 'package:flutter/material.dart';
import 'package:nungil/models/Video.dart';


class DetailCastListPage extends StatefulWidget {
  final Video item;
  const DetailCastListPage({required this.item, super.key});

  @override
  State<DetailCastListPage> createState() => _DetailCastListPageState();
}

class _DetailCastListPageState extends State<DetailCastListPage> {

  int _currentIndex = 0;
  final List<Widget> _tabs = [
    Center(child: Text('Tab 1 Content')),
    Center(child: Text('Tab 2 Content')),
    Center(child: Text('Tab 3 Content')),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_rounded),
          ),
          bottom: TabBar(
            onTap: (index){
              setState(() {
                _currentIndex = index;
              });
            },
            tabs: const[
              Tab(text: '출연진',),
              Tab(text: '제작진',),
            ],
          ),
        ),
        body: _tabs[_currentIndex],
      ),
    );
  }
}
