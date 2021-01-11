import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'detector_painters.dart';
import 'scanner_utils.dart';
import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:geolocator/geolocator.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class CameraPreviewScanner extends StatefulWidget {
  static const String id = "camera_preview";

  CameraPreviewScanner(this.contact1, this.contact2, this.fName);

  final contact1;
  final contact2;
  final fName;

  @override
  State<StatefulWidget> createState() => _CameraPreviewScannerState();
}

class _CameraPreviewScannerState extends State<CameraPreviewScanner> {
  dynamic _scanResults;
  CameraController _camera;
  Detector _currentDetector = Detector.face;
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.front;
  List<bool> openEyesList = [];

  int counter;

  final FaceDetector _faceDetector = FirebaseVision.instance
      .faceDetector(FaceDetectorOptions(enableClassification: true));

  bool _closedEye = false;
  bool _openEye = true;

  AudioCache cache;
  AudioPlayer player;

  double _latitude;
  double _longitude;

  void _playFile() {
    final player = AudioCache();
    player.play('alarm.wav');
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void sendTwilioSms(String message, List<String> recipients) async {
    TwilioFlutter twilioFlutter = TwilioFlutter(
        accountSid: 'AC420725418f52d371c890b6f042fb18a4',
        authToken: 'bc55fcd3ca50606a752b8a949cbf2698',
        twilioNumber: '+12138954245');

    for (String phNumber in recipients) {
      twilioFlutter.sendSMS(toNumber: phNumber, messageBody: message);
    }
    twilioFlutter = null;
  }

  @override
  void initState() {
    super.initState();
    counter = 0;
    //_playFile();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final CameraDescription description =
        await ScannerUtils.getCamera(_direction);

    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.iOS
          ? ResolutionPreset.low
          : ResolutionPreset.high,
    );
    await _camera.initialize();

    _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;
      _isDetecting = true;
      if (counter == 15) {
        bool ans = false;
        for (bool i in openEyesList) {
          ans = ans || i;
        }

        if (ans == false) {
          //playSound
          _playFile();
          //geolocator -> send sms
          Timer(Duration(seconds: 11), () {
            _determinePosition().then((position) {
              _latitude = position.latitude;
              _longitude = position.longitude;
              print(_latitude);
              String smsText =
                  'Your friend ${widget.fName} is in danger, See his location here: https://www.google.com/maps/search/?api=1&query=$_latitude,$_longitude';
              List<String> recipients = [widget.contact1, widget.contact2];
              sendTwilioSms(smsText, recipients);
            });
          });
        }
        openEyesList = [];
        counter = 0;
      }

      counter += 1;
      openEyesList.add(_openEye);
      // print('Counter:$counter');
      // print("Open Eyes: ${openEyesList.last}");
      ScannerUtils.detect(
        image: image,
        detectInImage: _getDetectionMethod(),
        imageRotation: description.sensorOrientation,
      ).then(
        (dynamic results) {
          if (_currentDetector == null) return;

          setState(() {
            _scanResults = results;
            for (Face face in _scanResults) {
              double rightEye;
              double leftEye;
              if (face.rightEyeOpenProbability != null &&
                  face.leftEyeOpenProbability != null) {
                rightEye = face.rightEyeOpenProbability;
                leftEye = face.leftEyeOpenProbability;
              }

              if (rightEye != null && leftEye != null) {
                if (rightEye < 0.5 && leftEye < 0.5) {
                  _closedEye = true;
                  _openEye = !_closedEye;
                } else {
                  _closedEye = false;
                  _openEye = !_closedEye;
                }
              }
            }
          });
        },
      ).whenComplete(() => _isDetecting = false);
    });
  }

  Future<dynamic> Function(FirebaseVisionImage image) _getDetectionMethod() {
    switch (_currentDetector) {
      case Detector.face:
        return _faceDetector.processImage;
    }

    return null;
  }

  Widget _buildResults() {
    const Text noResultsText = Text('No results!');

    if (_scanResults == null ||
        _camera == null ||
        !_camera.value.isInitialized) {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _camera.value.previewSize.height,
      _camera.value.previewSize.width,
    );

    switch (_currentDetector) {
      case Detector.face:
        if (_scanResults is! List<Face>) return noResultsText;
        painter = FaceDetectorPainter(imageSize, _scanResults);
        break;
      default:
        assert(_currentDetector == Detector.face);
        if (_scanResults is! List<Face>) return noResultsText;
        painter = FaceDetectorPainter(imageSize, _scanResults);
    }

    return CustomPaint(
      painter: painter,
    );
  }

  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: _camera == null
          ? const Center(
              child: Text(
                'Initializing Camera...',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 30.0,
                ),
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CameraPreview(_camera),
                _buildResults(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'closedEye -> ${_closedEye.toString()}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'openEye -> ${_openEye.toString()}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  void _toggleCameraDirection() async {
    if (_direction == CameraLensDirection.back) {
      _direction = CameraLensDirection.front;
    } else {
      _direction = CameraLensDirection.back;
    }

    await _camera.stopImageStream();
    await _camera.dispose();

    setState(() {
      _camera = null;
    });

    _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('In-Session'),
        actions: <Widget>[
          PopupMenuButton<Detector>(
            onSelected: (Detector result) {
              _currentDetector = result;
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Detector>>[
              const PopupMenuItem<Detector>(
                child: Text('Detect Face'),
                value: Detector.face,
              ),
            ],
          ),
        ],
      ),
      body: _buildImage(),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleCameraDirection,
        child: _direction == CameraLensDirection.back
            ? const Icon(Icons.camera_front)
            : const Icon(Icons.camera_rear),
      ),
    );
  }

  @override
  void dispose() {
    _camera.dispose().then((_) {
      _faceDetector.close();
    });

    _currentDetector = null;
    super.dispose();
  }
}
