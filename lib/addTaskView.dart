
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dailyView.dart';
import 'main.dart';


class AddTaskView extends StatefulWidget {
  AddTaskView({Key key, this.events, this.tasks}) : super(key: key);

  final List<Event> events;
  final List<Meeting> tasks;

  @override
  _AddTaskView createState() => _AddTaskView();
}

class _AddTaskView extends State<AddTaskView> {

  String date;
  TextEditingController className = new TextEditingController();
  TextEditingController taskName = new TextEditingController();

  DateTime startDate = DateTime.now();
  DateTime dueDate = DateTime.now().add(new Duration(days: 7));

  TextEditingController hoursToComplete = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<DateTime> getDate() {
      return showDatePicker(
        context: context,
        initialDate: DateTime(startDate.year, startDate.month, startDate.day, 9, 0, 0),
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(new Duration(days: 365)),
        initialEntryMode: DatePickerEntryMode.input,
      );
    }

    void callDatePicker(String dateTime) async {
      var pickDate = await getDate();
      if(pickDate != null) {
        if(dateTime == "startDate") {
          setState(() {
            startDate = pickDate;
          });
        } else {
          setState(() {
            dueDate = pickDate;
          });
        }
      }
    }

    Padding getTextField(TextEditingController controller, String hint) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(50,10,50,0),
          child: TextFormField(
            obscureText: false,
            controller: controller,
            decoration: InputDecoration(
                hintText: hint
            ),
          )
      );
    }

    Padding getDateField(DateTime dateTime, String hint) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(50,10,50,0),
          child: TextFormField(
            obscureText: false,
            decoration: InputDecoration(
                hintText: DateFormat('MM/dd/yyyy').format(dateTime)
            ),
            onTap: () {
              callDatePicker(hint);
            }
          )
      );
    }

    void addTask() {
      //TODO: Fix rounding to nearest half hour, fix double appearance bug and no appearance bug, wrong date bug
      var availableDays = dueDate.difference(startDate);
      for(int i = 0; i < availableDays.inDays + 1; i++) {
        widget.events.add(new Event(
          date: DateTime(startDate.year, startDate.month, startDate.day, 9, 0, 0).add(new Duration(days: i)),
          className: className.text,
          taskName: taskName.text,
          hours: int.parse(hoursToComplete.text)/availableDays.inDays,
          complete: false,
        ));
      }
      double hoursDouble = double.parse(hoursToComplete.text)/availableDays.inDays;
      int hours = hoursDouble.round();

      var list = [const Color.fromRGBO(238, 175, 175,1),const Color.fromRGBO(175, 238, 175, 1),const Color.fromRGBO(175, 238, 238, 1),const Color.fromRGBO(192, 192, 192, 1),const Color.fromRGBO(238, 175, 238, 1)];

      var color = (list..shuffle()).first;

      for(int i = 0; i < availableDays.inDays + 1; i++) {
        DateTime day = DateTime(startDate.year, startDate.month, startDate.day, 9, 0, 0).add(new Duration(days: i));
        widget.tasks.add(new Meeting( className.text + " " + taskName.text,
          day,
          day.add(new Duration(hours: hours)),
            color,
          false,
          hours,
        false,
        this.hashCode+i
        //     String eventName;
        // DateTime from;
        // DateTime to;
        // Color background;
        //     bool isAllDay;
        ));
      }
      setState(() {});
      print(widget.events.length);
      print(widget.tasks.length);
      print("hi");

      Navigator.pop(context, widget.events);
      Navigator.pop(context, widget.tasks);

    }


    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
        toolbarHeight: 68.0,
      ),
      body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            getTextField(className, "Class..."),
            getTextField(taskName, "Task Name..."),
            getDateField(startDate, "startDate"),
            getDateField(dueDate, "endDate"),
            getTextField(hoursToComplete, "Hours to Complete...")
            ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addTask(),
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }
}