import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/features/history/ui/page/history_page.dart';
import 'package:time_tracker/features/home/ui/page/home_page.dart';
import 'package:time_tracker/features/settings/ui/page/settings_page.dart';

class Routes {
  static const String home = '/';
  static const String history = '/history';
  static const String setting = '/settings';

  // unauthenticated user routes
  static Route unauthenticated(RouteSettings settings) {
    dynamic args = settings.arguments;
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case history:
        return MaterialPageRoute(builder: (_) => HistoryPage());
      case setting:
        return MaterialPageRoute(builder: (_) => SettingsPage());
    }
    return MaterialPageRoute(builder: (_) => Scaffold());
  }

  // authenticated user routes
  static Route authenticated(RouteSettings settings) {
    dynamic args = settings.arguments;
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case history:
        return MaterialPageRoute(builder: (_) => HistoryPage());
      case setting:
        return MaterialPageRoute(builder: (_) => SettingsPage());
    }
    return MaterialPageRoute(builder: (_) => Scaffold());
  }
}