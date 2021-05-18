import 'package:covid_scan/screens/home_screens/app_home.dart';
import 'package:covid_scan/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'tabItems.dart';

class BottomNavigation extends StatelessWidget {
  final ValueChanged<int> onSelectTab;
  final List<TabItem> tabs;

  BottomNavigation({
    this.onSelectTab,
    this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: kAppPrimColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      selectedFontSize: 12,
      items: tabs
          .map((e) =>
              _buildItem(index: e.getIndex(), icon: e.icon, tabName: e.tabName))
          .toList(),
      onTap: (index) => onSelectTab(
        index,
      ),
    );
  }
}

BottomNavigationBarItem _buildItem({int index, IconData icon, String tabName}) {
  return BottomNavigationBarItem(
    icon: Icon(
      icon,
      color: _tabColor(index: index),
    ),
    label: tabName,
  );
}

Color _tabColor({int index}) {
  return AppHomePageState.currentTab == index ? Colors.white : Colors.white60;
}
