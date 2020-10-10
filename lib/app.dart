import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  ui.Image _image;
  List<Face> _faces;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: (_image != null && _faces != null)
            ? FittedBox(
              child: SizedBox(
                height: _image.height.toDouble(),
                width: _image.width.toDouble(),
                child: CustomPaint(
                    painter: FacePainter(image: _image, faces: _faces),
                  ),
              ),
            )
            : Text("Waiting"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pickedFile =
              await ImagePicker().getImage(source: ImageSource.gallery);
          final file = File(pickedFile.path);
          final visionImage = FirebaseVisionImage.fromFile(file);
          final faceDetector = FirebaseVision.instance.faceDetector();
          final data = await file.readAsBytes();
          final rawImage = await decodeImageFromList(data);
          final faces = await faceDetector.processImage(visionImage);
          setState(() {
            _faces = faces;
            _image = rawImage;
          });
          print(faces);
        },
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  List<Face> faces;
  ui.Image image;

  FacePainter({
    this.image,
    this.faces,
  });

  Paint canvasPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 15.0
    ..color = Colors.red;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    canvas.drawImage(image, Offset.zero, Paint());
    // canvas.drawRect(Rect.fromLTWH(0, 0, 20, 20), Paint());
    for (final face in faces) {
      canvas.drawRect(face.boundingBox, canvasPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
