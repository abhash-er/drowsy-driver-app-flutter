import 'package:drowsy/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:drowsy/constants.dart';

class AccountScreen extends StatefulWidget {
  static const String id = 'account_screen';
  AccountScreen({Key key, this.fName, this.lName, this.contact1, this.contact2}) : super(key : key);
  final String fName;
  final String lName;
  final String contact1;
  final String contact2;

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final Color hintTextColor = Colors.grey;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0x3F0F123F),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color(0x3F0F123F),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            )),
            expandedHeight: 400.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Account',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              background: Image.asset(
                'images/account.jpg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                CircleAvatar(
                  //give a provider class if image is changed
                  radius: 50.0,
                  child: Container(
                    child: CircleAvatar(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          backgroundColor: Color(0xFF0F123F),
                          radius: 15.0,
                          child: GestureDetector(
                            onTap: () {
                              print("abhash");
                            },
                            child: Icon(
                              Icons.camera_alt,
                              size: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      radius: 50.0,
                      backgroundImage: AssetImage('images/avatar.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Card(
                  color: Color(0x3F0F123F),
                  child: Theme(
                    data: ThemeData(
                      textTheme: TextTheme(
                        subtitle1: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      unselectedWidgetColor: Colors.white,
                      accentColor: kButtonColor,
                    ),
                    child: ExpansionTile(
                      title: Text('Emergency Contacts'),
                      leading: Icon(Icons.phone),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              //Do something with the user input.
                            },
                            decoration: kTextFieldDecoration.copyWith(
                                hintStyle: TextStyle(color: hintTextColor),
                                hintText: widget.contact1),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              //Do something with the user input.
                            },
                            decoration: kTextFieldDecoration.copyWith(
                                hintStyle: TextStyle(color: hintTextColor),
                                hintText: widget.contact2),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Card(
                  color: Color(0x3F0F123F),
                  child: Theme(
                    data: ThemeData(
                      textTheme: TextTheme(
                        subtitle1: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      unselectedWidgetColor: Colors.white,
                      accentColor: kButtonColor,
                    ),
                    child: ExpansionTile(
                      title: Text('Edit Name'),
                      leading: Icon(Icons.text_format),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              //Do something with the user input.
                            },
                            decoration: kTextFieldDecoration.copyWith(
                                hintStyle: TextStyle(color: hintTextColor),
                                // TODO update hintText by fetching previous name
                                hintText: widget.fName + ' ' + widget.lName),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Color(0x3F0F123F),
                  child: ListTile(
                    onTap: () {
                      //TODO Create Change Password Screen
                    },
                    leading: Icon(Icons.vpn_key),
                    title: Text('Change Password'),
                  ),
                ),
                SizedBox(height:200.0),
                RoundedButton(text: 'Save',   colour: kButtonColor, textColor: Colors.white, onPressed: (){})
              ],
            ),
          ),
        ],
      ),
    );
  }
}
