import 'dart:io';
import 'dart:math' show pi;

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:provider/provider.dart';

import 'awesome_drawer_bar.dart';
import 'homeScreen.dart';

class PageStructure extends StatelessWidget {
  String? title="";
  final Widget child;
  final List<Widget> actions;
  final Color backgroundColor;
  final double elevation;

  PageStructure({
    required Key key,
    this.title,
    required this.child,
    required this.actions,
    required this.backgroundColor,
    required this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final angle =  180 * pi / 180  ;
    final _currentPage = context.select<MenuProvider, int>((provider) => provider.currentPage);
    final container = Container(
      color: Colors.grey[300],
      child: Center(
        child: Text(

            //"${tr("current")}: ${HomeScreen.mainMenu[_currentPage].title}",
          "",
          style: TextStyle(
            color: Colors.white
          ),


        ),
      ),
    );
    final color = Theme.of(context).accentColor;
    final style = TextStyle(color: color);

    return PlatformScaffold(
      backgroundColor: Colors.transparent,
      appBar: PlatformAppBar(
        automaticallyImplyLeading: false,
        title: PlatformText(
          HomeScreen.mainMenu[_currentPage].title,
        ),
        leading: Transform.rotate(
          angle: angle,
          child: PlatformIconButton(
            icon: Icon(
              Icons.menu,
            ),
            onPressed: () {
              AwesomeDrawerBar.of(context)?.toggle();
            },
          ),
        ),
        trailingActions: actions,
      ),
      bottomNavBar: PlatformNavBar(
        currentIndex: _currentPage,
        itemChanged: (index) => Provider.of<MenuProvider>(context, listen: false).updateCurrentPage(index),
        items: HomeScreen.mainMenu
            .map(
              (item) => BottomNavigationBarItem(
                label:  item.title,
                icon: Icon(
                  item.icon,
                  color: color,
                ),
              ),
            )
            .toList(),
      ),
      body: kIsWeb
          ? container
          : Platform.isAndroid
              ? container
              : SafeArea(
                  child: container,
                ),
    );
  }
}
