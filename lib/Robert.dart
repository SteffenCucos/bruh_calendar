import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_locker/home/home.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:intl/intl.dart';

class AddProfile extends StatefulWidget {
  AddProfile({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<AddProfile> {
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  String dob;
  TextEditingController fNameInputController;
  TextEditingController lNameInputController;
  TextEditingController bioSexInputController;
  TextEditingController healthIDInputController;
  TextEditingController heightInputController;
  TextEditingController weightInputController;
  TextEditingController profilePasswordInputController;
  TextEditingController confProfilePasswordInputController;
  TextStyle style = GoogleFonts.robotoSlab(
    fontSize: 20.0,
    color: Colors.black,
  );
  bool _isLoading = false;

  @override
  initState() {
    dob = "MM/DD/YYYY";
    fNameInputController = new TextEditingController();
    lNameInputController = new TextEditingController();
    bioSexInputController = new TextEditingController();
    healthIDInputController = new TextEditingController();
    heightInputController = new TextEditingController();
    weightInputController = new TextEditingController();
    profilePasswordInputController = new TextEditingController();
    confProfilePasswordInputController = new TextEditingController();
    super.initState();
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<DateTime> getDate() {
      return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.input,
      );
    }

    void callDatePicker() async {
      var order = await getDate();
      if (order != null) {
        setState(() {
          dob = DateFormat('MM/dd/yyyy').format(order);
        });
      }
    }

    final fNameField = Padding(
      padding: const EdgeInsets.fromLTRB(36.0, 0.0, 36.0, 0.0),
      child: TextFormField(
        obscureText: false,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
          hintText: "First Name Here",
        ),
        controller: fNameInputController,
      ),
    );

    final lNameField = Padding(
      padding: const EdgeInsets.fromLTRB(36.0, 0.0, 36.0, 0.0),
      child: TextFormField(
        obscureText: false,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
          hintText: "Last Name Here",
        ),
        controller: lNameInputController,
      ),
    );

    final dobField = Padding(
      padding: const EdgeInsets.fromLTRB(36.0, 0.0, 36.0, 0.0),
      child: TextFormField(
        obscureText: false,
        style: style,
        onTap: () {
          callDatePicker();
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
          hintText: dob,
        ),
      ),
    );

    final biologicalSexField = Padding(
      padding: const EdgeInsets.fromLTRB(36.0, 0.0, 36.0, 0.0),
      child: TextFormField(
        obscureText: false,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
          hintText: "male/female",
        ),
        controller: bioSexInputController,
      ),
    );

    final healthIDField = Padding(
      padding: const EdgeInsets.fromLTRB(36.0, 0.0, 36.0, 0.0),
      child: TextFormField(
        obscureText: false,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
          hintText: "Health Identification Number",
        ),
        controller: healthIDInputController,
      ),
    );

    final weightField = Padding(
      padding: const EdgeInsets.fromLTRB(36.0, 0.0, 36.0, 0.0),
      child: TextFormField(
        obscureText: false,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
          hintText: "Enter Numerical Weight Here",
        ),
        controller: weightInputController,
      ),
    );

    final heightField = Padding(
      padding: const EdgeInsets.fromLTRB(36.0, 0.0, 36.0, 0.0),
      child: TextFormField(
        obscureText: false,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
          hintText: "Enter Centimeter Height Here",
        ),
        controller: heightInputController,
      ),
    );

    final passwordField = Padding(
      padding: const EdgeInsets.fromLTRB(36.0, 0.0, 36.0, 0.0),
      child: TextFormField(
        obscureText: true,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
          hintText: "Password Here",
        ),
        controller: profilePasswordInputController,
      ),
    );

    final confPasswordField = Padding(
      padding: const EdgeInsets.fromLTRB(36.0, 0.0, 36.0, 0.0),
      child: TextFormField(
        obscureText: true,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
          hintText: "Confirm Password",
        ),
        controller: confProfilePasswordInputController,
      ),
    );

    final continueButton = Padding(
      padding: const EdgeInsets.fromLTRB(36.0, 0.0, 36.0, 0.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(6.0),
        color: Color(0xff3465eb),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });
            if (_profileFormKey.currentState.validate()) {
              if (profilePasswordInputController.text ==
                  confProfilePasswordInputController.text) {
                try {
                  String passHash;
                  if (profilePasswordInputController.text == null) {
                    passHash = 'NA';
                  } else {
                    passHash = profilePasswordInputController.text;
                  }

                  var reqBody = json.encode({
                    "userID": widget.user.uid,
                    "fName": fNameInputController.text,
                    "lName": lNameInputController.text,
                    "dob": dob,
                    "sex": bioSexInputController.text,
                    "healthID": healthIDInputController.text,
                    "weight": weightInputController.text,
                    "height": heightInputController.text,
                    "password": passHash,
                    "icon": "profile_temp.png",
                  });
                  var reqHeaders = {
                    'Content-type': 'application/json',
                    'Accept': '*/*',
                  };
                  http
                      .post(Uri.encodeFull(url),
                      body: reqBody, headers: reqHeaders)
                      .then((response) {
                    if (response.statusCode == 200) {
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(user: widget.user)),
                              (_) => false);
                      fNameInputController.clear();
                      lNameInputController.clear();
                      bioSexInputController.clear();
                      healthIDInputController.clear();
                      weightInputController.clear();
                    } else {
                      print(response.statusCode);
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  });
                } catch (error) {
                  print(error);
                  setState(() {
                    _isLoading = false;
                  });
                }
              } else {
                setState(() {
                  _isLoading = false;
                });
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text(
                            "The password and confirm password fields do not match"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    });
              }
            }
          },
          child: Text("Add Profile",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Container(
          color: Colors.white,
          child: Form(
            key: _profileFormKey,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
                  child: Row(children: <Widget>[
                    BackButton(),
                    Text(
                      "Create Profile",
                      style: style.copyWith(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: 45.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(36.0, 0.0, 0.0, 0.0),
                  child: Text(
                    "First Name",
                    style: style.copyWith(
                      fontSize: 15,
                      color: Color(0xff3458eb),
                    ),
                  ),
                ),
                fNameField,
                SizedBox(height: 25.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(36.0, 0.0, 0.0, 0.0),
                  child: Text(
                    "Last Name",
                    style: style.copyWith(
                      fontSize: 15,
                      color: Color(0xff3458eb),
                    ),
                  ),
                ),
                lNameField,
                SizedBox(height: 25.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(36.0, 0.0, 0.0, 0.0),
                  child: Text(
                    "Date of Birth",
                    style: style.copyWith(
                      fontSize: 15,
                      color: Color(0xff3458eb),
                    ),
                  ),
                ),
                dobField,
                SizedBox(height: 25.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(36.0, 0.0, 0.0, 0.0),
                  child: Text(
                    "Biological Sex",
                    style: style.copyWith(
                      fontSize: 15,
                      color: Color(0xff3458eb),
                    ),
                  ),
                ),
                biologicalSexField,
                SizedBox(height: 25.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(36.0, 0.0, 0.0, 0.0),
                  child: Text(
                    "Health ID #",
                    style: style.copyWith(
                      fontSize: 15,
                      color: Color(0xff3458eb),
                    ),
                  ),
                ),
                healthIDField,
                SizedBox(height: 25.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(36.0, 0.0, 0.0, 0.0),
                  child: Text(
                    "Approx. Weight (lbs) - optional",
                    style: style.copyWith(
                      fontSize: 15,
                      color: Color(0xff3458eb),
                    ),
                  ),
                ),
                weightField,
                SizedBox(height: 25.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(36.0, 0.0, 0.0, 0.0),
                  child: Text(
                    "Approx. Height (cm) - optional",
                    style: style.copyWith(
                      fontSize: 15,
                      color: Color(0xff3458eb),
                    ),
                  ),
                ),
                heightField,
                SizedBox(height: 25.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(36.0, 0.0, 0.0, 0.0),
                  child: Text(
                    "Profile Password",
                    style: style.copyWith(
                      fontSize: 15,
                      color: Color(0xff3458eb),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(36.0, 0.0, 0.0, 0.0),
                  child: Text(
                    "(Strongly recommended so that other family members" +
                        " with this app cannot freely view your entire medical history. This" +
                        " does NOT affect the ability to share the record with a doctor)",
                    style: style.copyWith(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                passwordField,
                SizedBox(height: 25.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(36.0, 0.0, 0.0, 0.0),
                  child: Text(
                    "Confirm Profile Password",
                    style: style.copyWith(
                      fontSize: 15,
                      color: Color(0xff3458eb),
                    ),
                  ),
                ),
                confPasswordField,
                SizedBox(height: 25.0),
                continueButton,
                SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
