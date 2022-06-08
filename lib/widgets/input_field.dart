import 'dart:async';
import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:xdlibrary/widgets/xdlibrary_config.dart';

class InputField extends StatefulWidget {
  final String? text;
  final String? hintText;
  final bool obscureText;
  final int? maxLines;
  final double height;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Color? normalColor;
  final Color? focusColor;
  final TextEditingController? controller;
  final Decoration? decoration;
  final Decoration? focusDecoration;
  final bool leftIconEnable;
  final FocusNode? focusNode;
  final Widget? leftWidget;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final Widget? clearWidget;
  final EdgeInsetsGeometry? lablePadding;

  final Color? backGroundColor;
  final bool nonDecoration;
  final double? contentPadding;
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
  final InputBorder? inputBorder;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final Widget? rightWidget;

  //当clearWidget显示或消失都会引起变化，故当clearWidget不显示时，用replacement占位
  final Widget? replacement;
  final TextAlign textAlign;
  final bool showClear;
  final String? labelText;
  final double? width;
  final bool onChangeDelay;
  final int delayDuration;

  const InputField.search({
    Key? key,
    this.text,
    this.obscureText = false,
    this.decoration,
    this.focusDecoration,
    this.maxLines = 1,
    this.height = 48,
    this.width,
    this.textInputAction = TextInputAction.search,
    this.normalColor,
    this.focusColor,
    this.onSubmitted,
    this.controller,
    this.hintText,
    this.focusNode,
    this.style,
    this.hintStyle,
    this.leftWidget,
    this.rightWidget,
    this.leftIconEnable = true,
    this.nonDecoration = false,
    this.backGroundColor,
    this.keyboardType = TextInputType.text,
    this.onEditingComplete,
    this.contentPadding,
    this.inputFormatters,
    this.maxLength,
    this.cancelCallBack,
    this.scopeNode,
    this.exceedLimitTip,
    this.enable = true,
    this.cursorColor,
    this.padding,
    this.readOnly = false,
    this.onChanged,
    this.textAlign = TextAlign.start,
    this.clearWidget,
    this.labelText,
    this.lablePadding,
    this.replacement,
    this.showClear = true,
    this.onChangeDelay = false,
    this.delayDuration = 1000,
    this.inputBorder = const OutlineInputBorder(borderSide: BorderSide.none),
    this.enabledBorder = const OutlineInputBorder(borderSide: BorderSide.none),
    this.focusedBorder = const OutlineInputBorder(borderSide: BorderSide.none),
  }) : super(key: key);

  const InputField({
    Key? key,
    this.text,
    this.obscureText = false,
    this.decoration,
    this.focusDecoration,
    this.maxLines = 1,
    this.height = 48,
    this.width,
    this.textInputAction = TextInputAction.done,
    this.normalColor,
    this.focusColor,
    this.onSubmitted,
    this.controller,
    this.hintText,
    this.focusNode,
    this.style,
    this.hintStyle,
    this.leftIconEnable = false,
    this.leftWidget,
    this.rightWidget,
    this.backGroundColor,
    this.nonDecoration = false,
    this.contentPadding,
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
    this.clearWidget,
    this.labelText,
    this.lablePadding,
    this.replacement,
    this.showClear = true,
    this.onChangeDelay = false,
    this.delayDuration = 1000,
    this.inputBorder = const OutlineInputBorder(borderSide: BorderSide.none),
    this.enabledBorder = const OutlineInputBorder(borderSide: BorderSide.none),
    this.focusedBorder = const OutlineInputBorder(borderSide: BorderSide.none),
  }) : super(key: key);

  const InputField.noneDecoration({
    Key? key,
    this.text,
    this.obscureText = false,
    this.decoration,
    this.focusDecoration,
    this.maxLines = 1,
    this.height = 48,
    this.width,
    this.textInputAction = TextInputAction.next,
    this.normalColor,
    this.focusColor = const Color(0xfff5f5f7),
    this.onSubmitted,
    this.controller,
    this.hintText,
    this.style,
    this.hintStyle,
    this.focusNode,
    this.leftWidget,
    this.rightWidget,
    this.backGroundColor,
    this.leftIconEnable = false,
    this.nonDecoration = true,
    this.keyboardType = TextInputType.text,
    this.contentPadding,
    this.onEditingComplete,
    this.inputFormatters,
    this.cancelCallBack,
    this.maxLength,
    this.scopeNode,
    this.exceedLimitTip,
    this.enable = true,
    this.cursorColor,
    this.padding,
    this.readOnly = false,
    this.onChanged,
    this.textAlign = TextAlign.start,
    this.clearWidget,
    this.showClear = true,
    this.labelText,
    this.lablePadding,
    this.replacement,
    this.onChangeDelay = false,
    this.delayDuration = 1000,
    this.inputBorder = const OutlineInputBorder(borderSide: BorderSide.none),
    this.enabledBorder = const OutlineInputBorder(borderSide: BorderSide.none),
    this.focusedBorder = const OutlineInputBorder(borderSide: BorderSide.none),
  }) : super(key: key);

  const InputField.border({
    Key? key,
    this.text,
    this.obscureText = false,
    this.decoration,
    this.focusDecoration,
    this.maxLines = 1,
    this.height = 48,
    this.width,
    this.textInputAction = TextInputAction.next,
    this.normalColor,
    this.focusColor = const Color(0xfff5f5f7),
    this.onSubmitted,
    this.controller,
    this.hintText,
    this.style,
    this.hintStyle,
    this.focusNode,
    this.leftWidget,
    this.rightWidget,
    this.backGroundColor,
    this.leftIconEnable = false,
    this.nonDecoration = true,
    this.keyboardType = TextInputType.text,
    this.contentPadding,
    this.onEditingComplete,
    this.inputFormatters,
    this.cancelCallBack,
    this.maxLength,
    this.scopeNode,
    this.exceedLimitTip,
    this.enable = true,
    this.cursorColor,
    this.padding,
    this.readOnly = false,
    this.onChanged,
    this.textAlign = TextAlign.start,
    this.clearWidget,
    this.showClear = true,
    this.labelText,
    this.lablePadding,
    this.replacement,
    //为空就会使用成默认的const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    this.inputBorder,
    this.enabledBorder,
    this.focusedBorder,
    this.onChangeDelay = false,
    this.delayDuration = 1000,
  }) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late FocusNode _focusNode;

  late TextEditingController _controller;
  bool _isShowClean = false;
  bool _showHint = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_focusNodeListener);
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

  Future<void> _focusNodeListener() async {
    if (_focusNode.hasFocus && _controller.text.isNotEmpty) {
      setState(() {
        _isShowClean = true;
      });
    } else {
      setState(() {
        _isShowClean = false;
      });
    }
  }

  @override
  void didUpdateWidget(InputField oldWidget) {
    if (_focusNode.hasFocus && _controller.text.isNotEmpty) {
      _isShowClean = true;
    } else {
      _isShowClean = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.padding != null ? Padding(child: _buildTextField(), padding: widget.padding!) : _buildTextField();
  }

  _buildTextField() {
    return Container(
      height: widget.height,
      width: widget.width,
      padding: EdgeInsets.only(left: widget.contentPadding ?? XdLibraryConfig.instance.inputFieldPadding),
      decoration: widget.nonDecoration ? null : _itemDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.leftIconEnable) widget.leftWidget ?? Icon(Icons.search, size: 16, color: _iconColor),
          if (widget.leftIconEnable) const SizedBox(width: 5),
          Expanded(
            child: TextField(
              readOnly: widget.readOnly!,
              focusNode: _focusNode,
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
                contentPadding: widget.lablePadding ?? (widget.labelText == "" ? null : const EdgeInsets.only(top: 5)),
                labelText: widget.labelText,
                labelStyle: widget.hintStyle,
                hintStyle: widget.hintStyle,
                hintText: !_showHint ? null : widget.hintText,
                border: widget.inputBorder,
                enabledBorder: widget.enabledBorder,
                focusedBorder: widget.focusedBorder,
                suffixIcon: _buildSuffixIcon(),
              ),
              onChanged: (character) {
                if (widget.onChangeDelay) {
                  if (widget.onChanged != null) {
                    if (timer != null && timer!.isActive) timer!.cancel();
                    timer = Timer(Duration(microseconds: widget.delayDuration), () {
                      widget.onChanged?.call(character);
                    });
                  }
                } else {
                  widget.onChanged?.call(character);
                }
                setState(() => _isShowClean = character.isNotEmpty);
              },
              inputFormatters: widget.inputFormatters,
              onSubmitted: (v) {
                setState(() => _isShowClean = false);
                widget.onSubmitted?.call(v);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildCancelButton() {
    return _isShowClean && widget.showClear
        ? GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Container(
              child: widget.clearWidget ??
                  XdLibraryConfig.instance.deleteWidgetBuilder?.call(null) ??
                  Icon(Icons.cancel, size: 16, color: _iconColor),
            ),
            onTap: () {
              // 保证在组件build的第一帧时才去触发取消清空内
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                _controller.clear();
                widget.onChanged?.call("");
              });
              widget.cancelCallBack?.call();
              setState(() {
                _isShowClean = false;
              });
            },
          )
        : null;
  }

  Widget? _buildSuffixIcon() {
    Widget cancelWidget = _buildCancelButton() ?? widget.replacement ?? const SizedBox(height: 16);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        cancelWidget,
        if (widget.rightWidget != null) widget.rightWidget!,
      ],
    );
  }

  get _iconColor => _focusNode.hasFocus ? Colors.black87 : Colors.black12;

  Decoration get _itemDecoration {
    if (_focusNode.hasFocus) {
      return widget.focusDecoration ??
          widget.decoration ??
          BoxDecoration(
            color: widget.focusColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          );
    } else {
      return widget.decoration ??
          BoxDecoration(
            color: _focusNode.hasFocus ? widget.focusColor : (widget.normalColor ?? widget.focusColor),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          );
    }
  }
}
