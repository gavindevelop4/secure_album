import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_album/constants.dart';
import 'package:secure_album/enums.dart';
import 'package:secure_album/mixins/album_view_mixin.dart';
import 'package:secure_album/models/file_system_item.dart';
import 'package:path_provider/path_provider.dart';

class AlbumGrid extends StatefulWidget {
  const AlbumGrid({
    Key? key,
    required this.file,
    required this.getListCallback,
    required this.parentMode,
    required this.setModeCallback,
    required this.refreshCallback,
  }) : super(key: key);

  final FileSystemItem file;
  final Function getListCallback;
  final Function setModeCallback;
  final AlbumMode parentMode;
  final Function refreshCallback;

  @override
  State<AlbumGrid> createState() => _AlbumGridState();
}

class _AlbumGridState extends State<AlbumGrid> with AlbumViewMixin {
  void handleLongPressGrid() {
    print('long press ${widget.file.title}');
    widget.setModeCallback();
  }

  void handleTapGrid() async {
    if (widget.file.type == FileSystemEntityType.directory) {
      final _path = await localPath;
      final String trimPath = widget.file.path.split(_path)[1];
      Get.toNamed('/albumDetail?filePath=$trimPath', arguments: widget.file)
          ?.then((value) {
        widget.refreshCallback();
      });
    } else {
      Get.toNamed('/image_preview', arguments: widget.file)?.then((value) {
        widget.refreshCallback();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleTapGrid,
      onLongPress: handleLongPressGrid,
      child: SizedBox(
        width: (Get.width - defaultPadding * 6) / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: (Get.width - defaultPadding * 7) / 2,
                  width: (Get.width - defaultPadding * 7) / 2,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                  ),
                  child: Builder(
                    builder: (context) {
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
                      return Image.file(
                        File(widget.file.path),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                // if (widget.parentMode == AlbumMode.edit)
                Positioned(
                  top: -7.5,
                  right: -7.5,
                  child: AnimatedOpacity(
                    opacity: widget.parentMode == AlbumMode.edit ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      onTap: () async {
                        await deleteFile(widget.file);
                        widget.getListCallback();
                      },
                      child: const Icon(
                        CupertinoIcons.minus_circle_fill,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding / 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.file.title.length < 20
                        ? widget.file.title
                        : widget.file.title.replaceRange(
                            10,
                            widget.file.title.length - 10,
                            '...',
                          ),
                    style: context.textTheme.bodyText1,
                  ),
                  if (widget.file.type == FileSystemEntityType.directory)
                    Text(
                      widget.file.total.toString(),
                      style: context.textTheme.bodyText2,
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
