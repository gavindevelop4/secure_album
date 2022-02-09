import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_album/components/album_grid.dart';
import 'package:secure_album/constants.dart';
import 'package:secure_album/enums.dart';
import 'package:secure_album/mixins/album_view_mixin.dart';

class AlbumPage extends StatefulWidget {
  AlbumPage({Key? key}) : super(key: key);

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> with AlbumViewMixin {
  @override
  void initState() {
    super.initState();
    setPath('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: getFloatingActionButton(),
      body: NestedScrollView(
        // floatHeaderSlivers: true,
        controller: PrimaryScrollController.of(context),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              backgroundColor: Colors.white,
              largeTitle: Text('AlbumTitle'.tr),
              stretch: true,
              middle: const Text(''),
              trailing: mode == AlbumMode.view
                  ? CupertinoButton(
                      onPressed: () {
                        setState(() {
                          mode = AlbumMode.edit;
                        });
                      },
                      child: Text('Edit'.tr),
                      padding: const EdgeInsets.all(0.0),
                    )
                  : CupertinoButton(
                      onPressed: () {
                        setState(() {
                          mode = AlbumMode.view;
                        });
                      },
                      child: Text('Cancel'.tr),
                      padding: const EdgeInsets.all(0.0),
                    ),
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
                        return AlbumGrid(
                          file: file,
                          getListCallback: getFileList,
                          parentMode: mode,
                        );
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
