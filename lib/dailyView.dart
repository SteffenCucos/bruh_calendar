
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
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay, this.duration, this.complete, this.hashValue);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  int duration;
  bool complete;
  int hashValue;
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
              "Conference", startTime, startTime.add(const Duration(hours: 2)), const Color(0xFF0F8644), false , 2 , false, widget.tasks.hashCode
          )
      );
    });
  }
  void calendarTapped(CalendarTapDetails details){
    if (details.targetElement == CalendarElement.appointment) {
      DateTime dateTime = details.date;
      List<Meeting> appointments = details.appointments.cast<Meeting>();
      print(appointments.length);
      Meeting appointment = appointments[0];
      for (Meeting e in widget.tasks){
        print(appointment.hashValue);
        print(e.hashValue);
        if (e.hashValue == appointment.hashValue){
          print(e.complete);
          e.complete = !e.complete;
        }
      }
      setState(() {});
    }
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
      String eventName = widget.tasks[i].eventName;
      if (widget.tasks[i].complete){
        print("clear");
        widget.tasks[i].background = widget.tasks[i].background.withOpacity(0.5);
        eventName+=" (Complete)";
      } else{
        print("opaque");
        widget.tasks[i].background = widget.tasks[i].background.withOpacity(0.9);
      }
      meetings.add(new Meeting(eventName, widget.tasks[i].from.add(Duration(hours: offset )), widget.tasks[i].to.add(Duration(hours: offset)), widget.tasks[i].background, widget.tasks[i].isAllDay, duration, widget.tasks[i].complete, widget.tasks[i].hashValue));
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
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
          ),
          ListTile(
            title: Text('Add Task'),
            leading: Icon(Icons.add),
            onTap: () async {
                await Navigator.pushNamed(context, '/AddTaskView');
                setState(() {});
            },
          ),
          ListTile(
            title: Text('All Tasks'),
            leading: Icon(Icons.folder),
            onTap: () {
              // TODO: Update App State
              Navigator.pushNamed(context, '/AllTasksView');
            },
          ),
          ListTile(
            title: Text('All Courses'),
            leading: Icon(Icons.school),
            onTap: () {
              // TODO: Update App State
              Navigator.pushNamed(context, '/AllCourseView');
            },
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              // TODO: Update App State
              //Navigator.pushNamed(context, '/Settings');
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
          title: Text("Daily View"),
          toolbarHeight: 60.0,
          actions: <Widget>[
            PopupMenuButton<String>(
              //onSelected: Navigator.pushNamed();
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: "DailyView",
                  child: Text('Daily View'),

                ),
                const PopupMenuItem<String>(
                  value: "WeeklyView",
                  child: Text('Weekly View'),
                ),
                const PopupMenuItem<String>(
                  value: "MonthlyView",
                  child: Text('Monthly View'),
                ),
                const PopupMenuItem<String>(
                  value: "YearlyView",
                  child: Text('Semester View'),
                ),
              ],
            )
          ]
        ),
        body: Center(
          child: SfCalendar(
            dataSource: MeetingDataSource(_getDataSource()),
            showNavigationArrow: true,
            //view: CalendarView.workWeek,
            timeSlotViewSettings: TimeSlotViewSettings(timeIntervalHeight: 100,),
            appointmentTextStyle: TextStyle(
                fontSize: 25,
                color: Color.fromRGBO(255,255,255,1),
                letterSpacing: 3,
                fontWeight: FontWeight.bold),
            onTap: calendarTapped,

            // child: Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: buildEvents(),
            // ),
          )
        ),
        drawer: menuDrawer,

        floatingActionButton: FloatingActionButton(
          //onPressed: () => (),
          tooltip: 'Add task',
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.pushNamed(context, '/AddTaskView');
            setState(() {});
          },
        ),
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   padding : const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            //   child : FloatingActionButton(
            //     heroTag: 'btn2',
            //     onPressed: () => incrementDate(-1),
            //     tooltip: 'Left',
            //     child: Icon(Icons.arrow_left),
            //   ),
            // ),
//            Container(
//              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
//              child: FloatingActionButton(
//                heroTag: 'btn1',
//                onPressed: addRandomTask,
//                tooltip: 'Increment',
//                child: Icon(Icons.add),
              //),
          //  ),
            // Container(
            //   padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
            //   child: FloatingActionButton(
            //     heroTag: 'btn3',
            //     onPressed: () => incrementDate(1),
            //     tooltip: 'Right',
            //     child: Icon(Icons.arrow_right),
            //   ),
            // ),
          ]
        )
    );
  }
}

