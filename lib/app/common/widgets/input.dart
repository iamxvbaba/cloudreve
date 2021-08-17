import 'package:cloudreve/app/common/consts/radii.dart';
import 'package:flutter/material.dart';

/// 输入框
Widget inputTextEdit({
  TextEditingController? controller,
  TextInputType keyboardType = TextInputType.text,
  String? hintText,
  bool isPassword = false,
  double marginTop = 15,
  bool autofocus = false,
}) {
  return Container(
    height: 44,
    margin: EdgeInsets.only(top: marginTop),
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 246, 246, 246),
      borderRadius: Radii.k6pxRadius,
    ),
    child: TextField(
      autofocus: autofocus,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 8),
        border: InputBorder.none,
      ),
      style: TextStyle(
        color: Color.fromARGB(255, 45, 45, 47),
        fontWeight: FontWeight.w400,
        fontSize: 18,
      ),
      maxLines: 1,
      autocorrect: false, // 自动纠正
      obscureText: isPassword, // 隐藏输入内容, 密码框
    ),
  );
}

/// email 输入框
/// 背景白色，文字黑色，带阴影
Widget inputEmailEdit({
  TextEditingController? controller,
  TextInputType keyboardType = TextInputType.text,
  String? hintText,
  bool isPassword = false,
  double marginTop = 15,
  bool autofocus = false,
}) {
  return Container(
    height: 44,
    margin: EdgeInsets.only(top: marginTop),
    decoration: BoxDecoration(
      color:  Color.fromARGB(255, 255, 255, 255),
      borderRadius: Radii.k6pxRadius,
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(41, 0, 0, 0),
          offset: Offset(0, 1),
          blurRadius: 0,
        ),
      ],
    ),
    child: TextField(
      autofocus: autofocus,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.fromLTRB(20, 10, 0, 9),
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Color.fromARGB(255, 45, 45, 47),
        ),
      ),
      style: TextStyle(
        color: Color.fromARGB(255, 45, 45, 47),
        fontWeight: FontWeight.w400,
        fontSize: 18,
      ),
      maxLines: 1,
      autocorrect: false, // 自动纠正
      obscureText: isPassword, // 隐藏输入内容, 密码框
    ),
  );
}