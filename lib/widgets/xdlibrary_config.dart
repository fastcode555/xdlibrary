import 'package:flutter/cupertino.dart';
import 'package:xdlibrary/widgets/rating_star.dart';

typedef WidgetBuilder<T> = Widget Function(T);

class XdLibraryConfig {
  /// InputField deleteWidget builder
  WidgetBuilder? deleteWidgetBuilder;

  ///RatingBar widget buidler
  WidgetBuilder<RatingState>? ratingBarBuilder;

  static XdLibraryConfig? _instance;

  factory XdLibraryConfig() => _getInstance();

  static XdLibraryConfig get instance => _getInstance();

  static XdLibraryConfig _getInstance() {
    _instance ??= XdLibraryConfig._internal();
    return _instance!;
  }

  XdLibraryConfig._internal() {}
}
