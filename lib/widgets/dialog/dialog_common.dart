import 'package:flutter/material.dart';

/// @date 4/7/22
/// describe:
Future<T?> showCommonBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    builder: (BuildContext context) {
      return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        child: builder(context),
      );
    },
    isScrollControlled: true,
  );
}
