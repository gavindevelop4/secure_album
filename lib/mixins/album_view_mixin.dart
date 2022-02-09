import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secure_album/components/new_album_dialog.dart';
import 'package:secure_album/controllers/role_controller.dart';
import 'package:secure_album/enums.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:photo_manager/photo_manager.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:secure_album/models/FileSystemItem.dart';
import 'package:secure_album/screens/gallery_screen/gallery_screen.dart';

mixin AlbumViewMixin<T extends StatefulWidget> on State<T> {
  List<FileSystemItem> list = [];
  late String path;

  AlbumMode mode = AlbumMode.view;

  Widget getFloatingActionButton() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppBar().preferredSize.height,
      ),
      child: AnimatedOpacity(
        opacity: mode == AlbumMode.view ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton(
          elevation: 0,
          child: const Icon(CupertinoIcons.add),
          onPressed: showAddActionSheet,
        ),
      ),
    );
  }

  void setPath(String newPath) async {
    final RoleController roleController = Get.put(RoleController());
    if (!roleController.roleFolderInitialized.value) {
      await roleController.initAllRoleFolder();
    }
    final String roleString = roleController.role.value.toShortString();
    if (newPath == '') {
      final _path = await localPath;
      setState(() {
        path = '$_path/$roleString/';
      });
    } else {
      setState(() {
        path = newPath;
      });
    }

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
      sortList();
    });
  }

  void sortList() {
    list.sort((a, b) {
      const Map<FileSystemEntityType, int> mapTypeValue = {
        FileSystemEntityType.file: 0,
        FileSystemEntityType.directory: 1,
      };
      int cmp = mapTypeValue[b.type]!.compareTo(mapTypeValue[a.type]!);
      if (cmp != 0) return cmp;
      return a.title.compareTo(b.title);
    });
    setState(() {});
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
        return NewAlbumDialog(
          getListCallback: getFileList,
          path: path,
        );
      },
    );
  }

  void addImportFromPhotos() async {
    // print('import from photos');
    Get.back();
    var result = await PhotoManager.requestPermissionExtend();
    if (result == PermissionState.authorized ||
        result == PermissionState.limited) {
      final result = await showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => GalleryScreen(),
      ) as Map;
      if (result['result'] == DialogReturnType.confirm) {
        final File imageFile = result['file'];
        final String fileName = imageFile.path.split('/').last;
        final File writingFile = File('$path/$fileName');
        await writingFile.writeAsBytes(await imageFile.readAsBytes());
        getFileList();
      }
    } else {
      // confirmBox(context, '请先开启相簿权限').then(
      //   (value) {
      //     if (value == ConfirmType.confirm) {
      //       PhotoManager.openSetting();
      //     }
      //     return '';
      //   },
      // );
    }
  }

  void addImportFromFiles() {
    print('import from Files');
    Get.back();
  }

  Future<void> deleteFile(FileSystemItem file) async {
    final result = await showCupertinoDialog(
      context: Get.context!,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('DeleteAlbum'.tr),
          content: Text(
            'ConfirmToDeleteAlbum'.tr + ' "${file.title}" ' + 'QuestionMark'.tr,
          ),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Cancel'.tr),
              onPressed: () {
                Get.back(result: 'cancel');
              },
            ),
            CupertinoDialogAction(
              child: Text('Confirm'.tr),
              onPressed: () {
                Get.back(result: 'confirm');
              },
            ),
          ],
        );
      },
    );
    if (result == 'confirm') {
      if (file.type == FileSystemEntityType.directory) {
        final Directory folder = Directory(file.path);
        await folder.delete(recursive: true);
      }
      if (file.type == FileSystemEntityType.file) {
        final File item = File(file.path);
        await item.delete();
      }
    }
  }
}
