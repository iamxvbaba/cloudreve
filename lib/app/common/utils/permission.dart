import 'package:permission_handler/permission_handler.dart';

void checkPermission() async {
  Permission permission = Permission.storage;
  PermissionStatus status = await permission.status;
  print('检测权限$status');
  if (status.isGranted) {
    //权限通过
  } else if (status.isDenied) {
    //权限拒绝， 需要区分IOS和Android，二者不一样
    requestPermission(permission);
  } else if (status.isPermanentlyDenied) {
    //权限永久拒绝，且不在提示，需要进入设置界面，IOS和Android不同
    openAppSettings();
  } else if (status.isRestricted) {
    //活动限制（例如，设置了家长///控件，仅在iOS以上受支持。
    openAppSettings();
  } else {
    //第一次申请
    requestPermission(permission);
  }
}

void requestPermission(Permission permission) async {
  //发起权限申请
  PermissionStatus status = await permission.request();
  // 返回权限申请的状态 status
  print('权限状态$status');
  if (status.isPermanentlyDenied) {
    openAppSettings();
  }
}