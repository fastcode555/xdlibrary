import 'package:flutter/material.dart';
import 'package:xdlibrary/widgets/xdlibrary_config.dart';

/// 星星视图的自定义构造器
/// state，[RatingState] 星星状态
typedef RatingStarBuilder = Widget Function(RatingState state);

enum RatingState {
  /// 半颗
  half,

  /// 未选
  unselect,

  /// 已选
  select,
}

/// 星级评分控件，支持：
///
/// * 可自定义图片、颜色、大小、间距
/// * 支持点击选中
/// * 支持是否限制评分最少一颗星，即第一颗星支持是否可反选
/// * 支持半颗星（仅支持展示，不支持选择）
class RatingStar extends StatefulWidget {
  static const DEFAULT_COUNT = 5;
  static const DEFAULT_SPACE = 1.0;

  /// 星星的总数，默认为 5 颗
  final int count;

  /// 初始选中个数
  final double selectedCount;

  /// 星星间的水平间距，默认为 1.0
  final double space;

  /// 是否可评 0 颗星，即第一颗星是否支持反选，默认不可评 0 星
  final bool canRatingZero;

  /// 单颗星星视图的自定义构造器
  final RatingStarBuilder? starBuilder;

  /// 如果设置了，就支持编辑
  final ValueChanged<double>? onSelected;
  final Color? color;
  final Color? activeColor;
  final double size;

  const RatingStar({
    Key? key,
    this.count = DEFAULT_COUNT,
    this.selectedCount = 0,
    this.space = DEFAULT_SPACE,
    this.starBuilder,
    this.onSelected,
    this.color = const Color(0xFFF0F0F0),
    this.activeColor,
    this.canRatingZero = false,
    this.size = 16.0,
  }) : super(key: key);

  @override
  _RatingStarState createState() => _RatingStarState();
}

class _RatingStarState extends State<RatingStar> {
  late double currSelected;

  @override
  void initState() {
    super.initState();
    currSelected = widget.selectedCount;
  }

  @override
  void didUpdateWidget(RatingStar oldWidget) {
    currSelected = widget.selectedCount;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _getContent(),
    );
  }

  List<Widget> _getContent() {
    List<Widget> list = [];
    for (var i = 0; i < widget.count; i++) {
      RatingState state;
      if (i < currSelected.floor()) {
        state = RatingState.select;
      } else if (i == currSelected.floor() && i < currSelected.ceil()) {
        state = RatingState.half;
      } else {
        state = RatingState.unselect;
      }
      var rating = widget.starBuilder != null ? widget.starBuilder!(state) : _buildRating(state);

      if (widget.onSelected != null) {
        list.add(GestureDetector(
          child: rating,
          onTap: () {
            // 反选第一个
            if (i == 0 && currSelected == 1 && widget.canRatingZero) {
              currSelected = 0;
            } else {
              currSelected = (i + 1).toDouble();
            }
            widget.onSelected!(currSelected);
            setState(() {});
          },
          behavior: HitTestBehavior.opaque,
        ));
      } else {
        list.add(rating);
      }

      if (i != widget.count - 1) {
        list.add(SizedBox(width: widget.space, height: 1));
      }
    }
    return list;
  }

  Widget _buildRating(RatingState state) {
    if (XdLibraryConfig.instance.ratingBarBuilder != null) {
      return XdLibraryConfig.instance.ratingBarBuilder!(state, widget.size, widget.color, widget.activeColor);
    }
    switch (state) {
      case RatingState.select:
        return Icon(Icons.star, color: widget.activeColor, size: widget.size);
      case RatingState.half:
        return Icon(Icons.star_half_rounded, color: widget.activeColor, size: widget.size);
      case RatingState.unselect:
      default:
        return Icon(Icons.star_border_rounded, color: widget.color, size: widget.size);
    }
  }
}
