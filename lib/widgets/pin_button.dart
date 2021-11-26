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

  PinButton({
    this.width,
    this.titleId,
    this.title,
    this.height,
    this.onPressed,
    this.borderRadius,
    this.radius,
    this.decoration,
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
    }
    return Container(
      decoration: decoration,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: borderRadius ?? _borderRadius,
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: height, width: width),
            child: Center(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2D2D2D),
                ),
                child: child ?? Center(child: Text(title ?? "")),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
