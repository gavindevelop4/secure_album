import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_album/screens/home_screen/pages/album_page.dart';
import 'package:secure_album/screens/home_screen/pages/setting_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;

  final List<Widget> pages = [
    AlbumPage(),
    SettingPage(),
  ];

  void _pageChange(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return pages[index];
          },
        );
      },
      tabBar: CupertinoTabBar(
        currentIndex: _pageIndex,
        onTap: _pageChange,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.photo),
            label: 'AlbumTitle'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.settings),
            label: 'SettingsTitle'.tr,
          ),
        ],
      ),
    );
  }
}
