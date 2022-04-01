import 'package:flutter/material.dart';
import 'package:flutter/src/gestures/events.dart';

/// @date 1/4/22
/// describe:
class HoverText extends StatefulWidget {
  final TextStyle? style;
  final String text;
  final Color hoverColor;
  final VoidCallback? onPressed;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;

  const HoverText(
    this.text, {
    Key? key,
    this.style,
    this.hoverColor = Colors.red,
    this.onPressed,
    this.textAlign,
    this.textDirection,
    this.maxLines,
  }) : super(key: key);

  @override
  _HoverTextState createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  TextStyle? _hoverStyle;
  TextStyle? _selectStyle;

  @override
  void initState() {
    super.initState();
    _selectStyle = widget.style;
    if (widget.style != null) {
      _hoverStyle = widget.style!.copyWith(color: widget.hoverColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      onHover: _onHover,
      child: GestureDetector(
        child: Text(
          widget.text,
          style: _selectStyle,
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          maxLines: widget.maxLines,
        ),
        onTap: widget.onPressed,
      ),
    );
  }

  void _onEnter(PointerEnterEvent event) {}

  void _onExit(PointerExitEvent event) {
    setState(
      () {
        _selectStyle = widget.style;
      },
    );
  }

  void _onHover(PointerHoverEvent event) {
    setState(() {
      _selectStyle = _hoverStyle;
    });
  }
}
