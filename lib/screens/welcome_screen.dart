import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:drowsy/constants.dart';
import 'package:drowsy/components/rounded_button.dart';
import 'login_screen.dart';
import 'register_screen.dart';
//import 'package:camera/camera.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  //final List<CameraDescription> cameras;
  //WelcomeScreen(this.cameras);
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 200.0,
            ),
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 150.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
            SizedBox(
              height: 100.0,
            ),
            Expanded(
              child: WavyAnimatedTextKit(
                textStyle: TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                text: ["Be  Safe", "Be  vigilant", "Drowsy"],
                isRepeatingAnimation: false,
              ),
            ),
            RoundedButton(
              text: 'Login',
              colour: kButtonColor,
              textColor: kBackgroundColor,
              onPressed: () {
                //push to sign in screen
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RegisterScreen.id);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account ? ',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    'Signup',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
