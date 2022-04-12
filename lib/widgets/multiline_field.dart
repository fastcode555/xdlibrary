import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_core/core.dart';

class MultilineField extends StatefulWidget {
  final String? text;
  final String? hintText;
  final bool obscureText;
  final int? maxLines;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Color? normalColor;
  final Color? focusColor;
  final TextEditingController? controller;
  final BoxDecoration? decoration;
  final BoxDecoration? focusDecoration;
  final FocusNode? focusNode;
  final TextStyle? style;
  final TextStyle? hintStyle;

  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? cancelCallBack;
  final VoidCallback? onEditingComplete;
  final FocusScopeNode? scopeNode; //全局焦点处理
  final int? maxLength; //输入框最多输入字符
  final String? exceedLimitTip; //超出限制提醒
  final bool enable;
  final Color? cursorColor;
  final EdgeInsetsGeometry? padding;
  final bool? readOnly;
  final ValueChanged<String>? onChanged;
  final TextAlign textAlign;

  const MultilineField({
    Key? key,
    this.text,
    this.obscureText = false,
    this.decoration,
    this.focusDecoration,
    this.maxLines,
    this.textInputAction = TextInputAction.done,
    this.normalColor,
    this.focusColor,
    this.onSubmitted,
    this.controller,
    this.hintText,
    this.focusNode,
    this.style,
    this.hintStyle,
    this.inputFormatters,
    this.onEditingComplete,
    this.cancelCallBack,
    this.scopeNode,
    this.maxLength,
    this.exceedLimitTip,
    this.keyboardType = TextInputType.text,
    this.enable = true,
    this.cursorColor,
    this.padding,
    this.readOnly = false,
    this.onChanged,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  _MultilineFieldState createState() => _MultilineFieldState();
}

class _MultilineFieldState extends State<MultilineField> {
  late TextEditingController _controller;
  bool _showHint = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (!TextUtil.isEmpty(widget.text)) {
      _controller.text = widget.text!;
    }
    _showHint = TextUtil.isEmpty(_controller.text);
    _controller.addListener(() {
      //自己实现限制输入长度
      if (widget.maxLength != null && widget.maxLength! > 0) {
        if (_controller.text.length > widget.maxLength!) {
          //限制提醒
          if (widget.exceedLimitTip != null) showToast(widget.exceedLimitTip ?? '');
          _controller.text = _controller.text.substring(0, widget.maxLength);
          //移动角标到最后位置
          _controller.selection = TextSelection.fromPosition(
            TextPosition(affinity: TextAffinity.downstream, offset: _controller.text.length),
          );
        }
      }
      //为解决柬埔寨语错位问题
      if (TextUtil.isEmpty(_controller.text) != _showHint) {
        setState(() {
          _showHint = TextUtil.isEmpty(_controller.text);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.padding != null ? Padding(child: _buildTextField(), padding: widget.padding!) : _buildTextField();
  }

  _buildTextField() {
    return TextField(
      readOnly: widget.readOnly!,
      focusNode: widget.focusNode,
      textAlign: widget.textAlign,
      onEditingComplete:
          widget.onEditingComplete ?? (widget.scopeNode != null ? () => widget.scopeNode?.nextFocus() : null),
      controller: _controller,
      //双击或长按报错
      //enableInteractiveSelection: false,
      maxLines: widget.maxLines,
      style: widget.style ?? const TextStyle(color: Colors.black),
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      //maxLength: widget.maxLength,自带的带有计数器
      cursorColor: widget.cursorColor,
      enabled: widget.enable,
      textInputAction: widget.textInputAction,
      //关闭自动联想功能,特别是输入密码的时候
      autocorrect: !Platform.isIOS,
      decoration: InputDecoration(
        focusColor: widget.focusColor,
        contentPadding: const EdgeInsets.only(top: 5),
        labelStyle: widget.hintStyle,
        hintStyle: widget.hintStyle,
        hintText: !_showHint ? null : widget.hintText,
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
      ),
      onChanged: (character) {
        if (widget.onChanged != null) {
          if (timer != null && timer!.isActive) timer!.cancel();
          timer = Timer(const Duration(seconds: 1), () {
            widget.onChanged?.call(character);
          });
        }
      },
      inputFormatters: widget.inputFormatters,
      onSubmitted: (v) {
        widget.onSubmitted?.call(v);
      },
    );
  }
}
