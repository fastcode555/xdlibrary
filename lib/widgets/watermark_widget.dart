/// @date 8/2/23
/// describe:
///
import 'package:flutter/material.dart';

class WatermarkWidget extends StatelessWidget {
  final int rowCount;
  final int columnCount;
  final String text;

  const WatermarkWidget({
    Key? key,
    required this.rowCount,
    required this.columnCount,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        margin: const EdgeInsets.only(top: 80, bottom: 80),
        child: Column(
          children: createColumnWidgets(),
        ),
      ),
    );
  }

  // 行
  List<Widget> creatRowWdiges() {
    List<Widget> list = [];
    for (var i = 0; i < rowCount; i++) {
      final widget = Expanded(
        child: Center(
          child: Transform.rotate(
            angle: 120,
            child: Text(
              text,
              style: const TextStyle(
                color: Color.fromARGB(35, 0, 0, 0),
                fontSize: 16,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      );
      list.add(widget);
    }
    return list;
  }

  // 列
  List<Widget> createColumnWidgets() {
    List<Widget> list = [];
    for (var i = 0; i < columnCount; i++) {
      final widget = Expanded(child: Row(children: creatRowWdiges()));
      list.add(widget);
    }
    return list;
  }
}
