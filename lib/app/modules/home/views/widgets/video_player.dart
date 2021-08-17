import 'package:fijkplayer/fijkplayer.dart';
import 'package:fijkplayer_skin/fijkplayer_skin.dart';
import 'package:fijkplayer_skin/schema.dart' show VideoSourceFormat;
import 'package:flutter/material.dart';


class VideoPlayer extends StatefulWidget {
  final String url;
  final String name;
  final String cookie;
  VideoPlayer(this.url,this.name,this.cookie);
  @override
  VideoPlayerState createState() => VideoPlayerState();
}

class VideoPlayerState extends State<VideoPlayer> {

  @override
  Widget build(BuildContext context) {
    // return VideoDetailPage();
    return Scaffold(
      appBar: AppBar(
        title: Text('视频播放'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VideoDetailPage(widget.url,widget.name,widget.cookie),
        ],
      ),
    );
  }
}

// 定制UI配置项
class PlayerShowConfig implements ShowConfigAbs {
  bool drawerBtn = false;
  bool nextBtn = false;
  bool speedBtn = true;
  bool topBar = true;
  bool lockBtn = true;
  bool autoNext = false;
  bool bottomPro = false;
  bool stateAuto = true;
}

class VideoDetailPage extends StatefulWidget {
  final String url;
  final String name;
  final String cookie;
  VideoDetailPage(this.url,this.name,this.cookie);
  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  final FijkPlayer player = FijkPlayer();

  late Map<String, List<Map<String, dynamic>>> videoList;

  VideoSourceFormat? _videoSourceTabs;
  late TabController _tabController;

  int _curTabIdx = 0;
  int _curActiveIdx = 0;

  // ignore: non_constant_identifier_names
  ShowConfigAbs v_cfg = PlayerShowConfig();

  @override
  void dispose() {
    print('播放器销毁');
    _tabController.dispose();
    player.dispose();
    super.dispose();
  }

  // 钩子函数，用于更新状态
  void onChangeVideo(int curTabIdx, int curActiveIdx) {
    this.setState(() {
      _curTabIdx = curTabIdx;
      _curActiveIdx = curActiveIdx;
    });
  }

  _init() async {
    videoList = {
      'video': [
        {
          'name': widget.name,
          'list': [
            {
              'url': widget.url,
              'name': widget.name
            },
          ]
        },
        {
          'name': widget.name,
          'list': [
            {
              'url': widget.url,
              'name': widget.name
            },
          ]
        }
      ]
    };
    await player.setOption(FijkOption.formatCategory, 'headers', 'Cookie:${widget.cookie}');
    player.prepareAsync();
    player.enterFullScreen(); // 进入全屏
    //await player.setDataSource(widget.url, autoPlay: true);
  }

  @override
  void initState() {
    super.initState();
    _init();
    // 格式化json转对象
    _videoSourceTabs = VideoSourceFormat.fromJson(videoList);
    // tabbar初始化
    _tabController = TabController(
      length: _videoSourceTabs!.video!.length,
      vsync: this,
    );
    // 这句不能省，必须有
    speed = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FijkView(
          height: 260,
          color: Colors.black,
          fit: FijkFit.contain,
          player: player,
          panelBuilder: (
              FijkPlayer player,
              FijkData data,
              BuildContext context,
              Size viewSize,
              Rect texturePos,
              ) {
            /// 使用自定义的布局
            return CustomFijkPanel(
              player: player,
              viewSize: viewSize,
              texturePos: texturePos,
              pageContent: context,
              // 标题 当前页面顶部的标题部分
              playerTitle: widget.name,
              // 当前视频改变钩子
              onChangeVideo: onChangeVideo,
              // 当前视频源tabIndex
              curTabIdx: _curTabIdx,
              // 当前视频源activeIndex
              curActiveIdx: _curActiveIdx,
              // 显示的配置
              showConfig: v_cfg,
              // json格式化后的视频数据
              videoFormat: _videoSourceTabs,
              // tabController
              tabController: _tabController,
            );
          },
        ),
        // 请不要使用同一个tabbar，否则会卡顿，原因是数据更新导致整体重新绘制，
        // 可以使用_curTabIdx和_curActiveIdx手动渲染其他类似组件，判断
        // Container(
        //   height: 300,
        //   child: buildPlayDrawer(),
        // ),
        // Container(
        //   child: Text(
        //       '当前tabIdx : ${_curTabIdx.toString()} 当前activeIdx : ${_curActiveIdx.toString()}'),
        // )
      ],
    );
  }
}