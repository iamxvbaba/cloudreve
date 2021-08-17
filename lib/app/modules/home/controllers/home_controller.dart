import 'package:cloudreve/app/api/file_item.dart';
import 'package:cloudreve/app/api/http_client.dart';
import 'package:cloudreve/app/common/utils/file_type.dart';
import 'package:cloudreve/app/common/utils/permission.dart';
import 'package:cloudreve/app/modules/home/views/widgets/audio_player.dart';
import 'package:cloudreve/app/modules/home/views/widgets/photo_show_view.dart';
import 'package:cloudreve/app/modules/home/views/widgets/video_player.dart';
import 'package:cloudreve/app/modules/task/controllers/task_controller.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart' hide FileType;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

class HomeController extends GetxController with StateMixin {
  var title = 'Cloudreve';

  var currentDir = ''; // 当前目录

  int pageIndex = 0;

  bool showBack = false;

  double containerHeight = 25;
  late ScrollController scrollController;
  TaskController _taskController = Get.find<TaskController>();

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  // email的控制器
  final TextEditingController dirController = TextEditingController();

  FileItem fileItem = FileItem();

  var sizeList = <String>["B", "KB", "MB", "GB"];
  Future<String> downloadUrl(String id) async {
    var resp = await HttpUtil.PUT('/api/v3/file/download/$id');
    if (resp['code'] != 0) {
      Get.snackbar('提示', '获取资源链接失败');
      return '';
    }
    return resp['data'].toString();
  }

  // 删除文件
  Future<void> delete(FileType ft, FileData file) async {
    var payload;
    if (ft == FileType.dir) {
      payload = {
        'items': [],
        'dirs': [file.id],
      };
    } else {
      payload = {
        'items': [file.id],
        'dirs': [],
      };
    }
    var resp = await HttpUtil.DELETE('/api/v3/object', payload: payload);
    if (resp['code'] == 0) {
      reload();
    } else {
      Get.snackbar('删除失败', resp['msg']);
    }
  }

  // 分享
  Future<void> share(FileType ft, FileData file) async {
    var resp = await HttpUtil.POST('/api/v3/share', payload: {
      'id': file.id,
      'is_dir': ft == FileType.dir,
      'password': '',
      'downloads': -1,
      'expire': 86400,
      'preview': true
    });
    if (resp['code'] != 0) {
      Get.snackbar('创建分享失败', resp['msg']);
      return;
    }
    print('分享链接地址${resp['data']}');
    Clipboard.setData(ClipboardData(text: resp['data']));
    Get.snackbar('创建成功', '分享地址已复制到剪切板',icon: Icon(Icons.share),duration: Duration(seconds: 3));
  }

  // 创建目录
  void createDir() async {
    if (!dirController.text.isNotEmpty) {
      Get.snackbar('提醒', '请输入目录名称');
      return;
    }
    var resp = await HttpUtil.PUT('/api/v3/directory',
        payload: {'path': '$currentDir/${dirController.text}'});
    if (resp['code'] != 0) {
      Get.snackbar('提示', '创建目录失败');
      return;
    }
    dirController.text = '';
    Get.back();
    reload();
    Get.snackbar('成功', '${dirController.text} 创建成功');
  }

  /// 读取图片内容
  Future<Widget> getImage(FileData file) async {
    Map<String, String> data = await HttpUtil.previewUrl(file.id);
    Widget pv = ExtendedImageSlidePage(
      child: ExtendedImage.network(
        data['url']!,
        headers: {'Cookie': data['Cookie']!},
        fit: BoxFit.contain,
        cache: true,
        enableSlideOutPage: true, // 滑动退出页面
        //cancelToken: cancellationToken,
      ),
      slideAxis: SlideAxis.both,
      slideType: SlideType.onlyImage,
      onSlidingPage: (state) {},
    );
    return pv;
  }

  Future<Map<String, dynamic>> upload() async {
    var result = await FilePicker.platform.pickFiles(withReadStream: true);
    if (result != null) {
      var file = result.files.first;
      print('currentDir:$currentDir');
      return HttpUtil.Upload(file, currentDir, file.name);
    } else {
      return {'code': 808, 'msg': '没有选择上传的文件'};
    }
  }

  // 添加到下载
  addDownloadTask(FileData item) async {
    checkPermission();
    _taskController.addDownload(item);
  }

  // 刷新页面
  reload() async {
    _loadFile(dir: currentDir);
  }

  // 页面后退按钮
  back() async {
    if (!showBack) {
      Get.snackbar('提示', '当前目录不可再返回');
      return;
    }
    var index = currentDir.lastIndexOf('/');
    var backDIr = currentDir.substring(0, index);
    bool ifF = false;
    // 返回根目录
    if (!backDIr.isNotEmpty) {
      ifF = true;
      backDIr = '/';
    }
    print('index:$index 当前目录:$currentDir 要返回的目录:$backDIr');
    if (await _loadFile(dir: backDIr)) {
      if (ifF) {
        showBack = false;
        update(['back']);
      }
    }
  }

  // 每项事件
  itemClick(FileData item, FileType ft) async {
    if (ft != FileType.dir) {
      if (ft == FileType.image) {
        Get.to(PhotoShowView(item));
        return;
      } else if (ft == FileType.music) {
        Map<String, String> data = await HttpUtil.previewUrl(item.id);
        Get.to(AudioPlayerWidget(data['url']!, item.name, data['Cookie']!));
        return;
      } else if (ft == FileType.video) {
        Map<String, String> data = await HttpUtil.previewUrl(item.id);
        Get.to(VideoPlayer(data['url']!, item.name, data['Cookie']!));
        return;
      } else {
        Get.snackbar('提示', '当前文件类型暂不支持预览');
        return;
      }
    }
    String path = '';
    if (item.path == '/') {
      path = item.path + item.name;
    } else {
      path = '${item.path}/${item.name}';
    }
    print('打开下一层目录:$path');
    // 保留上个目录的数据

    if (!await _loadFile(dir: path)) {
      return;
    }
    // 显示返回icon
    if (!showBack) {
      showBack = true;
      update(['back']);
    }
  }

  // 请求目录
  Future<bool> _loadFile({String dir = '/'}) async {
    var respData = await HttpUtil.GET('/api/v3/directory$dir');
    if (respData['code'] != 0) {
      Get.snackbar('提示', respData['msg']);
      return false;
    }
    try {
      fileItem = FileItem.fromJson(respData['data']);
    } catch (e, stack) {
      print('error:$e stack:$stack');
      Get.snackbar('提示', '解析结果失败');
      return false;
    }
    currentDir = dir;
    update(['list', 'dir']);
    return true;
  }

  void pageChanged(int index) {
    pageIndex = index;
    update(['page_body']);
  }

  void bottomTapped(int index) {
    pageIndex = index;
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
    update(['page_body']);
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    scrollController = ScrollController()
      ..addListener(() {
        // 只要大于一个组件的高度 就吸顶
        if (scrollController.offset > containerHeight) {
          if (title == 'Cloudreve') {
            title = currentDir;
            update(['title']);
          }
        } else {
          if (title != 'Cloudreve') {
            title = 'Cloudreve';
            update(['title']);
          }
        }
      });
  }

  @override
  void onReady() {
    super.onReady();
    _loadFile();
  }

  @override
  void onClose() {
    dirController.dispose();
    scrollController.dispose();
    pageController.dispose();
  }
}
