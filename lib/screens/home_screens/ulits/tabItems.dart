import 'package:flutter/material.dart';
import 'package:covid_scan/screens/home_screens/app_home.dart';

class TabItem {
  final String tabName;
  final IconData icon;
  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  int _index = 0;
  Widget _page;

  TabItem({
    @required this.tabName,
    @required this.icon,
    @required Widget page,
  }) {
    _page = page;
  }

  void setIndex(int i) {
    _index = i;
  }

  int getIndex() => _index;

  Widget get page {
    return Visibility(
      //only paint this page when current tab is active
      visible: _index == AppHomePageState.currentTab,
      //preserve state while switching
      maintainState: true,
      child: Navigator(
        key: key,
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (_) => _page,
          );
        },
      ),
    );
  }
}

class AppHomeState {}
