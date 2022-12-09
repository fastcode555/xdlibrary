import 'package:flutter/material.dart';

/// @date 8/12/22
/// describe:
//分成两边的Widget
class SplitWidget extends StatelessWidget {
  final double contentPadding;
  final Widget left;
  final Widget right;
  final int leftFlex;
  final int rightFlex;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment crossAxisAlignment;

  const SplitWidget({
    Key? key,
    required this.left,
    required this.right,
    this.contentPadding = 30,
    this.leftFlex = 1,
    this.rightFlex = 1,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Expanded(child: left, flex: leftFlex),
        const SizedBox(width: 30),
        Expanded(child: right, flex: rightFlex),
      ],
    );
    if (padding != null) {
      return Padding(padding: padding!, child: child);
    }
    return child;
  }
}
