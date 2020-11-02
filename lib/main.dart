import 'package:bruh_calendar/dailyView.dart';
import 'package:bruh_calendar/settingsView.dart';
import 'package:bruh_calendar/splash.dart';
import 'package:flutter/material.dart';

import 'addTaskView.dart';
import 'allTasksView.dart';

void main() {
  runApp(MyApp());
}

class Event {
  DateTime date;
  String className;
  String taskName;
  double hours;
  bool complete;

  Event({this.date, this.className, this.taskName, this.hours, this.complete});
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    List<Event> events = [
      new Event(date: DateTime.now(), className: "MAT301", taskName: "A3", hours: 2, complete: false),
      new Event(date: DateTime.now().add(new Duration(days: 1)), className: "MAT301", taskName: "A3", hours: 2, complete: false),
      new Event(date: DateTime.now().add(new Duration(days: 2)), className: "MAT301", taskName: "A3", hours: 2, complete: false),
      new Event(date: DateTime.now().add(new Duration(days: 3)), className: "MAT301", taskName: "A3", hours: 2, complete: false),
      new Event(date: DateTime.now(), className: "MAT301", taskName: "A4", hours: 2, complete: false),
      new Event(date: DateTime.now().add(new Duration(days: 1)), className: "MAT301", taskName: "A4", hours: 2, complete: false),
      new Event(date: DateTime.now().add(new Duration(days: 2)), className: "MAT301", taskName: "A4", hours: 2, complete: false),
      new Event(date: DateTime.now(), className: "CSC490", taskName: "MVP", hours: 4, complete: false),
      new Event(date: DateTime.now().add(new Duration(days: 1)), className: "CSC490", taskName: "MVP", hours: 4, complete: false),


    ];

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DailyView(title: "Title String", events: events),
      routes: <String, WidgetBuilder> {
        '/DailyView' : (BuildContext context) => DailyView(title: "Title String", events: events),
        '/SettingsView' : (BuildContext context) => SettingsView(),
        '/AddTaskView' : (BuildContext context) => AddTaskView(events: events),
        '/AllTasksView' : (BuildContext context) => AllTasksView(events: events),
      },
    );
  }
}


