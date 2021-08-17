import 'package:cloudreve/app/api/file_item.dart';
import 'package:cloudreve/app/common/utils/color_extension.dart';
import 'package:cloudreve/app/common/utils/file_type.dart';
import 'package:cloudreve/app/common/utils/responsive_utils.dart';
import 'package:cloudreve/app/common/utils/responsive_widget.dart';
import 'package:cloudreve/app/modules/home/views/widgets/dialog.dart';
import 'package:cloudreve/app/modules/setting/views/setting_view.dart';
import 'package:cloudreve/app/modules/task/views/task_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final _responsiveUtils = Get.find<ResponsiveUtils>();

  Widget _appBar() {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      elevation: 0,
      // backgroundColor: Colors.white,
      expandedHeight: 50,
      //
      leading: GetBuilder(
        id: 'back',
        init: controller,
        builder: (c) => controller.showBack
            ? InkWell(
                onTap: controller.back,
                child: Icon(Icons.arrow_back),
              )
            : Container(),
      ),
      title: GetBuilder(
        id: 'title',
        init: controller,
        builder: (c) => Text(
          controller.title,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      centerTitle: true,
      actions: <Widget>[
        PopupMenuButton(
          itemBuilder: (ctx) {
            return [
              PopupMenuItem(
                child:  Text('添加文件'),
                value: FileType.file,
              ),
              PopupMenuItem(
                child: Text('创建目录'),
                value:FileType.dir,
              ),
            ];
          },
          onSelected: (FileType ft) async {
            if (ft == FileType.file) {
              var result = await controller.upload();
              if (result['code'] != 0) {
                Get.snackbar('上传文件失败', result['msg']);
              } else {
                Get.snackbar('上传成功', result['msg']);
                controller.reload();
              }
            } else {
              showDirDialog(controller);
            }
          },
          onCanceled: () {
            print("canceled");
          },
          color: AppColor.greyAccentColor.withAlpha(210),
          icon: Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
      onStretchTrigger: () async {
        return;
      },
      stretch: true, //是否可拉伸伸展
      stretchTriggerOffset: 10, //触发拉伸偏移量
    );
  }

  Widget _folderList() {
    return GetBuilder(
        id: 'list',
        init: controller,
        builder: (c) => SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) {
                //return _card(index);
                return _buildItem(context, index);
              },
              childCount: controller.fileItem.objects.length,
            )));
  }

  Widget _buildDocumentName(String documentName) {
    return Text(
      documentName,
      maxLines: 1,
      style: TextStyle(fontSize: 14, color: AppColor.documentNameItemTextColor),
    );
  }

  Widget _buildOfflineModeIcon() {
    return SizedBox.shrink();
  }

  Widget _buildModifiedDocumentText(String modificationDate) {
    return Text(
      modificationDate,
      style: TextStyle(fontSize: 13, color: AppColor.documentModifiedDateItemTextColor),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    FileData item = controller.fileItem.objects[index];
    FileType ft = getFileType(item);
    String img = getFileSvg(ft);
    String date = item.date.substring(0, 10) + " " + item.date.substring(11, 11 + 8);

    return Slidable(
      key: Key(index.toString()),
      //controller: controller.slidableController,
      actionPane: SlidableScrollActionPane(), // 侧滑菜单出现方式 SlidableScrollActionPane SlidableDrawerActionPane SlidableStrechActionPane
      actionExtentRatio: 0.18, // 侧滑按钮所占的宽度
      enabled: true, // 是
      actions: <Widget>[
        if (ft != FileType.dir)
          Padding(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: IconSlideAction(
              caption: '下载',
              color: Colors.blue,
              icon: Icons.file_download,
              onTap: () {
                controller.addDownloadTask(item);
              },
              closeOnTap: true,
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: IconSlideAction(
            caption: '分享',
            color: Colors.indigo,
            icon: Icons.share,
            onTap: () {
              controller.share(ft, item);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: IconSlideAction(
            caption: '删除',
            color: Colors.redAccent,
            icon: Icons.delete_forever,
            onTap: () {
              controller.delete(ft,item);
            },
          ),
        ),
      ],
      child: ListTile(
        onTap: () {
          controller.itemClick(item, ft);
        },
        leading: Column(mainAxisAlignment: MainAxisAlignment.center, children: [SvgPicture.asset(img, width: 20, height: 24, fit: BoxFit.fill)]),
        title: ResponsiveWidget(
          mediumScreen: Transform(
            transform: Matrix4.translationValues(-16, 0.0, 0.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                _buildDocumentName(item.name),
                _buildOfflineModeIcon(),
              ]),
              Align(alignment: Alignment.centerRight, child: _buildModifiedDocumentText(date))
            ]),
          ),
          smallScreen: Transform(transform: Matrix4.translationValues(-16, 0.0, 0.0), child: _buildDocumentName(item.name)),
          responsiveUtil: _responsiveUtils,
        ),
        subtitle: _responsiveUtils.isSmallScreen(context)
            ? Transform(
                transform: Matrix4.translationValues(-16, 0.0, 0.0),
                child: Row(
                  children: [_buildModifiedDocumentText(date), _buildOfflineModeIcon()],
                ),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        id: 'page_body',
        builder: (c) => Scaffold(
              body: PageView(
                controller: controller.pageController,
                onPageChanged: controller.pageChanged,
                children: [
                  CustomScrollView(controller: controller.scrollController, physics: const BouncingScrollPhysics(), slivers: <Widget>[
                    _appBar(),
                    _folderList(),
                  ]),
                  TaskView(),
                  SettingView(),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: controller.pageIndex,
                onTap: controller.bottomTapped,
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'cloudreve'),
                  BottomNavigationBarItem(icon: Icon(Icons.update), label: 'tasks'),
                  BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'setting')
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () {
                  controller.reload();
                },
                child: Icon(Icons.sync),
              ),
            ));
  }
}
