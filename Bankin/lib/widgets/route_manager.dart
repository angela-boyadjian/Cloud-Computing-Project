import 'package:flutter/material.dart';

import 'package:Bankin/pages/login/login.dart';
import 'package:Bankin/widgets/nav_bar.dart';
import 'package:Bankin/pages/login/widgets/confirming_user.dart';

class RouteManager {
  showLogin(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ));
  }
  showNavBar(context, idToken) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavBar(idToken),
        ));
  }
  showConfirmingUser(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ConfirmingUser(),
        ));
  }
}
