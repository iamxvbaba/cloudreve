
import 'package:cloudreve/app/common/utils/color_extension.dart';
import 'package:cloudreve/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showDirDialog(HomeController ctl) {
  Get.defaultDialog(
      title: '',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: ctl.dirController,
            keyboardType: TextInputType.text,
            maxLines: 1,
            decoration: InputDecoration(
                labelText: '目录名称',
                hintMaxLines: 1,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.greenAccentColor, width: 4.0))),
          ),
          SizedBox(
            height: 30.0,
          ),
          MaterialButton(
            onPressed: ctl.createDir,
            child: Text(
              '添加',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            color: Colors.redAccent,
          )
        ],
      ),
      radius: 10.0);
}
