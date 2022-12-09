/// @date 9/12/22
/// describe:
import 'package:flutter/material.dart';

/// @date 9/12/22
/// describe: 组件产生放大的效果

class ZoomWidget extends StatefulWidget {
  final double targetScale;
  final Widget Function(bool isHovered) builder;
  final Decoration? shadeDecoration;
  final Color? shadeColor;
  final Widget? shadeWidget;
  final double? width;
  final double? height;

  const ZoomWidget({
    Key? key,
    required this.builder,
    this.targetScale = 1.1,
    this.shadeDecoration,
    this.shadeColor,
    this.shadeWidget,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  _HoverWidgetState createState() => _HoverWidgetState();
}

class _HoverWidgetState extends State<ZoomWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    Widget child = AnimatedScale(
      duration: Duration(milliseconds: 300),
      scale: isHovered ? widget.targetScale : 1.0,
      child: widget.builder(isHovered),
    );
    Widget? mouseWidget;
    if (widget.shadeDecoration != null) {
      mouseWidget = MouseRegion(
        onEnter: (_) => onEntered(true),
        onExit: (_) => onEntered(false),
        child: RepaintBoundary(
          child: ClipRect(
            child: Stack(children: [
              child,
              AnimatedOpacity(
                child: Container(decoration: widget.shadeDecoration!),
                opacity: isHovered ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
              ),
            ]),
          ),
        ),
      );
    } else if (widget.shadeColor != null) {
      mouseWidget = MouseRegion(
        onEnter: (_) => onEntered(true),
        onExit: (_) => onEntered(false),
        child: RepaintBoundary(
          child: ClipRect(
            child: Stack(
              children: [
                child,
                AnimatedOpacity(
                  child: Container(color: widget.shadeColor),
                  opacity: isHovered ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (widget.shadeWidget != null) {
      mouseWidget = MouseRegion(
        onEnter: (_) => onEntered(true),
        onExit: (_) => onEntered(false),
        child: RepaintBoundary(
          child: ClipRect(
            child: Stack(
              children: [
                child,
                AnimatedOpacity(
                  child: widget.shadeWidget!,
                  opacity: isHovered ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      mouseWidget = MouseRegion(
        onEnter: (_) => onEntered(true),
        onExit: (_) => onEntered(false),
        child: RepaintBoundary(child: ClipRect(child: child)),
      );
    }
    if (widget.width != null || widget.height != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: mouseWidget,
      );
    }
    return mouseWidget;
  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
