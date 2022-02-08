import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_album/constants.dart';
import 'package:secure_album/models/FileSystemItem.dart';
import 'package:path_provider/path_provider.dart';

class AlbumGrid extends StatefulWidget {
  const AlbumGrid({Key? key, required this.file}) : super(key: key);

  final FileSystemItem file;

  @override
  State<AlbumGrid> createState() => _AlbumGridState();
}

class _AlbumGridState extends State<AlbumGrid> {
  int totals = 0;

  void getFileData() async {
    if (widget.file.type == FileSystemEntityType.directory) {
      final Directory folder = Directory('${widget.file.path}/');
      List<FileSystemEntity> fileSystemEntityList = folder.listSync();
      setState(() {
        totals = fileSystemEntityList.length;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFileData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (Get.width - defaultPadding * 6) / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: (Get.width - defaultPadding * 7) / 2,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
              ),
              child: Builder(builder: (context) {
                if (widget.file.type == FileSystemEntityType.directory) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.folder_fill,
                        size: 60,
                      ),
                    ),
                  );
                }
                return const Image(
                  image: AssetImage(
                    'assets/testImages/test-image-1.jpeg',
                  ),
                  fit: BoxFit.cover,
                );
              })),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.file.title,
                  style: context.textTheme.bodyText1,
                ),
                if (widget.file.type == FileSystemEntityType.directory)
                  Text(
                    totals.toString(),
                    style: context.textTheme.bodyText2,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
