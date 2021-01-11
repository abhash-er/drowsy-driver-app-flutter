import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/driver_screen.dart';
import 'screens/setting_screen.dart';
import 'screens/session_screen.dart';
//import 'screens/previous_session_screen.dart'; // ---in development---
import 'screens/account_screen.dart';
import 'firebase_example/camera_preview_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'extras/info_screen.dart';

List<CameraDescription> cameras;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Geolocator.isLocationServiceEnabled();
  await Geolocator.checkPermission();

  runApp(DrowsyApp(cameras));
}

class DrowsyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  DrowsyApp(this.cameras);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor:  Color(0xFF0F123F),
        scaffoldBackgroundColor: Color(0xFF0F123F),
        canvasColor: Color(0xFF1B1A32),
      ),
      initialRoute: WelcomeScreen.id,
      routes: <String, WidgetBuilder>{
        WelcomeScreen.id : (context) => WelcomeScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        RegisterScreen.id : (context) => RegisterScreen(),
        DriverScreen.id : (BuildContext context) => DriverScreen(),
        SettingScreen.id : (context) => SettingScreen(),
        SessionScreen.id : (context) => SessionScreen('test','test','test'),
        AccountScreen.id : (context) => AccountScreen(),
        //PreviousSessionScreen.id : (context) => PreviousSessionScreen(), --indevelopment
        CameraPreviewScanner.id : (BuildContext context) =>
            CameraPreviewScanner('test','test','test'),
        InfoScreen.id : (context) => InfoScreen(),
      },
    );
  }
}


