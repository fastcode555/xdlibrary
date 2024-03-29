import 'package:flutter/material.dart';

/// @date 20/4/22
/// describe:
class CBox extends StatefulWidget {
  final Duration duration;
  final Decoration? decoration;
  final Decoration? focus;
  final ValueChanged<bool>? onChanged;
  final bool value;
  final double? size;
  final double? iconSize;
  final Color iconColor;
  final Color? activeColor;
  final Widget? child;

  const CBox({
    Key? key,
    this.duration = const Duration(milliseconds: 300),
    this.onChanged,
    this.size = 38,
    this.value = false,
    this.iconSize,
    this.iconColor = Colors.white,
    this.activeColor,
    this.child,
    this.decoration = const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(3)),
      border:
          Border.fromBorderSide(BorderSide(color: Colors.black54, width: 0.5)),
    ),
    this.focus,
  }) : super(key: key);

  const CBox.circle({
    Key? key,
    this.duration = const Duration(milliseconds: 300),
    this.onChanged,
    this.size = 38,
    this.value = false,
    this.iconSize,
    this.iconColor = Colors.white,
    this.activeColor,
    this.child,
    this.decoration = const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border:
          Border.fromBorderSide(BorderSide(color: Colors.black54, width: 0.5)),
    ),
    this.focus,
  }) : super(key: key);

  @override
  _CboxState createState() => _CboxState();
}

class _CboxState extends State<CBox> {
  bool _value = false;
  Decoration? _focus;

  Decoration? get _normal => widget.decoration;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant CBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    Widget box = AnimatedContainer(
      width: widget.size,
      height: widget.size,
      duration: widget.duration,
      decoration: _value ? getFocus() : _normal,
      child: Center(
        child: Visibility(
          visible: _value,
          child: Icon(
            Icons.done_rounded,
            color: widget.iconColor,
            size: widget.iconSize ?? (widget.size! * 0.65),
          ),
        ),
      ),
    );
    if (widget.child != null) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _value = !_value;
          });
          widget.onChanged?.call(_value);
        },
        child: Row(
          children: [box, widget.child!],
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          _value = !_value;
        });
        widget.onChanged?.call(_value);
      },
      child: box,
    );
  }

  Decoration getFocus() {
    if (widget.focus != null) return widget.focus!;
    if (_focus != null) return _focus!;
    var _borderRadius;
    var _shape;
    var _border;
    if (widget.decoration is BoxDecoration) {
      BoxDecoration _boxDer = widget.decoration as BoxDecoration;
      _borderRadius = _boxDer.borderRadius;
      _shape = _boxDer.shape;
      _border = _boxDer.border;
    }
    _focus = BoxDecoration(
        color: widget.activeColor ?? Theme.of(context).primaryColor,
        borderRadius: _borderRadius,
        shape: _shape,
        border: _border
        //border: Border.fromBorderSide(BorderSide(color: Colors.black54, width: 0.5)),
        );
    return _focus!;
  }
}
