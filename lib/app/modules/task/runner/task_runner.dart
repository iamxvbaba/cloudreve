import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

enum ExecState {
  init,
  start,
  processing,
  error,
  success
}

class TaskItem {
    bool download=true;
    File? file; //  上传时使用
    Directory? savePath; // 下载时使用

    ExecState state = ExecState.init;
    String fileName='';
    String url='';
    int totalSize = 0;
    int handleSize=0;

    void Function(TaskItem it) updateNotify;

    TaskItem(this.download,this.fileName,this.url,this.totalSize,this.updateNotify);
}

class TaskRunner {
  final Queue<TaskItem> _input = Queue();
  final StreamController<TaskItem> streamController = StreamController();
  final Future<TaskItem> Function(TaskItem) task;

  final int maxConcurrentTasks;
  int runningTasks = 0;

  TaskRunner(this.task, {this.maxConcurrentTasks = 5});

  Stream<TaskItem> get stream => streamController.stream;

  void add(TaskItem value) {
    _input.add(value);
    _startExecution();
  }

  void addAll(Iterable<TaskItem> iterable) {
    _input.addAll(iterable);
    _startExecution();
  }

  void _startExecution() {
    if (runningTasks == maxConcurrentTasks || _input.isEmpty) {
      return;
    }

    while (_input.isNotEmpty && runningTasks < maxConcurrentTasks) {
      runningTasks++;
      print('Concurrent workers: $runningTasks');
      task(_input.removeFirst()).then((value) async {
        while (_input.isNotEmpty) {
          await task(_input.removeFirst());
        }
        runningTasks--;
      });
    }
  }
}