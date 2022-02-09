import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secure_album/constants.dart';
import 'package:get/get.dart';

class NewAlbumDialog extends StatefulWidget {
  NewAlbumDialog({Key? key, required this.getListCallback, required this.path})
      : super(key: key);

  final Function getListCallback;
  final String path;

  @override
  State<NewAlbumDialog> createState() => _NewAlbumDialogState();
}

class _NewAlbumDialogState extends State<NewAlbumDialog> {
  TextEditingController newAlbumTitleController = TextEditingController();
  bool isError = false;

  @override
  Widget build(BuildContext context) {
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
          if (isError)
            Text(
              'AlbumNameRepeatWarning'.tr,
              style: const TextStyle(
                color: Colors.red,
              ),
            )
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
                  Directory('${widget.path}/$folderName/');
              if (await _appDocDirFolder.exists()) {
                setState(() {
                  isError = true;
                });
                return;
              }
              setState(() {
                isError = false;
              });
              final Directory _appDocDirNewFolder =
                  await _appDocDirFolder.create(recursive: true);
              widget.getListCallback();
              Get.back();
              newAlbumTitleController.clear();
            }
          },
        ),
      ],
    );
  }
}
