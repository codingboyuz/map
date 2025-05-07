import 'package:flutter/material.dart';
import 'package:map/core/routes/routes.dart';
import 'package:map/features/map/presentation/view/yandex_map_screen.dart';

class AppPages {
  static final RouteObserver<Route> observer = RouteObserver();

  /// Barcha sahifalar ro‘yxati
  static final List<PageEntity> _routes = [
    PageEntity(path: AppRoutes.MYMAP, page: const YandexMapScreen()),
  ];

  static List<PageEntity> routes() => _routes;

  static MaterialPageRoute? generateRouteSettings(RouteSettings settings) {
    var result = _routes.where((element) => element.path == settings.name);
    if (result.isNotEmpty) {
      return MaterialPageRoute<void>(
        builder: (_) => result.first.page,
        settings: settings,
      );
    }
    return null;
  }
}

class PageEntity<T> {
  final String path;
  final Widget page;

  PageEntity({required this.path, required this.page});
}
