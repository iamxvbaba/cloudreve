import 'package:cloudreve/app/api/http_client.dart';
import 'package:cloudreve/app/api/user.dart';
import 'package:cloudreve/app/routes/app_pages.dart';
import 'package:cloudreve/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {

  // email的控制器
  final TextEditingController urlController = TextEditingController();

  // email的控制器
  final TextEditingController emailController = TextEditingController();
  // 密码的控制器
  final TextEditingController passController = TextEditingController();

// 跳转注册界面
  signUp() {
    Get.snackbar('提示', '跳转注册界面');
  }
  // 忘记密码
  forgotPassword() {
    Get.snackbar('提示', '忘记密码');
  }
  // 执行登录操作
  signIn() async {
    if (urlController.value.text.isNotEmpty) {
      HttpUtil.init(urlController.value.text);
    } else {
      Get.snackbar('提示', '请填写服务器地址');
      return;
    }

    UserLoginEntity params = UserLoginEntity(
      email: emailController.value.text,
      password: passController.value.text,
    );
    var data = await UserAPI.login(
      params: params,
    );
    if (data['code'] != 0) {
      Get.snackbar('提示', data['msg']);
      return;
    }
    Global.isSignIn = true;
    Global.user = User.fromJson(data['data']);
    Get.snackbar('提示', '登录成功username:${Global.user.userName}');
    Get.offAllNamed(Routes.HOME);
  }
  @override
  void onInit() {
    super.onInit();
    urlController.text = 'http://139.198.181.140:5212';
    emailController.text = 'test@cloudreve.org';
    passController.text = '123456';
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    urlController.dispose();
    emailController.dispose();
    passController.dispose();
  }
}
