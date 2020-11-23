
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dailyView.dart';
import 'main.dart';
import 'package:percent_indicator/percent_indicator.dart';



class AllTasksView extends StatefulWidget {
  AllTasksView({Key key, this.events, this.tasks}) : super(key: key);

  final List<Event> events;
  final List<Meeting> tasks;

  @override
  _AllTasksView createState() => _AllTasksView();
}





class _AllTasksView extends State<AllTasksView> {

  List<Container> getTasks() {
    List<Container> tasks = [];

    var taskMap = new Map();

    for(Meeting e in widget.tasks) {
      String key = e.eventName;

      if(!taskMap.containsKey(key)) {
        taskMap[key] = new Map();
        taskMap[key]["totalHours"] = 0;
        taskMap[key]["completedHours"] = 0;
      }

      taskMap[key]["totalHours"] += e.duration;
      if(e.complete) {
        taskMap[key]["completedHours"] += e.duration;
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
                //LinearProgressIndicator(value: percent),
                new CircularPercentIndicator(
                  radius: 200.0,
                  lineWidth: 6.0,
                  percent: percent,
                  center: new Text((percent*100).floor().toString() + "%"),
                  progressColor: Colors.green,
                )
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