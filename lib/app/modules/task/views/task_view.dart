import 'package:cloudreve/app/common/utils/color_extension.dart';
import 'package:cloudreve/app/common/utils/file_size_helper.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../controllers/task_controller.dart';

class TaskView extends GetView<TaskController> {
  @override
  Widget build(BuildContext context) {
    double hp = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('TaskView'),
        centerTitle: true,
      ),
      body: GetBuilder(
        id: 'task_list',
        init: controller,
        builder: (c) => ListView.builder(
            itemCount: controller.tasks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(color: AppColor.greyAccentColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FocusedMenuHolder(
                      menuBoxDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
                      menuWidth: MediaQuery.of(context).size.width * 0.5,
                      menuItemExtent: 60,
                      onPressed: () {},
                      menuItems: [
                        FocusedMenuItem(
                          backgroundColor: Colors.redAccent,
                          title: Text(
                            'Delete',
                          ),
                          trailingIcon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            controller.removeTask(index);
                          },
                        ),
                      ],
                      child: ListTile(
                        key: Key(controller.tasks[index].fileName),
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          controller.tasks[index].fileName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: LinearPercentIndicator(
                                      padding: EdgeInsets.all(0),
                                      lineHeight: 5.0,
                                      percent:
                                      controller.tasks[index].handleSize /
                                          controller.tasks[index].totalSize,
                                      backgroundColor:
                                      AppColor.blueAccentColor.withAlpha(80),
                                      progressColor: ((controller.tasks[index].handleSize -
                                          controller.tasks[index].totalSize)==0)
                                          ? AppColor.greenAccentColor
                                          : Colors.blue,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text((controller.tasks[index].handleSize /
                                      controller.tasks[index].totalSize * 100).toStringAsFixed(2) +
                                      " %"),
                                ],
                              ),
                              SizedBox(
                                height: hp * 0.01,
                              ),
                              Row(
                                children: [
                                  Text(
                                    fileSize(controller.tasks[index].handleSize),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(' / '),
                                  Text(
                                    fileSize(controller.tasks[index].totalSize),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
