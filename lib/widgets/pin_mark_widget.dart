import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void showSnackBar(BuildContext context, String msg) {
  Scaffold.of(context).showSnackBar(SnackBar(content: new Text(msg)));
}

class PinSvg extends StatelessWidget {
  final String svg;
  final double? width;

  final double? height;
  final bool allowDrawingOutsideViewBox;

  const PinSvg(this.svg, {Key? key, this.width, this.height, this.allowDrawingOutsideViewBox = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(svg, width: width, height: height, allowDrawingOutsideViewBox: allowDrawingOutsideViewBox);
  }
}

class PinFillSvg extends StatelessWidget {
  final String svg;
  final double? width;

  final double? height;
  final bool allowDrawingOutsideViewBox;

  const PinFillSvg(
    this.svg, {
    Key? key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.allowDrawingOutsideViewBox = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(svg, width: width, height: height, allowDrawingOutsideViewBox: allowDrawingOutsideViewBox);
  }
}

class PinStack extends StatelessWidget {
  final Decoration? decoration;
  final List<Widget> children;

  const PinStack({required this.children, Key? key, this.decoration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (decoration == null) return Stack(children: children);
    return Container(decoration: decoration, child: Stack(children: children));
  }
}

class PinContainer extends StatelessWidget {
  final Decoration? decoration;
  final double? width;
  final double? height;
  final Widget? child;

  const PinContainer({
    this.child,
    Key? key,
    this.decoration,
    this.width = double.infinity,
    this.height = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: child, decoration: decoration, width: width, height: height);
  }
}

class CircleWidget extends StatelessWidget {
  final Color? color;
  final double? width;
  final double? height;
  final Widget? child;
  final double? radius;

  const CircleWidget(
    this.color, {
    this.child,
    Key? key,
    this.width,
    this.height,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      width: width ?? height ?? (radius != null ? radius! * 2 : null),
      height: height ?? width ?? (radius != null ? radius! * 2 : null),
    );
  }
}

class PinImageMark extends StatelessWidget {
  const PinImageMark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
