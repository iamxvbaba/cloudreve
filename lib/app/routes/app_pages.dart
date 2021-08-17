import 'package:get/get.dart';

import 'package:cloudreve/app/common/middlewares/router_auth.dart';
import 'package:cloudreve/app/modules/home/bindings/home_binding.dart';
import 'package:cloudreve/app/modules/home/views/home_view.dart';
import 'package:cloudreve/app/modules/login/bindings/login_binding.dart';
import 'package:cloudreve/app/modules/login/views/login_view.dart';
import 'package:cloudreve/app/modules/setting/bindings/setting_binding.dart';
import 'package:cloudreve/app/modules/setting/views/setting_view.dart';
import 'package:cloudreve/app/modules/task/bindings/task_binding.dart';
import 'package:cloudreve/app/modules/task/views/task_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      middlewares: [
        RouteAuthMiddleware(priority: 1),
      ],
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => SettingView(),
      binding: SettingBinding(),
      middlewares: [
        RouteAuthMiddleware(priority: 1),
      ],
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.TASK,
      page: () => TaskView(),
      binding: TaskBinding(),
    ),
  ];
}
