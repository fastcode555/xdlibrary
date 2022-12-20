import 'dart:async';

import 'package:flutter/material.dart';

enum CountDownStatus {
  init, //初始化状态
  countDowning, //倒数计时
  resend, //重新发送状态
}

class CountDownWidget extends StatefulWidget {
  final Duration duration;
  final Duration interval;
  final Widget Function(
      CountDownStatus status, int leftTime, Function() countDown) builder;

  const CountDownWidget({
    Key? key,
    this.duration = const Duration(seconds: 60),
    this.interval = const Duration(seconds: 1),
    required this.builder,
  });

  @override
  _CountDownWidgetState createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {
  Timer? _timer;
  int _time = 0;
  int _interval = 0;
  CountDownStatus _status = CountDownStatus.init;

  @override
  Widget build(BuildContext context) {
    return widget.builder(_status, _time, _startCountDown);
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void _startCountDown() {
    _timer?.cancel();
    _time = widget.duration.inSeconds;
    _interval = widget.interval.inSeconds;
    _status = CountDownStatus.countDowning;
    if (mounted) setState(() {});
    _timer = Timer.periodic(widget.interval, (timer) {
      _time -= _interval;
      if (_time <= 0) {
        _time = 0;
        _status = CountDownStatus.resend;
      } else {
        _status = CountDownStatus.countDowning;
      }
      if (mounted) setState(() {});
    });
  }
}
