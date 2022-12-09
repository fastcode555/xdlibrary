/// @date 9/12/22
/// describe:
import 'package:flutter/material.dart';

/// @date 9/12/22
/// describe: 组件产生放大的效果

class ZoomWidget extends StatefulWidget {
  final double targetScale;
  final Widget Function(bool isHovered) builder;

  const ZoomWidget({
    Key? key,
    required this.builder,
    this.targetScale = 1.1,
  }) : super(key: key);

  @override
  _HoverWidgetState createState() => _HoverWidgetState();
}

class _HoverWidgetState extends State<ZoomWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onEntered(true),
      onExit: (_) => onEntered(false),
      child: RepaintBoundary(
        child: ClipRect(
          child: AnimatedScale(
            duration: Duration(milliseconds: 300),
            scale: isHovered ? widget.targetScale : 1.0,
            child: widget.builder(isHovered),
          ),
        ),
      ),
    );
  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
