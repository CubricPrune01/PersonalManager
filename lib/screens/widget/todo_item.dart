import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:personalmanager/models/todo_model.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Function(Todo) onEdit;
  final Function(Todo) onDelete;
  final Function(Todo) onTap;
  const TodoItem({Key key, @required this.todo, @required this.onEdit, @required this.onDelete, @required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0,),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Edit',
            color: Colors.blue,
            icon: Icons.edit,
            onTap: () => onEdit(todo),
          ),
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => onDelete(todo),
          ),
        ],
        child: ListTile(
          onTap: () => onTap(todo),
          title: Text(todo.title),
        ),
      ),
    );
  }
}