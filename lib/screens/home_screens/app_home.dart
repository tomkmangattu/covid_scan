import 'package:covid_scan/cubit/signout_cubit.dart';
import 'package:covid_scan/screens/home_screens/user_page.dart';
import 'package:flutter/material.dart';
import 'package:covid_scan/screens/home_screens/ulits/tabItems.dart';
import 'package:covid_scan/screens/home_screens/owner_page.dart';
import 'package:covid_scan/screens/home_screens/settings_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ulits/nav_page.dart';

class AppHomePage extends StatefulWidget {
  static const String id = 'user home screen';

  @override
  AppHomePageState createState() => AppHomePageState();
}

class AppHomePageState extends State<AppHomePage> {
  static int currentTab = 0;

  //list of tabs
  final List<TabItem> tabs = [
    TabItem(
      tabName: 'scan',
      icon: Icons.phone_android_outlined,
      page: UserScreen(),
    ),
    TabItem(
      tabName: 'generate',
      icon: Icons.qr_code,
      page: OwnerScreen(),
    ),
    TabItem(
      tabName: 'profile',
      icon: Icons.account_circle_outlined,
      page: SettingsScreen(),
    ),
  ];

  AppHomePageState() {
    // indexing
    tabs.asMap().forEach((index, details) {
      details.setIndex(index);
    });
  }

  //sets current tab index and update state
  void _selectTab(int index) {
    if (index == currentTab) {
      //pop to first route
      tabs[index].key.currentState.popUntil((route) => route.isFirst);
    } else {
      // update the state to repaint
      setState(() {
        currentTab = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await tabs[currentTab].key.currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (currentTab != 0) {
            _selectTab(0);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: BlocProvider<SignoutCubit>(
        create: (context) => SignoutCubit(context: context),
        child: Scaffold(
          body: IndexedStack(
            index: currentTab,
            children: tabs.map((e) => e.page).toList(),
          ),
          bottomNavigationBar: BottomNavigation(
            onSelectTab: _selectTab,
            tabs: tabs,
          ),
        ),
      ),
    );
  }
}
