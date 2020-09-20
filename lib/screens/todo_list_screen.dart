import 'package:flutter/material.dart';
import 'package:personalmanager/models/todo_model.dart';
import 'package:personalmanager/screens/ui/add_todo.dart';
import 'package:personalmanager/screens/ui/todo_detail.dart';
import 'package:personalmanager/screens/widget/todo_item.dart';
import 'package:personalmanager/services/todo_db_services.dart';

class TodoListScreen extends StatefulWidget {

  static const String id = 'todo_list_screen';
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Todo List', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: StreamBuilder(
            stream: todoDb.streamList(),
            builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
              if (snapshot.hasError)
                return Center(
                  child: Text("There was an error"),
                );
              if (!snapshot.hasData) return CircularProgressIndicator();

              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return TodoItem(
                      todo: snapshot.data[index],
                      onDelete: (todo) async {
                        if (await _confirmDelete(context)) {
                          todoDb.removeItem(todo.id);
                        }
                      },
                      onTap: (todo) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TodoDetailScreen(
                              todo: todo,
                            ),
                          )),
                      onEdit: (todo) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddTodoScreen(
                                todo: todo,
                              ),
                            ));
                      },
                    );
                  });
            },
          ),
            floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: 100.0),
              child: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Colors.black54,
                onPressed: () => Navigator.pushNamed(context, 'add_todo'),
              ),
            ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete?"),
          actions: <Widget>[
            FlatButton(
              child: Text("No"),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ));
  }
}
