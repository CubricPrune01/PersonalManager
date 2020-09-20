import 'package:flutter/material.dart';
import 'package:personalmanager/screens/login_screen.dart';
import 'package:personalmanager/screens/main_screen.dart';
import 'package:personalmanager/screens/nav_screen.dart';
import 'package:personalmanager/services/auth.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';
  @override
  Widget build(BuildContext context) {
    return Consumer(
      // ignore: missing_return
      builder: (context, Auth user, _) {
        switch (user.status) {
          case Status.Uninitialized:
            return LoginScreen();
          case Status.Unauthenticated:
            return LoginScreen();
          case Status.Authenticating:
            return LoginScreen();
          case Status.Authenticated:
            return NavScreen();
        }
      },
    );
  }
}
