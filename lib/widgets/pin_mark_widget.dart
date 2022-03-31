import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void showSnackBar(BuildContext context, String msg) {
  Scaffold.of(context).showSnackBar(SnackBar(content: new Text(msg)));
}

class PinSvg extends StatelessWidget {
  final String svg;
  final double? width;
  final Color? color;

  final double? height;
  final bool allowDrawingOutsideViewBox;

  const PinSvg(
    this.svg, {
    Key? key,
    this.width,
    this.height,
    this.allowDrawingOutsideViewBox = true,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svg,
      width: width,
      height: height,
      fit: BoxFit.contain,
      color: color,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
    );
  }
}

class PinFillSvg extends StatelessWidget {
  final String svg;
  final double? width;
  final Color? color;
  final double? height;
  final bool allowDrawingOutsideViewBox;

  const PinFillSvg(
    this.svg, {
    Key? key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.color,
    this.allowDrawingOutsideViewBox = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svg,
      width: width,
      height: height,
      color: color,
      fit: BoxFit.contain,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
    );
  }
}

class PinStack extends StatelessWidget {
  final Decoration? decoration;
  final Color? color;
  final List<Widget> children;

  const PinStack({required this.children, Key? key, this.decoration, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (decoration == null) return Stack(children: children);
    return Container(
      decoration: decoration,
      color: color,
      child: Stack(children: children),
    );
  }
}

class PinContainer extends StatelessWidget {
  final Decoration? decoration;
  final double? width;
  final double? height;
  final Widget? child;
  final AlignmentGeometry? alignment;
  final Color? color;

  const PinContainer({
    this.child,
    Key? key,
    this.decoration,
    this.width = double.infinity,
    this.height = double.infinity,
    this.alignment = Alignment.center,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      decoration: decoration,
      width: width,
      height: height,
      alignment: alignment,
      color: color,
    );
  }
}

class CircleWidget extends StatelessWidget {
  final Color? color;
  final double? width;
  final double? height;
  final Widget? child;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;

  const CircleWidget(
    this.color, {
    this.child,
    Key? key,
    this.width,
    this.height,
    this.radius,
    this.padding,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      padding: padding,
      alignment: alignment,
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

class PinRelativeMark extends StatelessWidget {
  final List<Widget> children;

  const PinRelativeMark({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: children);
  }
}

class PinScaffold extends StatelessWidget {
  final Widget body;
  final Color? backgroundColor;

  const PinScaffold({Key? key, required this.body, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: 1500,
          child: body,
        ),
      ),
    );
  }
}
