import 'package:flutter/material.dart';

class SeekBar extends StatefulWidget {
  final double progressWidth;
  final double thumbRadius;
  final double value;
  final double secondValue;
  final Color barColor;
  final Color progressColor;
  final Color secondProgressColor;
  final Color thumbColor;
  final Function? onStartTrackingTouch;
  final ValueChanged<double>? onProgressChanged;
  final ValueChanged<double>? onStopTrackingTouch;
  final Function? onTouchDown;
  final Function? onTouchUp;
  final bool secondCircleEnale;

  SeekBar({
    Key? key,
    this.progressWidth = 2.5,
    this.thumbRadius = 7.0,
    this.value = 0.0,
    this.secondValue = 0.0,
    this.barColor = Colors.green,
    this.progressColor = Colors.orange,
    this.secondProgressColor = Colors.orangeAccent,
    this.thumbColor = Colors.white,
    this.onStartTrackingTouch,
    this.onProgressChanged,
    this.onStopTrackingTouch,
    this.onTouchDown,
    this.onTouchUp,
    this.secondCircleEnale = false,
  }) : super(key: key);

  @override
  _SeekBarState createState() {
    return _SeekBarState();
  }
}

class _SeekBarState extends State<SeekBar> {
  Offset _touchPoint = Offset.zero;

  double _value = 0.0;
  double _secondValue = 0.0;

  bool _touchDown = false;

  _setValue() {
    _value = _touchPoint.dx / context.size!.width;
  }

  _checkTouchPoint() {
    if (_touchPoint.dx <= 0) {
      _touchPoint = Offset(0, _touchPoint.dy);
    }
    if (_touchPoint.dx >= context.size!.width) {
      _touchPoint = Offset(context.size!.width, _touchPoint.dy);
    }
  }

  @override
  void initState() {
    _value = widget.value > 1
        ? 1
        : widget.value < 0
            ? 0
            : widget.value;
    _secondValue = widget.secondValue > 1
        ? 1
        : widget.secondValue < 0
            ? 0
            : widget.secondValue;
    super.initState();
  }

  @override
  void didUpdateWidget(SeekBar oldWidget) {
    _value = _touchDown
        ? _value
        : widget.value > 1
            ? 1
            : widget.value < 0
                ? 0
                : widget.value;
    _secondValue = widget.secondValue > 1
        ? 1
        : widget.secondValue < 0
            ? 0
            : widget.secondValue;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragDown: (details) {
        widget.onTouchDown?.call();

        RenderBox box = context.findRenderObject() as RenderBox;
        _touchPoint = box.globalToLocal(details.globalPosition);
        _checkTouchPoint();
        setState(() {
          _setValue();
          _touchDown = true;
        });
        widget.onStartTrackingTouch?.call();
      },
      onTapUp: (detail) {
        _setValue();
        _touchDown = false;
        widget.onStopTrackingTouch?.call(_value);
      },
      onTapDown: (detail) {
        _touchDown = true;
        widget.onTouchDown?.call();
      },
      onHorizontalDragUpdate: (details) {
        RenderBox box = context.findRenderObject() as RenderBox;
        _touchPoint = box.globalToLocal(details.globalPosition);
        _checkTouchPoint();
        setState(() {
          _setValue();
        });
      },
      onHorizontalDragEnd: (details) {
        setState(() {
          _touchDown = false;
        });
        widget.onStopTrackingTouch?.call(_value);
      },
      child: Container(
        constraints: BoxConstraints.expand(height: widget.thumbRadius * 2),
        child: CustomPaint(
          painter: _SeekBarPainter(
            progressWidth: widget.progressWidth,
            thumbRadius: widget.thumbRadius,
            value: _value,
            secondValue: _secondValue,
            barColor: widget.barColor,
            progressColor: widget.progressColor,
            secondProgressColor: widget.secondProgressColor,
            thumbColor: widget.thumbColor,
            touchDown: _touchDown,
            secondCircleEnale: widget.secondCircleEnale,
          ),
        ),
      ),
    );
  }
}

class _SeekBarPainter extends CustomPainter {
  final double? progressWidth;
  final double? thumbRadius;
  final double? value;
  final double? secondValue;
  final Color? barColor;
  final Color? progressColor;
  final Color? secondProgressColor;
  final Color? thumbColor;
  final bool? touchDown;
  final bool secondCircleEnale;

  _SeekBarPainter({
    this.progressWidth,
    this.thumbRadius,
    this.value,
    this.secondValue,
    this.barColor,
    this.progressColor,
    this.secondProgressColor,
    this.thumbColor,
    this.touchDown,
    this.secondCircleEnale = false,
  });

  @override
  bool shouldRepaint(_SeekBarPainter old) {
    return value != old.value || secondValue != old.secondValue || touchDown != old.touchDown;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.square
      ..strokeWidth = progressWidth!;

    final centerY = size.height / 2.0;
    final barLength = size.width - thumbRadius! * 2.0;

    final Offset startPoint = Offset(thumbRadius!, centerY);
    final Offset endPoint = Offset(size.width - thumbRadius!, centerY);
    final Offset progressPoint = Offset(barLength * value! + thumbRadius!, centerY);
    final Offset secondProgressPoint = Offset(barLength * secondValue! + thumbRadius!, centerY);

    try {
      paint.color = barColor!;
      canvas.drawLine(startPoint, endPoint, paint);

      paint.color = secondProgressColor!;
      canvas.drawLine(startPoint, secondProgressPoint, paint);

      paint.color = progressColor!;

      canvas.drawLine(startPoint, progressPoint, paint);
      canvas.drawShadow(
          Path()
            ..moveTo(startPoint.dx, startPoint.dy)
            ..lineTo(progressPoint.dx, progressPoint.dy)
            ..close(),
          progressColor!,
          10,
          false);

      final Paint thumbPaint = Paint()..isAntiAlias = true;

      thumbPaint.color = Colors.transparent;
      canvas.drawCircle(progressPoint, centerY, thumbPaint);

      if (touchDown!) {
        thumbPaint.color = thumbColor!.withOpacity(0.6);
        canvas.drawCircle(progressPoint, thumbRadius!, thumbPaint);
      }
      if (secondCircleEnale) {
        thumbPaint.color = thumbColor!;
        canvas.drawCircle(progressPoint, thumbRadius! * 1.0, thumbPaint);
        thumbPaint.color = Colors.black45;
        canvas.drawCircle(progressPoint, thumbRadius! * 0.5, thumbPaint);
      } else {
        thumbPaint.color = Colors.white;
        canvas.drawCircle(progressPoint, thumbRadius! * 0.75, thumbPaint);
      }
    } catch (e) {}
  }
}
