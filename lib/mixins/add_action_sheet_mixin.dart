import 'package:flutter/cupertino.dart';
import 'package:secure_album/constants.dart';
import 'package:secure_album/enums.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:secure_album/models/FileSystemItem.dart';

mixin AddActionSheetMixin<T extends StatefulWidget> on State<T> {
  TextEditingController newAlbumTitleController = TextEditingController();
  List<FileSystemItem> list = [];
  late String path;

  void setPath(newPath) async {
    final _path = await localPath;
    setState(() {
      path = '$_path/$newPath';
    });
    getFileList();
  }

  void getFileList() async {
    final Directory originFolder = Directory(path);
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

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
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
      context: Get.context!,
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

  void addNewAlbum() {
    Get.back();
    showCupertinoDialog(
      context: Get.context!,
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
}
