import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:my_app/src/rust/api/simple.dart';
import 'package:my_app/src/rust/api/mqtt.dart';
import 'package:my_app/src/rust/frb_generated.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'dart:async';

class MqttClientControler extends GetxController {
  var name = ["666", "777", "888"].obs;
  late MqttClient? mqtt_client; //from rust
  late Rx<StreamSubscription<String>> _dataSubscription;
  late Rx<StreamSubscription<String>> _state_monitor;
  RxList<String> m_msg = [""].obs;
  RxList<types.Message> messages = <types.Message>[].obs;
  RxString m_state_msg = "".obs;
  RxBool is_connected = false.obs;
  void connectMqttServer(
    //连接服务器并获取Stream
    String id,
    String host,
    int port,
  ) {
    mqtt_client = MqttClient(); //from rust
    mqtt_client!.connect(id: id, host: host, port: port);
    _dataSubscription = mqtt_client!.beginReceive().listen((value) {
      m_msg.add(value);
      //dataUpdateCallback(value);
    }).obs;
    _state_monitor = mqtt_client!.stateMonitor().listen((value) {
      m_state_msg.value = value;
      if (value == "ok") {
        is_connected.value = true;
      } else if (value == "error") {
        is_connected.value = false;
      }

      ///stateUpdateCallback(value);
    }).obs;
  }

  void disconnectMqttServer() {
    // _dataSubscription.cancel();  //等他内存释放自动取消，自己取消可能会丢失最后的消息
    // _state_monitor.cancel();
    mqtt_client!.exit();
    //mqtt_client = MqttClient(); //好像内存是等第一次调用函数时释放掉
    mqtt_client = null;
  }

  // void setDataUpdateListener() {
  //   _dataSubscription.listen((value) {
  //     m_msg.value = value;
  //     //F(value);
  //   });
  // }

  // void setConnectionStateUpdateListener() {
  //   _state_monitor.listen((value) {
  //     m_state_msg.value = value;
  //     //F(value);
  //   });
  // }

  void subscribe(String topic, QosNative qos) {
    mqtt_client!.subscribe(topic: topic, qos: qos);
  }

  void unsubscribe(String topic) {
    mqtt_client!.unsubscribe(topic: topic);
  }
}
