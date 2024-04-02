import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:my_app/MainPages.dart';
import 'package:my_app/pages/MqttClientPage.dart';

class CommonDebugView extends StatefulWidget {
  final bool? smallScreenMode;
  const CommonDebugView({Key? key, this.smallScreenMode}) : super(key: key);
  @override
  State<CommonDebugView> createState() => _CommonDebugViewState();
}

enum CommonDebugMode {
  MQTT_SERVER,
  MQTT_CLIENT,
  TCP_SERVER,
  TCP_CLIENT,
  UDP,
  HTTP
}

class _CommonDebugViewState extends State<CommonDebugView> {
  final _scrollController = ScrollController(initialScrollOffset: 10);
  final _gridViewKey = GlobalKey();
  var _pages = <CommonDebugMode>[];
  @override
  Widget build(BuildContext contex) {
    var generatedChildren = List.generate(
      // 创造Grid成员
      _pages.length,
      (index) => Container(
          key: Key(_pages.elementAt(index).toString()),
          child: switch (_pages[index]) {
            CommonDebugMode.MQTT_CLIENT => MqttClientPage(),
            CommonDebugMode.MQTT_SERVER => MqttClientPage(),
            CommonDebugMode.TCP_SERVER => MqttClientPage(),
            CommonDebugMode.TCP_CLIENT => MqttClientPage(),
            CommonDebugMode.UDP => MqttClientPage(),
            CommonDebugMode.HTTP => MqttClientPage(),
          }),
    );
    // final double _width = contex.width;
    // final double _height = contex.height;
    return Scaffold(
      body: Center(
        child: ReorderableBuilder(
          children: generatedChildren,
          scrollController: _scrollController,
          onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
            setState(() {
              for (final orderUpdateEntity in orderUpdateEntities) {
                final fruit = _pages.removeAt(orderUpdateEntity.oldIndex);
                _pages.insert(orderUpdateEntity.newIndex, fruit);
              }
            });
          },
          builder: (children) {
            return GridView(
              key: _gridViewKey,
              controller: _scrollController,
              children: children,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 4,
                crossAxisSpacing: 8,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            {setState(() => _pages.add(CommonDebugMode.MQTT_CLIENT))},
      ),
    );
  }
}
