// Dart imports:
import 'dart:io';
import 'dart:math' as Math;
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Package imports:
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:photo_manager/photo_manager.dart';
import 'package:secure_album/constants.dart';
import 'package:secure_album/enums.dart';

class GalleryScreen extends StatefulWidget {
  GalleryScreen({Key? key}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> photoList = [];

  void getList() async {
    List<AssetPathEntity> list = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );
    AssetPathEntity data = list[0];
    List<AssetEntity> imageList = await data.assetList;
    setState(() {
      photoList = imageList;
    });
  }

  Future<List<Uint8List?>> getByte(List<AssetEntity> entityList) async {
    return await Future.wait(entityList.map((e) async {
      return await e.thumbData;
    }).toList());
  }

  void selectPhoto(AssetEntity entity) async {
    // EasyLoading.instance
    //   ..maskType = EasyLoadingMaskType.black
    //   ..userInteractions = false;
    // EasyLoading.show(status: '加载中');
    final File? file = await entity.file;
    // final File compressedFile = await compressFile(file!);
    // EasyLoading.dismiss();
    // Navigator.pop(context, {
    //   'type': ConfirmType.confirm,
    //   'file': compressedFile,
    // });
    Navigator.pop(context, {
      'file': file,
      'result': DialogReturnType.confirm,
    });
  }

  // Future<File> compressFile(File file) async {
  //   int rand = new Math.Random().nextInt(1000000000);
  //   final dir = await path_provider.getTemporaryDirectory();
  //   final targetPath = dir.absolute.path + "/temp_$rand.jpg";
  //   var result = await FlutterImageCompress.compressAndGetFile(
  //     file.absolute.path,
  //     targetPath,
  //     quality: 50,
  //     minWidth: 500,
  //     minHeight: 500,
  //   );
  //   return result!;
  // }

  void changeNotify(method) {
    getList();
    setState(() {});
  }

  void listenToPhotoManager() {
    PhotoManager.addChangeCallback(changeNotify);
    PhotoManager.startChangeNotify();
  }

  void disposeListener() {
    PhotoManager.removeChangeCallback(changeNotify);
    PhotoManager.stopChangeNotify();
  }

  @override
  void initState() {
    super.initState();
    getList();
    listenToPhotoManager();
  }

  @override
  void dispose() {
    disposeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, {
          'result': DialogReturnType.cancel,
        });
        return false;
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('ChoosePhoto'.tr),
        ),
        child: FutureBuilder<List<Uint8List?>>(
          future: getByte(photoList),
          builder:
              (BuildContext context, AsyncSnapshot<List<Uint8List?>> snapshot) {
            if (snapshot.hasData) {
              List<Uint8List?> gridList = snapshot.data ?? [];
              return RefreshIndicator(
                onRefresh: () async {
                  getList();
                  setState(() {}); // force rebuild
                },
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: gridList.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (gridList[index] != null) {
                        return GestureDetector(
                          onTap: () {
                            selectPhoto(photoList[index]);
                          },
                          child: Image.memory(
                            gridList[index]!,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      return Container(
                        child: Text('no picture'),
                      );
                    }),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              child: Text('no picture'),
            );
          },
        ),
      ),
    );
  }
}

class ImageGrid extends StatefulWidget {
  const ImageGrid({Key? key, required this.entity}) : super(key: key);

  final AssetEntity entity;

  @override
  _ImageGridState createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  late Uint8List? bytes;

  void getByte() async {
    final Uint8List? imageBytes = await widget.entity.thumbData;
    setState(() {
      bytes = imageBytes;
    });
  }

  @override
  void initState() {
    super.initState();
    getByte();
  }

  @override
  Widget build(BuildContext context) {
    return bytes != null
        ? Image.memory(
            bytes!,
          )
        : Container(
            child: Text('no picture'),
          );
  }
}
