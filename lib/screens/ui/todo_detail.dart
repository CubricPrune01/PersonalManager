import 'package:flutter/material.dart';
import 'package:personalmanager/models/todo_model.dart';

class TodoDetailScreen extends StatelessWidget {

  final Todo todo;

  const TodoDetailScreen({Key key, this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Todo Detail', style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
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
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(todo.title, style: Theme.of(context).textTheme.headline6,),
                  SizedBox(height: 10.0),
                  Text(todo.description, style: Theme.of(context).textTheme.bodyText1,),
                ],
              ),
            )
        )
    );
  }
}
