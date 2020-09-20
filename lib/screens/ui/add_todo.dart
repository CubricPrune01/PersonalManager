import 'package:flutter/material.dart';
import 'package:personalmanager/models/todo_model.dart';
import 'package:personalmanager/services/auth.dart';
import 'package:personalmanager/services/todo_db_services.dart';
import 'package:provider/provider.dart';

class AddTodoScreen extends StatefulWidget {

  final Todo todo;

  const AddTodoScreen({Key key, this.todo}) : super(key: key);

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {

  TextStyle style = TextStyle(fontSize: 20.0);
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  FocusNode _descriptionNode;
  bool _editMode;
  bool _processing;
  @override
  void initState() {
    super.initState();
    _processing=false;
    _editMode = widget.todo != null;
    _titleController = TextEditingController( text:  _editMode ? widget.todo.title : null);
    _descriptionController = TextEditingController(text:  _editMode ? widget.todo.description : null);
    _descriptionNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        key: _key,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Add Todo', style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 100.0,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _titleController,
                  validator: (value) => (value.isEmpty) ? 'Please Enter Todo Title' : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: 'Todo Title',
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),)
                  ),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: (){
                    FocusScope.of(context).requestFocus(_descriptionNode);
                  },
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _descriptionController,
                  focusNode: _descriptionNode,
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) => (value.isEmpty) ? 'Please Enter Event Description' : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: 'Event Description',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              RaisedButton(
                child: _processing ? CircularProgressIndicator() : Text("Save"),
                onPressed: _processing ? null  : ()async {
                  setState(() {
                    _processing = true;
                  });
                  if(_titleController.text.isEmpty) {
                    _key.currentState.showSnackBar(SnackBar(
                      content: Text("Todo Title is required."),
                    ));
                    return;
                  }
                  Todo todo = Todo(
                    id: _editMode ? widget.todo.id : null,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    createdAt: DateTime.now(),
                    userId: Provider.of<Auth>(context, listen: false).user.uid,
                  );
                  if(_editMode) {
                    await todoDb.updateItem(todo);
                  }else {
                    await todoDb.createItem(todo);
                  }
                  setState(() {
                    _processing = false;
                  });
                  _key.currentState.showSnackBar(SnackBar(
                    content: Text("Notes saved successfully")
                  ));
                  Navigator.pop(context);
                  FocusScope.of(context).requestFocus(FocusNode());
                  _titleController.clear();
                  _descriptionController.clear();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
