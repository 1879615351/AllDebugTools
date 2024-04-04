import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_app/controlers/MqttClientControler.dart';
import 'package:flutter/material.dart';
import 'package:my_app/src/rust/api/simple.dart';
import 'package:my_app/src/rust/api/mqtt.dart';
import 'package:my_app/src/rust/frb_generated.dart';
import 'dart:async';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class FloatingActionButtonLocationTopStart
    extends FloatingActionButtonLocation {
  const FloatingActionButtonLocationTopStart();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // 计算左上角的位置
    final double startPadding = 10;
    final double topPadding = 10;
    return Offset(startPadding, topPadding);
  }
}

class MqttClientPage extends StatefulWidget {
  late bool is_inner;
  MqttClientControler? myController;
  MqttClientPage({Key? key, this.is_inner = false, this.myController})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return MqttClientState();
  }
}

class MqttClientState extends State<MqttClientPage>
    with AutomaticKeepAliveClientMixin {
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );
  //MqttClientControler mqtt_client_controller = MqttClientControler();
  //late bool is_inner;
  // MqttClientControler? myController;
  MqttClientPage? inner_widget;
  String id = "1";
  String host = "127.0.0.1";
  int port = 1883;
  final _viewKey = GlobalKey();
  //MqttClientState({required this.is_inner, this.myController});

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    startClient1(id: "1");
    startClient1(id: "2");
    if (widget.is_inner == false) {
      if (widget.myController == null) {
        widget.myController =
            MqttClientControler(); //Get.put(MqttClientControler())会全局注册实例
      }
    }
  }

  void _addMessage(types.Message message) {
    setState(() {
      widget.myController!.messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: '1',
      text: message.text,
    );
    _addMessage(textMessage);
  }

  MqttClientPage getOrCreateInnerWidget() {
    if (inner_widget == null) {
      inner_widget =
          MqttClientPage(is_inner: true, myController: widget.myController);
    }
    return inner_widget!;
  }

  Future<void> navigateAndGetResult() async {
    final result = await Get.to(() => getOrCreateInnerWidget());
    // 处理返回结果，如果需要的话
    print("返回的结果是: $result");
    // 你可以在这里根据返回的结果来更新UI或状态
    setState(() {}); //等待页面返回后更新前页面
  }

  void connectMqttServer() {
    widget.myController!.connectMqttServer(id, host, port);
  }

  void disconnectMqttServer() {
    widget.myController!.disconnectMqttServer();
  }

  @override
  Widget build(BuildContext context) {
    //已解决从内部大页面切换回来不刷新消息的问题 => 异步await等待页面返回后更新前页面
    //TODO: Chat 需要添加UniqueKey()来进行每次build都重新刷新，不然添加消息多几个会寄
    //TODO:添加消息过多时，溢出显示区域会崩溃
    debugPrint('build mqttClientPage');
    return widget.is_inner
        ? Scaffold(
            body: Row(
              children: <Widget>[
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Expanded(
                        child: Chat(
                      key: UniqueKey(), //每次build都更新
                      messages: widget.myController!.messages,
                      onAttachmentPressed: null,
                      onMessageTap: null,
                      onPreviewDataFetched: null,
                      onSendPressed: _handleSendPressed,
                      showUserAvatars: true,
                      showUserNames: true,
                      user: _user,
                      theme: const DefaultChatTheme(
                        seenIcon: Text(
                          'read',
                          style: TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ))
                  ],
                )),
                Expanded(
                    child: Container(
                  color: Colors.lightGreen,
                ))
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => {
                setState(
                  () {
                    Get.back();
                  },
                )
              },
              child: Icon(Icons.back_hand),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocationTopStart(),
          ) //下面是外部小窗口，上面是内部大窗口
        : InkWell(
            //单击事件响应
            onTap: () {
              //debugPrint(test);
              if (widget.is_inner == false) {
                navigateAndGetResult();
              }
            },
            child: Container(
              //alignment: Alignment(0, 0),
              child: Row(
                //水平布局
                children: <Widget>[
                  Expanded(
                    //左边是显示消息和发送消息
                    child: Chat(
                      useTopSafeAreaInset: true,
                      key: UniqueKey(), //每次build都更新
                      messages: widget.myController!.messages,
                      onAttachmentPressed: null,
                      onMessageTap: null,
                      onPreviewDataFetched: null,
                      onSendPressed: _handleSendPressed,
                      showUserAvatars: false,
                      showUserNames: false,
                      user: _user,
                      theme: const DefaultChatTheme(
                        seenIcon: Text(
                          'read',
                          style: TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      //右边是一些设置
                      child: Container(
                    color: Colors.deepPurpleAccent,
                  ))
                ],
              ),
              //child: Obx(() => Text(myController!.name[0])),
            ),
          );
  }
}
