import 'package:flutter/material.dart';
import 'package:hey_amy/screen/recorder.dart';
import 'package:hey_amy/screen/transcripter.dart';

import '../model/pallete.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _PageData {
  final String title;
  final Widget page;

  _PageData({required this.title, required this.page});
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // 定义页面列表
  // final List<Widget> _pages = [
  //   Recorder(),
  //   Transcripter(),
  // ];
  List<_PageData> pages = [
    _PageData(title: 'Transcripter', page: Transcripter()),
    _PageData(title: 'Recorder', page: Recorder()),
    // Add more pages as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.whiteColor,
        title: const Text(
          "Hey Amy",
          // _appbarTitle.isEmpty ?
          // 'Hey Amy' : _appbarTitle ,
          style: Pallete.appTitleStyle,
        ),
        centerTitle: true,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        // actions: [
        //   // IconButton(
        //   //   icon: Icon(Icons.settings),
        //   //   onPressed: () {
        //   //     // 执行设置操作
        //   //     print('Settings button pressed');
        //   //   },
        //   // ),
        //
        // ],
        leading: PopupMenuButton<int>(
          icon: const Icon(Icons.menu, color: Pallete.mainFontColor),
          onSelected: (int index) {
            // 切换页面
            setState(() {
              //_appbarTitle = pageNames[index];
              _selectedIndex = index;
            });
          },
          itemBuilder: (BuildContext context) => _buildPopupMenuItems(),
        ),
      ),
      body: _buildPage(_selectedIndex),
    );
  }

  List<PopupMenuEntry<int>> _buildPopupMenuItems() {
    return pages.asMap().entries
        .map((entry) => PopupMenuItem<int>(
              value: entry.key,
              child: Text(entry.value.title),
            ))
        .toList();
  }

  Widget _buildPage(int index) {
    return pages[index].page;
  }
}
