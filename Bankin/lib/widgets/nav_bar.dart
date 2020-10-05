import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:Bankin/pages/budget/budget.dart';
import 'package:Bankin/pages/saving/saving.dart';
import 'package:Bankin/pages/coaching/coaching.dart';
import 'package:Bankin/pages/analysis/analysis.dart';
import 'package:Bankin/pages/accounts/accounts.dart';

class NavBar extends StatefulWidget {
  NavBar();
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return NavBarInit();
  }
}

class NavBarInit extends StatefulWidget {
  NavBarInit();

  @override
  NavBarInitState createState() => new NavBarInitState();
}

class NavBarInitState extends State<NavBarInit> with SingleTickerProviderStateMixin {
  PageController pageController;
  int pageIndex = 2;
  final double iconSize = 20.0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: 2,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
  }
  final Color iconColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: PageView(
          children: <Widget>[
            Analysis(),
            Budget(),
            Accounts(),
            Saving(),
            Coaching(),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: pageIndex,
          height: 50.0,
          items: <Widget>[
            Icon(FontAwesomeIcons.chartLine,
                size: pageIndex == 0 ? iconSize + 5 : iconSize, color: iconColor),
            Icon(FontAwesomeIcons.chartPie,
                size: pageIndex == 1 ? iconSize + 5 : iconSize, color: iconColor),
            Icon(FontAwesomeIcons.wallet,
                size: pageIndex == 2 ? iconSize + 5 : iconSize, color: iconColor),
            Icon(FontAwesomeIcons.coins,
                size: pageIndex == 3 ? iconSize + 5 : iconSize, color: iconColor),
            Icon(FontAwesomeIcons.headset,
                size: pageIndex == 4 ? iconSize + 5 : iconSize, color: iconColor),
          ],
          color: Colors.orange,
          buttonBackgroundColor: Colors.red,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 400),
          onTap: (index) {
            onTap(index);
          },
        ),
    );
  }
}