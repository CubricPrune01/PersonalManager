import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personalmanager/services/event_firestore_service.dart';
import 'package:personalmanager/screens/ui/view_event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:personalmanager/models/event_model.dart';

class CalendarScreen extends StatefulWidget {

  static const String id = 'calendar_screen';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  var userData = Firestore.instance.collection('users').document('uid').get();

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> events) {
    Map<DateTime, List<dynamic>> data = {};
    events.forEach((event) {
      DateTime date = DateTime(event.eventDate.year, event.eventDate.month, event.eventDate.day, 12);
      if(data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }

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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: StreamBuilder<List<EventModel>>(
            stream: eventDBS.streamList(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                List<EventModel> allEvents = snapshot.data;
                if(allEvents.isNotEmpty) {
                  _events = _groupEvents(allEvents);
                }
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 100.0,),
                    TableCalendar(
                      events: _events,
                      initialCalendarFormat: CalendarFormat.month,
                      calendarStyle: CalendarStyle(
                          canEventMarkersOverflow: true,
                          todayColor: Colors.orange,
                          selectedColor: Theme.of(context).primaryColor,
                          todayStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white,
                          )
                      ),
                      headerStyle: HeaderStyle(
                        centerHeaderTitle: true,
                        formatButtonDecoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        formatButtonShowsNext: false,
                        formatButtonTextStyle: TextStyle(color: Colors.white),
                      ),
                      startingDayOfWeek: StartingDayOfWeek.sunday,
                      onDaySelected: (day, events) {
                        setState(() {
                          _selectedEvents = events;
                        });
                      },
                      builders: CalendarBuilders(
                        selectedDayBuilder: (context, date, events) => Container(
                          margin: EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        todayDayBuilder: (context, date, events) => Container(
                          margin: EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      calendarController: _controller,
                    ),
                    ..._selectedEvents.map((event) => ListTile(
                      title: Text(event.title),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailsPage(event: event,)));
                      },
                    )),
                  ],
                ),
              );
            }
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 100.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.black54,
              onPressed: () => Navigator.pushNamed(context, 'add_event'),
            ),
          )
        ),
      ),
    );
  }
}
