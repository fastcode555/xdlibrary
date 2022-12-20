import 'package:flutter/material.dart';

/// @date 8/12/22
/// describe: 动态行数的Text
class DynamicLineText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextOverflow? overflow;

  const DynamicLineText(
    this.text, {
    this.style,
    this.overflow = TextOverflow.ellipsis,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraint) {
        double height = constraint.maxHeight;
        //double lineHeight = _paintHeightWithTextStyle(text, style ?? TextStyle(), maxWidth: constraint.maxWidth);
        double lineHeight =
            _paintHeightWithTextStyle('\n', style ?? TextStyle());
        print('maxHeight:$height,lineHeight:$lineHeight');
        int maxLine = height ~/ lineHeight + 1;
        maxLine = maxLine <= 0 ? 1 : maxLine;
        return Text(text, style: style, overflow: overflow, maxLines: maxLine);
      },
    );
  }

  double _paintHeightWithTextStyle(String text, TextStyle style,
      {double? maxWidth}) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: maxWidth ?? double.infinity);
    return textPainter.size.height;
  }
}
