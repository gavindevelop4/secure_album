import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:secure_album/components/album_grid.dart';
import 'package:secure_album/constants.dart';
import 'package:secure_album/enums.dart';

class AlbumPage extends StatefulWidget {
  AlbumPage({Key? key}) : super(key: key);

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  void addNewAlbum() {
    print('new album');
    Get.back();
  }

  void addImportFromPhotos() {
    print('import from photos');
  }

  void addImportFromFiles() {
    print('import from Files');
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
            child: const Text('cancel'),
          ),
        );
      },
    );
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
                      [
                        AlbumGrid(),
                        AlbumGrid(),
                        AlbumGrid(),
                        AlbumGrid(),
                        AlbumGrid(),
                        AlbumGrid(),
                        AlbumGrid(),
                        AlbumGrid(),
                        AlbumGrid(),
                        AlbumGrid(),
                      ],
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
