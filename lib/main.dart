import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Music Player",
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark(),
    ),
  );
}
