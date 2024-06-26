import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;
const double _kMenuHorizontalPadding = 16.0;
const double _kMenuDividerHeight = 16.0;
const double _kMenuMaxWidth = 5.0 * _kMenuWidthStep;
const double _kMenuMinWidth = 2.0 * _kMenuWidthStep;
const double _kMenuVerticalPadding = 8.0;
const double _kMenuWidthStep = 56.0;
const double _kMenuScreenPadding = 8.0;

abstract class PopupMenusEntry<T> extends StatefulWidget {
  const PopupMenusEntry({Key? key}) : super(key: key);

  double get height;

  bool represents(T? value);
}

class PopupMenusDivider extends PopupMenusEntry<Never> {
  const PopupMenusDivider({Key? key, this.height = _kMenuDividerHeight}) : super(key: key);

  @override
  final double height;

  @override
  bool represents(void value) => false;

  @override
  State<PopupMenusDivider> createState() => _PopupMenusDividerState();
}

class _PopupMenusDividerState extends State<PopupMenusDivider> {
  @override
  Widget build(BuildContext context) => Divider(height: widget.height);
}

class _MenuItem extends SingleChildRenderObjectWidget {
  const _MenuItem({
    Key? key,
    required this.onLayout,
    required Widget? child,
  })  : assert(onLayout != null),
        super(key: key, child: child);

  final ValueChanged<Size> onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMenuItem(onLayout);
  }

  @override
  void updateRenderObject(BuildContext context, covariant _RenderMenuItem renderObject) {
    renderObject.onLayout = onLayout;
  }
}

class _RenderMenuItem extends RenderShiftedBox {
  _RenderMenuItem(this.onLayout, [RenderBox? child])
      : assert(onLayout != null),
        super(child);

  ValueChanged<Size> onLayout;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child == null) {
      return Size.zero;
    }
    return child!.getDryLayout(constraints);
  }

  @override
  void performLayout() {
    if (child == null) {
      size = Size.zero;
    } else {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      childParentData.offset = Offset.zero;
    }
    onLayout(size);
  }
}

class PopupMenusItem<T> extends PopupMenusEntry<T> {
  const PopupMenusItem({
    Key? key,
    this.value,
    this.onTap,
    this.enabled = true,
    this.height = kMinInteractiveDimension,
    this.padding,
    this.textStyle,
    this.mouseCursor,
    required this.child,
  })  : assert(enabled != null),
        assert(height != null),
        super(key: key);

  final T? value;

  final VoidCallback? onTap;

  final bool enabled;

  @override
  final double height;

  final EdgeInsets? padding;

  final TextStyle? textStyle;

  final MouseCursor? mouseCursor;

  final Widget? child;

  @override
  bool represents(T? value) => value == this.value;

  @override
  PopupMenusItemState<T, PopupMenusItem<T>> createState() => PopupMenusItemState<T, PopupMenusItem<T>>();
}

class PopupMenusItemState<T, W extends PopupMenusItem<T>> extends State<W> {
  @protected
  Widget? buildChild() => widget.child;

  @protected
  void handleTap() {
    widget.onTap?.call();

    Navigator.pop<T>(context, widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PopupMenuThemeData popupMenusTheme = PopupMenuTheme.of(context);
    TextStyle style = widget.textStyle ?? popupMenusTheme.textStyle ?? theme.textTheme.titleMedium!;

    if (!widget.enabled) style = style.copyWith(color: theme.disabledColor);

    Widget item = AnimatedDefaultTextStyle(
      style: style,
      duration: kThemeChangeDuration,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        constraints: BoxConstraints(minHeight: widget.height),
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: _kMenuHorizontalPadding),
        child: buildChild(),
      ),
    );

    if (!widget.enabled) {
      final bool isDark = theme.brightness == Brightness.dark;
      item = IconTheme.merge(
        data: IconThemeData(opacity: isDark ? 0.5 : 0.38),
        child: item,
      );
    }
    final MouseCursor effectiveMouseCursor = MaterialStateProperty.resolveAs<MouseCursor>(
      widget.mouseCursor ?? MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!widget.enabled) MaterialState.disabled,
      },
    );

    return MergeSemantics(
      child: Semantics(
        enabled: widget.enabled,
        button: true,
        child: InkWell(
          onTap: widget.enabled ? handleTap : null,
          canRequestFocus: widget.enabled,
          mouseCursor: effectiveMouseCursor,
          child: item,
        ),
      ),
    );
  }
}

class CheckedPopupMenusItem<T> extends PopupMenusItem<T> {
  const CheckedPopupMenusItem({
    Key? key,
    T? value,
    this.checked = false,
    bool enabled = true,
    EdgeInsets? padding,
    double height = kMinInteractiveDimension,
    Widget? child,
  })  : assert(checked != null),
        super(
          key: key,
          value: value,
          enabled: enabled,
          padding: padding,
          height: height,
          child: child,
        );

  final bool checked;

  @override
  Widget? get child => super.child;

  @override
  PopupMenusItemState<T, CheckedPopupMenusItem<T>> createState() => _CheckedPopupMenusItemState<T>();
}

class _CheckedPopupMenusItemState<T> extends PopupMenusItemState<T, CheckedPopupMenusItem<T>>
    with SingleTickerProviderStateMixin {
  static const Duration _fadeDuration = Duration(milliseconds: 150);
  late AnimationController _controller;

  Animation<double> get _opacity => _controller.view;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _fadeDuration, vsync: this)
      ..value = widget.checked ? 1.0 : 0.0
      ..addListener(() => setState(() {
            /* animation changed */
          }));
  }

  @override
  void handleTap() {
    // This fades the checkmark in or out when tapped.
    if (widget.checked)
      _controller.reverse();
    else
      _controller.forward();
    super.handleTap();
  }

  @override
  Widget buildChild() {
    return ListTile(
      enabled: widget.enabled,
      leading: FadeTransition(
        opacity: _opacity,
        child: Icon(_controller.isDismissed ? null : Icons.done),
      ),
      title: widget.child,
    );
  }
}

class _PopupMenus<T> extends StatelessWidget {
  const _PopupMenus({
    Key? key,
    required this.route,
    required this.semanticLabel,
  }) : super(key: key);

  final _PopupMenusRoute<T> route;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final double unit = 1.0 / (route.items.length + 1.5); // 1.0 for the width and 0.5 for the last item's fade.
    final List<Widget> children = <Widget>[];
    final PopupMenuThemeData popupMenusTheme = PopupMenuTheme.of(context);

    for (int i = 0; i < route.items.length; i += 1) {
      final double start = (i + 1) * unit;
      final double end = (start + 1.5 * unit).clamp(0.0, 1.0);
      final CurvedAnimation opacity = CurvedAnimation(
        parent: route.animation!,
        curve: Interval(start, end),
      );
      Widget item = route.items[i];
      if (route.initialValue != null && route.items[i].represents(route.initialValue)) {
        item = Container(
          color: Theme.of(context).highlightColor,
          child: item,
        );
      }
      children.add(
        _MenuItem(
          onLayout: (Size size) {
            route.itemSizes[i] = size;
          },
          child: FadeTransition(
            opacity: opacity,
            child: item,
          ),
        ),
      );
    }

    final CurveTween opacity = CurveTween(curve: const Interval(0.0, 1.0 / 3.0));
    final CurveTween width = CurveTween(curve: Interval(0.0, unit));
    final CurveTween height = CurveTween(curve: Interval(0.0, unit * route.items.length));

    final Widget child = ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: _kMenuMinWidth,
        maxWidth: _kMenuMaxWidth,
      ),
      child: IntrinsicWidth(
        stepWidth: _kMenuWidthStep,
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: semanticLabel,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: _kMenuVerticalPadding,
            ),
            child: ListBody(children: children),
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: route.animation!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: opacity.animate(route.animation!),
          child: Material(
            shape: route.shape ?? popupMenusTheme.shape,
            color: route.blur ? Colors.transparent : route.color ?? popupMenusTheme.color,
            type: MaterialType.card,
            elevation: route.elevation ?? popupMenusTheme.elevation ?? 8.0,
            child: _buildBlurWidget(width, height, child, popupMenusTheme),
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildBlurWidget(CurveTween width, CurveTween height, Widget? child, PopupMenuThemeData popupMenusTheme) {
    if (route.blur) {
      return Align(
        alignment: AlignmentDirectional.topEnd,
        widthFactor: width.evaluate(route.animation!),
        heightFactor: height.evaluate(route.animation!),
        child: ClipRRect(
          borderRadius: _getBorderRadius(popupMenusTheme) ?? BorderRadius.zero,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: route.color ?? popupMenusTheme.color, child: child),
          ),
        ),
      );
    }
    return Align(
      alignment: AlignmentDirectional.topEnd,
      widthFactor: width.evaluate(route.animation!),
      heightFactor: height.evaluate(route.animation!),
      child: child,
    );
  }

  BorderRadiusGeometry? _getBorderRadius(PopupMenuThemeData popupMenusTheme) {
    ShapeBorder? border = route.shape ?? popupMenusTheme.shape;
    if (border == null) return null;
    if (border is RoundedRectangleBorder) {
      return border.borderRadius;
    }
    return null;
  }
}

// Positioning of the menu on the screen.
class _PopupMenusRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenusRouteLayout(
    this.position,
    this.itemSizes,
    this.selectedItemIndex,
    this.textDirection,
    this.padding,
  );

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  // The sizes of each item are computed when the menu is laid out, and before
  // the route is laid out.
  List<Size?> itemSizes;

  // The index of the selected item, or null if PopupMenusButton.initialValue
  // was not specified.
  final int? selectedItemIndex;

  // Whether to prefer going to the left or to the right.
  final TextDirection textDirection;

  // The padding of unsafe area.
  EdgeInsets padding;

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest).deflate(
      const EdgeInsets.all(_kMenuScreenPadding) + padding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    final double buttonHeight = size.height - position.top - position.bottom;
    // Find the ideal vertical position.
    double y = position.top;
    if (selectedItemIndex != null && itemSizes != null) {
      double selectedItemOffset = _kMenuVerticalPadding;
      for (int index = 0; index < selectedItemIndex!; index += 1) selectedItemOffset += itemSizes[index]!.height;
      selectedItemOffset += itemSizes[selectedItemIndex!]!.height / 2;
      y = y + buttonHeight / 2.0 - selectedItemOffset;
    }

    // Find the ideal horizontal position.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    } else {
      // Menu button is equidistant from both edges, so grow in reading direction.
      assert(textDirection != null);
      switch (textDirection) {
        case TextDirection.rtl:
          x = size.width - position.right - childSize.width;
          break;
        case TextDirection.ltr:
          x = position.left;
          break;
      }
    }

    // Avoid going outside an area defined as the rectangle 8.0 pixels from the
    // edge of the screen in every direction.
    if (x < _kMenuScreenPadding + padding.left)
      x = _kMenuScreenPadding + padding.left;
    else if (x + childSize.width > size.width - _kMenuScreenPadding - padding.right)
      x = size.width - childSize.width - _kMenuScreenPadding - padding.right;
    if (y < _kMenuScreenPadding + padding.top)
      y = _kMenuScreenPadding + padding.top;
    else if (y + childSize.height > size.height - _kMenuScreenPadding - padding.bottom)
      y = size.height - padding.bottom - _kMenuScreenPadding - childSize.height;

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenusRouteLayout oldDelegate) {
    // If called when the old and new itemSizes have been initialized then
    // we expect them to have the same length because there's no practical
    // way to change length of the items list once the menu has been shown.
    assert(itemSizes.length == oldDelegate.itemSizes.length);

    return position != oldDelegate.position ||
        selectedItemIndex != oldDelegate.selectedItemIndex ||
        textDirection != oldDelegate.textDirection ||
        !listEquals(itemSizes, oldDelegate.itemSizes) ||
        padding != oldDelegate.padding;
  }
}

class _PopupMenusRoute<T> extends PopupRoute<T> {
  _PopupMenusRoute({
    required this.position,
    required this.items,
    this.initialValue,
    this.elevation,
    required this.barrierLabel,
    this.semanticLabel,
    this.shape,
    this.color,
    this.blur = false,
    required this.capturedThemes,
  }) : itemSizes = List<Size?>.filled(items.length, null);

  final RelativeRect position;
  final List<PopupMenusEntry<T>> items;
  final List<Size?> itemSizes;
  final T? initialValue;
  final double? elevation;
  final String? semanticLabel;
  final ShapeBorder? shape;
  final Color? color;
  final bool blur;
  final CapturedThemes capturedThemes;

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linear,
      reverseCurve: const Interval(0.0, _kMenuCloseIntervalEnd),
    );
  }

  @override
  Duration get transitionDuration => _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    int? selectedItemIndex;
    if (initialValue != null) {
      for (int index = 0; selectedItemIndex == null && index < items.length; index += 1) {
        if (items[index].represents(initialValue)) selectedItemIndex = index;
      }
    }

    final Widget menu = _PopupMenus<T>(route: this, semanticLabel: semanticLabel);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _PopupMenusRouteLayout(
              position,
              itemSizes,
              selectedItemIndex,
              Directionality.of(context),
              mediaQuery.padding,
            ),
            child: capturedThemes.wrap(menu),
          );
        },
      ),
    );
  }
}

Future<T?> showMenu<T>({
  required BuildContext context,
  required RelativeRect position,
  required List<PopupMenusEntry<T>> items,
  T? initialValue,
  double? elevation,
  String? semanticLabel,
  ShapeBorder? shape,
  Color? color,
  bool blur = false,
  bool useRootNavigator = false,
}) {
  assert(context != null);
  assert(position != null);
  assert(useRootNavigator != null);
  assert(items != null && items.isNotEmpty);
  assert(debugCheckHasMaterialLocalizations(context));

  switch (Theme.of(context).platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      break;
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      semanticLabel ??= MaterialLocalizations.of(context).popupMenuLabel;
  }

  final NavigatorState navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  return navigator.push(_PopupMenusRoute<T>(
    position: position,
    items: items,
    initialValue: initialValue,
    elevation: elevation,
    semanticLabel: semanticLabel,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    shape: shape,
    color: color,
    blur: blur,
    capturedThemes: InheritedTheme.capture(from: context, to: navigator.context),
  ));
}

typedef PopupMenusItemSelected<T> = void Function(T value);

typedef PopupMenusCanceled = void Function();

typedef PopupMenusItemBuilder<T> = List<PopupMenusEntry<T>> Function(BuildContext context);

typedef PoupMenusOffsetBuilder = Offset Function(bool isTop);

typedef ContextBuilder = BuildContext Function();

class PopupMenusButton<T> extends StatefulWidget {
  final bool blur;

  const PopupMenusButton({
    Key? key,
    required this.itemBuilder,
    this.initialValue,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.elevation,
    this.padding = const EdgeInsets.all(8.0),
    this.child,
    this.icon,
    this.iconSize,
    this.offsetBuilder,
    this.enabled = true,
    this.shape,
    this.color,
    this.blur = false,
    this.enableFeedback,
    required this.builder,
  })  : assert(
          !(child != null && icon != null),
          'You can only pass [child] or [icon], not both.',
        ),
        super(key: key);

  final PopupMenusItemBuilder<T> itemBuilder;

  final T? initialValue;

  final PopupMenusItemSelected<T>? onSelected;

  final PopupMenusCanceled? onCanceled;

  final String? tooltip;

  final double? elevation;

  final EdgeInsetsGeometry padding;

  final Widget? child;

  final Widget? icon;

  final PoupMenusOffsetBuilder? offsetBuilder;
  final bool enabled;

  final ShapeBorder? shape;

  final Color? color;

  final bool? enableFeedback;

  final double? iconSize;

  //指定显示的widget的context
  final ContextBuilder builder;

  @override
  PopupMenusButtonState<T> createState() => PopupMenusButtonState<T>();
}

class PopupMenusButtonState<T> extends State<PopupMenusButton<T>> {
  static bool _isTop = false;

  void _caculateOffsetY() {
    BuildContext _parentContext = widget.builder();
    RenderBox? box = _parentContext.findRenderObject()! as RenderBox;
    Offset _offset = const Offset(0, 0);
    _offset = box.localToGlobal(_offset);

    double height = window.physicalSize.height / MediaQuery.of(context).devicePixelRatio;
    _isTop = _offset.dy < height / 2;
  }

  void showButtonMenu() {
    final PopupMenuThemeData popupMenusTheme = PopupMenuTheme.of(context);
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    _caculateOffsetY();
    Offset _offset = widget.offsetBuilder?.call(_isTop) ?? Offset.zero;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(_offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + _offset, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    final List<PopupMenusEntry<T>> items = widget.itemBuilder(context);
    // Only show the menu if there is something to show
    if (items.isNotEmpty) {
      showMenu<T?>(
        context: context,
        elevation: widget.elevation ?? popupMenusTheme.elevation,
        items: items,
        initialValue: widget.initialValue,
        position: position,
        blur: widget.blur,
        shape: widget.shape ?? popupMenusTheme.shape,
        color: widget.color ?? popupMenusTheme.color,
      ).then<void>((T? newValue) {
        if (!mounted) return null;
        if (newValue == null) {
          widget.onCanceled?.call();
          return null;
        }
        widget.onSelected?.call(newValue);
      });
    }
  }

  bool get _canRequestFocus {
    final NavigationMode mode = MediaQuery.maybeOf(context)?.navigationMode ?? NavigationMode.traditional;
    switch (mode) {
      case NavigationMode.traditional:
        return widget.enabled;
      case NavigationMode.directional:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool enableFeedback = widget.enableFeedback ?? PopupMenuTheme.of(context).enableFeedback ?? true;

    assert(debugCheckHasMaterialLocalizations(context));

    if (widget.child != null) {
      return Tooltip(
        message: widget.tooltip ?? MaterialLocalizations.of(context).showMenuTooltip,
        child: InkWell(
          onTap: widget.enabled ? showButtonMenu : null,
          canRequestFocus: _canRequestFocus,
          enableFeedback: enableFeedback,
          child: widget.child,
        ),
      );
    }

    return IconButton(
      icon: widget.icon ?? Icon(Icons.adaptive.more),
      padding: widget.padding,
      iconSize: widget.iconSize ?? 24.0,
      tooltip: widget.tooltip ?? MaterialLocalizations.of(context).showMenuTooltip,
      onPressed: widget.enabled ? showButtonMenu : null,
      enableFeedback: enableFeedback,
    );
  }
}
