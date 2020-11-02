

import 'dart:io';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key} ) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() async {
    sleep(const Duration(seconds:5));
    Navigator.pushReplacementNamed(context, "/DailyView");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                child: Text("Loading..."),
            ),
        ),
    );
  }
}



