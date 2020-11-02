
import 'package:flutter/material.dart';


class SettingsView extends StatefulWidget {
  SettingsView({Key key}) : super(key: key);

  @override
  _SettingsView createState() => _SettingsView();
}

class _SettingsView extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        toolbarHeight: 68.0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        tooltip: 'Go Back',
        child: Icon(Icons.backspace),
      ),
    );
  }
}