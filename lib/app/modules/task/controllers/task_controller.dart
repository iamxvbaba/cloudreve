import 'dart:io';

import 'package:cloudreve/app/api/file_item.dart';
import 'package:cloudreve/app/api/http_client.dart';
import 'package:cloudreve/app/common/utils/permission.dart';
import 'package:cloudreve/app/modules/task/runner/task_runner.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';


Future<TaskItem> _download(TaskItem x) async{
   x.state = ExecState.processing;
   Uri uri = Uri.parse(x.url);
   HttpClientRequest request = await  HttpUtil.httpClient.getUrl(uri);
   request.cookies.addAll(await HttpUtil.cookieJar.loadForRequest(uri));

   // 获取返回数据
   HttpClientResponse response = await request.close();

   String filePath = '${x.savePath!.path}/${x.fileName}';

   print('下载的文件地址:$filePath');

   final file = File(filePath);
   final wr = file.openWrite(mode:  FileMode.write);

   try {
     x.totalSize == 0? response.contentLength : x.totalSize;
     response.listen((value) {
       wr.add(value);
       x.handleSize += value.length;
       x.updateNotify(x);
     }).onDone(() {
       wr.close();
       x.state = ExecState.success;
       x.updateNotify(x);
     });
   } catch (e, t) {
     wr.close();
     x.state = ExecState.error;
     x.updateNotify(x);
     return x;
   }
   return x;
}


class TaskController extends GetxController {
  final _downloadTask = TaskRunner(_download,maxConcurrentTasks: 3);
  final List<TaskItem> tasks = List<TaskItem>.empty(growable: true);

  void removeTask(index) {
    tasks.remove(tasks[index]);
    update(['task_list']); // 通知更新页面
  }

  void addDownload(FileData item)async{
    checkPermission();
    String getDownloadUrl = '/api/v3/file/download/${item.id}';
    var resp = await HttpUtil.PUT(getDownloadUrl);
    String path = resp['data'].toString();
    var storePath;
    if (Platform.isIOS) {
      storePath = await getApplicationSupportDirectory();
    } else if (Platform.isAndroid) {
      storePath = await getExternalStorageDirectory();
      print('安卓下载 file_name:$item.name');
    } else {
      Get.snackbar('提示', '下载暂不支持此系统');
      return;
    }
    final it = TaskItem(true,item.name, path, item.size,(t){
      print('--------下载进度--------${t.handleSize}/${t.totalSize}');
      if (t.state == ExecState.error || t.state == ExecState.success) {
        _downloadTask.streamController.add(t);
      }
      update(['task_list']); // 通知更新页面
    });
    it.savePath = storePath;
    _downloadTask.add(it);
    tasks.add(it);
    Get.snackbar('提示', '添加下载任务成功');
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _downloadTask.stream.listen((task) {
      Get.snackbar('下载完成', '${task.fileName}',duration: Duration(seconds: 4));
    });
  }

  @override
  void onClose() {}
}
