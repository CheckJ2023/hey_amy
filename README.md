# hey_amy

A new Flutter project of voice assistant.

## UI
### pages control

- create data structure that is PageData class to control 
  every pages.
```
import 'package:flutter/material.dart';
import 'recorder.dart';
import 'transcripter.dart';

void main() {
  runApp(MyApp());
}

class PageData {
  final String title;
  final Widget page;

  PageData({required this.title, required this.page});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<PageData> pages = [
    PageData(title: 'Recorder', page: RecorderPage()),
    PageData(title: 'Transcripter', page: TranscripterPage()),
    // Add more pages as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
        actions: [
          PopupMenuButton<int>(
            icon: Icon(Icons.menu),
            onSelected: (int index) {
              // 切换页面
              setState(() {
                _selectedIndex = index;
              });
            },
            itemBuilder: (BuildContext context) => _buildPopupMenuItems(),
          ),
        ],
      ),
      body: _buildPage(_selectedIndex),
    );
  }

  List<PopupMenuEntry<int>> _buildPopupMenuItems() {
    return pages
        .asMap()
        .entries
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
```