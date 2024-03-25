import 'package:flutter/material.dart';
import 'package:my_app/src/rust/api/simple.dart';
import 'package:my_app/src/rust/api/mqtt.dart';
import 'package:my_app/src/rust/frb_generated.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:floating_tabbar/floating_tabbar.dart';
import 'package:my_app/pages/mqtt_client.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(MyApp());
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContentBodyState();
  }
}

class ContentBodyState extends State<MyApp> {
  MqttClient mqtt_client = MqttClient();
  late StreamSubscription<String> _dataSubscription;
  late StreamSubscription<String> _state_monitor;
  String id = "1";
  String host = "192.168.53.156";
  int port = 1883;
  String msg = "";
  String state = "";
  @override
  void initState() {
    super.initState();
    startClient1(id: "1");
    // mqtt_client.publish(
    //     topic: "testtopic",
    //     qos: QosNative.exactlyOnce,
    //     retain: false,
    //     payload: "667788");
    startClient1(id: "2");
  }

  void connectMqttServer() {
    mqtt_client.connect(id: id, host: host, port: port);
    _dataSubscription = mqtt_client.beginReceive().listen((value) {
      setState(() {
        msg = value;
      });
    });
    _state_monitor = mqtt_client.stateMonitor().listen((value) {
      setState(() {
        state = value;
      });
    });
  }

  void disconnectMqttServer() {
    // _dataSubscription.cancel();  //等他内存释放自动取消，自己取消可能会丢失最后的消息
    // _state_monitor.cancel();
    mqtt_client.exit();
    mqtt_client = MqttClient(); //好像内存是等第一次调用函数时释放掉
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: FloatingTabbarST(smallScreenMode: false));
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Center(
              child: Text('flutter_rust_bridge quickstart'),
            ),
            actions: <Widget>[
              IconButton(onPressed: () {}, icon: Icon(Icons.add)),
            ]),
        body: Column(
          children: <Widget>[
            Divider(),
            Text(
              ('Action: Call Rust `greet("Tom")`\nResult: `${greet(name: "Tom")}`'),
            ),
            Text(
              (msg),
            ),
            ElevatedButton(
                onPressed: () => {mqtt_client.unsubscribe(topic: "testtopic")},
                child: Text("取消订阅")),
            ElevatedButton(
                onPressed: () => {
                      setState(() {
                        connectMqttServer();
                      })
                    },
                child: Text("连接服务器")),
            ElevatedButton(
                onPressed: () => {
                      setState(() {
                        disconnectMqttServer();
                      })
                    },
                child: Text("断开服务器")),
            ElevatedButton(
                onPressed: () => {
                      setState(() {
                        mqtt_client.subscribe(
                            topic: "testtopic", qos: QosNative.exactlyOnce);
                      })
                    },
                child: Text("开始订阅")),
            Text(
              (state),
            ),
          ],
        ),
      ),
    );
  }
}

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     //startClient(id: "1", host: "192.16.1.1", port: 9988);
//     //startClient(id: "1", host: "192.16.1.1", port: 9988);
//     // MqttClient mqtt_client =
//     //     MqttClient(id: "1", host: "192.168.53.156", port: 1883);
//     MqttClient mqtt_client = MqttClient(id: "1", host: "127.0.0.1", port: 1883);
//     mqtt_client.subscribe(topic: "testtopic", qos: QosNative.exactlyOnce);
//     Future(() {
//       print("开始");
//       // 模拟耗时操作
//       mqtt_client.beginReceive();
//       print("结束");
//     });

//     startClient1(id: "1");
//     mqtt_client.publish(
//         topic: "testtopic",
//         qos: QosNative.exactlyOnce,
//         retain: false,
//         payload: "667788");
//     startClient1(id: "2");
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
//         body: Center(
//           child: Column(
//             children: [
//               Text(
//                 ('Action: Call Rust `greet("Tom")`\nResult: `${greet(name: "Tom")}`'),
//               ),
//               ElevatedButton(
//                   onPressed: () async {
//                     print("按钮的单击事件");
//                     const XTypeGroup typeGroup = XTypeGroup(
//                         //label: 'images',
//                         //extensions: <String>['jpg', 'png'],
//                         );
//                     final XFile? file = await openFile(
//                         acceptedTypeGroups: <XTypeGroup>[typeGroup]);
//                     if (file != null) {
//                       print(file.name);
//                     }
//                   },
//                   child: Text("选择文件")),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
