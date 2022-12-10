import 'package:flutter/material.dart';

/// @date 9/12/22
/// describe:

class HoverWidget extends StatefulWidget {
  final Widget Function(bool isHovered) builder;
  final Decoration? shadeDecoration;
  final Color? shadeColor;
  final Widget? shadeWidget;
  final double? width;
  final double? height;

  const HoverWidget({
    Key? key,
    required this.builder,
    this.shadeDecoration,
    this.shadeColor,
    this.shadeWidget,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  _HoverWidgetState createState() => _HoverWidgetState();
}

class _HoverWidgetState extends State<HoverWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final hovered = Matrix4.identity()..translate(0.0, -10.0, 0.0);
    final transform = isHovered ? hovered : Matrix4.identity();

    Widget? mouseWidget;
    if (widget.shadeDecoration != null) {
      mouseWidget = MouseRegion(
        onEnter: (_) => onEntered(true),
        onExit: (_) => onEntered(false),
        child: AnimatedContainer(
          width: widget.width,
          height: widget.height,
          duration: Duration(milliseconds: 300),
          transform: transform,
          child: Stack(children: [
            widget.builder(isHovered),
            AnimatedOpacity(
              child: Container(decoration: widget.shadeDecoration!),
              opacity: isHovered ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
            ),
          ]),
        ),
      );
    } else if (widget.shadeColor != null) {
      mouseWidget = MouseRegion(
        onEnter: (_) => onEntered(true),
        onExit: (_) => onEntered(false),
        child: AnimatedContainer(
          width: widget.width,
          height: widget.height,
          duration: Duration(milliseconds: 300),
          transform: transform,
          child: Stack(children: [
            widget.builder(isHovered),
            AnimatedOpacity(
              child: Container(color: widget.shadeColor),
              opacity: isHovered ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
            ),
          ]),
        ),
      );
    } else if (widget.shadeWidget != null) {
      mouseWidget = MouseRegion(
        onEnter: (_) => onEntered(true),
        onExit: (_) => onEntered(false),
        child: AnimatedContainer(
          width: widget.width,
          height: widget.height,
          duration: Duration(milliseconds: 300),
          transform: transform,
          child: Stack(children: [
            widget.builder(isHovered),
            AnimatedOpacity(
              child: widget.shadeWidget!,
              opacity: isHovered ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
            ),
          ]),
        ),
      );
    } else {
      mouseWidget = MouseRegion(
        onEnter: (_) => onEntered(true),
        onExit: (_) => onEntered(false),
        child: AnimatedContainer(
          width: widget.width,
          height: widget.height,
          duration: Duration(milliseconds: 300),
          transform: transform,
          child: widget.builder(isHovered),
        ),
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
