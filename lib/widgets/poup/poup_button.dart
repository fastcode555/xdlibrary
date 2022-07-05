import 'package:flutter/material.dart';
import 'package:xdlibrary/widgets/poup/base_poup_menu.dart';

class PoupButton<T> extends StatelessWidget {
  final List<T>? datas;
  final Widget child;
  final Color? color;
  final PopupMenusItemSelected<T>? onSelected;
  final ContextBuilder contextBuilder;
  final PoupMenusOffsetBuilder? offsetBuilder;
  final ShapeBorder? shape;
  final Widget Function(int index, T item) itemBuilder;

  PoupButton(
    this.child, {
    this.datas,
    this.color,
    this.onSelected,
    this.offsetBuilder,
    this.shape,
    required this.contextBuilder,
    required this.itemBuilder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenusButton<T>(
      child: child,
      color: color,
      onSelected: onSelected,
      builder: contextBuilder,
      offsetBuilder: offsetBuilder,
      shape: shape,
      /* shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(width: 1.0, color: Colours.ff27dbd9, style: BorderStyle.solid),
      ),*/
      itemBuilder: _buildItems,
    );
  }

  List<PopupMenusEntry<T>> _buildItems(BuildContext context) {
    List<PopupMenusEntry<T>> chilren = [];
    if (datas == null || datas!.isEmpty) return [];
    for (int i = 0; i < datas!.length; i++) {
      T item = datas![i];
      chilren.add(PopupMenusItem(value: item, child: itemBuilder(i, item)));
    }
    return chilren;
  }
}
