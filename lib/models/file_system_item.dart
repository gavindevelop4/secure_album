import 'dart:io';

import 'package:equatable/equatable.dart';

class FileSystemItem extends Equatable {
  final String title;
  final FileSystemEntityType type;
  final String path;

  const FileSystemItem({
    this.title = '',
    this.type = FileSystemEntityType.notFound,
    this.path = '',
  });

  int? get total {
    if (type == FileSystemEntityType.directory) {
      final Directory folder = Directory('$path/');
      List<FileSystemEntity> fileSystemEntityList = folder.listSync();
      return fileSystemEntityList.length;
    }
    return null;
  }

  String? get directoryPath {
    if (type == FileSystemEntityType.file) {
      final List<String> filePathSplit = path.split('/');
      filePathSplit.removeRange(filePathSplit.length - 1, filePathSplit.length);
      return filePathSplit.join('/');
    }
    return null;
  }

  @override
  List<Object> get props => [
        title,
        type,
        path,
      ];
}
