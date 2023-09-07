import 'package:flutter/material.dart';

typedef CanAccept = bool Function(int oldIndex, int newIndex);
typedef DataWidgetBuilder<T> = Widget Function(BuildContext context, T data, int index);
typedef CanDragAtPosition<T> = bool Function(int index, T data);

class SortableGridView<T> extends StatefulWidget {
  final DataWidgetBuilder<T> itemBuilder;
  final CanAccept canAccept; //是否接受拖拽过来的数据的回调函数
  final List<T> dataList; //数据源List
  final int crossAxisCount;
  final double childAspectRatio;
  final CanDragAtPosition<T>? canDrag;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final ScrollPhysics? physics;
  final VoidCallback? onDragCompleted;
  final VoidCallback? onDragStarted;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;

  const SortableGridView(
    this.dataList, {
    Key? key,
    this.crossAxisCount = 3,
    this.canDrag,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
    this.physics,
    this.onDragCompleted,
    this.onDragStarted,
    this.padding,
    this.shrinkWrap = true,
    required this.itemBuilder,
    required this.canAccept,
  })  : assert(canAccept != null),
        assert(dataList != null && dataList.length >= 0),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SortableGridViewState<T>();
}

class _SortableGridViewState<T> extends State<SortableGridView<T>> {
  late List<T> _dataList; //数据源
  late List<T> _dataListBackup; //数据源备份，在拖动时 会直接在数据源上修改 来影响UI变化，当拖动取消等情况，需要通过备份还原
  bool _showItemWhenCovered = false; //手指覆盖的地方，即item被拖动时 底部的那个widget是否可见；
  int _willAcceptIndex = -1; //当拖动覆盖到某个item上的时候，记录这个item的坐标

  @override
  void initState() {
    super.initState();
    _dataList = widget.dataList;
    _dataListBackup = _dataList.sublist(0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: widget.physics,
      padding: widget.padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: widget.childAspectRatio,
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: widget.crossAxisSpacing,
        mainAxisSpacing: widget.mainAxisSpacing,
      ),
      shrinkWrap: widget.shrinkWrap,
      //item宽高比
      itemBuilder: (_, index) {
        if (widget.canDrag != null) {
          return widget.canDrag!(index, _dataList[index])
              ? _buildDraggable(context, index)
              : _buildNormalWidget(context, index);
        } else {
          return _buildDraggable(context, index);
        }
      },
      itemCount: _dataList.length,
    );
  }

  _buildNormalWidget(BuildContext context, int i) => widget.itemBuilder(context, _dataList[i], i);

  //绘制一个可拖拽的控件。
  Widget _buildDraggable(BuildContext context, int index) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return LongPressDraggable(
          data: index,
          child: DragTarget<int>(
            //松手时 如果onWillAccept返回true 那么久会调用，本案例不使用。
            onAccept: (int data) {},
            //绘制widget
            builder: (context, data, rejects) {
              return _willAcceptIndex >= 0 && _willAcceptIndex == index
                  ? Container()
                  : widget.itemBuilder(context, _dataList[index], index);
            },
            //手指拖着一个widget从另一个widget头上滑走时会调用
            onLeave: (leftIndex) {
              debugPrint('$leftIndex is Leaving item $index');
              _willAcceptIndex = -1;
              setState(() {
                _showItemWhenCovered = false;
                _dataList.clear();
                _dataList.addAll(_dataListBackup.sublist(0));
              });
            },
            //接下来松手 是否需要将数据给这个widget？  因为需要在拖动时改变UI，所以在这里直接修改数据源
            onWillAccept: (int? fromIndex) {
              debugPrint('$index will accept item $fromIndex');
              final accept = fromIndex != index;
              if (accept) {
                _willAcceptIndex = index;
                _showItemWhenCovered = true;
                _dataList.clear();
                _dataList.addAll(_dataListBackup.sublist(0));
                final fromData = _dataList[fromIndex!];
                setState(() {
                  _dataList.removeAt(fromIndex);
                  _dataList.insert(index, fromData);
                });
              }
              return accept;
            },
          ),
          onDragStarted: () {
            //开始拖动，备份数据源
            _dataListBackup = _dataList.sublist(0);
            debugPrint('item $index ---------------------------onDragStarted');
            widget.onDragStarted?.call();
          },
          onDraggableCanceled: (Velocity velocity, Offset offset) {
            debugPrint(
                'item $index ---------------------------onDraggableCanceled,velocity = $velocity,offset = $offset');
            //拖动取消，还原数据源
            setState(() {
              _willAcceptIndex = -1;
              _showItemWhenCovered = false;
              _dataList.clear();
              _dataList.addAll(_dataListBackup.sublist(0));
            });
          },
          onDragCompleted: () {
            //拖动完成，刷新状态，重置willAcceptIndex
            debugPrint('item $index ---------------------------onDragCompleted');
            setState(() {
              _showItemWhenCovered = false;
              _willAcceptIndex = -1;
            });
            if (widget.onDragCompleted != null) {
              widget.onDragCompleted!();
            }
          },
          //用户拖动item时，那个给用户看起来被拖动的widget，（就是会跟着用户走的那个widget）
          feedback: SizedBox(
            width: constraint.maxWidth,
            height: constraint.maxHeight,
            child: widget.itemBuilder(context, _dataList[index], index),
          ),
          //这个是当item被拖动时，item原来位置用来占位的widget，（用户把item拖走后原来的地方该显示啥？就是这个）
          childWhenDragging: SizedBox(
            child: _showItemWhenCovered ? widget.itemBuilder(context, _dataList[index], index) : null,
          ),
        );
      },
    );
  }
}
