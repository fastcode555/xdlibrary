import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PinButton extends StatelessWidget {
  // 按钮宽高
  final double? width;
  final double? height;

  final Widget? child;
  final BorderRadius? borderRadius;

  //点击回调
  final GestureTapCallback? onPressed;
  final String? titleId;
  final String? title;
  final double? radius;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  PinButton({
    this.width,
    this.titleId,
    this.title,
    this.height,
    this.onPressed,
    this.borderRadius,
    this.radius,
    this.decoration,
    this.padding,
    this.margin,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius? _borderRadius;
    if (radius == null && decoration != null && decoration is BoxDecoration) {
      BoxDecoration boxDecoration = decoration as BoxDecoration;
      if (boxDecoration.borderRadius is BorderRadius) {
        _borderRadius = boxDecoration.borderRadius as BorderRadius;
      }
      if (boxDecoration.shape == BoxShape.circle) {
        _borderRadius = BorderRadius.all(Radius.circular(9999));
      }
    }
    return Container(
      decoration: decoration,
      padding: padding,
      margin: margin,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: borderRadius ?? _borderRadius,
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: height, width: width),
            child: Center(child: child ?? Center(child: Text(title ?? ""))),
          ),
        ),
      ),
    );
  }
}
