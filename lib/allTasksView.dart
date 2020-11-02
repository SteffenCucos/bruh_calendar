
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'main.dart';


class AllTasksView extends StatefulWidget {
  AllTasksView({Key key, this.events}) : super(key: key);

  final List<Event> events;

  @override
  _AllTasksView createState() => _AllTasksView();
}





class _AllTasksView extends State<AllTasksView> {

  List<Container> getTasks() {
    List<Container> tasks = [];

    var taskMap = new Map();

    for(Event e in widget.events) {
      String key = e.className + " " + e.taskName;

      if(!taskMap.containsKey(key)) {
        taskMap[key] = new Map();
        taskMap[key]["totalHours"] = 0;
        taskMap[key]["completedHours"] = 0;
      }

      taskMap[key]["totalHours"] += e.hours;
      if(e.complete) {
        taskMap[key]["completedHours"] += e.hours;
      }
    }

    taskMap.forEach((key, value) {
      double percent = value["completedHours"]/value["totalHours"];

      tasks.add(
          Container(
            padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
            margin: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.lightGreen,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(key),
                LinearProgressIndicator(value: percent),
              ],
            ),
          )
      );
    });

    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Tasks"),
        toolbarHeight: 68.0,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: getTasks(),
      ),
    );
  }
}