import 'package:get/get.dart';
import 'package:my_app/controlers/MqttClientControler.dart';
import 'package:flutter/material.dart';
import 'package:my_app/src/rust/api/simple.dart';
import 'package:my_app/src/rust/api/mqtt.dart';
import 'package:my_app/src/rust/frb_generated.dart';
import 'dart:async';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

List<types.Message> _messages = [];
final _user = const types.User(
  id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
);

class MqttClientPage extends StatefulWidget {
  late bool is_inner;
  MqttClientControler? myController;
  MqttClientPage({this.is_inner = false, this.myController});
  @override
  State<StatefulWidget> createState() {
    return MqttClientState(is_inner: is_inner, myController: myController);
  }
}

class MqttClientState extends State<MqttClientPage> {
  //MqttClientControler mqtt_client_controller = MqttClientControler();
  late bool is_inner;
  MqttClientControler? myController;
  MqttClientPage? inner_widget;
  String id = "1";
  String host = "127.0.0.1";
  int port = 1883;
  MqttClientState({required this.is_inner, this.myController});
  @override
  void initState() {
    super.initState();
    startClient1(id: "1");
    startClient1(id: "2");
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
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
          MqttClientPage(is_inner: true, myController: this.myController);
    }
    return inner_widget!;
  }

  void connectMqttServer() {
    myController!.connectMqttServer(id, host, port);
  }

  void disconnectMqttServer() {
    myController!.disconnectMqttServer();
  }

  @override
  Widget build(BuildContext context) {
    //return GetMaterialApp(home: FloatingTabbarST(smallScreenMode: false));
    this.myController = Get.put(MqttClientControler());
    //TODO: 添加3个消息以后崩溃。
    //TODO: 从内部大页面切换回来不刷新消息的问题。
    return Center(
        child: this.is_inner
            ? Scaffold(
                body: Container(
                  alignment: Alignment(0, 0),
                  child: Row(
                    //水平布局
                    children: <Widget>[
                      Expanded(
                          //左边是显示消息和发送消息
                          child: Container(
                        child: Chat(
                          messages: _messages,
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
                        ),
                      )),
                      Expanded(
                          //右边是一些设置
                          child: Container(
                        color: Colors.deepPurpleAccent,
                      ))
                    ],
                  ),
                  //child: Obx(() => Text(myController!.name[0])),
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
              ) //下面是外部小窗口，上面是内部大窗口
            : InkWell(
                //单击事件响应
                onTap: () {
                  //debugPrint(test);
                  if (is_inner == false) {
                    setState(() {
                      Get.to(() => getOrCreateInnerWidget());
                    });
                  }
                },
                child: Container(
                  alignment: Alignment(0, 0),
                  child: Row(
                    //水平布局
                    children: <Widget>[
                      Expanded(
                          //左边是显示消息和发送消息
                          child: Container(
                        child: Chat(
                          messages: _messages,
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
                        ),
                      )),
                      Expanded(
                          //右边是一些设置
                          child: Container(
                        color: Colors.deepPurpleAccent,
                      ))
                    ],
                  ),
                  //child: Obx(() => Text(myController!.name[0])),
                ),
              ));
  }
}
