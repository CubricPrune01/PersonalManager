import 'package:flutter/material.dart';
import 'package:personalmanager/models/event_model.dart';
import 'package:personalmanager/services/event_firestore_service.dart';

class AddEventPage extends StatefulWidget {

  final EventModel note;

  const AddEventPage({Key key, this.note}) : super(key: key);


  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {

  TextStyle style = TextStyle(fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _description;
  DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.note != null ? widget.note.title : "");
    _description = TextEditingController(text: widget.note != null ? widget.note.description : "");
    _eventDate = DateTime.now();
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.note != null ? 'Edit Event' : 'Add Event', style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
      ),
      key: _key,
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
        child: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.center,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextFormField(
                    controller: _title,
                    validator: (value) => (value.isEmpty) ? 'Please Enter Event Title' : null,
                    style: style,
                    decoration: InputDecoration(
                      labelText: 'Event Title',
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),)
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextFormField(
                    controller: _description,
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
                ListTile(
                  title: Text('Event Date (YYYY-MM-DD)'),
                  subtitle: Text('${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}'),
                  onTap: () async {
                    DateTime picked = await showDatePicker(context: context, initialDate: _eventDate, firstDate: DateTime(_eventDate.year-5), lastDate: DateTime(_eventDate.year+5));
                    if(picked != null) {
                      setState(() {
                        _eventDate = picked;
                      });
                    }
                  },
                ),
                SizedBox(height: 10.0,),
                processing ? Center(child: CircularProgressIndicator())
                    : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.black54,
                    child: MaterialButton(
                      onPressed: () async {
                        if(_formKey.currentState.validate()){
                          setState(() {
                            processing = true;
                          });
                          if(widget.note != null) {
                            await eventDBS.updateData(widget.note.id, {
                              'title': _title.text,
                              'description': _description.text,
                              'event_date': widget.note.eventDate,
                            });
                          } else {
                            await eventDBS.createItem(EventModel(
                              title: _title.text,
                              description: _description.text,
                              eventDate: _eventDate,
                            ));
                          }
                          Navigator.pop(context);
                          setState(() {
                            processing = false;
                          });
                        }
                      },
                      child: Text(
                        'Save',
                        style: style.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black54,
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                            'Cancel',
                          style: style.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),),
                      ),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
}
