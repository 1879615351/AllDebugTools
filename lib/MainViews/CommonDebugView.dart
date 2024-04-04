import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:my_app/MainPages.dart';
import 'package:my_app/pages/MqttClientPage.dart';
import 'package:my_app/controlers/MqttClientControler.dart';

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

class CommonPanelKeeper {
  late GetxController controller;
  late Key key;
  late CommonDebugMode mode;
  CommonPanelKeeper(
      {required this.controller, required this.key, required this.mode});
}

class _CommonDebugViewState extends State<CommonDebugView>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController(initialScrollOffset: 10);
  final _gridViewKey = GlobalKey();
  List<CommonPanelKeeper> page_keeper = <CommonPanelKeeper>[];
  void _handleDragStarted() {
    ScaffoldMessenger.of(context).clearSnackBars();
    const snackBar = SnackBar(
      content: Text('Dragging has started!'),
      duration: Duration(milliseconds: 1000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handleDragEnd() {
    ScaffoldMessenger.of(context).clearSnackBars();
    const snackBar = SnackBar(
      content: Text('Dragging was finished!'),
      duration: Duration(milliseconds: 1000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void add_pages(CommonDebugMode mode) {
    var key = UniqueKey();
    GetxController controller = switch (mode) {
      CommonDebugMode.MQTT_CLIENT => MqttClientControler(),
      CommonDebugMode.MQTT_SERVER => MqttClientControler(),
      CommonDebugMode.TCP_SERVER => MqttClientControler(),
      CommonDebugMode.TCP_CLIENT => MqttClientControler(),
      CommonDebugMode.UDP => MqttClientControler(),
      CommonDebugMode.HTTP => MqttClientControler(),
    };
    CommonPanelKeeper keeper =
        CommonPanelKeeper(controller: controller, key: key, mode: mode);
    page_keeper.add(keeper);
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext contex) {
    debugPrint('build called');
    //add_pages(CommonDebugMode.TCP_CLIENT);
    //add_pages(CommonDebugMode.UDP);
    var generatedChildren = List.generate(
      // 创造Grid成员
      page_keeper.length,
      (index) => Center(
          key: page_keeper[index].key,
          child: switch (page_keeper[index].mode) {
            CommonDebugMode.MQTT_CLIENT => MqttClientPage(
                is_inner: false,
                myController:
                    page_keeper[index].controller as MqttClientControler,
                key: page_keeper[index].key,
              ),
            CommonDebugMode.MQTT_SERVER => MqttClientPage(
                is_inner: false,
                myController:
                    page_keeper[index].controller as MqttClientControler,
                key: page_keeper[index].key,
              ),
            CommonDebugMode.TCP_SERVER => MqttClientPage(
                is_inner: false,
                myController:
                    page_keeper[index].controller as MqttClientControler,
                key: page_keeper[index].key,
              ),
            CommonDebugMode.TCP_CLIENT => MqttClientPage(
                is_inner: false,
                myController:
                    page_keeper[index].controller as MqttClientControler,
                key: page_keeper[index].key,
              ),
            CommonDebugMode.UDP => MqttClientPage(
                is_inner: false,
                myController:
                    page_keeper[index].controller as MqttClientControler,
                key: page_keeper[index].key,
              ),
            CommonDebugMode.HTTP => MqttClientPage(
                is_inner: false,
                myController:
                    page_keeper[index].controller as MqttClientControler,
                key: page_keeper[index].key,
              ),
          }),
    );
    return Scaffold(
      body: Center(
        child: ReorderableBuilder(
          children: generatedChildren,
          scrollController: _scrollController,
          onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
            setState(() {
              for (final orderUpdateEntity in orderUpdateEntities) {
                final page = page_keeper.removeAt(orderUpdateEntity.oldIndex);
                page_keeper.insert(orderUpdateEntity.newIndex, page);
              }
            });
          },
          //enableDraggable: false,
          onDragStarted: _handleDragStarted,
          onDragEnd: _handleDragEnd,
          builder: (children) {
            return GridView(
              key: _gridViewKey,
              controller: _scrollController,
              children: children,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
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
            {setState(() => add_pages(CommonDebugMode.MQTT_CLIENT))},
      ),
    );
  }
}
