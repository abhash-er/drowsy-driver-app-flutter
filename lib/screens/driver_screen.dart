import 'package:drowsy/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drowsy/constants.dart';
import 'account_screen.dart';
import 'setting_screen.dart';
import 'session_screen.dart';
import 'welcome_screen.dart';
//navigation screen!!

class DriverScreen extends StatefulWidget {
  static const String id = "driver_screen";

  DriverScreen(
      {Key key,
      this.firstName,
      this.lastName,
      this.uid,
      this.contact1,
      this.contact2})
      : super(key: key);
  final String firstName;
  final String lastName;
  final String contact1;
  final String contact2;
  final String uid;

  @override
  _DriverScreenState createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(FontAwesomeIcons.freeCodeCamp),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text('Drowsy'),
        backgroundColor: Color(0x3F0F123F),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.only(left: 10.0, top: 30.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('Hello'),
                      ),
                      CircleAvatar(
                        radius: 30.0,
                        child: Container(
                          child: Image.asset('images/avatar.png'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 50.0),
                  Container(
                    height: 200.0,
                    child: Image.asset('images/road.png'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            ListTile(
              title: Text(
                'Account',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountScreen(
                              fName: widget.firstName,
                              lName: widget.lastName,
                              contact1: widget.contact1,
                              contact2: widget.contact2,
                            )));
              },
              leading: Padding(
                padding: EdgeInsets.only(top: 5),
                child: Icon(
                  FontAwesomeIcons.userAlt,
                  size: 15,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            ListTile(
              title: Text(
                'Settings',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, SettingScreen.id);
              },
              leading: Padding(
                padding: EdgeInsets.only(top: 5),
                child: Icon(
                  FontAwesomeIcons.cog,
                  size: 15,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 8,
            ),
            ListTile(
              title: Text(
                'Log Out',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                //log out of session
                Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.id, (route) => false);
              },
              leading: Padding(
                padding: EdgeInsets.only(top: 5),
                child: Icon(
                  FontAwesomeIcons.signOutAlt,
                  size: 15,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Container(
                height: 200.0,
                child: Image.asset('images/driver.png'),
              ),
            ),
            SizedBox(
              height: 200.0,
            ),
            Center(
              child: Text(
                'Hit the road by pressing the car button',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'SourceSansPro',
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: kButtonColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.car,
                    color: Colors.white,
                  ),
                  iconSize: 40.0,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SessionScreen(widget.contact1,
                                widget.contact2, widget.firstName)));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
