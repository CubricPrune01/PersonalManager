import 'package:flutter/material.dart';
import 'package:personalmanager/screens/calendar_screen.dart';
import 'package:personalmanager/screens/todo_list_screen.dart';

class MainScreen extends StatefulWidget {

  static const String id = 'main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xffbeebe9),
                Color(0xfff4dada),
                Color(0xffffb6b9),
                Color(0xfff6eec7)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          ),
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
          ],
        ),
      ),
    );
  }
}

