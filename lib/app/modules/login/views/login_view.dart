import 'package:cloudreve/app/common/utils/color_extension.dart';
import 'package:cloudreve/app/common/widgets/button.dart';
import 'package:cloudreve/app/common/widgets/input.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {

  Widget _logo() {
    return CircleAvatar(
        radius: 80, backgroundImage: AssetImage('assets/images/logo.png'));
  }

  // 登录表单
  Widget _buildInputForm() {
    return Container(
      width: 294,
      // height: 204,
      margin: EdgeInsets.only(top: 49),
      child: Column(
        children: [
          // server addr
          inputTextEdit(
            controller: controller.urlController,
            keyboardType: TextInputType.url,
            hintText: '服务器地址',
            marginTop: 0,
            // autofocus: true,
          ),
          // email input
          inputTextEdit(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'username',
            // autofocus: true,
          ),
          // password input
          inputTextEdit(
            controller: controller.passController,
            keyboardType: TextInputType.visiblePassword,
            hintText: 'password',
            isPassword: true,
          ),
          // 注册、登录 横向布局
          Container(
            height: 44,
            margin: EdgeInsets.only(top: 15),
            child: Row(
              children: [
                // 注册
                btnFlatButtonWidget(
                  onPressed: controller.signUp,
                  gbColor: Color.fromARGB(255, 45, 45, 47),
                  title: 'Sign up',
                ),
                Spacer(),
                // 登录
                btnFlatButtonWidget(
                  onPressed: controller.signIn,
                  gbColor: Colors.blue,
                  title: 'Sign in',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.blueAccentColor,AppColor.greyAccentColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _logo(),
              _buildInputForm(),
            ],
          ),
        ),
      ),
    );
  }
}
