import 'package:flutter/material.dart';
import 'package:personalmanager/models/event_model.dart';

class EventDetailsPage extends StatelessWidget {

  final EventModel event;

  const EventDetailsPage({Key key, this.event}) : super(key: key);

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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Event Details', style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 100.0,),
                Text(event.title, style: Theme.of(context).textTheme.headline4,),
                SizedBox(height: 20.0,),
                Text(event.eventDate.toString()),
                SizedBox(height: 20.0,),
                Text(event.description)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
