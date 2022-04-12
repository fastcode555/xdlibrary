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
  final Color? color;

  double? _width;
  double? _height;
  bool _isWrap = false;

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
    this.color,
    @required this.child,
  });

  PinButton.wrap({
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
    this.color,
    @required this.child,
  }) : _isWrap = true;

  void _onInit() {
    if (width == null && _isWrap) {
      if (child is Text) {
        Text textWidget = child as Text;
        if (textWidget.style != null) {
          final TextPainter textPainter = TextPainter(
              text: TextSpan(text: textWidget.data, style: textWidget.style),
              maxLines: 1,
              textDirection: TextDirection.ltr)
            ..layout(
              minWidth: 0,
              maxWidth: double.infinity,
            );
          if (padding != null && padding is EdgeInsets) {
            EdgeInsets insets = padding as EdgeInsets;
            _width = textPainter.width + insets.left + insets.right;
            _height = height ?? (textPainter.height + insets.top + insets.bottom);
          } else {
            _width = textPainter.width + 14;
            _height = height ?? (textPainter.height + 6);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isWrap && _width == null) {
      _onInit();
    }
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
      color: color,
      margin: margin,
      height: height ?? _height,
      width: width ?? _width,
      alignment: Alignment.center,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: borderRadius ?? _borderRadius,
          onTap: onPressed,
          child: Center(child: child ?? Text(title ?? "")),
        ),
      ),
    );
  }
}
