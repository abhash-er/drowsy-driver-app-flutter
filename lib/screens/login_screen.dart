import 'package:flutter/material.dart';
import 'package:drowsy/components/rounded_button.dart';
import 'package:drowsy/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'driver_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  Color hintTextColor = Colors.grey;

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  void initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 120.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            SingleChildScrollView(
              child: Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                          accentColor: kButtonColor),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Email',
                              hintText: 'john.doe@gmail.com'),
                          controller: emailInputController,
                          keyboardType: TextInputType.emailAddress,
                          validator: emailValidator,
                        ),
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                          accentColor: kButtonColor),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Password',
                              hintText: '********'),
                          controller: pwdInputController,
                          validator: pwdValidator,
                          obscureText: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 50.0),
                    RoundedButton(
                      text: 'Login',
                      colour: kButtonColor,
                      textColor: kBackgroundColor,
                      onPressed: () {
                        if (_loginFormKey.currentState.validate()) {
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                              email: emailInputController.text,
                              password: pwdInputController.text)
                              .then((currentUser) =>
                              Firestore.instance.collection("users").document(
                                  currentUser.user.uid).get().then((
                                  DocumentSnapshot result) =>
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (context) =>
                                          DriverScreen(firstName: result["fName"],
                                              lastName: result["surname"],
                                              contact1: result["emergency1"],
                                              contact2: result["emergency2"],
                                              uid: currentUser.user.uid)),(route) => false))
                                  .catchError((err) => print(err)))
                              .catchError((err) => print(err));
                        }
                      },
                    ),
                    SizedBox(height: 10.0),
                    Text("Don't have an account yet?"),
                    FlatButton(
                      child: Text("Register Here!"),
                      onPressed: () {
                        Navigator.popAndPushNamed(context, RegisterScreen.id);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
