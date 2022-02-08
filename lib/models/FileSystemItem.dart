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

  @override
  List<Object> get props => [
        title,
        type,
        path,
      ];
}
