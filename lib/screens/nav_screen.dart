import 'dart:io';

import 'package:flutter/material.dart';
import 'package:personalmanager/screens/calendar_screen.dart';
import 'package:personalmanager/screens/main_screen.dart';
import 'package:personalmanager/screens/todo_list_screen.dart';
import 'package:personalmanager/services/auth.dart';
import 'package:provider/provider.dart';

class NavScreen extends StatefulWidget {
  static const String id = 'nav_screen';
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {

  int _currentIndex = 0;

  final pageOptions = [
    MainScreen(),
    TodoListScreen(),
    CalendarScreen(),
  ];

  List<Choice> choices = const <Choice>[
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
    const Choice(title: 'Close', icon: Icons.backspace),
  ];

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
      Provider.of<Auth>(context, listen: false).signOut();
    } else if (choice.title == 'Edit') {
      openDialog();
    }
  }

  Future<Null> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
            children: <Widget>[
              Container(
                color: Colors.black54,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                height: 100.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Exit App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Are you sure you want to exit the application?',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: Colors.black54,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.black54,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'YES',
                      style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
        break;
    }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: onItemMenuPress,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          choice.icon,
                          color: Colors.black,
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          choice.title,
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ));
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        child: pageOptions[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar (
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor:Colors.transparent,
        elevation: 0.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black12,),
            title: Text('Home', style: TextStyle(color: Colors.black),),
            activeIcon: Icon(Icons.home, color: Colors.black)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted, color: Colors.black12,),
            title: Text('Todo List', style: TextStyle(color: Colors.black),),
              activeIcon: Icon(Icons.format_list_bulleted, color: Colors.black)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available, color: Colors.black12,),
            title: Text('Event Calendar', style: TextStyle(color: Colors.black),),
              activeIcon: Icon(Icons.event_available, color: Colors.black)
          )
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
