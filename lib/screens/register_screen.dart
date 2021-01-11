import 'package:flutter/material.dart';
import 'package:drowsy/constants.dart';
import 'package:drowsy/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'driver_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = "register_screen";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //String email;
  // String _password;
  // String _repassword;

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  TextEditingController emergencyContact1;
  TextEditingController emergencyContact2;

  Color hintTextColor = Colors.grey;

  @override
  void initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    emergencyContact1 = new TextEditingController();
    emergencyContact2 = new TextEditingController();
    super.initState();
  }

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

  String phoneNumberValidator(String value){
    Pattern pattern =
        r'^(\+91[\-\s]?)?[0]?(91)?[789]\d{9}$';
    RegExp phRegex = new RegExp(pattern);
    if(!phRegex.hasMatch(value)){
      return 'Phone number Format is invalid';
    }
    else{
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              height: 50,
            ),
            SingleChildScrollView(
              child: Form(
                key: _registerFormKey,
                child: Column(
                  children: [
                    Theme(
                      data : Theme.of(context).copyWith(accentColor: kButtonColor),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          hintText: "John",
                        ),
                        controller: firstNameInputController,
                        validator: (value) {
                          if (value.length < 3) {
                            return "Please enter a valid first name.";
                          }
                        },
                      ),
                    ),
                    Theme(
                      data : Theme.of(context).copyWith(accentColor: kButtonColor),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Last Name*',
                          hintText: "Doe",
                        ),
                        controller: lastNameInputController,
                        validator: (value) {
                          if (value.length < 3) {
                            return "Please enter a valid last name.";
                          }
                        },
                      ),
                    ),
                    Theme(
                      data : Theme.of(context).copyWith(accentColor: kButtonColor),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email*',
                          hintText: "john.doe@gmail.com",
                        ),
                        controller: emailInputController,
                        keyboardType: TextInputType.emailAddress,
                        validator: emailValidator,
                      ),
                    ),
                    Theme(
                      data : Theme.of(context).copyWith(accentColor: kButtonColor),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password*',
                          hintText: "********",
                        ),
                        controller: pwdInputController,
                        obscureText: true,
                        validator: pwdValidator,
                      ),
                    ),
                    Theme(
                      data : Theme.of(context).copyWith(accentColor: kButtonColor),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Confirm Password*',
                          hintText: "********",
                        ),
                        controller: confirmPwdInputController,
                        obscureText: true,
                        validator: pwdValidator,
                      ),
                    ),
                    Theme(
                      data : Theme.of(context).copyWith(accentColor: kButtonColor),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Emergency Phone Number',
                          hintText: "+911234567890",
                        ),
                        controller: emergencyContact1,
                        validator: phoneNumberValidator,
                      ),
                    ),
                    Theme(
                      data : Theme.of(context).copyWith(accentColor: kButtonColor),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Emergency Phone Number Alternate',
                          hintText: "+911234567890",
                        ),
                        controller: emergencyContact2,
                        validator: phoneNumberValidator,
                      ),
                    ),

                    SizedBox(
                      height: 50,
                    ),
                    RoundedButton(
                      text: 'Register',
                      colour: kButtonColor,
                      textColor: kBackgroundColor,
                      onPressed: () {
                        if (_registerFormKey.currentState.validate()) {
                          if (pwdInputController.text ==
                              confirmPwdInputController.text) {
                            CircularProgressIndicator();
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailInputController.text,
                                    password: pwdInputController.text)
                                .then((currentUser) => Firestore.instance
                                    .collection("users")
                                    .document(currentUser.user.uid)
                                    .setData({
                                      "uid": currentUser.user.uid,
                                      "fName": firstNameInputController.text,
                                      "surname": lastNameInputController.text,
                                      "email": emailInputController.text,
                                      "emergency1" : emergencyContact1.text,
                                      "emergency2" : emergencyContact2.text,
                                    })
                                    .then((result) => {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DriverScreen(
                                                          firstName: firstNameInputController.text,
                                                          lastName: lastNameInputController.text,
                                                          contact1: emergencyContact1.text,
                                                          contact2: emergencyContact2.text,
                                                          uid: currentUser
                                                              .user.uid)),
                                              (route) => false),
                                          firstNameInputController.clear(),
                                          lastNameInputController.clear(),
                                          emailInputController.clear(),
                                          pwdInputController.clear(),
                                          confirmPwdInputController.clear(),
                                          emergencyContact1.clear(),
                                          emergencyContact2.clear(),
                                        })
                                    .catchError((err) => print(err)))
                                .catchError((err) => print(err));
                          }
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Error',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: Text('Please correct the formatting'),
                                  actions: [
                                    FlatButton(
                                      child: Text(
                                        'Close',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                      },
                    ),
                    Text("Already Have an Account?"),
                    FlatButton(
                      child: Text("Login Here!"),
                      onPressed: () {
                        Navigator.popAndPushNamed(context, LoginScreen.id);
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
