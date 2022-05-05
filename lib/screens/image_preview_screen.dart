import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_album/components/sliding_app_bar.dart';
import 'package:secure_album/components/sliding_bottom_bar.dart';
import 'package:secure_album/models/file_system_item.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewScreen extends StatefulWidget {
  ImagePreviewScreen({Key? key}) : super(key: key);

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen>
    with TickerProviderStateMixin {
  final FileSystemItem file = Get.arguments as FileSystemItem;

  String title = '';
  int total = 0;
  int currentImage = 0;
  List<FileSystemItem> fileList = [];

  bool _appbarVisible = true;
  late final AnimationController _appbarAnimationController;
  late final AnimationController _bottomBarAnimationController;

  late PageController _pageController;

  void getDirectoryList() {
    // print(file.path);
    final String fileDirectoryPath = file.directoryPath ?? '';
    final Directory originFolder = Directory(fileDirectoryPath);
    List<FileSystemEntity> fileSystemEntityList = originFolder.listSync();
    List<FileSystemEntity> filteredFileSystemEntityList =
        fileSystemEntityList.where((item) {
      FileSystemEntityType type = FileSystemEntity.typeSync(item.path);
      return type == FileSystemEntityType.file;
    }).toList();
    final List<FileSystemItem> list = filteredFileSystemEntityList
        .map((e) => FileSystemItem(
              title: e.path.split('/').last,
              type: FileSystemEntity.typeSync(e.path),
              path: e.path,
            ))
        .toList();
    // print(filteredFileSystemEntityList);
    final int currentItemIndex =
        list.indexWhere((element) => element.title == file.title);
    setState(() {
      fileList = list;
      total = list.length;
      currentImage = currentItemIndex;
      title = list[currentItemIndex].title;
    });
    // if (_pageController.hasClients) {
    _pageController = PageController(initialPage: currentItemIndex);
    // }
  }

  void _pageChange(int index) {
    setState(() {
      currentImage = index;
      title = fileList[index].title;
    });
  }

  @override
  void initState() {
    super.initState();
    getDirectoryList();
    _appbarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bottomBarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: SlidingAppBar(
        controller: _appbarAnimationController,
        visible: _appbarVisible,
        child: AppBar(
          elevation: 0,
          title: Text(
            title.length < 20
                ? title
                : title.replaceRange(
                    10,
                    title.length - 10,
                    '...',
                  ),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
        ),
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _pageChange,
                    itemCount: total,
                    itemBuilder: (context, index) {
                      final item = fileList[index];
                      return ImagePage(
                          file: item,
                          onTap: () {
                            setState(() {
                              _appbarVisible = !_appbarVisible;
                            });
                          });
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: SlidingBottomBar(
              visible: _appbarVisible,
              controller: _bottomBarAnimationController,
              child: Container(
                color: Colors.black,
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${currentImage + 1}/$total',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePage extends StatelessWidget {
  const ImagePage({
    Key? key,
    required this.file,
    this.onTap,
  }) : super(key: key);

  final FileSystemItem file;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        onVerticalDragUpdate: (DragUpdateDetails dragUpdateDetails) {
          if (dragUpdateDetails.delta.dy > 20) {
            Get.back();
          }
        },
        child: Center(
          child: PhotoView(
            imageProvider: AssetImage(file.path),
          ),
        ),
      ),
    );
  }
}
