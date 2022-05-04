import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_album/screens/album_detail_screen/album_detail_screen.dart';
import 'package:secure_album/screens/gallery_screen/gallery_screen.dart';
import 'package:secure_album/screens/home_screen/home_screen.dart';
import 'package:secure_album/screens/image_preview_screen.dart';

List<GetPage<dynamic>> routes = [
  GetPage(name: '/', page: () => HomeScreen()),
  GetPage(name: '/albumDetail', page: () => AlbumDetailScreen()),
  GetPage(name: '/gallery', page: () => GalleryScreen()),
  GetPage(name: '/image_preview', page: () => ImagePreviewScreen()),
];
