import 'package:floating_tabbar/lib.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_selector/flutter_custom_selector.dart';
import 'package:my_app/MainViews/CommonDebugView.dart';

enum CommonDebugMode {
  MQTT_SERVER,
  MQTT_CLIENT,
  TCP_SERVER,
  TCP_CLIENT,
  UDP,
  HTTP
}

class ToolsCheckPanel extends StatelessWidget {
  CommonDebugMode? _selectd_mode;
  List<String> modes = [
    "MQTT 客户端",
    "MQTT 服务器",
    "TCP  服务器",
    "TCP  客户端",
    "UDP",
    "HTTP",
  ];
  @override
  Widget build(BuildContext context) {
    double _width = context.width;
    double _height = context.height;
    return SizedBox(
        width: _width * 0.5,
        height: _height * 0.5,
        child: Column(
          children: <Widget>[
            CustomSingleSelectField<String>(
              items: modes,
              title: "调试模式",
              // initialValue: modes[0],
              onSelectionDone: (value) {
                // //selectedString = value;
                // setState(() {});
                int index = modes.indexOf(value);
                if (index != -1) {
                  _selectd_mode = CommonDebugMode.values[index];
                  //debugPrint(Mode.values[index].toString());
                  //TODO: 将枚举通过点击确定传递到外面
                }
              },
              itemAsString: (item) => item,
            ),
            //Divider(),
            // TextField(
            //   decoration: const InputDecoration(
            //     label: Text("标签label"),
            //     icon: Icon(Icons.favorite),
            //     iconColor: Colors.black,
            //     border: OutlineInputBorder(),
            //     hintText: "提示文本hintText",
            //     hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
            //     contentPadding: EdgeInsets.all(2),
            //     counter: Text("提示文本counter"),
            //     helperText: "帮助文本helperText",
            //     prefixIcon: Icon(Icons.arrow_left),
            //     suffixIcon: Icon(Icons.arrow_right),
            //     suffix: Text('suffix'),
            //   ),
            //   onChanged: (value) {},
            // )
          ],
        ));
  }
}

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

class MainPage extends StatefulWidget {
  final bool? smallScreenMode;
  const MainPage({Key? key, this.smallScreenMode}) : super(key: key);
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool leading = false;
  bool nauticsFooter = false;
  bool parentAppbar = false;
  bool isFloating = true;
  bool useNautics = false;
  bool showTabLabelsForFloating = true;
  bool showTabLabelsForNonFloating = false;
  bool useIndicator = false;

  Color backgroundColor = Colors.white;
  Color activeColor = Colors.purple;
  Color inactiveColor = Colors.black;
  Color indicatorColor = Colors.purple.withOpacity(0.5);

  int minExtendedWidth = 200;

  late final Widget floatingTabbarST;
  ToolsCheckPanel mode_check_panel = ToolsCheckPanel();
  @override
  void initState() {
    super.initState();
    floatingTabbarST = const OpsShell(child: MainPage(smallScreenMode: true));
  }

  List<TabItem> tabListOne() {
    List<TabItem> list = [
      TabItem(
        title: const Text("Work"),
        onTap: () {},
        selectedLeading: const Icon(Icons.home),
        badgeCount: 1,
        unSelectedLeading: const Icon(Icons.home_outlined),
        tab: const Center(child: Text("Work", style: TextStyle(fontSize: 30))),
      ),
      TabItem(
        onTap: () {},
        selectedLeading: const Icon(Icons.mediation),
        unSelectedLeading: const Icon(Icons.library_books_outlined),
        title: const Text("Report"),
        tab:
            const Center(child: Text("Report", style: TextStyle(fontSize: 30))),
      ),
      TabItem(
        onTap: () {},
        selectedLeading: const Icon(Icons.settings),
        unSelectedLeading: const Icon(Icons.settings_outlined),
        title: const Text("Settings"),
        tab: const Center(
            child: Text("Settings", style: TextStyle(fontSize: 30))),
      ),
    ];
    return list;
  }

  Widget showCMenu({required Size size}) {
    return SizedBox(
      height: size.height * 0.6,
      width: size.width * 0.5,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children3(context, size)),
    );
  }

  List<TabItem> tabListTwo({required Size size}) {
    List<TabItem> list = [
      TabItem(
          title: const Text("Work"),
          onTap: () {},
          selectedLeading: const Icon(Icons.home),
          //badgeCount: 1,
          unSelectedLeading: const Icon(Icons.home_outlined),
          tab: CommonDebugView()),
      // Scaffold(
      //   body: Stack(
      //     children: <Widget>[
      //       Center(
      //         child: Text("66666"),
      //       )
      //     ],
      //   ),
      //   floatingActionButton: FloatingActionButton(
      //     child: const Icon(Icons.home),
      //     onPressed: () {
      //       Get.defaultDialog(
      //         title: "提示消息",
      //         //middleText: "请选择",
      //         content: mode_check_panel,
      //         confirm: ElevatedButton(
      //             onPressed: () {
      //               //TODO:根据选择的框，创建不同的调试页面Tab在主页面显示小窗，添加大小窗口切换
      //               debugPrint(mode_check_panel._selectd_mode.toString());
      //               Get.back();
      //             },
      //             child: Text("确定")),
      //         cancel: ElevatedButton(
      //             onPressed: () {
      //               Get.back();
      //             },
      //             child: Text("取消")),
      //       );
      //     },
      //   ),
      //   floatingActionButtonLocation:
      //       FloatingActionButtonLocationTopStart(),
      // )),
      TabItem(
        onTap: () {},
        selectedLeading: const Icon(Icons.video_file),
        unSelectedLeading: const Icon(Icons.video_file_outlined),
        title: const Text("Report"),
        tab:
            const Center(child: Text("Report", style: TextStyle(fontSize: 30))),
      ),
      TabItem(
        onTap: () {},
        selectedLeading: const Icon(Icons.settings),
        unSelectedLeading: const Icon(Icons.settings_outlined),
        title: const Text("Settings"),
        tab:
            const Center(child: Text("Report", style: TextStyle(fontSize: 30))),
      ),
    ];
    return list;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: null,
      body: Row(
        children: [
          Expanded(
            child: FloatingTabBar(
              backgroundColor: backgroundColor,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              indicatorColor: indicatorColor,
              leading: leading ? const Icon(Icons.home_work_rounded) : null,
              nauticsFooter:
                  nauticsFooter ? const Icon(Icons.more_horiz) : null,
              parentAppbar: null,
              minExtendedWidth: minExtendedWidth.toDouble(),
              isFloating: isFloating,
              useNautics: useNautics,
              showTabLabelsForFloating: showTabLabelsForFloating,
              showTabLabelsForNonFloating: showTabLabelsForNonFloating,
              useIndicator: useIndicator,
              smallScreenMode: widget.smallScreenMode,
              children: tabListTwo(size: size),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> children2(BuildContext context, Size size) {
    return [
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          chooseColor(
              context: context,
              size: size,
              selectedColor: (v) => setState(() => backgroundColor = v));
        },
        child: const Text("Background Color"),
      ),
      ElevatedButton(
        onPressed: () {
          chooseColor(
              context: context,
              size: size,
              selectedColor: (v) => setState(() => activeColor = v));
        },
        child: const Text("Active Color"),
      ),
      ElevatedButton(
        onPressed: () {
          chooseColor(
              context: context,
              size: size,
              selectedColor: (v) => setState(() => inactiveColor = v));
        },
        child: const Text("Inactive Color"),
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            useIndicator = !useIndicator;
          });
        },
        child: const Text("Use Indicator"),
      ),
      ElevatedButton(
        onPressed: () {
          chooseColor(
              context: context,
              size: size,
              selectedColor: (v) => setState(() => indicatorColor = v));
        },
        child: const Text("Indicator Color"),
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            leading = !leading;
          });
        },
        child: const Text("Leading"),
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            nauticsFooter = !nauticsFooter;
          });
        },
        child: const Text("Nautics Footer"),
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            parentAppbar = !parentAppbar;
          });
        },
        child: const Text("Parent Appbar"),
      ),
      Floater(
        child: SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Min Extended Width"),
              const SizedBox(height: 5),
              IncrementDecrementNumber(
                count: minExtendedWidth,
                onCountChange: (value) {
                  setState(() {
                    minExtendedWidth = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            isFloating = !isFloating;
          });
        },
        child: const Text("Is Floating"),
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            useNautics = !useNautics;
          });
        },
        child: const Text("Use Nautics"),
      ),
      const SizedBox(height: 10),
    ];
  }

  List<Widget> children3(BuildContext context, Size size) {
    return [
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          chooseColor(
              context: context,
              size: size,
              selectedColor: (v) => setState(() => backgroundColor = v));
        },
        child: const Text("Background Color"),
      ),
      ElevatedButton(
        onPressed: () {
          chooseColor(
              context: context,
              size: size,
              selectedColor: (v) => setState(() => activeColor = v));
        },
        child: const Text("Active Color"),
      ),
      ElevatedButton(
        onPressed: () {
          chooseColor(
              context: context,
              size: size,
              selectedColor: (v) => setState(() => inactiveColor = v));
        },
        child: const Text("Inactive Color"),
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            parentAppbar = !parentAppbar;
          });
        },
        child: const Text("Parent Appbar"),
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            isFloating = !isFloating;
          });
        },
        child: const Text("Is Floating"),
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            showTabLabelsForFloating = !showTabLabelsForFloating;
          });
        },
        child: const Text("Show Tab Labels For Floating"),
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            showTabLabelsForNonFloating = !showTabLabelsForNonFloating;
          });
        },
        child: const Text("Show Tab Labels For Non Floating"),
      ),
      const SizedBox(height: 10),
    ];
  }
}
