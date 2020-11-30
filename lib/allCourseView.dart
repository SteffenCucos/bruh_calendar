
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dailyView.dart';
import 'main.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';




class AllCourseView extends StatefulWidget {
  AllCourseView({Key key, this.events, this.tasks}) : super(key: key);

  final List<Event> events;
  final List<Meeting> tasks;

  @override
  _AllCourseView createState() => _AllCourseView();
}


class UniqueColorGenerator {
  static Random random = new Random();
  static Color getColor() {
    return Color.fromARGB(
        255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
  }
}


class _AllCourseView extends State<AllCourseView> {

  List<Container> getTasks() {
    List<Container> tasks = [];
    String newkey;

    var taskMap = new Map();

    for(Meeting e in widget.tasks) {
      String key = e.eventName;

      if (key.contains(' ')) {
        String tempkey = key;
        newkey = tempkey.split(" ")[0];
      }
      else {
        newkey = key;
      }


      if(!taskMap.containsKey(newkey)) {
        taskMap[newkey] = new Map();
        taskMap[newkey]["totalHours"] = 0;
        taskMap[newkey]["completedHours"] = 0;
      }

      taskMap[newkey]["totalHours"] += e.duration;
      if(e.complete) {
        taskMap[newkey]["completedHours"] += e.duration;
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
                  radius: 170.0,
                  lineWidth: 30.0,
                  percent: percent,
                  center: new Text((percent*100).floor().toString() + "%"),
                  progressColor: UniqueColorGenerator.getColor(),
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