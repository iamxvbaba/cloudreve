import 'package:cloudreve/app/common/utils/responsive_utils.dart';
import 'package:cloudreve/app/modules/task/controllers/task_controller.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TaskController>(TaskController(),permanent: true);
    Get.put<ResponsiveUtils>(ResponsiveUtils(),permanent: true);
    Get.put<HomeController>(HomeController(),permanent: true);
  }
}
