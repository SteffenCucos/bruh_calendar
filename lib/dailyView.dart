
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'main.dart';


class DailyView extends StatefulWidget {
  DailyView({Key key, this.title, this.events, this.tasks}) : super(key: key);

  final String title;
  List<Event> events;
  List<Meeting> tasks; 

  DateTime date = DateTime.now();

  @override
  _DailyViewState createState() => _DailyViewState();
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay, this.duration);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  int duration;
}
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}


class _DailyViewState extends State<DailyView> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void incrementDate(int increment) {
    setState(() {
      widget.date = widget.date.add(new Duration(days: increment));
    });
  }


  void addRandomTask() {
    setState(() {
      final DateTime startTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 9, 0, 0);
      final DateTime endTime = startTime.add(const Duration(hours: 2));

      widget.tasks.add(
          new Meeting(
              "Conference", startTime, startTime.add(const Duration(hours: 2)), const Color(0xFF0F8644), false , 2
          )
      );
    });
  }
  List<Meeting> _getDataSource() {
    var meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
    DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    var map = {};
    for (int i = 0 ; i<widget.tasks.length;i++) {
      map.putIfAbsent(widget.tasks[i].from.day, () => 0);
      int offset = map[widget.tasks[i].from.day];
      int duration = widget.tasks[i].duration;
      print(duration);
      print("duration");
      meetings.add(new Meeting(widget.tasks[i].eventName, widget.tasks[i].from.add(Duration(hours: offset )), widget.tasks[i].to.add(Duration(hours: offset)), widget.tasks[i].background, widget.tasks[i].isAllDay, duration));
      map[widget.tasks[i].from.day] = map[widget.tasks[i].from.day] + widget.tasks[i].duration;
      //print(meetings.length);
    }
    return meetings;
  }

  @override
  Widget build(BuildContext context) {

    final menuDrawer = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 100.0,
            child: DrawerHeader(
              child: Text('Menu Drawer'),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.ac_unit),
            onTap: () {
              // TODO: Update App State
              //Navigator.pushNamed(context, '/Settings');
            },
          ),
          ListTile(
            title: Text('Add Task'),
            leading: Icon(Icons.person),
            onTap: () async {
                await Navigator.pushNamed(context, '/AddTaskView');
                setState(() {});
            },
          ),
          ListTile(
            title: Text('All Tasks'),
            leading: Icon(Icons.ac_unit),
            onTap: () {
              // TODO: Update App State
              Navigator.pushNamed(context, '/AllTasksView');
            },
          ),
        ],
      ),
    );

    var _length = widget.events == null ? -1 : widget.events.length;

    List<Widget> buildEvents() {
      List<Widget> containers = [];
      for(Event e in widget.events) {
        if(Jiffy(widget.date).dayOfYear == Jiffy(e.date).dayOfYear) {
          containers.add(
              InkWell(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: e.complete ? Colors.lightGreen : Colors.red,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(e.className),
                      Text(e.taskName),
                      Text(e.hours.toString()),
                    ],
                  ),
                ),
                onTap: () => {
                  setState(() {
                    e.complete = !e.complete;
                  })
                },
              )
          );
        }
      }
      return containers;
    }


    return Scaffold(
        appBar: AppBar(
          title: Text(DateFormat('MM/dd/yyyy').format(widget.date)),
          toolbarHeight: 68.0,
        ),
        body: Center(
          child: SfCalendar(
            dataSource: MeetingDataSource(_getDataSource()),
            showNavigationArrow: true,
            timeSlotViewSettings: TimeSlotViewSettings(timeIntervalHeight: 100,),
            appointmentTextStyle: TextStyle(
                fontSize: 25,
                color: Color.fromRGBO(255,255,255,1),
                letterSpacing: 3,
                fontWeight: FontWeight.bold),
            // child: Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: buildEvents(),
            // ),
          )
        ),
        drawer: menuDrawer,
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding : const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child : FloatingActionButton(
                heroTag: 'btn2',
                onPressed: () => incrementDate(-1),
                tooltip: 'Left',
                child: Icon(Icons.arrow_left),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
              child: FloatingActionButton(
                heroTag: 'btn1',
                onPressed: addRandomTask,
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
              child: FloatingActionButton(
                heroTag: 'btn3',
                onPressed: () => incrementDate(1),
                tooltip: 'Right',
                child: Icon(Icons.arrow_right),
              ),
            ),
          ]
        )
    );
  }
}

