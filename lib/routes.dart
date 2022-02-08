import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_album/screens/home_screen.dart';

List<GetPage<dynamic>> routes = [
  GetPage(name: '/', page: () => HomeScreen()),
];
