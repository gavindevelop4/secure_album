import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_album/models/file_system_item.dart';

class ImagePreviewScreen extends StatefulWidget {
  ImagePreviewScreen({Key? key}) : super(key: key);

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  final FileSystemItem file = Get.arguments as FileSystemItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          file.title.length < 20
              ? file.title
              : file.title.replaceRange(
                  10,
                  file.title.length - 10,
                  '...',
                ),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Image.file(
            File(file.path),
          ),
        ),
      ),
    );
  }
}
