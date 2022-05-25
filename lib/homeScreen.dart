import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_awesome_drawer_bar/page_structure.dart';

import 'package:provider/provider.dart';

import 'awesome_drawer_bar.dart';
import 'menu_page.dart';

class HomeScreen extends StatefulWidget {
  static List<MenuItem> mainMenu = [
    MenuItem(tr("chat"), Icons.message, 0),
    MenuItem(tr("premium"), Icons.wallet_membership_sharp, 1),
    MenuItem(tr("notifications"), Icons.notifications, 2),
    MenuItem(tr("help"), Icons.help, 3),
    MenuItem(tr("about us"), Icons.info_outline, 4),
  ];

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _drawerController = AwesomeDrawerBarController();

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return AwesomeDrawerBar(
      isRTL: false,
      controller: _drawerController,
      type: StyleState.scaleRight,
      menuScreen: MenuScreen(
        HomeScreen.mainMenu,
        callback: _updatePage,
        current: _currentPage, key: UniqueKey(),
      ),
      mainScreen: MainScreen(),
      borderRadius: 24.0,
      showShadow: true,
      angle: 0.0, //default
      slideWidth: MediaQuery.of(context).size.width * (false ? .45 : 0.65), // default

    );
  }

  void _updatePage(index) {
    Provider.of<MenuProvider>(context, listen: false).updateCurrentPage(index);
    _drawerController.toggle!();
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    ValueNotifier<DrawerState>?listenable=AwesomeDrawerBar.of(context)?.stateNotifier;
    final rtl = false;
    return ValueListenableBuilder<DrawerState>(
      valueListenable:listenable! ,
      builder: (context, state, child) {
        return AbsorbPointer(
          absorbing: state != DrawerState.closed,
          child: child,
        );
      },
      child: GestureDetector(
        child: PageStructure(
          elevation: 10, actions: [], backgroundColor: Colors.orange, key: UniqueKey(),
          child: Container(),

        ),
        onPanUpdate: (details) {
          if (details.delta.dx < 6 && !rtl || details.delta.dx < -6 && rtl) {
            AwesomeDrawerBar.of(context)?.toggle();
          }
        },
      ),
    );
  }
}

class MenuProvider extends ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void updateCurrentPage(int index) {
    if (index != currentPage) {
      _currentPage = index;
      notifyListeners();
    }
  }
}
