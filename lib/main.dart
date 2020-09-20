import 'package:flutter/material.dart';
import 'package:personalmanager/screens/calendar_screen.dart';
import 'package:personalmanager/screens/home_screen.dart';
import 'package:personalmanager/screens/login_screen.dart';
import 'package:personalmanager/screens/main_screen.dart';
import 'package:personalmanager/screens/nav_screen.dart';
import 'package:personalmanager/screens/todo_list_screen.dart';
import 'package:personalmanager/screens/ui/add_event.dart';
import 'package:personalmanager/screens/ui/add_todo.dart';
import 'package:personalmanager/services/auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(PersonalManager());

class PersonalManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Auth.instance(),
      child: MaterialApp(
        home: HomeScreen(),
        initialRoute: HomeScreen.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          NavScreen.id: (context) => NavScreen(),
          MainScreen.id: (context) => MainScreen(),
          TodoListScreen.id: (context) => TodoListScreen(),
          CalendarScreen.id: (context) => CalendarScreen(),
          'add_event': (_) => AddEventPage(),
          'add_todo' : (_) => AddTodoScreen(),
        },
      ),
    );
  }
}
