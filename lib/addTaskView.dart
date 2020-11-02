
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'main.dart';


class AddTaskView extends StatefulWidget {
  AddTaskView({Key key, this.events}) : super(key: key);

  final List<Event> events;

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
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(new Duration(days: 365)),
        initialEntryMode: DatePickerEntryMode.input,
      );
    }

    void callDatePicker(DateTime dateTime) async {
      var order = await getDate();
      if(order != null) {
        if(dateTime == startDate) {
          setState(() {
            startDate = order;
          });
        } else {
          setState(() {
            dueDate = order;
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
              callDatePicker(dateTime);
            }
          )
      );
    }

    void addTask() {
      var availableDays = dueDate.difference(startDate);
      for(int i = 0; i < availableDays.inDays + 1; i++) {
        widget.events.add(new Event(
          date: startDate.add(new Duration(days: i)),
          className: className.text,
          taskName: taskName.text,
          hours: int.parse(hoursToComplete.text)/availableDays.inDays,
          complete: false,
        ));
      }
      setState(() {});
      print(widget.events.length);
      Navigator.pop(context, widget.events);
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
            getDateField(startDate, "---"),
            getDateField(dueDate, "---"),
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