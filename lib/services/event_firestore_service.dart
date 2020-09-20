import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:personalmanager/models/event_model.dart';

DatabaseService<EventModel> eventDBS = DatabaseService<EventModel>('users', fromDS: (id, data)
=> EventModel.fromDS(id, data), toMap: (event) => event.toMap());

