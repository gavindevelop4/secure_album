import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:secure_album/components/album_grid.dart';
import 'package:secure_album/constants.dart';
import 'package:secure_album/enums.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:secure_album/models/FileSystemItem.dart';

class AlbumPage extends StatefulWidget {
  AlbumPage({Key? key}) : super(key: key);

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  TextEditingController newAlbumTitleController = TextEditingController();
  List<FileSystemItem> list = [];

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void getFileList() async {
    final path = await _localPath;
    final Directory originFolder = Directory('$path/');
    List<FileSystemEntity> fileSystemEntityList = originFolder.listSync();
    List<FileSystemItem> fileList = [];

    for (var item in fileSystemEntityList) {
      FileSystemEntityType type = await FileSystemEntity.type(item.path);
      String fileTitle = item.path.split('/').last;
      fileList.add(
        FileSystemItem(title: fileTitle, type: type, path: item.path),
      );
    }
    setState(() {
      list = fileList;
    });
  }

  void addNewAlbum() {
    Get.back();
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('NewAlbumTitleText'.tr),
          content: Column(
            children: [
              Text('NewAlbumTitleDescription'.tr),
              const SizedBox(
                height: defaultPadding * 2,
              ),
              CupertinoTextField(
                controller: newAlbumTitleController,
                placeholder: 'TitleText'.tr,
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Cancel'.tr),
              onPressed: () {
                Get.back();
                newAlbumTitleController.clear();
              },
            ),
            CupertinoDialogAction(
              child: Text('Confirm'.tr),
              onPressed: () async {
                final String folderName = newAlbumTitleController.text;
                if (folderName != '') {
                  final path = await _localPath;
                  final Directory _appDocDirFolder =
                      Directory('$path/$folderName/');
                  if (await _appDocDirFolder.exists()) {
                    print('directory already exist');
                    return;
                  }
                  final Directory _appDocDirNewFolder =
                      await _appDocDirFolder.create(recursive: true);
                  getFileList();
                  Get.back();
                  newAlbumTitleController.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void addImportFromPhotos() {
    print('import from photos');
    Get.back();
  }

  void addImportFromFiles() {
    print('import from Files');
    Get.back();
  }

  void showAddActionSheet() {
    List<CupertinoActionSheetAction> getAlbumAddAction() {
      List<CupertinoActionSheetAction> list = [];

      Map<AlbumAddActionType, void Function()> actionMap = {
        AlbumAddActionType.newAlbum: addNewAlbum,
        AlbumAddActionType.importFromPhotos: addImportFromPhotos,
        AlbumAddActionType.importFromFiles: addImportFromFiles
      };

      for (var value in AlbumAddActionType.values) {
        list.add(
          CupertinoActionSheetAction(
            onPressed: actionMap[value] ?? () {},
            child: Text(
              value.toString().tr,
            ),
          ),
        );
      }

      return list;
    }

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: getAlbumAddAction(),
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Get.back();
            },
            child: Text('Cancel'.tr),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getFileList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: AppBar().preferredSize.height,
        ),
        child: FloatingActionButton(
          elevation: 0,
          child: const Icon(CupertinoIcons.add),
          onPressed: showAddActionSheet,
        ),
      ),
      body: NestedScrollView(
        // floatHeaderSlivers: true,
        controller: PrimaryScrollController.of(context),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              backgroundColor: Colors.white,
              largeTitle: Text('AlbumTitle'.tr),
              stretch: true,
            ),
          ];
        },
        body: Builder(builder: (context) {
          return CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverSafeArea(
                top: false,
                sliver: SliverPadding(
                  padding: const EdgeInsets.only(
                    top: defaultPadding * 2,
                    left: defaultPadding * 2,
                    right: defaultPadding * 2,
                  ),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: defaultPadding,
                      crossAxisSpacing: defaultPadding * 2,
                      childAspectRatio: (Get.width - defaultPadding * 6) /
                          2 /
                          ((Get.width - defaultPadding * 6) / 2 + 40),
                    ),
                    delegate: SliverChildListDelegate(
                      list.map((file) {
                        return AlbumGrid(file: file);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
