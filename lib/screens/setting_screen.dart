import 'package:drowsy/extras/info_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drowsy/constants.dart';
import 'package:drowsy/extras/info_screen.dart';

class SettingScreen extends StatelessWidget {
  static const String id = "setting_screen";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0x3F0F123F),
      ),
      body: ListView(
        children: [
          Container(
            height: 200.0,
            child: Image.asset('images/setting.png'),
          ),
          SizedBox(
            height: 100,
          ),
          Card(
            color: kBackgroundColor,
            child: ListTile(
              onTap: () {
                //TODO have forgot password screen done
              },
              leading: Icon(FontAwesomeIcons.key),
              title: Text('Forgot Password'),
            ),
          ),
          Card(
            color: kBackgroundColor,
            child: ListTile(
              onTap: () {
                showAlertDialog(context);
              },
              leading: Icon(FontAwesomeIcons.userSlash),
              title: Text('Delete Account'),
            ),
          ),
          Card(
            color: kBackgroundColor,
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, InfoScreen.id);
              },
              leading: Icon(FontAwesomeIcons.info),
              title: Text('About'),
            ),
          ),
        ],
        //Forgot password

        //delete my account
        //About
      ),
    );
  }
}


showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Continue"),
    onPressed:  () {
      //remove account from firebase
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: Color(0xFF1B1A32),
    title: Text("Confirm"),
    content: Text("Would you like to continue with your choice?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}