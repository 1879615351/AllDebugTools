import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/src/rust/frb_generated.dart'; //初始化rust相关内容
import 'package:my_app/MainPages.dart';
import 'dart:async';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
        home: Scaffold(
      body: MainPage(),
    ));
  }
}
