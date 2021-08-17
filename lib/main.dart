import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/common/utils/color_extension.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: 'cloudreve',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          unselectedWidgetColor: AppColor.unselectedElementColor
      ),
    ),
  );
}
