import 'package:drowsy/constants.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:math';
import 'dart:async';
import 'package:image/image.dart' as imglib;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';


typedef void Callback(List<dynamic> list, int h, int w);

class CameraFeed extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraFeed(this.cameras);

  @override
  _CameraFeedState createState() => new _CameraFeedState();
}

class _CameraFeedState extends State<CameraFeed> {
  CameraController controller;
  bool isDetecting = false;
  Timer _timer;


  FirebaseVisionImageMetadata metadata = FirebaseVisionImageMetadata(
    rawFormat: 35,
    size: const Size(1.0, 1.0),
    planeData: <FirebaseVisionImagePlaneMetadata>[
      FirebaseVisionImagePlaneMetadata(
        bytesPerRow: 1000,
        height: 480,
        width: 480,
      ),
    ],
  );

  //Timer _timer;
  bool _closedEye = false;
  bool _openEye = false;
  final FaceDetector faceDetector = FirebaseVision.instance
      .faceDetector(FaceDetectorOptions(enableClassification: true));

  Future<List<int>> convertYUV420toImageColor(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;
      final int uvRowStride = image.planes[1].bytesPerRow;
      final int uvPixelStride = image.planes[1].bytesPerPixel;

      print("uvRowStride: " + uvRowStride.toString());
      print("uvPixelStride: " + uvPixelStride.toString());

      // imgLib -> Image package from https://pub.dartlang.org/packages/image
      var img = imglib.Image(width, height); // Create Image buffer

      // Fill image buffer with plane[0] from YUV420_888
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          final int uvIndex =
              uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
          final int index = y * width + x;

          final yp = image.planes[0].bytes[index];
          final up = image.planes[1].bytes[uvIndex];
          final vp = image.planes[2].bytes[uvIndex];
          // Calculate pixel color
          int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
          int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255);
          int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
          // color: 0x FF  FF  FF  FF
          //           A   B   G   R
          img.data[index] = (0xFF << 24) | (b << 16) | (g << 8) | r;
        }
      }

      imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
      List<int> png = pngEncoder.encodeImage(img);
      //muteYUVProcessing = false;
      return png;
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    print(widget.cameras);
    if (widget.cameras == null || widget.cameras.length < 1) {
      print('No Cameras Found.');
    } else {
      controller = new CameraController(
        widget.cameras[1],
        ResolutionPreset.high,
      );

      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

      });
    }
  }

  void detectFace(rgbImg,metadata) async{
    final FirebaseVisionImage visionImage =
    FirebaseVisionImage.fromBytes(rgbImg, metadata);
    final List<Face> faces =
        await faceDetector.processImage(visionImage);

    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;
      double leftEyeProb = 0.0;
      double rightEyeProb = 0.0;

      if (face.leftEyeOpenProbability != null) {
        leftEyeProb = face.leftEyeOpenProbability;
      }
      if (face.rightEyeOpenProbability != null) {
        rightEyeProb = face.rightEyeOpenProbability;
      }

      setState(() {
        if (leftEyeProb == 0.0 && rightEyeProb == 0.0) {
          print("Fetch Error");
        }
        if (leftEyeProb < 0.5 && rightEyeProb < 0.5) {
          _closedEye = true;
          _openEye = false;
        } else {
          _closedEye = false;
          _openEye = true;
        }
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = max(tmp.height, tmp.width);
    var screenW = min(tmp.height, tmp.width);
    tmp = controller.value.previewSize;
    var previewH = max(tmp.height, tmp.width);
    var previewW = min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
      MaterialButton(
      child: Text("Start Scanning"),
      textColor: Colors.white,
      color: Colors.blue,
      onPressed: () async {
        _timer = Timer.periodic(Duration(seconds: 3), (currentTimer) async{
          await controller.startImageStream((CameraImage img) async {
            if (!isDetecting) {
              isDetecting = true;
              await convertYUV420toImageColor(img)
                  .then((rgbImg) {
                detectFace(rgbImg, metadata);
                isDetecting = false;
              });
            }
          });
        });
      }
      ),
          Container(

            color: kButtonColor,
            child: Row(children: [
              Text('closedEye -> ${_closedEye.toString()}'),
              SizedBox(width: 15.0,),
              Text('openEye -> ${_openEye.toString()}'),
            ]),
          ),
        ],
      ),
    );
  }
}

