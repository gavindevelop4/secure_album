import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_album/components/album_grid.dart';
import 'package:secure_album/constants.dart';
import 'package:secure_album/mixins/album_view_mixin.dart';
import 'package:secure_album/models/FileSystemItem.dart';

class AlbumDetailScreen extends StatefulWidget {
  AlbumDetailScreen({Key? key}) : super(key: key);

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen>
    with AlbumViewMixin {
  final FileSystemItem file = Get.arguments as FileSystemItem;

  @override
  void initState() {
    super.initState();
    setPath(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: getFloatingActionButton(),
      body: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(file.title),
        ),
        child: CustomScrollView(
          // physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverSafeArea(
              bottom: false,
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
        ),
      ),
    );
  }
}
