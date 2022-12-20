import 'package:flutter/material.dart';

/// @date 19/12/22
/// describe:

class HoverController {
  _OverlayHoverState? _state;

  void _bind(_OverlayHoverState state) {
    _state = state;
  }

  void show() {
    _state?._showOverlay();
  }

  void hide() {
    _state?._hideOverlay();
  }
}

class OverlayHover extends StatefulWidget {
  final Widget hoverWidget;
  final Widget child;
  final Alignment followerAnchor;
  final Alignment targetAnchor;
  final HoverController? controller;

  const OverlayHover({
    required this.child,
    required this.hoverWidget,
    Key? key,
    this.followerAnchor: Alignment.topCenter,
    this.targetAnchor: Alignment.bottomCenter,
    this.controller,
  }) : super(key: key);

  @override
  _OverlayHoverState createState() => _OverlayHoverState();
}

class _OverlayHoverState extends State<OverlayHover> {
  final LayerLink layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _show = false;
  bool _focusPanel = false;

  @override
  void initState() {
    super.initState();
    widget.controller?._bind(this);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: MouseRegion(
        onEnter: (_) {
          if (_show) return;
          if (!_show) {
            _showOverlay();
          }
        },
        onExit: (_) {
          Future.delayed(const Duration(milliseconds: 200), () {
            //没有聚焦在面板上
            if (!_focusPanel && _show) {
              _hideOverlay();
            }
          });
        },
        child: widget.child,
      ),
    );
  }

  void _showOverlay() {
    _show = true;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _show = false;
    _focusPanel = false;
    _overlayEntry?.remove();
  }

  OverlayEntry _createOverlayEntry() => OverlayEntry(
        builder: (BuildContext context) => UnconstrainedBox(
          child: CompositedTransformFollower(
            link: layerLink,
            followerAnchor: widget.followerAnchor,
            targetAnchor: widget.targetAnchor,
            child: MouseRegion(
              onEnter: (_) {
                _focusPanel = true;
              },
              onExit: (_) {
                if (_show) {
                  _hideOverlay();
                }
              },
              child: widget.hoverWidget,
            ),
          ),
        ),
      );
}
