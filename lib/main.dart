import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_album/lang.dart';
import 'package:secure_album/routes.dart';
import 'package:secure_album/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: CustomThemes.lightTheme,
      defaultTransition: Transition.cupertino,
      translations: Messages(), // your translations
      locale: Get.deviceLocale, // translations will be displayed in that locale
      fallbackLocale: const Locale('en'),
      getPages: routes,
    );
  }
}
