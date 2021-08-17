import 'package:cloudreve/app/routes/app_pages.dart';
import 'package:cloudreve/global.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

/// 检查是否登录
class RouteAuthMiddleware extends GetMiddleware {
  // priority 数字小优先级高
  @override
  int? priority = 0;

  RouteAuthMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    if (Global.isSignIn || route == Routes.LOGIN)  {
      return null;
    } else {
      Future.delayed(
          Duration(seconds: 1), () => Get.snackbar('提示', '登录过期,请重新登录'));
      return RouteSettings(name: Routes.LOGIN);
    }
  }
}