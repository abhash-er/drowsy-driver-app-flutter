import 'package:drowsy/constants.dart';
import 'package:flutter/material.dart';

//import 'package:drowsy/components/camera_widget.dart';
import 'package:drowsy/firebase_example/camera_preview_scanner.dart';

class SessionScreen extends StatefulWidget {
  static const String id = "session_screen";
  final String contact1;
  final String contact2;
  final String fName;

  SessionScreen(this.contact1, this.contact2, this.fName);

  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: Container(
              height: 200.0,
              child: Image.asset('images/confirm.png'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Make Sure You have your GPS turned on for emergency services and all permissions are checked.',
              style: TextStyle(fontWeight: FontWeight.w700,fontFamily: 'SourceSansPro'),),
          ),
          Container(
            height: 100.0,
            width: 100.0,
            child: FloatingActionButton(
              child: Text('Voila'),
              backgroundColor: kButtonColor,
              onPressed: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CameraPreviewScanner(
                            widget.contact1,
                            widget.contact2,
                            widget.fName,
                          ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
