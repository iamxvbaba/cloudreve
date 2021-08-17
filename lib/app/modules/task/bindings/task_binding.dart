import 'package:get/get.dart';

import '../controllers/task_controller.dart';

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    // 在home页面就初始化
    // Get.lazyPut<TaskController>(
    //   () => TaskController(),
    // );
  }
}
