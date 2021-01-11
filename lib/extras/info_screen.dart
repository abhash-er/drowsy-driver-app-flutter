import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  static const String id = 'info_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Info'),
          leading: Builder(builder: (context) => Icon(Icons.info))),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                height: 200.0,
                child: Image.asset('images/info.png'),
              ),
            ),
            SizedBox(height: 100,),
            Text(
              'This app aims to prevent the accidents that are caused by the drowsiness or fatigue. When the driver closes their eye for more than 5-6 sec, the app will play an alarm that can be wake up any driver. Simultaneously It will send a danger message to the user\'s emergency contact.',
              style: TextStyle(fontFamily: 'SourceSansPro', fontWeight: FontWeight.w400, fontSize: 15),
            ),
            SizedBox(height: 100,),
            Text(
              'Developer - Abhash Kumar Jha',
              style: TextStyle(fontWeight: FontWeight.w700,),
            )
          ],
        ),
      ),
    );
  }
}
