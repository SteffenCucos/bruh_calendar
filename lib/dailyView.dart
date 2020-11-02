
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import 'main.dart';


class DailyView extends StatefulWidget {
  DailyView({Key key, this.title, this.events}) : super(key: key);

  final String title;
  List<Event> events;

  DateTime date = DateTime.now();

  @override
  _DailyViewState createState() => _DailyViewState();
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
      widget.events.add(
          new Event(
            date: widget.date,
            className: "className.text",
            taskName: "taskName.text",
            hours: 1.5,
            complete: false,
          )
      );
    });
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
                    e.complete = true;
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildEvents(),
            ),
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